//
//  Created by Anton Spivak
//

import BIP
import CryptoKit
import Foundation

// MARK: - Account.Blockchain

public extension Account {
    struct Blockchain {
        // MARK: Lifecycle

        public init(
            pkey: PublicKey,
            chain: ChainInformation,
            credentials: EncryptedValue<Credentials>?
        ) {
            self.pkey = pkey
            self.chain = chain
            self.credentials = credentials
        }

        // MARK: Public

        public typealias PublicKey = Data

        public var pkey: PublicKey
        public var chain: ChainInformation
        public var credentials: EncryptedValue<Credentials>?
    }
}

private typealias _Address = Address

public extension Account.Blockchain {
    func signer(using key: DerivedKey) throws -> Signer? {
        guard let credentials
        else {
            return nil
        }

        do {
            return try Signer(chain: chain, credentials: credentials.decrypt(using: key))
        } catch {
            throw Wolstore.Error.wrongKey
        }
    }
}

public extension Account.Blockchain {
    static func generate(for chain: ChainInformation, using key: DerivedKey) -> Account.Blockchain {
        do {
            return try .create(for: chain, with: .generate(for: chain), using: key)
        } catch {
            fatalError("[Account.Kind.Blockchain]: Failed to generate account.")
        }
    }

    static func create(
        for chain: ChainInformation,
        with credentials: Credentials,
        using key: DerivedKey
    ) throws -> Account.Blockchain {
        let privateKey = try credentials.privateKey(for: chain)
        return try Account.Blockchain(
            pkey: privateKey.publicKey.rawValue,
            chain: chain,
            credentials: EncryptedValue(decryptedValue: credentials, using: key)
        )
    }
}

// MARK: - Account.Blockchain + Codable

extension Account.Blockchain: Codable {}

// MARK: - Account.Blockchain + Sendable

extension Account.Blockchain: Sendable {}

// MARK: - Account.Blockchain + Hashable

extension Account.Blockchain: Hashable {}

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
        let digest = BIP39.Digest(for: chain)
        if let coin = chain.keychain.b44._coin {
            let derivationPath = HDWallet(coin: coin).derivationPath
            return .mnemonica(digest.mnemonica.words, derivationPath)
        } else {
            return .mnemonica(digest.mnemonica.words, nil)
        }
    }
}

private extension Account.Blockchain.Credentials {
    func privateKey(for chain: ChainInformation) throws -> any _PrivateKey {
        let rawValue: Data
        switch self {
        case let .secretKey(secretKey):
            rawValue = secretKey
        case let .mnemonica(phrase, derivationPath):
            let mnemonica = try Mnemonica(phrase)
            let digest = try BIP39.Digest(for: chain, with: mnemonica)

            if let derivationPath {
                rawValue = ExtendedKey(digest, derivationPath).keyPair.privateKey.rawValue
            } else {
                rawValue = Data(digest.seed)
            }
        }

        switch chain.keychain.signing.algorithm {
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

// MARK: - Account.Blockchain.Signer

public extension Account.Blockchain {
    struct Signer {
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

public extension Account.Blockchain.Signer {
    func sign(_ data: any DataProtocol) throws -> any DataProtocol {
        try credentials.privateKey(for: chain).sign(data)
    }

    func check(signature: any DataProtocol, for data: any DataProtocol) throws -> Bool {
        try credentials.privateKey(for: chain).publicKey.check(signature: signature, for: data)
    }
}
