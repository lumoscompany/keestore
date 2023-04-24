//
//  Created by Anton Spivak
//

import BIP
import Foundation

// MARK: - ChainInformation

public struct ChainInformation {
    // MARK: Lifecycle

    public init(name: String, icon: Icon?, keychain: Keychain) {
        self.name = name
        self.icon = icon
        self.keychain = keychain
    }

    // MARK: Public

    public let name: String
    public let icon: Icon?
    public let keychain: Keychain
}

// MARK: Codable

extension ChainInformation: Codable {}

// MARK: Sendable

extension ChainInformation: Sendable {}

// MARK: Hashable

extension ChainInformation: Hashable {}

// MARK: ChainInformation.Icon

public extension ChainInformation {
    enum Icon {
        case base64(value: Data)
        case url(value: URL)
    }
}

// MARK: - ChainInformation.Icon + Codable

extension ChainInformation.Icon: Codable {}

// MARK: - ChainInformation.Icon + Sendable

extension ChainInformation.Icon: Sendable {}

// MARK: - ChainInformation.Icon + Hashable

extension ChainInformation.Icon: Hashable {}

// MARK: - ChainInformation.Keychain

public extension ChainInformation {
    struct Keychain {
        // MARK: Lifecycle

        public init(signing: Signing, b32: B32, b39: B39, b44: B44) {
            self.signing = signing
            self.b32 = b32
            self.b39 = b39
            self.b44 = b44
        }

        // MARK: Public

        public let signing: Signing
        public let b32: B32
        public let b39: B39
        public let b44: B44
    }
}

// MARK: - ChainInformation.Keychain + Codable

extension ChainInformation.Keychain: Codable {}

// MARK: - ChainInformation.Keychain + Sendable

extension ChainInformation.Keychain: Sendable {}

// MARK: - ChainInformation.Keychain + Hashable

extension ChainInformation.Keychain: Hashable {}

// MARK: - ChainInformation.Keychain.Signing

public extension ChainInformation.Keychain {
    struct Signing {
        // MARK: Lifecycle

        public init(algorithm: Algorithm) {
            self.algorithm = algorithm
        }

        // MARK: Public

        public let algorithm: Algorithm
    }
}

// MARK: - ChainInformation.Keychain.Signing + Codable

extension ChainInformation.Keychain.Signing: Codable {}

// MARK: - ChainInformation.Keychain.Signing + Sendable

extension ChainInformation.Keychain.Signing: Sendable {}

// MARK: - ChainInformation.Keychain.Signing + Hashable

extension ChainInformation.Keychain.Signing: Hashable {}

// MARK: - ChainInformation.Keychain.Signing.Algorithm

public extension ChainInformation.Keychain.Signing {
    enum Algorithm {
        case secp256k1
        case curve25519
    }
}

// MARK: - ChainInformation.Keychain.Signing.Algorithm + Codable

extension ChainInformation.Keychain.Signing.Algorithm: Codable {}

// MARK: - ChainInformation.Keychain.Signing.Algorithm + Sendable

extension ChainInformation.Keychain.Signing.Algorithm: Sendable {}

// MARK: - ChainInformation.Keychain.Signing.Algorithm + Hashable

extension ChainInformation.Keychain.Signing.Algorithm: Hashable {}

// MARK: - ChainInformation.Keychain.B44

public extension ChainInformation.Keychain {
    struct B44 {
        // MARK: Lifecycle

        init(coin: Int32?) {
            self.coin = coin
        }

        // MARK: Public

        public let coin: Int32?
    }
}

// MARK: - ChainInformation.Keychain.B44 + Codable

extension ChainInformation.Keychain.B44: Codable {}

// MARK: - ChainInformation.Keychain.B44 + Sendable

extension ChainInformation.Keychain.B44: Sendable {}

// MARK: - ChainInformation.Keychain.B44 + Hashable

extension ChainInformation.Keychain.B44: Hashable {}

// MARK: - ChainInformation.Keychain.B39

public extension ChainInformation.Keychain {
    struct B39 {
        // MARK: Lifecycle

        public init(words: Mnemonica.Length, m: M) {
            self.words = words
            self.m = m
        }

