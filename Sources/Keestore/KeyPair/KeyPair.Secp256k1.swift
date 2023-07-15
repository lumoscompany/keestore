//
//  Created by Anton Spivak
//

import Foundation
import ObscureKit

// MARK: - KeyPair.Secp256k1

public extension KeyPair {
    enum Secp256k1: _KeyPair {}
}

// MARK: - KeyPair.Secp256k1.Error

public extension KeyPair.Secp256k1 {
    enum Error {
        case invalidPrivateKey
    }
}

// MARK: - KeyPair.Secp256k1.Error + LocalizedError

extension KeyPair.Secp256k1.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPrivateKey:
            return "[Secp256k1.Error]: Private key invalid."
        }
    }
}

// MARK: - KeyPair.Secp256k1.PublicKey

public extension KeyPair.Secp256k1 {
    struct PublicKey: _PublicKey {
        // MARK: Lifecycle

        internal init(rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: Data
    }
}

public extension KeyPair.Secp256k1.PublicKey {
    var uncompressed: KeyPair.Secp256k1.PublicKey {
        let concreteBytes = try? ObscureKit.secp256k1.parsePublicKey(
            from: rawValue,
            compressed: false
        ).concreteBytes

        guard let concreteBytes
        else {
            fatalError("[KeyPair.Secp256k1.PublicKey]: Bad data.")
        }

        return KeyPair.Secp256k1.PublicKey(rawValue: Data(concreteBytes))
    }

    func check(signature: any DataProtocol, for data: any DataProtocol) throws -> Bool {
        fatalError()
    }
}

// MARK: - KeyPair.Secp256k1.PublicKey + Sendable

extension KeyPair.Secp256k1.PublicKey: Sendable {}

// MARK: - KeyPair.Secp256k1.PublicKey + Hashable

extension KeyPair.Secp256k1.PublicKey: Hashable {}

// MARK: - KeyPair.Secp256k1.PrivateKey

public extension KeyPair.Secp256k1 {
    struct PrivateKey: _PrivateKey {
        // MARK: Lifecycle

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

public extension KeyPair.Secp256k1.PrivateKey {
    var publicKey: KeyPair.Secp256k1.PublicKey {
        do {
            let publicKey = try ObscureKit.secp256k1.generatePublicKey(
                from: rawValue,
                compressed: true
            ).concreteBytes
            return KeyPair.Secp256k1.PublicKey(rawValue: Data(publicKey))
        } catch {
            fatalError("\(error)")
        }
    }

    func sign(_ data: any DataProtocol) throws -> any DataProtocol {
        let result = try ObscureKit.secp256k1.sign(
            value: Data(data).concreteBytes,
            with: rawValue
        ).combined.concreteBytes
        return Data(result)
    }
}

// MARK: - KeyPair.Secp256k1.PrivateKey + Codable

extension KeyPair.Secp256k1.PrivateKey: Codable {}

// MARK: - KeyPair.Secp256k1.PrivateKey + Sendable

extension KeyPair.Secp256k1.PrivateKey: Sendable {}

// MARK: - KeyPair.Secp256k1.PrivateKey + Hashable

extension KeyPair.Secp256k1.PrivateKey: Hashable {}
