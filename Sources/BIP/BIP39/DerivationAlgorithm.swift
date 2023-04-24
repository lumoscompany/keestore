//
//  Created by Anton Spivak
//

import AuthenticationServices
import CryptoKit
import ObscureKit

// MARK: - BIP39.DerivationAlgorithm

public extension BIP39 {
    enum DerivationAlgorithm {
        case hmac(kind: HashingFunction)
        case pkcs5(salt: String, password: String, iterations: Int, klength: Int)
    }
}

// MARK: - BIP39.DerivationAlgorithm + Codable

extension BIP39.DerivationAlgorithm: Codable {}

// MARK: - BIP39.DerivationAlgorithm + Sendable

extension BIP39.DerivationAlgorithm: Sendable {}

// MARK: - BIP39.DerivationAlgorithm + Hashable

extension BIP39.DerivationAlgorithm: Hashable {}

// MARK: - BIP39.DerivationAlgorithm.HashingFunction

public extension BIP39.DerivationAlgorithm {
    enum HashingFunction {
        case sha512
    }
}

// MARK: - BIP39.DerivationAlgorithm.HashingFunction + Codable

extension BIP39.DerivationAlgorithm.HashingFunction: Codable {}

// MARK: - BIP39.DerivationAlgorithm.HashingFunction + Sendable

extension BIP39.DerivationAlgorithm.HashingFunction: Sendable {}

// MARK: - BIP39.DerivationAlgorithm.HashingFunction + Hashable

extension BIP39.DerivationAlgorithm.HashingFunction: Hashable {}

internal extension BIP39.DerivationAlgorithm.HashingFunction {
    var _function: (some HashFunction).Type {
        switch self {
        case .sha512:
            return SHA512.self
        }
    }
}

internal extension Collection where Element == BIP39.DerivationAlgorithm {
    func seed(from words: [String]) throws -> some ContiguousBytes {
        var value = [UInt8](words.joined(separator: " ").normalized().utf8)
        try forEach({
            switch $0 {
            case let .hmac(kind):
                value = hmac(kind._function, bytes: [UInt8](), key: value).concreteBytes
            case let .pkcs5(salt, password, iterations, klength):
                value = try PKCS5.PBKDF2SHA512(
                    password: value,
                    salt: [UInt8]("\(salt)\(password)".normalized().utf8),
                    iterations: UInt32(iterations),
                    derivedKeyLength: klength
                ).concreteBytes
            }
        })
        return value
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

public extension Array where Element == BIP39.DerivationAlgorithm {
    static func ethereum(
        password: String = "",
        iterations: Int = 2048,
        klength: Int = 64
    ) -> [Element] {
        return [.pkcs5(
            salt: "mnemonic",
            password: password,
            iterations: iterations,
            klength: klength
        )]
    }

    static func ton(iterations: Int = 100000, klength: Int = 32) -> [Element] {
        return [
            .hmac(kind: .sha512),
            .pkcs5(
                salt: "TON default seed",
                password: "",
                iterations: iterations,
                klength: klength
            ),
        ]
    }
}
