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
            (name: "vmid",  value: String(uid)),
            (name: "pn",    value: String(fromOptional: pageNumber)),
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
            (name: "vmid",  value: String(uid)),
            ])
    }
}
