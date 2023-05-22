//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Blockchain.AddressProvider

public extension Account.Blockchain {
    struct AddressProvider {
        // MARK: Lifecycle

        public init(
            generator: @escaping GeneratorFunction,
            validator: @escaping ValidatorFunction
        ) {
            self.generator = generator
            self.validator = validator
        }

        // MARK: Public

        public typealias GeneratorFunction = (Account.Blockchain.PublicKey) throws -> String
        public typealias ValidatorFunction = (String) -> Bool

        public let generator: GeneratorFunction
        public let validator: ValidatorFunction
    }
}

public extension Account.Blockchain.AddressProvider {
    static var empty: Account.Blockchain.AddressProvider {
        Account.Blockchain.AddressProvider(generator: { _ in "" }, validator: { _ in true })
    }
}

public extension ChainInformation.AddressFormatting {
    var provider: Account.Blockchain.AddressProvider {
        switch self {
        case .ethereum:
            return Account.Blockchain.AddressProvider(
                generator: { publicKey in
                    Address.Ethereum(publicKey: publicKey).description
                }, validator: { rawValue in
                    Address.Ethereum(rawValue) != nil
                }
            )
        case .tron:
            return Account.Blockchain.AddressProvider(
                generator: { publicKey in
                    Address.TRON(publicKey: publicKey).description
                }, validator: { rawValue in
                    Address.TRON(rawValue) != nil
                }
            )
        }
    }
}
