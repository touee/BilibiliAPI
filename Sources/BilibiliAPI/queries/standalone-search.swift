import Foundation

// 搜索
public struct SearchQuery: APIQuery, MultipageAPIQuery {
    public let keyword: String
    public let order: SearchOrder?
    public let duration: SearchDuration?
    public let regionID: Int?
    public let pageNumber: Int?
    public init(keyword: String, order: SearchOrder? = nil, duration: SearchDuration? = nil,
                regionID: Int? = nil, pageNumber: Int? = nil) {
        self.keyword = keyword
        self.order = order
        self.duration = duration
        self.regionID = regionID
        self.pageNumber = pageNumber
    }
    
    public static var endpoint = buildEndpoint("app", "/x/v2/search")
    public static var spec = APISpec.forMobile(requiresKeys: false)
    public func buildQueryItems() -> [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "keyword",   value: keyword),
            (name: "order",     value: order?.rawValue),
            (name: "duration",  value: String(fromOptional: duration?.rawValue)),
            (name: "rid",       value: String(fromOptional: regionID)),
            (name: "pn",        value: String(fromOptional: pageNumber)),
            ])
    }
}
