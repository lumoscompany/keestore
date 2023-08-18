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
            publicKey: PublicKey?,
            chain: ChainInformation,
            credentials: EncryptedValue<Credentials>?
        ) {
            self.address = address
            self.publicKey = publicKey
            self.chain = chain
            self.credentials = credentials
        }

        // MARK: Public

        public typealias PublicKey = Data
        public typealias Address = String

        public var address: Address
        public var publicKey: PublicKey?
        public var chain: ChainInformation
        public var credentials: EncryptedValue<Credentials>?
    }
}

// MARK: - Account.Blockchain + Codable

extension Account.Blockchain: Codable {}

// MARK: - Account.Blockchain + Sendable

extension Account.Blockchain: Sendable {}

// MARK: - Account.Blockchain + Hashable

extension Account.Blockchain: Hashable {}

private typealias _Address = Address

public extension Account.Blockchain {
    func signer(using key: DerivedKey) throws -> SigningProtocol? {
        guard let credentials
        else {
            return nil
        }

        do {
            return try SigningProtocol(chain: chain, credentials: credentials.decrypt(using: key))
        } catch {
            throw Keestore.Error.wrongKey
        }
    }
}

public extension Account.Blockchain {
    static func generate(
        for chainInformation: ChainInformation,
        using key: DerivedKey
    ) async throws -> Account.Blockchain {
        return try await .create(
            for: chainInformation,
            with: .generate(for: chainInformation),
            using: key
        )
    }

    static func create(
        for chainInformation: ChainInformation,
        with credentials: Credentials,
        using key: DerivedKey
    ) async throws -> Account.Blockchain {
        let publicKey = try credentials.privateKey(for: chainInformation).publicKey
        return try await Account.Blockchain(
            address: chainInformation.address(with: credentials),
            publicKey: publicKey.rawValue,
            chain: chainInformation,
            credentials: EncryptedValue(decryptedValue: credentials, using: key)
        )
    }
}

public extension ChainInformation {
    func address(
        with credentials: Account.Blockchain.Credentials,
        using addressProvider: Account.Blockchain.AddressProvider? = nil
    ) async throws -> Account.Blockchain.Address {
        let privateKey = try credentials.privateKey(for: self)
        guard let addressFormatting,
              let addressProvider = await addressFormatting.addressProvider
        else {
            throw Keestore.Error.unknownAddressFormat
        }

        return try await addressProvider.generator(privateKey.publicKey.rawValue)
    }
}
