//
//  Created by Anton Spivak
//

import CryptoKit
import Foundation

// MARK: - KeyPair.Curve25519

public extension KeyPair {
    enum Curve25519: _KeyPair {}
}

// MARK: - KeyPair.Curve25519.Error

public extension KeyPair.Curve25519 {
    enum Error {
        case invalidPrivateKey
    }
}

// MARK: - KeyPair.Curve25519.Error + LocalizedError

extension KeyPair.Curve25519.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPrivateKey:
            return "[Curve25519.Error]: Private key invalid."
        }
    }
}

// MARK: - KeyPair.Curve25519.PublicKey

public extension KeyPair.Curve25519 {
    struct PublicKey: _PublicKey {
        // MARK: Lifecycle

        public init(rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: Data
    }
}

public extension KeyPair.Curve25519.PublicKey {
    var compressed: KeyPair.Curve25519.PublicKey {
        self
    }

    func check(signature: any DataProtocol, for data: any DataProtocol) throws -> Bool {
        try CryptoKit.Curve25519.Signing.PublicKey(
            rawRepresentation: rawValue
        ).isValidSignature(signature, for: data)
    }
}

// MARK: - KeyPair.Curve25519.PublicKey + Sendable

extension KeyPair.Curve25519.PublicKey: Sendable {}

// MARK: - KeyPair.Curve25519.PublicKey + Hashable

extension KeyPair.Curve25519.PublicKey: Hashable {}

// MARK: - KeyPair.Curve25519.PrivateKey

public extension KeyPair.Curve25519 {
    struct PrivateKey: _PrivateKey {
        // MARK: Lifecycle

        public init() {
            let privateKey = Curve25519.Signing.PrivateKey()
            self.rawValue = privateKey.rawRepresentation
        }

        public init(rawValue: Data) throws {
            guard rawValue.count == 32
            else {
                throw Error.invalidPrivateKey
            }

            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: Data
    }
}

public extension KeyPair.Curve25519.PrivateKey {
    var publicKey: KeyPair.Curve25519.PublicKey {
        do {
            let publicKey = try CryptoKit.Curve25519.Signing.PrivateKey(
                rawRepresentation: rawValue
            ).publicKey
            return KeyPair.Curve25519.PublicKey(rawValue: publicKey.rawRepresentation)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func sign(_ data: any DataProtocol) throws -> any DataProtocol {
        try Curve25519.Signing.PrivateKey(
            rawRepresentation: rawValue
        ).signature(for: data)
    }
}

// MARK: - KeyPair.Curve25519.PrivateKey + Codable

extension KeyPair.Curve25519.PrivateKey: Codable {}

// MARK: - KeyPair.Curve25519.PrivateKey + Sendable

extension KeyPair.Curve25519.PrivateKey: Sendable {}

// MARK: - KeyPair.Curve25519.PrivateKey + Hashable

extension KeyPair.Curve25519.PrivateKey: Hashable {}
