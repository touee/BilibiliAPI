import JQWrapper

// 视频的相关视频
public struct VideoRelatedVideosResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = VideoRelatedVideosQuery
    
    public let result: Result
    public typealias Result = [GeneralVideoItem]

    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
        [ .data[]? | \#(String(format: generalVideoItemJSONQueryTemplate, "", ""))]
        """#, usesLock: true)
}

// 视频的 tag
public struct VideoTagsResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = VideoTagsQuery
    
    public let result: Result
    public typealias Result = [TagItem]
    public class TagItem: GeneralTagItem {
        public let likes: Int
        public let dislikes: Int
        
        public enum CodingKeys: String, CodingKey {
            case likes
            case dislikes
        }
        
        public required init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            self.likes = try c.decode(Int.self, forKey: .likes)
            self.dislikes = try c.decode(Int.self, forKey: .dislikes)
            try super.init(from: decoder)
        }
        
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(self.likes, forKey: .likes)
            try c.encode(self.dislikes, forKey: .dislikes)
        }
    }
    
    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
        [.data[]? | \#(String(format: generalTagItemJSONQueryTemplate, "tag_id", "tag_name", "", "likes, dislikes: .hates"))]
        """#, usesLock: true)
}
