import JQWrapper

// 标签页信息+按时间排序视频
struct TagDetailResult: APIResultContainer, ExtractableWithJQ {
    typealias Query = TagDetailQuery
    
    let result: Result
    struct Result: APIResult {
        let info: GeneralTagItem
        let similar_tags: [SimilarTagItem]
        let videos: [GeneralVideoItem]
    }
    
    struct SimilarTagItem: Codable {
        let tid: UInt64
        let name :String
    }
    
    static let transformer: JQ? = try! JQ(query: #"""
        .data | {
            info: .info | \#(String(format: generalTagItemJSONQueryTemplate, "tag_id", "tag_name", "", "state")),
            similar_tags: [.similar[]? | { tid, name: .tname }],
            videos: [.news.archives[]? | \#(String(format: generalVideoItemJSONQueryTemplate, "dimension", ""))]
        }
        """#, usesLock: true)
}

// 标签页按默认排序视频
struct TagTopResult: APIResultContainer, ExtractableWithJQ {
    typealias Query = TagTopQuery
    
    let result: Result
    typealias Result = [GeneralVideoItem]

    static let transformer: JQ? = try! JQ(query: #"""
        [ .data[]? | \#(String(format: generalVideoItemJSONQueryTemplate, "", ""))]
        """#, usesLock: true)
}