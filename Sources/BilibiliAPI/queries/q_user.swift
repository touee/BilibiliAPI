import Foundation

public protocol APIQueryWithUID: APIQuery {
    var uid: UInt64 { get }
}

// 用户投稿
public struct UserSubmissionsQuery: APIQuery, MultipageAPIQuery, APIQueryWithUID {
    public let uid: UInt64
    public let pageNumber: Int?
    public init(uid: UInt64, pageNumber: Int? = nil) {
        self.uid = uid
        self.pageNumber = pageNumber
    }
    
    public static var endpoint = buildEndpoint("app", "/x/v2/space/archive")
    public static var spec = APISpec.forMobile(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "vmid",  value: String(self.uid)),
            (name: "pn",    value: String(fromOptional: self.pageNumber)),
            ])
    }
}

// 用户投稿搜索 (关键词为空时功能同 UserSubmissionsQuery, 但返回结果有差异)
public struct UserSubmissionSearchQuery: APIQuery, MultipageAPIQuery, APIQueryWithUID {
    public let uid: UInt64
    public let keyword: String
    public let order: UserSubmissionSearchOrder
    // 还有一项 `tid` 参数, 但作用不明 (并非筛选分区)
    public let pageNumber: Int?
    public let pageSize: Int?
    // pageSize 可达 100
    public init(uid: UInt64, keyword: String, order: UserSubmissionSearchOrder, pageNumber: Int? = nil, pageSize: Int? = 30) {
        self.uid = uid
        self.keyword = keyword
        self.order = order
        self.pageNumber = pageNumber
        self.pageSize = pageSize
    }
    
    public static var endpoint = buildEndpoint("api", "/x/space/arc/search")
    public static var spec = APISpec.forBrowser(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "mid",       value: String(self.uid)),
            (name: "pn",        value: String(fromOptional: self.pageNumber)),
            (name: "ps",        value: String(fromOptional: self.pageSize)),
            (name: "keyword",   value: self.keyword),
            (name: "order",     value: self.order.rawValue),
            ])
    }
}

// 用户收藏夹列表
public struct UserFavoriteFolderListQuery: APIQuery, APIQueryWithUID {
    public let uid: UInt64
    public init(uid: UInt64) {
        self.uid = uid
    }
    
    public static var endpoint = buildEndpoint("api", "/x/v2/fav/folder")
    public static var spec = APISpec.forMobile(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "vmid",  value: String(self.uid)),
            ])
    }
}
