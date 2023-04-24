//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Generic

public extension Account {
    struct Generic {
        // MARK: Lifecycle

        public init(
            origins: [URL],
            login: String,
            credentials: EncryptedValue<Credentials>
        ) {
            self.login = login
            self.origins = origins
            self.credentials = credentials
        }

        // MARK: Public

        public var origins: [URL]
        public var login: String
        public var credentials: EncryptedValue<Credentials>
    }
}

// MARK: - Account.Generic + Codable

extension Account.Generic: Codable {}

// MARK: - Account.Generic + Sendable

extension Account.Generic: Sendable {}

// MARK: - Account.Generic + Hashable

extension Account.Generic: Hashable {}

// MARK: - Account.Generic.Credentials

public extension Account.Generic {
    enum Credentials {
        case password(Plaintext, OTP?)

        // MARK: Public

        public typealias Plaintext = Data
        public typealias OTP = Data
    }
}

// MARK: - Account.Generic.Credentials + Codable

extension Account.Generic.Credentials: Codable {}

// MARK: - Account.Generic.Credentials + Sendable

extension Account.Generic.Credentials: Sendable {}

// MARK: - Account.Generic.Credentials + Hashable

extension Account.Generic.Credentials: Hashable {}
