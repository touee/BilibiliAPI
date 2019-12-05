import Foundation

// 标签页信息
public struct TagTabInfoQuery: APIQuery {
    public let tid: UInt64?
    public let tagName: String?
    public init(tid: UInt64?, tagName: String?) {
        self.tid = tid
        self.tagName = tagName
    }
    
    public static var endpoint = buildEndpoint("app", "/x/v2/tag/tab")
    public static var spec = APISpec.forBrowser(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "tag_id",    value: String(fromOptional: self.tid)),
            (name: "tag_name",  value: self.tagName),
            ])
    }
}

public protocol APIQueryWithTID: APIQuery {
    var tid: UInt64 { get }
}

// 标签页信息+按时间排序视频
public struct TagDetailQuery: APIQuery, MultipageAPIQuery, APIQueryWithTID {
    public let tid: UInt64
    public let pageNumber: Int?
    public init(tid: UInt64, pageNumber: Int? = nil) {
        self.tid = tid
        self.pageNumber = pageNumber
    }
    
    public static var endpoint = buildEndpoint("api", "/x/tag/detail")
    public static var spec = APISpec.forMobile(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "tag_id",    value: String(self.tid)),
            (name: "pn",        value: String(fromOptional: self.pageNumber)),
            ])
    }
}

// 标签页按默认排序视频
public struct TagTopQuery: APIQuery, MultipageAPIQuery, APIQueryWithTID {
    public let tid: UInt64
    public let pageNumber: Int?
    public init(tid: UInt64, pageNumber: Int? = nil) {
        self.tid = tid
        self.pageNumber = pageNumber
    }
    
    public static var endpoint = buildEndpoint("api", "/x/web-interface/tag/top")
    public static var spec = APISpec.forBrowser(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "tid",    value: String(self.tid)),
            (name: "pn",        value: String(fromOptional: self.pageNumber)),
            ])
    }
}
