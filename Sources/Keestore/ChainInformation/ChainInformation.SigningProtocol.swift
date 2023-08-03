//
//  Created by Anton Spivak
//

import Foundation
import ObscureKit

// MARK: - ChainInformation.SigningProtocol

public extension ChainInformation {
    struct SigningProtocol {
        // MARK: Lifecycle

        public init(
            algorithm: Algorithm,
            hashingFunction: HashingFunction?,
            messageSigningPrefix: SigningMessagePrefix?
        ) {
            self.algorithm = algorithm
            self.hashingFunction = hashingFunction
            self.messageSigningPrefix = messageSigningPrefix
        }

        // MARK: Public

        public let algorithm: Algorithm
        public let hashingFunction: HashingFunction?
        public let messageSigningPrefix: SigningMessagePrefix?
    }
}

// MARK: - ChainInformation.SigningProtocol + Codable

extension ChainInformation.SigningProtocol: Codable {}

// MARK: - ChainInformation.SigningProtocol + Sendable

extension ChainInformation.SigningProtocol: Sendable {}

// MARK: - ChainInformation.SigningProtocol + Hashable

extension ChainInformation.SigningProtocol: Hashable {}

// MARK: - ChainInformation.SigningProtocol.Algorithm

public extension ChainInformation.SigningProtocol {
    enum Algorithm {
        case secp256k1
        case curve25519
    }
}

// MARK: - ChainInformation.SigningProtocol.Algorithm + Codable

extension ChainInformation.SigningProtocol.Algorithm: Codable {}

// MARK: - ChainInformation.SigningProtocol.Algorithm + Sendable

extension ChainInformation.SigningProtocol.Algorithm: Sendable {}

// MARK: - ChainInformation.SigningProtocol.Algorithm + Hashable

extension ChainInformation.SigningProtocol.Algorithm: Hashable {}

// MARK: - ChainInformation.HashingFunction

public extension ChainInformation {
    enum HashingFunction {
        case keccak256
    }
}

// MARK: - ChainInformation.HashingFunction + Codable

extension ChainInformation.HashingFunction: Codable {}

// MARK: - ChainInformation.HashingFunction + Sendable

extension ChainInformation.HashingFunction: Sendable {}

// MARK: - ChainInformation.HashingFunction + Hashable

extension ChainInformation.HashingFunction: Hashable {}

// MARK: - ChainInformation.SigningMessagePrefix

public extension ChainInformation {
    struct SigningMessagePrefix {
        // MARK: Lifecycle

        public init(firstByte: UInt8?, prefixText: String, hashingFunction: HashingFunction?) {
            self.firstByte = firstByte
            self.prefixText = prefixText
            self.hashingFunction = hashingFunction
        }

        // MARK: Public

        public let firstByte: UInt8?
        public let prefixText: String
        public let hashingFunction: HashingFunction?
    }
}

// MARK: - ChainInformation.SigningMessagePrefix + Codable

extension ChainInformation.SigningMessagePrefix: Codable {}

// MARK: - ChainInformation.SigningMessagePrefix + Sendable

extension ChainInformation.SigningMessagePrefix: Sendable {}

// MARK: - ChainInformation.SigningMessagePrefix + Hashable

extension ChainInformation.SigningMessagePrefix: Hashable {}

internal extension Optional where Wrapped == ChainInformation.HashingFunction {
    func process(_ bytes: any ContiguousBytes) -> any ContiguousBytes {
        switch self {
        case .none:
            return bytes.concreteBytes
        case let .some(wrapped):
            return wrapped.process(bytes)
        }
    }
}

internal extension ChainInformation.HashingFunction {
    func process(_ bytes: any ContiguousBytes) -> any ContiguousBytes {
        switch self {
        case .keccak256:
            return ObscureKit.keccak256(bytes).concreteBytes
        }
    }
}
