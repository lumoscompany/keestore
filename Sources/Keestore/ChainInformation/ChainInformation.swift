//
//  Created by Anton Spivak
//

import BIP
import Foundation

// MARK: - ChainInformation

public struct ChainInformation {
    // MARK: Lifecycle

    init(
        name: String,
        icon: CodableResource?,
        signingProtocol: SigningProtocol,
        addressFormatting: AddressFormatting?,
        b32: B32,
        b39: B39,
        b44: B44?
    ) {
        self.name = name
        self.icon = icon

        self.signingProtocol = signingProtocol
        self.addressFormatting = addressFormatting

        self.b32 = b32
        self.b39 = b39
        self.b44 = b44
    }

    // MARK: Public

    public let name: String
    public let icon: CodableResource?

    public let signingProtocol: SigningProtocol
    public let addressFormatting: AddressFormatting?

    public let b32: B32
    public let b39: B39
    public let b44: B44?
}

// MARK: Codable

extension ChainInformation: Codable {}

// MARK: Sendable

extension ChainInformation: Sendable {}

// MARK: Hashable

extension ChainInformation: Hashable {
    public static func == (lhs: ChainInformation, rhs: ChainInformation) -> Bool {
        lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

public extension BIP39.Digest {
    init(for chainInformation: ChainInformation) {
        let b39 = chainInformation.b39
        self.init(length: b39.words, algorithm: b39.algorithm)
    }

    init(for chainInformation: ChainInformation, with mnemonica: Mnemonica) throws {
        try self.init(mnemonica, algorithm: chainInformation.b39.algorithm)
    }
}

public extension ChainInformation {
    static func ton() -> ChainInformation {
        self.init(
            name: "TON",
            icon: nil,
            signingProtocol: .init(
                algorithm: .curve25519,
                hashingFunction: nil,
                messageSigningPrefix: nil
            ),
            addressFormatting: .custom("ton"),
            b32: .init(),
            b39: .init(words: .w24, algorithm: .ton()),
            b44: nil
        )
    }

    static func ethereum() -> ChainInformation {
        self.init(
            name: "Ethereum",
            icon: nil,
            signingProtocol: .init(
                algorithm: .secp256k1,
                hashingFunction: .keccak256,
                messageSigningPrefix: .init(
                    firstByte: 25,
                    prefixText: "Ethereum Signed Message:\n",
                    hashingFunction: .keccak256
                )
            ),
            addressFormatting: .ethereum,
            b32: .init(),
            b39: .init(words: .w12, algorithm: .ethereum()),
            b44: .init(coin: .ethereum)
        )
    }

    static func tron() -> ChainInformation {
        self.init(
            name: "TRON",
            icon: nil,
            signingProtocol: .init(
                algorithm: .secp256k1,
                hashingFunction: .keccak256,
                messageSigningPrefix: .init(
                    firstByte: 25,
                    prefixText: "TRON Signed Message:\n",
                    hashingFunction: .keccak256
                )
            ),
            addressFormatting: .tron,
            b32: .init(),
            b39: .init(words: .w12, algorithm: .ethereum()),
            b44: .init(coin: .tron)
        )
    }
}
