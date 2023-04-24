//
//  Created by Anton Spivak
//

import Foundation

// MARK: - BIP32.DerivationPath.KeyIndex

public extension BIP32.DerivationPath {
    enum KeyIndex {
        case ordinary(Int32)
        case hardened(Int32)
    }
}

// MARK: - BIP32.DerivationPath.KeyIndex + RawRepresentable

extension BIP32.DerivationPath.KeyIndex: RawRepresentable {
    public init(rawValue: UInt32) {
        switch rawValue {
        case 0 ..< .highestBit:
            self = .ordinary(Int32(rawValue))
        default:
            self = .hardened(Int32(rawValue - .highestBit))
        }
    }

    public var rawValue: UInt32 {
        switch self {
        case let .ordinary(value):
            return UInt32(value)
        case let .hardened(value):
            return UInt32(value) | .highestBit
        }
    }
}

// MARK: - BIP32.DerivationPath.KeyIndex + LosslessStringConvertible

extension BIP32.DerivationPath.KeyIndex: LosslessStringConvertible {
    public init?(_ description: String) {
        let hardened = description.unescaped.hasSuffix("`")

        var value = description
        if hardened {
            value = String(value.dropLast())
        }

        guard let _value = Int32(value)
        else {
            return nil
        }

        if hardened {
            self = .hardened(_value)
        } else {
            self = .ordinary(_value)
        }
    }

    public var description: String {
        switch self {
        case let .ordinary(value):
            return "\(value)"
        case let .hardened(value):
            return "\(value)`"
        }
    }
}

// MARK: - BIP32.DerivationPath.KeyIndex + ExpressibleByStringLiteral

extension BIP32.DerivationPath.KeyIndex: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let value = BIP32.DerivationPath.KeyIndex(value)
        else {
            fatalError("[DerivationPath.KeyIndex]: Unsupported `stringLiteral`.")
        }

        self = value
    }
}

// MARK: - BIP32.DerivationPath.KeyIndex + Hashable

extension BIP32.DerivationPath.KeyIndex: Hashable {}

// MARK: - BIP32.DerivationPath.KeyIndex + Sendable

extension BIP32.DerivationPath.KeyIndex: Sendable {}

private extension UInt32 {
    static var highestBit: UInt32 {
        0x80000000
    }
}
