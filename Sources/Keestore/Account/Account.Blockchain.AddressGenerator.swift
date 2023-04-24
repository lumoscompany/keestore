//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Blockchain.AddressProvider

public extension Account.Blockchain {
    struct AddressProvider {
        // MARK: Lifecycle

        public init(_ function: @escaping Function) {
            self.function = function
        }

        // MARK: Public

        public typealias Function = (Account.Blockchain.PublicKey) throws -> String

        public let function: Function
    }
}

public extension Account.Blockchain.AddressProvider {
    static var empty: Account.Blockchain.AddressProvider {
        Account.Blockchain.AddressProvider({ _ in "" })
    }
}

extension ChainInformation.AddressFormatting {
    var addressProvider: Account.Blockchain.AddressProvider {
        switch self {
        case .ethereum:
            return Account.Blockchain.AddressProvider({ publicKey in
                Address.Ethereum(publicKey: publicKey).description
            })
        case .tron:
            return Account.Blockchain.AddressProvider({ publicKey in
                Address.TRON(publicKey: publicKey).description
            })
        }
    }
}
