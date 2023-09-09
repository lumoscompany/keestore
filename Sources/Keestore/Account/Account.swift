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

internal extension Account {
    func change(_ nkey: DerivedKey, with key: DerivedKey) throws -> Account {
        switch kind {
        case let .blockchain(blockchain):
            guard let credentials = blockchain.credentials
            else {
                return self
            }

            let _credentials = try credentials.decrypt(using: key)
            return try .init(
                uuid: uuid,
                name: name,
                kind: .blockchain(.init(
                    address: blockchain.address,
                    publicKey: blockchain.publicKey,
                    chain: blockchain.chain,
                    credentials: .init(decryptedValue: _credentials, using: nkey)
                )),
                view: view
            )
        case let .generic(generic):
            let _credentials = try generic.credentials.decrypt(using: key)
            return try .init(
                uuid: uuid,
                name: name,
                kind: .generic(.init(
                    origins: generic.origins,
                    credentials: .init(decryptedValue: _credentials, using: nkey)
                )),
                view: view
            )
        }
    }
}

// MARK: Codable

extension Account: Codable {}

// MARK: Sendable

extension Account: Sendable {}

// MARK: Hashable

extension Account: Hashable {}

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
            secondaryForegroundColor: PlatformColor,
            borderColor: PlatformColor
        ) {
            self.backgroundAsset = backgroundAsset
            self.primaryForegroundColor = primaryForegroundColor
            self.secondaryForegroundColor = secondaryForegroundColor
            self.borderColor = borderColor
        }

        // MARK: Public

        public let backgroundAsset: CodableResource

        public var primaryForegroundColor: PlatformColor
        public var secondaryForegroundColor: PlatformColor

        public var borderColor: PlatformColor
    }
}

// MARK: - Account.ViewRepresentation.ISO7810 + Codable

extension Account.ViewRepresentation.ISO7810: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.backgroundAsset = try container.decode(
            CodableResource.self,
            forKey: .backgroundAsset
        )

        self.primaryForegroundColor = try container.decode(
            PlatformColor.self,
            forKey: .primaryForegroundColor
        )
        self.secondaryForegroundColor = try container.decode(
            PlatformColor.self,
            forKey: .secondaryForegroundColor
        )

        self.borderColor = try container.decodeIfPresent(
            PlatformColor.self,
            forKey: .borderColor
        ) ?? .init(rawValue: .clear)
    }
}

// MARK: - Account.ViewRepresentation.ISO7810 + Sendable

extension Account.ViewRepresentation.ISO7810: Sendable {}

// MARK: - Account.ViewRepresentation.ISO7810 + Hashable

extension Account.ViewRepresentation.ISO7810: Hashable {}
