//
//  Created by Anton Spivak
//

import CryptoKit
import Foundation

// MARK: - DerivedKey.PublicSignature

public extension DerivedKey {
    struct PublicSignature: RawRepresentable {
        // MARK: Lifecycle

        public init(rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        /// - note: 64 bytes
        public var rawValue: Data
    }
}

// MARK: - DerivedKey.PublicSignature + Codable

extension DerivedKey.PublicSignature: Codable {}

// MARK: - DerivedKey.PublicSignature + Sendable

extension DerivedKey.PublicSignature: Sendable {}

// MARK: - DerivedKey.PublicSignature + Hashable

extension DerivedKey.PublicSignature: Hashable {}

public extension DerivedKey.PublicSignature {
    init(key: DerivedKey) {
        let signature = Curve25519.Signing.PrivateKey.signature(for: key)
        self.init(rawValue: signature)
    }

    func validate(key: DerivedKey) -> Bool {
        Curve25519.Signing.PrivateKey.validate(signature: rawValue, for: key)
    }
}

private extension Curve25519.Signing.PrivateKey {
    static func validate(signature: Data, for key: DerivedKey) -> Bool {
        let privateKey = Self(key: key)
        return privateKey.publicKey.isValidSignature(signature, for: _signatureData)
    }

    static func signature(for key: DerivedKey) -> Data {
        let privateKey = Self(key: key)
        guard let signature = try? privateKey.signature(for: _signatureData)
        else {
            fatalError("[Curve25519.Signing.PrivateKey]: Curve25519 signature error.")
        }
        return signature
    }

    private init(key: DerivedKey) {
        var hash: (any ContiguousBytes)!
        key.perform(with: {
            hash = hmac(SHA512.self, bytes: [UInt8](), key: $0)
        })
        
        let seed = try? PKCS5.PBKDF2SHA512(
            password: hash.concreteBytes.sha512,
            salt: [UInt8]("derived key signature seed".utf8),
            iterations: UInt32(100_000),
            derivedKeyLength: 32
        )

        guard let seed
        else {
            fatalError("[]: PKCS5.PBKDF2SHA512 error.")
        }

        let privateKey = try? Curve25519.Signing.PrivateKey(rawRepresentation: seed)
        guard let privateKey
        else {
            fatalError("[KEY32.Signature]: Curve25519 error.")
        }

        self = privateKey
    }

    private static var _signatureData: Data {
        Data([UInt8]("derived key signature data".utf8))
    }
}
