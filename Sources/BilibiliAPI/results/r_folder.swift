import JQWrapper

// 收藏夹中的视频
public struct FavoriteFolderVideosResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = FavoriteFolderVideosQuery
    
    public let result: Result
    public struct Result: APIResult {
        public let archives: [FavoriteFolderVideoItem]
    }
    public class FavoriteFolderVideoItem: GeneralVideoItem {
        public let favorite_time: Int64
        
        public enum CodingKeys: String, CodingKey {
            case favorite_time
        }
        
        public required init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            self.favorite_time = try c.decode(Int64.self, forKey: .favorite_time)
            try super.init(from: decoder)
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(self.favorite_time, forKey: .favorite_time)
        }
    }
    
    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
        .data | {
        archives: [.archives[]? |\#(String(format: generalVideoItemJSONQueryTemplate,
            "dimension", "favorite_time: .fav_at "))]
        }
        """#, usesLock: true)
}
