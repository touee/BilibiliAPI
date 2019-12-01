import JQWrapper

// 用户投稿
struct UserSubmissionsResult: APIResultContainer, ExtractableWithJQ {
    typealias Query = UserSubmissionsQuery
    
    let result: Result
    struct Result: APIResult {
        let total_count: Int
        let submissions: [VideoItem]
    }
    struct VideoItem: Codable {
        let title: String
        let subregion_name: String
        let cover_url: String
        let aid: UInt64
        let duration: Int
        let view_count: Int
        let danmaku_count: Int
        let c_time: Int64
        let other_interesting_stuff: String // is_popular, state, ugc_pay
    }
    
    static let transformer: JQ? = try! JQ(query: #"""
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
struct UserFavoriteFolderListResult: APIResultContainer, ExtractableWithJQ {
    typealias Query = UserFavoriteFolderListQuery
    
    let result: Result
    typealias Result = [FolderItem]
    struct FolderItem: Codable {
        let fid: UInt64
        let name: String
        let capacity: Int // 5000 是主收藏夹, 999 是自己创建的收藏夹
        let current_item_count: Int
        let create_time: Int64
        let modify_time: Int64
        let other_interesting_stuff: String // atten_count, state, favoured, ctime, mtime
    }
    
    static let transformer: JQ? = try! JQ(query: #"""
        [.data[]? | {
            fid, name, capacity: .max_count, current_item_count: .cur_count,
            create_time: .ctime, modify_time: .mtime,
            other_interesting_stuff: ({
                atten_count, state, favoured
            } | @json)
        }]
        """#, usesLock: true)
}