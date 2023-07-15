//
//  Created by Anton Spivak
//

import BIP
import Foundation

// MARK: - Account

public struct Account {
    // MARK: Lifecycle

    public init(uuid: UUID = UUID(), name: String, kind: Kind, view: ViewRepresentation) {
        self.uuid = uuid
        self.name = name
        self.kind = kind
        self.view = view
    }

    // MARK: Public

    public var uuid: UUID
    public var name: String
    public var kind: Kind
    public var view: ViewRepresentation
}

// MARK: Codable

extension Account: Codable {}

// MARK: Sendable

extension Account: Sendable {}

// MARK: Hashable

extension Account: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    public static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

// MARK: Account.ViewRepresentation

public extension Account {
    enum ViewRepresentation {
        case iso7810(ISO7810)
    }
}

// MARK: - Account.ViewRepresentation + Codable

extension Account.ViewRepresentation: Codable {}

// MARK: - Account.ViewRepresentation + Sendable

extension Account.ViewRepresentation: Sendable {}

// MARK: - Account.ViewRepresentation + Hashable

extension Account.ViewRepresentation: Hashable {}

// MARK: - Account.ViewRepresentation.ISO7810

public extension Account.ViewRepresentation {
    struct ISO7810 {
        // MARK: Lifecycle

        public init(
            backgroundAsset: CodableResource,
            primaryForegroundColor: PlatformColor,
            secondaryForegroundColor: PlatformColor
        ) {
            self.backgroundAsset = backgroundAsset
            self.primaryForegroundColor = primaryForegroundColor
            self.secondaryForegroundColor = secondaryForegroundColor
        }

        // MARK: Public

        public let backgroundAsset: CodableResource

        public var primaryForegroundColor: PlatformColor
        public var secondaryForegroundColor: PlatformColor
    }
}

// MARK: - Account.ViewRepresentation.ISO7810 + Codable

extension Account.ViewRepresentation.ISO7810: Codable {}

// MARK: - Account.ViewRepresentation.ISO7810 + Sendable

extension Account.ViewRepresentation.ISO7810: Sendable {}

// MARK: - Account.ViewRepresentation.ISO7810 + Hashable

extension Account.ViewRepresentation.ISO7810: Hashable {}
