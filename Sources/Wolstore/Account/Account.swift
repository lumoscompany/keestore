//
//  Created by Anton Spivak
//

import BIP
import Foundation

// MARK: - Account

public struct Account {
    // MARK: Lifecycle

    public init(
        uuid: UUID,
        kind: Kind,
        information: Information
    ) {
        self.uuid = uuid
        self.kind = kind
        self.information = information
    }

    // MARK: Public

    public var uuid: UUID
    public var kind: Kind
    public var information: Information
}

// MARK: Codable

extension Account: Codable {}

// MARK: Sendable

extension Account: Sendable {}

// MARK: Hashable

extension Account: Hashable {}
