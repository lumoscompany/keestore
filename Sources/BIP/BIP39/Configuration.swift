//
//  Created by Anton Spivak
//

import AuthenticationServices
import CryptoKit
import ObscureKit

// MARK: - BIP39.Configuration

public extension BIP39 {
    enum Configuration {
        case standart(password: String = "", iterations: Int = 2048, keyLength: Int = 64)
        case ton(iterations: Int = 100000, keyLength: Int = 32)
    }
}

internal extension BIP39.Configuration {
    func seed(from words: [String]) throws -> some ContiguousBytes {
        switch self {
        case let .standart(password, iterations, keyLength):
            let mnemonic = words.joined(separator: " ").normalized()
            let salt = "mnemonic\(password)".normalized()
            return try PKCS5.PBKDF2SHA512(
                password: [UInt8](mnemonic.utf8),
                salt: [UInt8](salt.utf8),
                iterations: UInt32(iterations),
                derivedKeyLength: keyLength
            )
        case let .ton(iterations, keyLength):
            let mnemonic = words.joined(separator: " ").normalized()
            let hash = hmac(SHA512.self, bytes: [UInt8](), key: [UInt8](mnemonic.utf8))

            let salt = "TON default seed".normalized()
            return try PKCS5.PBKDF2SHA512(
                password: hash.concreteBytes,
                salt: [UInt8](salt.utf8),
                iterations: UInt32(iterations),
                derivedKeyLength: keyLength
            )
        }
    }
}

private extension String {
    func normalized() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private extension Array where Element == String {
    func normalized() -> [String] {
        map({ $0.normalized() })
    }
}
