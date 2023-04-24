//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Blockchain.SigningProtocol

public extension Account.Blockchain {
    struct SigningProtocol {
        // MARK: Lifecycle

        init(chain: ChainInformation, credentials: Credentials) {
            self.chain = chain
            self.credentials = credentials
        }

        // MARK: Public

        public var chain: ChainInformation
        public var credentials: Credentials
    }
}

public extension Account.Blockchain.SigningProtocol {
    func sign(_ data: any DataProtocol) throws -> any DataProtocol {
        try credentials.privateKey(for: chain).sign(data)
    }

    func check(signature: any DataProtocol, for data: any DataProtocol) throws -> Bool {
        try credentials.privateKey(for: chain).publicKey.check(signature: signature, for: data)
    }
}
