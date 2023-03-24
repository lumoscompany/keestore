//
//  Created by Anton Spivak
//

import Foundation

@_exported import BIP
@_exported import ObscureKit

// MARK: - Wolstore

public struct Wolstore {
    // MARK: Lifecycle

    public init(signature: DerivedKey.Signature, accounts: [Account]) {
        self.signature = signature
        self.accounts = accounts
    }

    // MARK: Public

    public var signature: DerivedKey.Signature
    public var accounts: [Account]
}

// MARK: - Wolstore + Modifications

public extension Wolstore {
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
