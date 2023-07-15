//
//  Created by Anton Spivak
//

import Foundation

internal extension JSONEncoder {
    private static var keestore: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.keyEncodingStrategy = .useDefaultKeys
        encoder.dataEncodingStrategy = .base64
        return encoder
    }()

    static func encode<T>(_ value: T) throws -> Data where T: Encodable {
        do {
            return try keestore.encode(value)
        } catch {
            throw Keestore.Error.encodingFailed(error)
        }
    }
}

internal extension JSONDecoder {
    private static var keestore: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dataDecodingStrategy = .base64
        return decoder
    }()

    static func decode<T>(
        _ type: T.Type,
        from data: Data
    ) throws -> T where T: Decodable {
        do {
            return try keestore.decode(type, from: data)
        } catch {
            throw Keestore.Error.decodingFailed(error)
        }
    }
}

internal extension Data {
    static func + (lhs: Data, rhs: Data) -> Data {
        var data = lhs
        data.append(rhs)
        return data
    }
}
