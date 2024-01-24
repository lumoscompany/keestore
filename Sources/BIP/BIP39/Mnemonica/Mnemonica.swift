//
//  Created by Adam Stragner
//

import CryptoKit
import Foundation

// MARK: - BIP39.Mnemonica

public extension BIP39 {
    struct Mnemonica {
        // MARK: Lifecycle

        public init(length: Length, glossary: Glossary = .english) {
            let entropy = Entropy(length: length)
            try! self.init(entropy: entropy, glossary: glossary)
        }

        public init(entropy: BIP39.Entropy, glossary: Glossary = .english) throws {
            let words = try Self._words(from: entropy, glossary: glossary, options: .defaults)
            guard let length = BIP39.Mnemonica.Length(rawValue: words.count)
            else {
                throw BIP39.Error.invalidMnemonicaLength
            }

            self.init(words: words, length: length, glossary: glossary)
        }

        private init(words: [String], options: ParsingOptions) throws {
            let lowercasedWords = words.map({ $0.lowercased() })
            guard let tuple = try? BIP39.Mnemonica.check(lowercasedWords)
            else {
                throw BIP39.Error.invalidMnemonicaVocabulary
            }

            self.init(words: words, length: tuple.0, glossary: tuple.1)
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

        public var isValidChecksum: Bool { (try? entropy(.validateChecksum)) != nil }

        public func entropy(_ options: ParsingOptions = .defaults) throws -> Entropy {
            try BIP39.Mnemonica._entropy(from: words, glossary: glossary, options: options)
        }
    }
}

// MARK: - BIP39.Mnemonica + RawRepresentable

extension BIP39.Mnemonica: RawRepresentable {
    public init(_ rawValue: [String], options: ParsingOptions = .defaults) throws {
        try self.init(words: rawValue, options: options)
    }

    public init?(rawValue: [String]) {
        try? self.init(words: rawValue, options: .defaults)
    }

    public var rawValue: [String] { words }
}

// MARK: - BIP39.Mnemonica + ExpressibleByStringLiteral

extension BIP39.Mnemonica: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        guard let value = BIP39.Mnemonica(value)
        else {
            fatalError("Couldn't initialize `Mnemonica` from string literal \(value)")
        }
        self = value
    }
}

// MARK: - BIP39.Mnemonica + LosslessStringConvertible

extension BIP39.Mnemonica: LosslessStringConvertible {
    public init(description: String, options: ParsingOptions = .defaults) throws {
        try self.init(words: description.components(separatedBy: " "), options: options)
    }

    public init?(_ description: String) {
        try? self.init(words: description.components(separatedBy: " "), options: .defaults)
    }

    public var description: String {
        rawValue.joined(separator: " ")
    }
}

public extension BIP39.Mnemonica {
    func digest(with algorithm: [BIP39.DerivationAlgorithm]) throws -> BIP39.Digest {
        try BIP39.Digest(mnemonica: self, algorithm: algorithm)
    }
}

// MARK: - BIP39.Mnemonica.ParsingOptions

public extension BIP39.Mnemonica {
    struct ParsingOptions: OptionSet {
        // MARK: Lifecycle

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public static let validateChecksum = ParsingOptions(rawValue: 1 << 0)
        public static let defaults: ParsingOptions = [.validateChecksum]

        public var rawValue: UInt
    }
}

// MARK: - BIP39.Mnemonica + Hashable

// extension BIP39.Mnemonica: Codable {}

extension BIP39.Mnemonica: Hashable {}

// MARK: - BIP39.Mnemonica + Sendable

extension BIP39.Mnemonica: Sendable {}

private extension BIP39.Mnemonica {
    static func _words(
        from entropy: BIP39.Entropy,
        glossary: BIP39.Mnemonica.Glossary,
        options: ParsingOptions
    ) throws -> [String] {
        let entropyBytes = entropy.bytes.concreteBytes
        let checksumBits = _checksum(entropyBytes)
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
                throw BIP39.Error.invalidEntropyCount
            }

            words.append(vocabulary[index])
        }

        return words
    }

    static func _entropy(
        from words: [String],
        glossary: BIP39.Mnemonica.Glossary,
        options: ParsingOptions
    ) throws -> BIP39.Entropy {
        let bits = try words.map({
            guard let index = glossary.list.firstIndex(of: $0)
            else {
                throw BIP39.Error.invalidMnemonicaVocabulary
            }

            var bindex = String(index, radix: 2)
            while bindex.count < 11 {
                bindex = "0" + bindex
            }

            return bindex
        }).joined()

        let divider = Int(Double(bits.count / 33).rounded(.down) * 32)

        let entropyBits = String(bits.prefix(divider))
        let checksumBits = String(bits.suffix(bits.count - divider))

        let entropyBytes = [UInt8](bitsStringRepresentation: entropyBits)
        if options.contains(.validateChecksum) && checksumBits != _checksum(entropyBytes) {
            throw BIP39.Error.invalidMnemonicaVocabulary
        }

        return .init(entropyBytes)
    }

    private static func _checksum(_ entropyBytes: [UInt8]) -> String {
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

private extension Array where Element == UInt8 {
    init(bitsStringRepresentation string: String) {
        let padded = string.padding(
            toLength: ((string.count + 7) / 8) * 8,
            withPad: "0",
            startingAt: 0
        ).map({ $0 })

        self = stride(from: 0, to: padded.count, by: 8).map({
            let substring = String(padded[$0 ..< $0 + 8])
            guard let byte = UInt8(substring, radix: 2)
            else {
                fatalError("Couldn't initialize byte from bits string \(substring)")
            }
            return byte
        })
    }
}
