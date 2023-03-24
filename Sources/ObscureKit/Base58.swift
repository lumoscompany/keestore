//
//  Created by Anton Spivak
//

import BigInt
import CryptoKit
import Foundation

// MARK: - Base58

private enum Base58 {
    // MARK: Internal

    static func base58EncodedString(_ bytes: [UInt8]) -> String {
        var result: [UInt8] = []
        var _bytes = BigUInt(Data(bytes))

        while _bytes > 0 {
            let (quotient, remainder) = _bytes.quotientAndRemainder(dividingBy: .base58Radix)
            result.insert(alphabet[Int(remainder)], at: 0)
            _bytes = quotient
        }

        let prefix = Array(bytes.prefix(while: {
            $0 == 0
        })).map({ _ in alphabet[0] })

        result.insert(contentsOf: prefix, at: 0)
        guard let string = String(bytes: result, encoding: .utf8)
        else {
            fatalError("[Base58]: Can't encode UT8 string from bytes.")
        }

        return string
    }

    static func decodeBase58String(_ value: String) -> [UInt8]? {
        var result = BigUInt.base58Zero
        var i = BigUInt(1)

        let bytes = [UInt8](value.utf8)
        for char in bytes.reversed() {
            guard let index = alphabet.firstIndex(of: char)
            else {
                return nil
            }

            result += (i * BigUInt(index))
            i *= .base58Radix
        }

        return Array(bytes.prefix(while: {
            i in i == alphabet[0]
        })) + result.serialize()
    }

    // MARK: Fileprivate

    fileprivate static let checksuml = 4

    fileprivate static var alphabet: [UInt8] {
        [UInt8]("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".utf8)
    }
}

private extension BigUInt {
    static var base58Zero = BigUInt(0)
    static var base58Radix = BigUInt(Base58.alphabet.count)
}

public extension Array where Element == UInt8 {
    var base58EncodedString: String {
        guard !isEmpty
        else {
            return ""
        }
        return Base58.base58EncodedString(self)
    }

    var base58EncodedCheksumString: String {
        guard !isEmpty
        else {
            return ""
        }

        var bytes = self
        let checksum = [UInt8](bytes.sha256.sha256[0 ..< 4])

        bytes.append(contentsOf: checksum)
        return Base58.base58EncodedString(bytes)
    }

    init?(base58EncodedString value: String) {
        guard let bytes = Base58.decodeBase58String(value)
        else {
            return nil
        }

        self = bytes
    }

    init?(base58EncodedCheksumString value: String) {
        guard var bytes = Base58.decodeBase58String(value),
              bytes.count >= 4
        else {
            return nil
        }

        let checksum = [UInt8](bytes[bytes.count - 4 ..< bytes.count])
        bytes = [UInt8](bytes[0 ..< bytes.count - 4])

        guard [UInt8](bytes.sha256.sha256[0 ..< 4]) == checksum
        else {
            return nil
        }

        self = bytes
    }
}

public extension String {
    var base58EncodedString: String {
        [UInt8](utf8).base58EncodedString
    }

    var base58EncodedCheksumString: String {
        [UInt8](utf8).base58EncodedCheksumString
    }
}
