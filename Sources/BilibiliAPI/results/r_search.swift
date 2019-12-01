import JQWrapper

// 搜索
public struct SearchResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = SearchQuery
    
    public let result: Result
    public struct Result: APIResult {
        public let items: [VideoItem]
    }

    public struct VideoItem: Codable {
        public let title: String
        public let cover_url: String
        public let aid: UInt64
        public let view_count: Int
        public let danmaku_count: Int
        public let uploader_name: String
        public let uploader_uid: UInt64
        public let uploader_profile_image_url: String
        public let description: String?
        public let duration_text: String
    }
    
    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
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
