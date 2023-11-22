//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Elementkey.Service

public extension Account.Elementkey {
    struct Service {
        // MARK: Lifecycle

        public init(identifier: Identifier, icon: CodableResource?) {
            self.identifier = identifier
            self.icon = icon
        }

        // MARK: Public

        public var identifier: Identifier
        public let icon: CodableResource?
    }
}

// MARK: - Account.Elementkey.Service + Codable

extension Account.Elementkey.Service: Codable {}

// MARK: - Account.Elementkey.Service + Sendable

extension Account.Elementkey.Service: Sendable {}

// MARK: - Account.Elementkey.Service + Hashable

extension Account.Elementkey.Service: Hashable {}

// MARK: - Account.Elementkey.Service.Identifier

public extension Account.Elementkey.Service {
    struct Identifier: RawRepresentableCodable {
        // MARK: Lifecycle

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: String
    }
}

// MARK: - Account.Elementkey.Service.Identifier + Sendable

extension Account.Elementkey.Service.Identifier: Sendable {}

// MARK: - Account.Elementkey.Service.Identifier + Hashable

extension Account.Elementkey.Service.Identifier: Hashable {}
