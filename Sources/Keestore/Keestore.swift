//
//  Created by Anton Spivak
//

import Foundation

@_exported import BIP
@_exported import ObscureKit

// MARK: - Keestore

public struct Keestore {
    // MARK: Lifecycle

    public init(signature: DerivedKey.Signature, accounts: [Account]) {
        self.signature = signature
        self.accounts = accounts
    }

    // MARK: Public

    private(set) public var signature: DerivedKey.Signature
    private(set) public var accounts: [Account]
}

// MARK: - Keestore + Modifications

public extension Keestore {
    mutating func append(_ account: Account, using key: DerivedKey) throws {
        guard key.validate(signature)
        else {
            throw Error.wrongKey
        }

        accounts.append(account)
    }

    mutating func remove(_ account: Account, using key: DerivedKey) throws {
        guard key.validate(signature)
        else {
            throw Error.wrongKey
        }

        accounts.removeAll(where: { $0.uuid == account.uuid })
    }
}
