//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Kind

public extension Account {
    enum Kind {
        case blockchain(Blockchain)
        case elementkey(Elementkey)
        case generic(Generic)
    }
}

// MARK: - Account.Kind + Codable

extension Account.Kind: Codable {}

// MARK: - Account.Kind + Sendable

extension Account.Kind: Sendable {}

// MARK: - Account.Kind + Hashable

extension Account.Kind: Hashable {}
