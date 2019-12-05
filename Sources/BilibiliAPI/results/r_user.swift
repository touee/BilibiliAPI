import JQWrapper

// 用户投稿
public struct UserSubmissionsResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = UserSubmissionsQuery
    
    public let result: Result
    public struct Result: APIResult {
        public let total_count: Int
        public let submissions: [VideoItem]
    }
    public struct VideoItem: Codable {
        public let title: String
        public let subregion_name: String
        public let cover_url: String
        public let aid: UInt64
        public let duration: Int
        public let view_count: Int
        public let danmaku_count: Int
        public let publish_time: Int64 // 虽然键名是 ctime, 实际和 pubdate 相符
        public let other_interesting_stuff: String // is_popular, state, ugc_pay
    }
    
    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
        .data | {
            total_count: .count,
            submissions: [.item[]? | select(.goto?=="av") | {
                title, subregion_name: .tname, cover_url: .cover,
                aid: (.param | tonumber), duration,
                view_count: (.play // 0), danmaku_count: (.danmaku // 0),
                publish_time: .ctime, other_interesting_stuff: ({
                    state, is_popular, ugc_pay
                } | @json)
            }]
        }
        """#, usesLock: true)
}

public struct UserSubmissionSearchResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = UserSubmissionSearchQuery
    
    public let result: Result
    public struct Result: APIResult {
        public let total_count: Int
        public let subregion_id_name_table: [Int: String]? // id -> name
        public let submissions: [VideoItem]
    }
    public struct VideoItem: Codable {
        public let title: String
        public let subregion_id: String
        public let cover_url_without_scheme: String
        public var cover_url: String {
            return "http:" + cover_url_without_scheme
        }
        public let aid: UInt64
        public let durationText: String
        public var duration: Int {
            let parts = self.durationText.split(separator: ":", omittingEmptySubsequences: false)
            if parts.count != 2 { fatalError() }
            return Int(parts[0])! * 60 + Int(parts[1])!
        }
        public let view_count: Int
        public let danmaku_count: Int
        public let reply_count: Int
        public let publish_time: Int64
        public let description: String
        public let other_interesting_stuff: String // review, bvid, hide_click, subtitle
    }
    
    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
        .data | {
            total_count: .page.count,
            subregion_id_name_table: (.list.tlist? | map ({ .tid: .name }) | add) // null,
            submissions: [.list.vlist | {
                .title, subregion_id: .typeid,
                cover_url_without_scheme: .pic,
                .aid, durationText: .length, view_count: .play,
                danmaku_count: .video_review, reply_count: .comment,
                publish_time: .created, .description,
                other_interesting_stuff: ({
                    review, bvid, hide_click, subtitle
                } | @json)
            }]
        }
        """#, usesLock: true)
}

// 用户收藏夹列表
public struct UserFavoriteFolderListResult: APIResultContainer, ExtractableWithJQ {
    public typealias Query = UserFavoriteFolderListQuery
    
    public let result: Result
    public typealias Result = [FolderItem]
    public struct FolderItem: Codable {
        public let fid: UInt64
        public let name: String
        public let capacity: Int // 5000 是主收藏夹, 999 是自己创建的收藏夹
        public let current_item_count: Int
        public let create_time: Int64
        public let modify_time: Int64
        public let other_interesting_stuff: String // atten_count, state, favoured, ctime, mtime
    }
    
    public init(result: Result) {
        self.result = result
    }
    
    public static let transformer: JQ? = try! JQ(query: #"""
        [.data[]? | {
            fid, name, capacity: .max_count, current_item_count: .cur_count,
            create_time: .ctime, modify_time: .mtime,
            other_interesting_stuff: ({
                atten_count, state, favoured
            } | @json)
        }]
        """#, usesLock: true)
}
