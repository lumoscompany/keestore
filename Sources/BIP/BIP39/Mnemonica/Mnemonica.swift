//
//  Created by Anton Spivak
//

import CryptoKit
import Foundation

// MARK: - BIP39.Mnemonica

public extension BIP39 {
    struct Mnemonica {
        // MARK: Lifecycle

        init<D>(_ entropy: D, glossary: Glossary) throws where D: ContiguousBytes {
            self = try BIP39.Mnemonica.generate(from: entropy, glossary: glossary)
        }

        private init(words: [String], length: Length, glossary: Glossary) {
            self.words = words
            self.length = length
            self.glossary = glossary
        }

        // MARK: Public

        public let words: [String]
        public let length: Length
        public let glossary: Glossary
    }
}

// MARK: - BIP39.Mnemonica + RawRepresentable

extension BIP39.Mnemonica: RawRepresentable {
    public init?(rawValue: String) {
        self.init(rawValue: rawValue.components(separatedBy: " "))
    }

    public init?(rawValue: [String]) {
        guard let tuple = try? BIP39.Mnemonica.check(rawValue)
        else {
            return nil
        }

        self.init(words: rawValue, length: tuple.0, glossary: tuple.1)
    }

    public var rawValue: [String] {
        words
    }
}

public extension BIP39.Mnemonica {
    init(_ words: String) throws {
        try self.init(words.components(separatedBy: " "))
    }

    init(_ words: [String]) throws {
        let tuple = try BIP39.Mnemonica.check(words)
        self.init(words: words, length: tuple.0, glossary: tuple.1)
    }
}

public extension BIP39.Mnemonica {
    func digest(with algorithm: [BIP39.DerivationAlgorithm]) throws -> BIP39.Digest {
        try BIP39.Digest(self, algorithm: algorithm)
    }
}

// MARK: - BIP39.Mnemonica + Hashable

// extension BIP39.Mnemonica: Codable {}

extension BIP39.Mnemonica: Hashable {}

// MARK: - BIP39.Mnemonica + Sendable

extension BIP39.Mnemonica: Sendable {}

internal extension BIP39.Mnemonica {
    static func generate(
        from entropy: ContiguousBytes,
        glossary: BIP39.Mnemonica.Glossary
    ) throws -> BIP39.Mnemonica {
        var entropyBytes = [UInt8]()
        let _ = entropy.withUnsafeBytes({ buffer in
            entropyBytes.append(contentsOf: buffer)
        })

        let checksumBits = _checksumBits(entropyBytes)
        let entropyBits = String(entropyBytes.flatMap({
            ("00000000" + String($0, radix: 2)).suffix(8)
        }))

        let bits = entropyBits + checksumBits

        let vocabulary = glossary.list
        var words = [String]()

        for i in 0 ..< (bits.count / 11) {
            let startIndex = bits.index(bits.startIndex, offsetBy: i * 11)
            let endIndex = bits.index(bits.startIndex, offsetBy: (i + 1) * 11)

            guard let index = Int(bits[startIndex ..< endIndex], radix: 2)
            else {
                fatalError("[BIP39]: `_generateRandomWords` error.")
            }

            words.append(vocabulary[index])
        }

        guard let length = BIP39.Mnemonica.Length(rawValue: words.count)
        else {
            throw BIP39.Error.invalidMnemonicaLength
        }

        return BIP39.Mnemonica(
            words: words,
            length: length,
            glossary: glossary
        )
    }
}

private extension BIP39.Mnemonica {
    static func _checksumBits(_ entropyBytes: [UInt8]) -> String {
        let size = (entropyBytes.count * 8) / 32
        let hash = SHA256.hash(data: entropyBytes)
        let hashBits = String(hash.flatMap({
            ("00000000" + String($0, radix: 2)).suffix(8)
        }))
        return String(hashBits.prefix(size))
    }
}

private extension BIP39.Mnemonica {
    @discardableResult
    static func check(_ words: [String]) throws -> (Length, Glossary) {
        guard let length = BIP39.Mnemonica.Length(rawValue: words.count)
        else {
            throw BIP39.Error.invalidMnemonicaVocabulary
        }

        var glossary: Glossary?
        Glossary.allCases.forEach({
            guard $0.validate(words)
            else {
                return
            }

            glossary = $0
        })

        guard let glossary
        else {
            throw BIP39.Error.invalidMnemonicaVocabulary
        }

        return (length, glossary)
    }
}
