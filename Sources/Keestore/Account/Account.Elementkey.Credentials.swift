//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Elementkey.Credentials

public extension Account.Elementkey {
    struct Credentials {
        // MARK: Lifecycle

        public init(
            publicKey: PublicKey,
            signatureProtocol: SignatureProtocol,
            privateKey: EncryptedValue<PrivateKey>
        ) {
            self.signatureProtocol = signatureProtocol
            self.publicKey = publicKey
            self.privateKey = privateKey
        }

        // MARK: Public

        public typealias PublicKey = Data
        public typealias PrivateKey = Data

        public var signatureProtocol: SignatureProtocol

        public var publicKey: PublicKey
        public var privateKey: EncryptedValue<PrivateKey>
    }
}

// MARK: - Account.Elementkey.Credentials + Codable

extension Account.Elementkey.Credentials: Codable {}

// MARK: - Account.Elementkey.Credentials + Sendable

extension Account.Elementkey.Credentials: Sendable {}

// MARK: - Account.Elementkey.Credentials + Hashable

extension Account.Elementkey.Credentials: Hashable {}

public extension Account.Elementkey.Credentials {
    static func generate(
        with signatureProtocol: Account.Elementkey.SignatureProtocol,
        using key: DerivedKey
    ) throws -> Account.Elementkey.Credentials {
        switch signatureProtocol.algorithm {
        case .curve25519:
            let privateKey = KeyPair.Curve25519.PrivateKey()
            return try .init(
                publicKey: privateKey.publicKey.rawValue,
                signatureProtocol: signatureProtocol,
                privateKey: .init(decryptedValue: privateKey.rawValue, using: key)
            )
        }
    }

    func sign(message: String, using key: DerivedKey) throws -> any DataProtocol {
        let privateKey = try privateKey(using: key)
        return try privateKey.sign([UInt8](message.utf8))
    }
}

internal extension Account.Elementkey.Credentials {
    func privateKey(using key: DerivedKey) throws -> any _PrivateKey {
        let rawValue: Data
        do {
            rawValue = try privateKey.decrypt(using: key)
        } catch {
            throw Keestore.Error.wrongKey
        }

        return switch signatureProtocol.algorithm {
        case .curve25519: try KeyPair.Curve25519.PrivateKey(rawValue: rawValue)
        }
    }
}
