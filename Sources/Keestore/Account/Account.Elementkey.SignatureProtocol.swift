//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Elementkey.SignatureProtocol

public extension Account.Elementkey {
    struct SignatureProtocol {
        // MARK: Lifecycle

        public init(algorithm: Algorithm) {
            self.algorithm = algorithm
        }

        // MARK: Public

        public let algorithm: Algorithm
    }
}

// MARK: - Account.Elementkey.SignatureProtocol + Codable

extension Account.Elementkey.SignatureProtocol: Codable {}

// MARK: - Account.Elementkey.SignatureProtocol + Sendable

extension Account.Elementkey.SignatureProtocol: Sendable {}

// MARK: - Account.Elementkey.SignatureProtocol + Hashable

extension Account.Elementkey.SignatureProtocol: Hashable {}

// MARK: - Account.Elementkey.SignatureProtocol.Algorithm

public extension Account.Elementkey.SignatureProtocol {
    enum Algorithm {
        case curve25519
    }
}

// MARK: - Account.Elementkey.SignatureProtocol.Algorithm + Codable

extension Account.Elementkey.SignatureProtocol.Algorithm: Codable {}

// MARK: - Account.Elementkey.SignatureProtocol.Algorithm + Sendable

extension Account.Elementkey.SignatureProtocol.Algorithm: Sendable {}

// MARK: - Account.Elementkey.SignatureProtocol.Algorithm + Hashable

extension Account.Elementkey.SignatureProtocol.Algorithm: Hashable {}
