import Foundation

public struct Request {
    public let url: URL
    public let headers: [(String, String)]
    public var urlRequest: URLRequest {
        var r = URLRequest(url: self.url)
        for header in self.headers {
            r.addValue(header.1, forHTTPHeaderField: header.0)
        }
        return r
    }
}

public struct Response {
    public let body: Data
    public let statusCode: UInt
    public init(body: Data, statusCode: UInt) {
        self.body = body
        self.statusCode = statusCode
    }
}

public enum APIProviderError: Error {
    case missingAPIKeys
    case missingClientInfo(ofType: APISpec.PreferredClientType)
    case clientInfoBuildNumberMismatched
}

public class APIProvider {
    private let fallbackKeys: APIKeys?
    private var clientInfos = [APISpec.PreferredClientType: [ClientInfo]]()

    public init(fallbackKeys: APIKeys? = nil) {
        self.fallbackKeys = fallbackKeys
    }
    
    public func addClientInfo(for type: APISpec.PreferredClientType,
                                       _ info: ClientInfo, ignoresCheck: Bool = false) throws {
        // check
        if !ignoresCheck {
            switch type {
            case .browser: break
            case .iphone7260:
                if info.build != 7260 {
                    throw APIProviderError.clientInfoBuildNumberMismatched
                }
            }
        }

        clientInfos[type] = (clientInfos[type] ?? []) + [info]
    }
}

public extension APIProvider {
    func buildRequest(for api: APIQuery, clientInfo providedClientInfo: ClientInfo? = nil) throws -> Request {
        var url = type(of: api).endpoint
        url.queryItems = api.buildQueryItems()
        var headers = [(String, String)]()
        
        let spec = type(of: api).spec
        
        let clientInfo: ClientInfo
        if let providedClientInfo = providedClientInfo {
            clientInfo = providedClientInfo
        } else {
            guard let infos = self.clientInfos[spec.preferredClientType], infos.count > 0 else {
                throw APIProviderError.missingClientInfo(ofType: spec.preferredClientType)
            }
            if infos.count == 1 {
                clientInfo = infos[0]
            } else {
                let rand = Int(arc4random_uniform(UInt32(infos.count)))
                clientInfo = infos[rand]
            }
        }
        url.queryItems! += (clientInfo.queryItems)
        if let userAgent = clientInfo.userAgent {
            headers.append(("User-Agent",  userAgent))
        }
        
        if spec.requiresTimestamp {
            url.queryItems!.append(URLQueryItem(name: "ts", value: String(Int64(Date().timeIntervalSince1970))))
        }
        
        let keys = (clientInfo.keys ?? self.fallbackKeys)
        if spec.requiresKeys || spec.requiresSign {
            guard let keys = keys else {
                throw APIProviderError.missingAPIKeys
            }
            if spec.requiresKeys {
                url.queryItems! += keys.appKeyQueryItems
            }
            if spec.requiresSign {
                keys.sign(for: &url.queryItems!)
            }
        }
        url.queryItems!.sort { $0.name < $1.name }
        
        return Request(url: url.url!, headers: headers)
    }
}
