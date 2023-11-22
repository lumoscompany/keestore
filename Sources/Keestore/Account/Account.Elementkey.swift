//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Elementkey

public extension Account {
    struct Elementkey {
        // MARK: Lifecycle

        public init(
            item: Item,
            service: Service,
            token: ViewToken,
            credentials: Credentials
        ) {
            self.item = item
            self.service = service
            self.token = token
            self.credentials = credentials
        }

        // MARK: Public

        public typealias PublicKey = Data
        public typealias ViewToken = String

        public var item: Item
        public var service: Service

        public var token: ViewToken
        public var credentials: Credentials
    }
}

// MARK: - Account.Elementkey + Codable

extension Account.Elementkey: Codable {}

// MARK: - Account.Elementkey + Sendable

extension Account.Elementkey: Sendable {}

// MARK: - Account.Elementkey + Hashable

extension Account.Elementkey: Hashable {}
