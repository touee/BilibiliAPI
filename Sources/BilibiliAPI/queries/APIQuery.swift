import Foundation

public protocol APIQuery: Codable {
    static var endpoint: URLComponents { get }
    static var spec: APISpec { get }
    func buildQueryItems() -> [URLQueryItem]
}

internal func buildEndpoint(_ subdomain: String, _ path: String) -> URLComponents {
    var url = URLComponents()
    url.scheme = "https"
    url.host = "\(subdomain).bilibili.com"
    url.path = path
    return url
}

public struct APISpec {
    let preferredClientType: PreferredClientType
    let requiresTimestamp: Bool
    let requiresKeys: Bool
    let requiresSign: Bool
//    let requiresAuth: Bool
    
    public enum PreferredClientType: Hashable {
        case browser
        case iphone7260
    }
    
    init (preferredClientType: PreferredClientType,
          requiresTimestamp: Bool = false, requiresKeys: Bool = false,
          requiresSign: Bool = false, requiresAuth: Bool = false) {
        self.preferredClientType = preferredClientType
        self.requiresTimestamp = requiresTimestamp
        self.requiresKeys = requiresKeys
        self.requiresSign = requiresSign
//        self.requiresAuth = requiresAuth
    }
}

public extension APISpec {
    static func forBrowser(requiresKeys: Bool) -> APISpec {
        return APISpec(preferredClientType: .browser,
                       requiresTimestamp: requiresKeys,
                       requiresKeys: requiresKeys,
                       requiresSign: requiresKeys)
    }
    static func forMobile(requiresKeys: Bool) -> APISpec {
        return APISpec(preferredClientType: .iphone7260,
                       requiresTimestamp: requiresKeys,
                       requiresKeys: requiresKeys,
                       requiresSign: requiresKeys)
    }
}

public protocol MultipageAPIQuery: APIQuery {
    var pageNumber: Int? { get }
}
