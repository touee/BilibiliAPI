import Foundation

public protocol APIQueryWithAID: APIQuery {
    var aid: UInt64 { get }
}

// 视频信息
public struct VideoInfoQuery: APIQuery, APIQueryWithAID {
    public let aid: UInt64
    public init(aid: UInt64) {
        self.aid = aid
    }
    
    public static var endpoint = buildEndpoint("app", "/x/v2/view")
    public static var spec = APISpec.forMobile(requiresKeys: true)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "aid", value: String(self.aid)),
            ])
    }
}

// 视频的相关视频
public struct VideoRelatedVideosQuery: APIQuery, APIQueryWithAID {
    public let aid: UInt64
    public init(aid: UInt64) {
        self.aid = aid
    }
    
    public static var endpoint = buildEndpoint("api", "/x/web-interface/archive/related")
    public static var spec = APISpec.forBrowser(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "aid", value: String(self.aid)),
            ])
    }
}

// 视频 tags
public struct VideoTagsQuery: APIQuery, APIQueryWithAID {
    public let aid: UInt64
    public init(aid: UInt64) {
        self.aid = aid
    }
    
    public static var endpoint = buildEndpoint("api", "/x/tag/archive/tags")
    public static var spec = APISpec.forBrowser(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "aid", value: String(self.aid)),
            ])
    }
}
