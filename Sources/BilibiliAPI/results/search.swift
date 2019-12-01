// 搜索
struct SearchResult: APIResultContainer, ExtractableWithJQ {
    typealias Query = SearchQuery
    
    let result: Result
    struct Result: APIResult {
        let items: [VideoItem]
    }

    struct VideoItem: Codable {
        let title: String
        let cover_url: String
        let aid: UInt64
        let view_count: Int
        let danmaku_count: Int
        let uploader_name: String
        let uploader_uid: UInt64
        let uploader_profile_image_url: String
        let description: String?
        let duration_text: String
    }
    
    static let transformer: JQ? = try! JQ(query: #"""
        .data | {
            items: [.item[]? | select(.linktype=="video") | {
                title, cover_url: .cover, aid: (.param | tonumber),
                view_count: (.play // 0), danmaku_count: (.danmaku // 0),
                uploader_name: .author, uploader_uid: .mid,
                uploader_profile_image_url: .face,
                description: .desc, duration_text: .duration
            }]
        }
        """#, usesLock: true)
}