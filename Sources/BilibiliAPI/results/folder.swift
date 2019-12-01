// 收藏夹中的视频
struct FavoriteFolderVideosResult: APIResultContainer, ExtractableWithJQ {
    typealias Query = UserFavoriteFolderQuery
    
    let result: Result
    struct Result: APIResult {
        let archives: [FavoriteFolderVideoItem]
    }
    class FavoriteFolderVideoItem: GeneralVideoItem {
        let favorite_time: Int64
        
        enum CodingKeys: String, CodingKey {
            case favorite_time
        }
        
        required init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            self.favorite_time = try c.decode(Int64.self, forKey: .favorite_time)
            try super.init(from: decoder)
        }
        
        override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(self.favorite_time, forKey: .favorite_time)
        }
    }
    
    static let transformer: JQ? = try! JQ(query: #"""
        .data | {
        archives: [.archives[]? |\#(String(format: generalVideoItemJSONQueryTemplate,
            "dimension", "favorite_time: .fav_at "))]
        }
        """#, usesLock: true)
}