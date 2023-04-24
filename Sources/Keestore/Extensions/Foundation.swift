//
//  Created by Anton Spivak
//

import Foundation

internal extension JSONEncoder {
    static var keestore: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.keyEncodingStrategy = .useDefaultKeys
        encoder.dataEncodingStrategy = .base64
        return encoder
    }()
}

internal extension JSONDecoder {
    static var keestore: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dataDecodingStrategy = .base64
        return decoder
    }()
}

internal extension DispatchQueue {
    func async(execute block: @escaping () -> Void) {
        async(execute: DispatchWorkItem(block: block))
    }
}

internal extension Data {
    static func + (lhs: Data, rhs: Data) -> Data {
        var data = lhs
        data.append(rhs)
        return data
    }
}
