public class GeneralVideoItem: Codable {
    public struct VideoStats: Codable {
        public let views: Int
        public let danmakus: Int
        public let replies: Int
        public let favorites: Int
        public let coins: Int
        public let shares: Int
        public let current_rank: Int
        public let highest_rank: Int
        public let likes: Int
        public let dislikes: Int
        public let remained_raw: String?
    }
    public struct VideoTimes: Codable {
        public let pub: Int64
        public let c: Int64
    }
    public let aid: UInt64
    public let parts: Int
    public let subregion_id: Int
    public let subregion_name: String
    public let ownership: Int
    public let cover_url: String
    public let title: String
    public let times: VideoTimes
    public let description: String
    public let duration: Int
    public let uploader_name: String
    public let uploader_uid: UInt64
    public let uploader_profile_image_url: String
    public let cid: UInt64?
    public let state: Int
    public let stats: VideoStats
    public let other_interesting_stuff: String // state attribute rights stat dimension
}
public let generalVideoItemJSONQueryTemplate = #"""
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

public class GeneralTagItem: Codable {
    public let tid: UInt64
    public let name: String
    public let type: Int
    public let cover_url: String // empty ok
    public let head_cover_url: String // empty ok
    public let description: String // empty ok
    public let short_description: String // empty ok
    public let c_time: Int64
    public let other_interesting_stuff: String // type, count
}
public let generalTagItemJSONQueryTemplate = #"""
    {
        tid: .%@, name: .%@, type, cover_url: .cover,
        head_cover_url: .head_cover, description: .content,
        short_description: .short_content, c_time: .ctime,
        other_interesting_stuff: ({
            count, is_atten, attribute, %@ } | @json),
        %@
    }
    """#
