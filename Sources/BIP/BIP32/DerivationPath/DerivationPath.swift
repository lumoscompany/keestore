//
//  Created by Anton Spivak
//

import Foundation

// MARK: - BIP32.DerivationPath

public extension BIP32 {
    struct DerivationPath {
        // MARK: Lifecycle

        public init(_ kind: KeyKind = .master, _ indices: [KeyIndex]) {
            self.kind = kind
            self.indices = indices
        }

        // MARK: Public

        public let kind: KeyKind
        public let indices: [KeyIndex]
    }
}

// MARK: - BIP32.DerivationPath + RawRepresentable

extension BIP32.DerivationPath: RawRepresentable {
    public init?(rawValue: String) {
        let elements = rawValue.unescaped.components(separatedBy: "/")
        print(elements)
        guard elements.count > 1,
              let keyKind = KeyKind(elements[0])
        else {
            return nil
        }

        let indices = elements[1 ..< elements.count].compactMap({
            KeyIndex($0)
        })

        guard indices.count == elements.count - 1
        else {
            return nil
        }

        self = BIP32.DerivationPath(keyKind, indices)
    }

    public var rawValue: String {
        ([kind.description] + indices.map({ $0.description })).joined(separator: "/")
    }
}

// MARK: - BIP32.DerivationPath + LosslessStringConvertible

extension BIP32.DerivationPath: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(rawValue: description)
    }

    public var description: String {
        rawValue
    }
}

// MARK: - BIP32.DerivationPath + ExpressibleByStringLiteral

extension BIP32.DerivationPath: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let derivationPath = BIP32.DerivationPath(value)
        else {
            fatalError("[DerivationPath]: Unsupported `stringLiteral`.")
        }

        self = derivationPath
    }
}

// MARK: - BIP32.DerivationPath + Codable

extension BIP32.DerivationPath: Codable {
    enum CodingKeys: CodingKey {
        case rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)

        guard let derivationPath = BIP32.DerivationPath(rawValue: rawValue)
        else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [CodingKeys.rawValue], debugDescription: "")
            )
        }

        self = derivationPath
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawValue, forKey: .rawValue)
    }
}

// MARK: - BIP32.DerivationPath + Sendable

extension BIP32.DerivationPath: Sendable {}

// MARK: - BIP32.DerivationPath + Hashable

extension BIP32.DerivationPath: Hashable {}