        // MARK: Public

        public let words: Mnemonica.Length
        public let m: M
    }
}

// MARK: - ChainInformation.Keychain.B39 + Codable

extension ChainInformation.Keychain.B39: Codable {}

// MARK: - ChainInformation.Keychain.B39 + Sendable

extension ChainInformation.Keychain.B39: Sendable {}

// MARK: - ChainInformation.Keychain.B39 + Hashable

extension ChainInformation.Keychain.B39: Hashable {}

// MARK: - ChainInformation.Keychain.B39.M

public extension ChainInformation.Keychain.B39 {
    struct M {
        // MARK: Lifecycle

        public init(
            algorithm: BIP39.Configuration.DerivationAlgorithm,
            salt: String,
            iterations: Int,
            keyLength: Int
        ) {
            self.algorithm = algorithm
            self.salt = salt
            self.iterations = iterations
            self.keyLength = keyLength
        }

        // MARK: Public

        public let algorithm: BIP39.Configuration.DerivationAlgorithm
        public let salt: String
        public let iterations: Int
        public let keyLength: Int
    }
}

// MARK: - ChainInformation.Keychain.B39.M + Codable

extension ChainInformation.Keychain.B39.M: Codable {}

// MARK: - ChainInformation.Keychain.B39.M + Sendable

extension ChainInformation.Keychain.B39.M: Sendable {}

// MARK: - ChainInformation.Keychain.B39.M + Hashable

extension ChainInformation.Keychain.B39.M: Hashable {}

// MARK: - ChainInformation.Keychain.B32

public extension ChainInformation.Keychain {
    struct B32 {
        public init() {}
    }
}

// MARK: - ChainInformation.Keychain.B32 + Codable

extension ChainInformation.Keychain.B32: Codable {}

// MARK: - ChainInformation.Keychain.B32 + Sendable

extension ChainInformation.Keychain.B32: Sendable {}

// MARK: - ChainInformation.Keychain.B32 + Hashable

extension ChainInformation.Keychain.B32: Hashable {}

public extension ChainInformation.Keychain.B44 {
    var _coin: BIP44.CoinKind? {
        guard let coin
        else {
            return nil
        }

        return .init(.hardened(coin))
    }
}

public extension BIP39.Digest {
    init(for chainInformation: ChainInformation) {
        self.init(
            length: chainInformation.keychain.b39.words,
            configuration: .init(for: chainInformation.keychain.b39.m)
        )
    }

    init(for chainInformation: ChainInformation, with mnemonica: Mnemonica) throws {
        try self.init(mnemonica, configuration: .init(for: chainInformation.keychain.b39.m))
    }
}

public extension BIP39.Configuration {
    init(for m: ChainInformation.Keychain.B39.M) {
        self.init(
            derivationAlgorithm: m.algorithm,
            salt: m.salt,
            password: "",
            iterations: m.iterations,
            keyLength: m.keyLength
        )
    }
}

public extension ChainInformation {
    static func ton() -> ChainInformation {
        self.init(
            name: "TON",
            icon: nil,
            keychain: Keychain(
                signing: .init(algorithm: .curve25519),
                b32: .init(),
                b39: .init(
                    words: .w24,
                    m: .init(
                        algorithm: .hmacpbkdf2,
                        salt: "TON default seed",
                        iterations: 100000,
                        keyLength: 32
                    )
                ),
                b44: .init(coin: nil)
            )
        )
    }

    static func ethereum() -> ChainInformation {
        _evm(name: "Ethereum", coin: 195)
    }

    static func tron() -> ChainInformation {
        _evm(name: "TRON", coin: 60)
    }

    private static func _evm(name: String, coin: Int32) -> ChainInformation {
        self.init(
            name: name,
            icon: nil,
            keychain: Keychain(
                signing: .init(algorithm: .secp256k1),
                b32: .init(),
                b39: .init(
                    words: .w12,
                    m: .init(algorithm: .pbkdf2, salt: "mnemonic", iterations: 2048, keyLength: 64)
                ),
                b44: .init(coin: coin)
            )
        )
    }
}
