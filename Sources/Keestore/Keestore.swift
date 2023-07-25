//
//  Created by Anton Spivak
//

import Foundation

@_exported import BIP
@_exported import ObscureKit

// MARK: - Keestore

public struct Keestore {
    // MARK: Lifecycle

    public init?(key: DerivedKey) {
        guard let signature = DerivedKey.PublicSignature(key: key)
        else {
            return nil
        }

        self.init(
            version: 0,
            signature: signature,
            accounts: []
        )
    }

    public init(version: Int, signature: DerivedKey.PublicSignature, accounts: [Account]) {
        self.version = version
        self.signature = signature
        self.accounts = accounts
    }

    // MARK: Public

    private(set) public var version: Int
    private(set) public var signature: DerivedKey.PublicSignature
    private(set) public var accounts: [Account]
}

// MARK: - Keestore + Modifications

public extension Keestore {
    mutating func append(_ account: Account, using key: DerivedKey) throws {
        try validate(key)
        accounts.append(account)
    }

    mutating func update(_ account: Account, using key: DerivedKey) throws {
        try validate(key)
        
        let index = accounts.firstIndex(where: {
            $0.uuid == account.uuid
        })
        
        guard let index
        else {
            throw Error.accountNotExists
        }
        
        accounts[index] = account
    }

    mutating func remove(_ account: Account, using key: DerivedKey) throws {
        try validate(key)
        accounts.removeAll(where: { $0.uuid == account.uuid })
    }

    private func validate(_ key: DerivedKey) throws {
        guard signature.validate(key: key)
        else {
            throw Error.wrongKey
        }
    }
}

// MARK: Codable

extension Keestore: Codable {}

// MARK: Sendable

extension Keestore: Sendable {}

// MARK: Hashable

extension Keestore: Hashable {}
