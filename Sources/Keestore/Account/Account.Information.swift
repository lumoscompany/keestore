//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Information

public extension Account {
    struct Information {
        // MARK: Lifecycle

        public init(name: String, look: Look) {
            self.name = name
            self.look = look
        }

        // MARK: Public

        public let name: String
        public let look: Look
    }
}

// MARK: - Account.Information + Codable

extension Account.Information: Codable {}

// MARK: - Account.Information + Sendable

extension Account.Information: Sendable {}

// MARK: - Account.Information + Hashable

extension Account.Information: Hashable {}

// MARK: - Account.Information.Look

public extension Account.Information {
    enum Look {
        case card(Card)
    }
}

// MARK: - Account.Information.Look + Codable

extension Account.Information.Look: Codable {}

// MARK: - Account.Information.Look + Sendable

extension Account.Information.Look: Sendable {}

// MARK: - Account.Information.Look + Hashable

extension Account.Information.Look: Hashable {}

// MARK: - Account.Information.Look.Card

public extension Account.Information.Look {
    struct Card {
        // MARK: Lifecycle

        public init(
            borderColor: Unicolor,
            backgroundAsset: CodableAsset,
            primaryForegroundColor: Unicolor,
            secondaryForegroundColor: Unicolor
        ) {
            self.borderColor = borderColor
            self.backgroundAsset = backgroundAsset
            self.primaryForegroundColor = primaryForegroundColor
            self.secondaryForegroundColor = secondaryForegroundColor
        }

        // MARK: Public

        @CodableColor
        public var borderColor: Unicolor

        public let backgroundAsset: CodableAsset

        @CodableColor
        public var primaryForegroundColor: Unicolor

        @CodableColor
        public var secondaryForegroundColor: Unicolor
    }
}

// MARK: - Account.Information.Look.Card + Codable

extension Account.Information.Look.Card: Codable {}

// MARK: - Account.Information.Look.Card + Sendable

extension Account.Information.Look.Card: Sendable {}

// MARK: - Account.Information.Look.Card + Hashable

extension Account.Information.Look.Card: Hashable {}
