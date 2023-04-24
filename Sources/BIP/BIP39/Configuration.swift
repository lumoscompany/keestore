//
//  Created by Anton Spivak
//

import AuthenticationServices
import CryptoKit
import ObscureKit

// MARK: - BIP39.Configuration

public extension BIP39 {
    struct Configuration {
        // MARK: Lifecycle

        public init(
            derivationAlgorithm: DerivationAlgorithm,
            salt: String,
            password: String,
            iterations: Int,
            keyLength: Int
        ) {
            self.derivationAlgorithm = derivationAlgorithm
            self.salt = salt
            self.password = password
            self.iterations = iterations
            self.keyLength = keyLength
        }

        // MARK: Public

        public let derivationAlgorithm: DerivationAlgorithm
        public let salt: String
        public let password: String
        public let iterations: Int
        public let keyLength: Int
    }
}

// MARK: - BIP39.Configuration + Codable

extension BIP39.Configuration: Codable {}

// MARK: - BIP39.Configuration + Sendable

extension BIP39.Configuration: Sendable {}

// MARK: - BIP39.Configuration + Hashable

extension BIP39.Configuration: Hashable {}

// MARK: - BIP39.Configuration.DerivationAlgorithm

public extension BIP39.Configuration {
    enum DerivationAlgorithm: String {
        case hmacpbkdf2 = "hmac-sha512-pbkdf2-sha512"
        case pbkdf2 = "pbkdf2-sha512"
    }
}

// MARK: - BIP39.Configuration.DerivationAlgorithm + Codable

extension BIP39.Configuration.DerivationAlgorithm: Codable {}

// MARK: - BIP39.Configuration.DerivationAlgorithm + Sendable

extension BIP39.Configuration.DerivationAlgorithm: Sendable {}

// MARK: - BIP39.Configuration.DerivationAlgorithm + Hashable

extension BIP39.Configuration.DerivationAlgorithm: Hashable {}

public extension BIP39.Configuration {
    static func standart(
        password: String = "",
        iterations: Int = 2048,
        keyLength: Int = 64
    ) -> BIP39.Configuration {
        BIP39.Configuration(
            derivationAlgorithm: .pbkdf2,
            salt: "mnemonic",
            password: password,
            iterations: iterations,
            keyLength: keyLength
        )
    }

    static func ton(iterations: Int = 100000, keyLength: Int = 32) -> BIP39.Configuration {
        BIP39.Configuration(
            derivationAlgorithm: .hmacpbkdf2,
            salt: "TON default seed",
            password: "",
            iterations: iterations,
            keyLength: keyLength
        )
    }
}

internal extension BIP39.Configuration {
    func seed(from words: [String]) throws -> some ContiguousBytes {
        switch derivationAlgorithm {
        case .pbkdf2:
            let mnemonic = words.joined(separator: " ").normalized()
            let salt = "\(salt)\(password)".normalized()
            return try PKCS5.PBKDF2SHA512(
                password: [UInt8](mnemonic.utf8),
                salt: [UInt8](salt.utf8),
                iterations: UInt32(iterations),
                derivedKeyLength: keyLength
            )
        case .hmacpbkdf2:
            let mnemonic = words.joined(separator: " ").normalized()
            let hash = hmac(SHA512.self, bytes: [UInt8](), key: [UInt8](mnemonic.utf8))
            let salt = "\(salt)\(password)".normalized()
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
