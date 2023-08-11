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

        public typealias GeneratorFunction = (Account.Blockchain.PublicKey) async throws -> String
        public typealias ValidatorFunction = (String) async -> Bool

        public let generator: GeneratorFunction
        public let validator: ValidatorFunction
    }
}

public extension Account.Blockchain.AddressProvider {
    static let ethereum = Account.Blockchain.AddressProvider(
        generator: { publicKey in
            Address.Ethereum(publicKey: publicKey).description
        }, validator: { rawValue in
            Address.Ethereum(rawValue) != nil
        }
    )

    static let tron = Account.Blockchain.AddressProvider(
        generator: { publicKey in
            Address.TRON(publicKey: publicKey).description
        }, validator: { rawValue in
            Address.TRON(rawValue) != nil
        }
    )
}
