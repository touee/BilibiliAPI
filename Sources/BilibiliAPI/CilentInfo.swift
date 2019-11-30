import Foundation

public struct ClientInfo {
    let build: Int?
    let device: String?
    let mobiApp: String?
    let platform: String?

    let userAgent: String?
    
    let keys: APIKeys?

    public var queryItems: [URLQueryItem] {
        return buildQueryItemArray(from: [
            (name: "build", value: String(fromOptional: self.build)),
            (name: "device", value: self.device),
            (name: "mobi_app", value: self.mobiApp),
            (name: "platform", value: self.platform),
        ])
    }
    
    // 防止之后添加新内容的时候遗漏掉
    public var onlyAddsQueryItemsAndUserAgent: Bool {
        return true
    }
}

public extension ClientInfo {
    static func forBrowser(userAgent: String, keys: APIKeys?) -> ClientInfo {
        return ClientInfo(build: nil, device: nil,
                          mobiApp: nil, platform: nil,
                          userAgent: userAgent,
                          keys: keys)
    }
}

public struct APIKeys {
    public let appKey: String
    public let secretKey: String
    
    public init(appKey: String, secretKey: String) {
        self.appKey = appKey
        self.secretKey = secretKey
    }
}

public extension APIKeys {
    var appKeyQueryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "actionKey", value: "appkey"),
            URLQueryItem(name: "appkey", value: self.appKey),
        ]
    }
    
    func sign(for items: inout [URLQueryItem]) {
        var uc = URLComponents()
        items.sort { $0.name < $1.name }
        uc.queryItems = items
        let queryString = uc.query ?? ""
        let sign = md5(queryString + self.secretKey)
        items.append(URLQueryItem(name: "sign", value: sign))
    }
}
