//
//  Created by Anton Spivak
//

import Foundation

// MARK: - BIP32.ExtendedKey.KeyPair

public extension BIP32.ExtendedKey {
    struct KeyPair {
        // MARK: Lifecycle

        public init(publicKey: PublicKey, privateKey: PrivateKey) {
            self.publicKey = publicKey
            self.privateKey = privateKey
        }

        // MARK: Public

        public let publicKey: PublicKey
        public let privateKey: PrivateKey
    }
}

// MARK: - BIP32.ExtendedKey.KeyPair + Equatable

extension BIP32.ExtendedKey.KeyPair: Equatable {}

// MARK: - BIP32.ExtendedKey.KeyPair + Sendable

extension BIP32.ExtendedKey.KeyPair: Sendable {}

// MARK: - BIP32.ExtendedKey.KeyPair.PrivateKey

public extension BIP32.ExtendedKey.KeyPair {
    struct PrivateKey: RawRepresentable {
        // MARK: Lifecycle

        public init(rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: Data
    }
}

// MARK: - BIP32.ExtendedKey.KeyPair.PrivateKey + Equatable

extension BIP32.ExtendedKey.KeyPair.PrivateKey: Equatable {}

// MARK: - BIP32.ExtendedKey.KeyPair.PrivateKey + Sendable

extension BIP32.ExtendedKey.KeyPair.PrivateKey: Sendable {}

// MARK: - BIP32.ExtendedKey.KeyPair.PublicKey

public extension BIP32.ExtendedKey.KeyPair {
    struct PublicKey: RawRepresentable {
        // MARK: Lifecycle

        public init(rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: Data
    }
}

// MARK: - BIP32.ExtendedKey.KeyPair.PublicKey + Equatable

extension BIP32.ExtendedKey.KeyPair.PublicKey: Equatable {}

// MARK: - BIP32.ExtendedKey.KeyPair.PublicKey + Sendable

extension BIP32.ExtendedKey.KeyPair.PublicKey: Sendable {}
