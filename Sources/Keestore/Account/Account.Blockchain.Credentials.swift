//
//  Created by Adam Stragner
//

import Foundation

// MARK: - Account.Blockchain.Credentials

public extension Account.Blockchain {
    enum Credentials {
        case secretKey(SecretKey)
        case mnemonica(SecretPhrase, DerivationPath?)

        // MARK: Public

        public typealias SecretKey = Data
        public typealias SecretPhrase = [String]
    }
}

public extension Account.Blockchain.Credentials {
    static func generate(for chain: ChainInformation) -> Account.Blockchain.Credentials {
        let digest = BIP39.Digest(chainInformation: chain)
        if let coin = chain.b44?.coin {
            let derivationPath = HDWallet(coin: coin).derivationPath
            return .mnemonica(digest.mnemonica.words, derivationPath)
        } else {
            return .mnemonica(digest.mnemonica.words, nil)
        }
    }
}

internal extension Account.Blockchain.Credentials {
    func privateKey(for chain: ChainInformation) throws -> any _PrivateKey {
        let rawValue: Data
        switch self {
        case let .secretKey(secretKey):
            rawValue = secretKey
        case let .mnemonica(phrase, derivationPath):
            let mnemonica = try Mnemonica(phrase)
            let digest = try BIP39.Digest(mnemonica: mnemonica, chainInformation: chain)

            if let derivationPath {
                rawValue = ExtendedKey(digest, derivationPath).keyPair.privateKey.rawValue
            } else {
                rawValue = Data(digest.seed)
            }
        }

        switch chain.signingProtocol.algorithm {
        case .curve25519:
            return try KeyPair.Curve25519.PrivateKey(rawValue: rawValue)
        case .secp256k1:
            return try KeyPair.Secp256k1.PrivateKey(rawValue: rawValue)
        }
    }
}

// MARK: - Account.Blockchain.Credentials + Codable

extension Account.Blockchain.Credentials: Codable {}

// MARK: - Account.Blockchain.Credentials + Sendable

extension Account.Blockchain.Credentials: Sendable {}

// MARK: - Account.Blockchain.Credentials + Hashable

extension Account.Blockchain.Credentials: Hashable {}
