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
            chain: ChainInformation,
            credentials: EncryptedValue<Credentials>?
        ) {
            self.address = address
            self.chain = chain
            self.credentials = credentials
        }

        // MARK: Public

        public typealias PublicKey = Data
        public typealias Address = String

        public var address: Address
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
        addressProvider: AddressProvider? = nil,
        using key: DerivedKey
    ) throws -> Account.Blockchain {
        return try .create(
            for: chainInformation,
            addressProvider: addressProvider,
            with: .generate(for: chainInformation),
            using: key
        )
    }

    static func create(
        for chainInformation: ChainInformation,
        addressProvider: AddressProvider? = nil,
        with credentials: Credentials,
        using key: DerivedKey
    ) throws -> Account.Blockchain {
        let privateKey = try credentials.privateKey(for: chainInformation)

        let address: Address
        if let addressProvider {
            address = try addressProvider.function(privateKey.publicKey.rawValue)
        } else if let addressFormatting = chainInformation.addressFormatting {
            address = try addressFormatting.addressProvider.function(privateKey.publicKey.rawValue)
        } else {
            throw Keestore.Error.unknownAddressFormat
        }

        return try Account.Blockchain(
            address: address,
            chain: chainInformation,
            credentials: EncryptedValue(decryptedValue: credentials, using: key)
        )
    }
}
