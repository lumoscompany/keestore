//
//  Created by Anton Spivak
//

import CommonCrypto
import CryptoKit
import Foundation

// MARK: - DerivedKey

public struct DerivedKey {
    // MARK: Lifecycle

    /// - parameter rawValue: 32 bytes buffer (SHA256)
    public init?(rawValue: Data) {
        guard rawValue.count == kCCKeySizeAES256
        else {
            return nil
        }

        self.rawValue = rawValue
    }

    /// - parameter string: Any UTF8 string
    public init(string: String) {
        let data = [UInt8](string.utf8)
        let hash = try? PKCS5.PBKDF2SHA512(
            password: data.sha512,
            salt: [UInt8]("derived key encryption seed".utf8),
            iterations: UInt32(100_000),
            derivedKeyLength: 32
        )

        guard let hash
        else {
            fatalError("[SymmetricKey]: PKCS5.PBKDF2SHA512 error.")
        }

        self.rawValue = Data(hash.concreteBytes.sha256)
    }

    // MARK: Public

    /// - note: 32 bytes
    public let rawValue: Data
}

internal extension SymmetricKey {
    init(_ key: DerivedKey) {
        self.init(data: key.rawValue)
    }
}

// MARK: - DerivedKey + Sendable

extension DerivedKey: Sendable {}

// MARK: - DerivedKey + Hashable

extension DerivedKey: Hashable {}

// MARK: - DerivedKey.Signature

///  - note: Do not implement it by default due security.
// extension DerivedKey: Codable {}

public extension DerivedKey {
    struct Signature: RawRepresentable {
        // MARK: Lifecycle

        public init(rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        /// - note: 64 bytes
        public var rawValue: Data
    }
}

// MARK: - DerivedKey.Signature + Codable

extension DerivedKey.Signature: Codable {}

// MARK: - DerivedKey.Signature + Sendable

extension DerivedKey.Signature: Sendable {}

// MARK: - DerivedKey.Signature + Hashable

extension DerivedKey.Signature: Hashable {}

public extension DerivedKey {
    var signature: Signature {
        guard let signature = try? _generateKeyPair().privateKey.signature(for: _signatureData)
        else {
            fatalError("[DerivedKey.Signature]: Curve25519 error.")
        }

        return Signature(rawValue: signature)
    }

    func validate(_ signature: Signature) -> Bool {
        let keyPair = _generateKeyPair()
        return keyPair.publicKey.isValidSignature(
            signature.rawValue,
            for: _signatureData
        )
    }

    private var _signatureData: Data {
        Data([UInt8]("derived key signature data".utf8))
    }

    private func _generateKeyPair() -> (
        publicKey: Curve25519.Signing.PublicKey,
        privateKey: Curve25519.Signing.PrivateKey
    ) {
        let hash = hmac(SHA512.self, bytes: [UInt8](), key: rawValue)
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

        return (privateKey.publicKey, privateKey)
    }
}
