//
//  Created by Anton Spivak
//

import CryptoKit
import Foundation

// MARK: - BIP39.Digest

public extension BIP39 {
    struct Digest {
        // MARK: Lifecycle

        private init<D>(mnemonica: BIP39.Mnemonica, seed: D) where D: ContiguousBytes {
            self.seed = seed.concreteBytes
            self.mnemonica = mnemonica
        }

        // MARK: Public

        public let mnemonica: BIP39.Mnemonica
        public let seed: [UInt8]
    }
}

public extension BIP39.Digest {
    init(
        glossary: BIP39.Mnemonica.Glossary = .english,
        length: BIP39.Mnemonica.Length,
        algorithm: [BIP39.DerivationAlgorithm]
    ) {
        let entropy = BIP39.Digest._entropy(with: length)
        guard let mnemonica = try? BIP39.Mnemonica(entropy, glossary: glossary),
              let digest = try? BIP39.Digest(mnemonica, algorithm: algorithm)
        else {
            fatalError("[BIP39]: Random mnemonica generation failed.")
        }

        self = digest
    }

    init(_ mnemonica: BIP39.Mnemonica, algorithm: [BIP39.DerivationAlgorithm]) throws {
        try self.init(
            mnemonica: mnemonica,
            seed: algorithm.seed(from: mnemonica.words)
        )
    }
}

internal extension BIP39.Digest {
    static func _entropy(with length: BIP39.Mnemonica.Length) -> ContiguousBytes {
        let count = length.entropyStrength / 8
        var entropy = [UInt8](repeating: 0, count: count)
        _ = SecRandomCopyBytes(kSecRandomDefault, entropy.count, &entropy)
        return entropy
    }
}

// MARK: - BIP39.Digest + Equatable

extension BIP39.Digest: Equatable {
    public static func == (lhs: BIP39.Digest, rhs: BIP39.Digest) -> Bool {
        lhs.mnemonica == rhs.mnemonica && lhs.seed.concreteBytes == rhs.seed.concreteBytes
    }
}

// MARK: - BIP39.Digest + Sendable

// extension BIP39.Digest: Codable {}

extension BIP39.Digest: Sendable {}

// MARK: - BIP39.Digest + Hashable

extension BIP39.Digest: Hashable {}
