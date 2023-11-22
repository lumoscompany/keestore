//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Elementkey.Item

public extension Account.Elementkey {
    struct Item {
        // MARK: Lifecycle

        public init(identifier: Identifier, information: [InformationKey: String]) {
            self.identifier = identifier
            self.information = information
        }

        // MARK: Public

        public var identifier: Identifier
        public var information: [InformationKey: String]
    }
}

// MARK: - Account.Elementkey.Item + Codable

extension Account.Elementkey.Item: Codable {}

// MARK: - Account.Elementkey.Item + Sendable

extension Account.Elementkey.Item: Sendable {}

// MARK: - Account.Elementkey.Item + Hashable

extension Account.Elementkey.Item: Hashable {}

// MARK: - Account.Elementkey.Item.Identifier

public extension Account.Elementkey.Item {
    struct Identifier: RawRepresentableCodable {
        // MARK: Lifecycle

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: String
    }
}

// MARK: - Account.Elementkey.Item.Identifier + Sendable

extension Account.Elementkey.Item.Identifier: Sendable {}

// MARK: - Account.Elementkey.Item.Identifier + Hashable

extension Account.Elementkey.Item.Identifier: Hashable {}

// MARK: - Account.Elementkey.Item.InformationKey

public extension Account.Elementkey.Item {
    struct InformationKey: RawRepresentableCodable {
        // MARK: Lifecycle

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: String
    }
}

// MARK: - Account.Elementkey.Item.InformationKey + CodingKeyRepresentable

extension Account.Elementkey.Item.InformationKey: CodingKeyRepresentable {
    public var codingKey: CodingKey {
        AnyCodingKey(stringValue: rawValue)
    }

    public init?<T>(codingKey: T) where T: CodingKey {
        self.init(rawValue: codingKey.stringValue)
    }
}

// MARK: - Account.Elementkey.Item.InformationKey + Sendable

extension Account.Elementkey.Item.InformationKey: Sendable {}

// MARK: - Account.Elementkey.Item.InformationKey + Hashable

extension Account.Elementkey.Item.InformationKey: Hashable {}

// MARK: - AnyCodingKey

private struct AnyCodingKey: CodingKey {
    // MARK: Lifecycle

    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }

    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    // MARK: Internal

    let stringValue: String
    let intValue: Int?
}
