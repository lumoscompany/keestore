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
            address: Address,
            network: Network,
            credentials: EncryptedValue<Credentials>?
        ) {
            self.address = address
            self.network = network
            self.credentials = credentials
        }

        // MARK: Public

        public typealias Address = Data

        public var address: Address
        public var network: Network
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
            return try Signer(network: network, credentials: credentials.decrypt(using: key))
        } catch {
            throw Wolstore.Error.wrongKey
        }
    }
}

public extension Account.Blockchain {
    static func generate(for network: Network, using key: DerivedKey) -> Account.Blockchain {
        do {
            return try .create(for: network, with: .generate(for: network), using: key)
        } catch {
            fatalError("[Account.Kind.Blockchain]: Failed to generate account.")
        }
    }

    static func create(
        for network: Network,
        with credentials: Credentials,
        using key: DerivedKey
    ) throws -> Account.Blockchain {
        let address: Data
        let privateKey = try credentials.privateKey(for: network)

        switch network {
        case .ton:
            address = Data()
        case .tron:
            let publicKey = privateKey.publicKey.uncompressed.rawValue
            address = _Address.TRON(publicKey: publicKey).rawValue
        case .ethereum:
            let publicKey = privateKey.publicKey.uncompressed.rawValue
            address = _Address.Ethereum(publicKey: publicKey).rawValue
        }

        return try Account.Blockchain(
            address: address,
            network: network,
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
    static func generate(for network: Network) -> Account.Blockchain.Credentials {
        let digest = BIP39.Digest(for: network)
        switch network {
        case .ton:
            return .mnemonica(digest.mnemonica.words, nil)
        case .tron:
            let derivationPath = HDWallet(coin: .tron).derivationPath
            return .mnemonica(digest.mnemonica.words, derivationPath)
        case let .ethereum(ethereumChain):
            let derivationPath = HDWallet(coin: ethereumChain.coin).derivationPath
            return .mnemonica(digest.mnemonica.words, derivationPath)
        }
    }
}

private extension Account.Blockchain.Credentials {
    func privateKey(for network: Network) throws -> any _PrivateKey {
        let rawValue: Data
        switch self {
        case let .secretKey(secretKey):
            rawValue = secretKey
        case let .mnemonica(phrase, derivationPath):
            let mnemonica = try Mnemonica(phrase)
            let digest = try BIP39.Digest(for: network, with: mnemonica)

            switch network {
            case .ton:
                let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: digest.seed)
                rawValue = privateKey.rawRepresentation
            case .ethereum, .tron:
                let derivationPath = derivationPath ?? DerivationPath(.master, [])
                rawValue = ExtendedKey(digest, derivationPath).keyPair.privateKey.rawValue
            }
        }

        switch network {
        case .ton:
            return try KeyPair.Curve25519.PrivateKey(rawValue: rawValue)
        case .ethereum, .tron:
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

        init(network: Network, credentials: Credentials) {
            self.network = network
            self.credentials = credentials
        }

        // MARK: Public

        public var network: Network
        public var credentials: Credentials
    }
}

public extension Account.Blockchain.Signer {
    func sign(_ data: any DataProtocol) throws -> any DataProtocol {
        try credentials.privateKey(for: network).sign(data)
    }

    func check(signature: any DataProtocol, for data: any DataProtocol) throws -> Bool {
        try credentials.privateKey(for: network).publicKey.check(signature: signature, for: data)
    }
}
