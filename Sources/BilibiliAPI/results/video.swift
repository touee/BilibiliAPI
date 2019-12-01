// 视频的相关视频
struct VideoRelatedVideosResult: APIResultContainer, ExtractableWithJQ {
    typealias Query = VideoRelatedVideosQuery
    
    let result: Result
    typealias Result = [GeneralVideoItem]

    static let transformer: JQ? = try! JQ(query: #"""
        [ .data[]? | \#(String(format: generalVideoItemJSONQueryTemplate, "", ""))]
        """#, usesLock: true)
}

// 视频的 tag
struct VideoTagsResult: APIResultContainer, ExtractableWithJQ {
    typealias Query = VideoTagsQuery
    
    let result: Result
    typealias Result = [TagItem]
    class TagItem: GeneralTagItem {
        let likes: Int
        let dislikes: Int
        
        enum CodingKeys: String, CodingKey {
            case likes
            case dislikes
        }
        
        required init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            self.likes = try c.decode(Int.self, forKey: .likes)
            self.dislikes = try c.decode(Int.self, forKey: .dislikes)
            try super.init(from: decoder)
        }
        
        override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(self.likes, forKey: .likes)
            try c.encode(self.dislikes, forKey: .dislikes)
        }
    }
    
    static let transformer: JQ? = try! JQ(query: #"""
        [.data[]? | \#(String(format: generalTagItemJSONQueryTemplate, "tag_id", "tag_name", "", "likes, dislikes: .hates"))]
        """#, usesLock: true)
}