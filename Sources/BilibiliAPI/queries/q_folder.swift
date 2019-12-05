import Foundation

public protocol APIQueryWithFID: APIQuery {
    var fid: UInt64 { get }
}

// 收藏夹视频
public struct FavoriteFolderVideosQuery: APIQuery, MultipageAPIQuery, APIQueryWithUID, APIQueryWithFID {
    public let uid: UInt64
    public let fid: UInt64
    public let pageNumber: Int?
    public init(uid: UInt64, fid: UInt64, pageNumber: Int? = nil) {
        self.uid = uid
        self.fid = fid
        self.pageNumber = pageNumber
    }
    
    public static var endpoint = buildEndpoint("api", "/x/v2/fav/video")
    public static var spec = APISpec.forMobile(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "vmid",  value: String(self.uid)),
            (name: "fid",   value: String(self.fid)),
            (name: "pn",    value: String(fromOptional: self.pageNumber)),
            ])
    }
}
