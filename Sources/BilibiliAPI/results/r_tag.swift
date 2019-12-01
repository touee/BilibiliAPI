import JQWrapper

// 标签页信息+按时间排序视频
public struct TagDetailResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = TagDetailQuery
    
    public let result: Result
    public struct Result: APIResult {
        public let info: GeneralTagItem
        public let similar_tags: [SimilarTagItem]
        public let videos: [GeneralVideoItem]
    }
    
    public struct SimilarTagItem: Codable {
        let tid: UInt64
        let name :String
    }
    
    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
        .data | {
            info: .info | \#(String(format: generalTagItemJSONQueryTemplate, "tag_id", "tag_name", "", "state")),
            similar_tags: [.similar[]? | { tid, name: .tname }],
            videos: [.news.archives[]? | \#(String(format: generalVideoItemJSONQueryTemplate, "dimension", ""))]
        }
        """#, usesLock: true)
}

// 标签页按默认排序视频
public struct TagTopResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = TagTopQuery
    
    public let result: Result
    public typealias Result = [GeneralVideoItem]

    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
        [ .data[]? | \#(String(format: generalVideoItemJSONQueryTemplate, "", ""))]
        """#, usesLock: true)
}
