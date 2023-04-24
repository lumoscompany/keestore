//
//  Created by Anton Spivak
//

import Foundation

// MARK: - ChainInformation.SigningProtocol

public extension ChainInformation {
    struct SigningProtocol {
        // MARK: Lifecycle

        public init(algorithm: Algorithm) {
            self.algorithm = algorithm
        }

        // MARK: Public

        public let algorithm: Algorithm
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
