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
    func sign(message: String) throws -> any DataProtocol {
        var rawValue = [UInt8]()
        let messageSigningPrefix = chain.signingProtocol.messageSigningPrefix

        if let messageSigningPrefix {
            if let firstByte = messageSigningPrefix.firstByte {
                rawValue.append(firstByte)
            }

            let prefixText = messageSigningPrefix.prefixText
            rawValue.append(contentsOf: [UInt8](prefixText.utf8))
        }

        let messageBytes = [UInt8](message.utf8)

        rawValue.append(contentsOf: [UInt8]("\(messageBytes.count)".utf8))
        rawValue.append(contentsOf: messageBytes)

        if let hashingFunction = messageSigningPrefix?.hashingFunction {
            rawValue = hashingFunction.process(rawValue).concreteBytes
        }

        return try credentials.privateKey(for: chain).sign(rawValue)
    }

    func sign(data: any DataProtocol) throws -> any DataProtocol {
        let hash = chain.signingProtocol.hashingFunction.process(Data(data))
        return try credentials.privateKey(for: chain).sign(hash.concreteBytes)
    }

    func check(signature: any DataProtocol, for data: any DataProtocol) throws -> Bool {
        try credentials.privateKey(for: chain).publicKey.check(signature: signature, for: data)
    }
}
