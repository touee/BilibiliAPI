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
        public let c_time: Int64
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
                c_time: .ctime, other_interesting_stuff: ({
                    state, is_popular, ugc_pay
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
