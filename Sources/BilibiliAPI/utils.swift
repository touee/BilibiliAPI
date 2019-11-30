import Foundation
import Cryptor

internal func buildQueryItemArray(from pairs: [(name: String, value: String?)]) -> [URLQueryItem] {
    var out = [URLQueryItem]()
    for pair in pairs {
        guard let value = pair.value else {
            continue
        }
        out.append(URLQueryItem(name: pair.name, value: value))
    }
    return out
}

internal extension String {
    init?<T: BinaryInteger>(fromOptional num: T?) {
        guard let num = num else {
            return nil
        }
        self.init(num)
    }
}

internal func md5(_ input: String) -> String {
    return input.md5
}
