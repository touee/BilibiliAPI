import Foundation
import JQWrapper

public protocol APIResultContainer {
    associatedtype Query: APIQuery
    associatedtype Result: APIResult
    init(result: Result)
    var result: Result { get }
}

public protocol APIResult: Codable {}

extension Array: APIResult where Element: Codable {}

public protocol ExtractableWithJQ: APIResultContainer {
    static var transformer: JQ? { get }
}

public extension ExtractableWithJQ {
    init(from response: Response) throws {
        var body = String(data: response.body, encoding: .utf8)!
        if let transformer = Self.transformer {
            body = try transformer.executeOne(input: body)
        }
        let result = try JSONDecoder().decode(Result.self, from: body.data(using: .utf8)!)
        self.init(result: result)
    }
    static func extract(from response: Response) throws -> Result {
        return try Self(from: response).result
    }
}
