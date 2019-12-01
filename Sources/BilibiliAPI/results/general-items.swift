class GeneralVideoItem: Codable {
    struct VideoStats: Codable {
        let views: Int
        let danmakus: Int
        let replies: Int
        let favorites: Int
        let coins: Int
        let shares: Int
        let current_rank: Int
        let highest_rank: Int
        let likes: Int
        let dislikes: Int
        let remained_raw: String?
    }
    struct VideoTimes: Codable {
        let pub: Int64
        let c: Int64
    }
    let aid: UInt64
    let parts: Int
    let subregion_id: Int
    let subregion_name: String
    let ownership: Int
    let cover_url: String
    let title: String
    let times: VideoTimes
    let description: String
    let duration: Int
    let uploader_name: String
    let uploader_uid: UInt64
    let uploader_profile_image_url: String
    let cid: UInt64?
    let state: Int
    let stats: VideoStats
    let other_interesting_stuff: String // state attribute rights stat dimension
}
let generalVideoItemJSONQueryTemplate = #"""
    {
        aid, parts: .videos, subregion_id: .tid, subregion_name: .tname,
        ownership: .copyright, cover_url: .pic, title,
        times: { pub: .pubdate, c: .ctime }, description: .desc,
        duration, uploader_name: .owner.name, uploader_uid: .owner.mid,
        uploader_profile_image_url: .owner.face, cid, state,
        stats: .stat | ({
            views: .view, danmakus: .danmaku, replies: .reply,
            favorites: .favorite, coins: .coin, shares: .share,
            current_rank: .now_rank, highest_rank: .his_rank,
            likes: .like, dislikes: .dislike
        } + { remained_raw: .stat | del(.view, .danmaku, .reply, .favorite, .coin, .share, .now_rank, .his_rank, .like, .dislike)
                | (if (. | length) == 0 then null else . end) }),
        other_interesting_stuff: ({
            attribute, rights, mission_id, %@ } | @json),
        %@
    }
    """#

class GeneralTagItem: Codable {
    let tid: UInt64
    let name: String
    let type: Int
    let cover_url: String // empty ok
    let head_cover_url: String // empty ok
    let description: String // empty ok
    let short_description: String // empty ok
    let c_time: Int64
    let other_interesting_stuff: String // type, count
}
let generalTagItemJSONQueryTemplate = #"""
    {
        tid: .%@, name: .%@, type, cover_url: .cover,
        head_cover_url: .head_cover, description: .content,
        short_description: .short_content, c_time: .ctime,
        other_interesting_stuff: ({
            count, is_atten, attribute, %@ } | @json),
        %@
    }
    """#
