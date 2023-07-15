//
//  Created by Anton Spivak
//

import Foundation
import ObscureKit

// MARK: - ChainInformation.SigningProtocol

public extension ChainInformation {
    struct SigningProtocol {
        // MARK: Lifecycle

        public init(algorithm: Algorithm, hashingFunction: HashingFunction?) {
            self.algorithm = algorithm
            self.hashingFunction = hashingFunction
        }

        // MARK: Public

        public let algorithm: Algorithm
        public let hashingFunction: HashingFunction?
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

internal extension Optional where Wrapped == ChainInformation.HashingFunction {
    func process(_ bytes: any ContiguousBytes) -> some ContiguousBytes {
        switch self {
        case .none:
            return bytes.concreteBytes
        case let .some(wrapped):
            switch wrapped {
            case .keccak256:
                return keccak256(bytes).concreteBytes
            }
        }
    }
}
