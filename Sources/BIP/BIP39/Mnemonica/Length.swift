//
//  Created by Anton Spivak
//

import Foundation

// MARK: - BIP39.Mnemonica.Length

public extension BIP39.Mnemonica {
    enum Length {
        case w12
        case w18
        case w24
    }
}

// MARK: - BIP39.Mnemonica.Length + RawRepresentable

extension BIP39.Mnemonica.Length: RawRepresentable {
    public init?(rawValue: Int) {
        switch rawValue {
        case 12:
            self = .w12
        case 18:
            self = .w18
        case 24:
            self = .w24
        default:
            return nil
        }
    }

    // MARK: Public

    public var rawValue: Int {
        switch self {
        case .w12:
            return 12
        case .w18:
            return 18
        case .w24:
            return 24
        }
    }
}

internal extension BIP39.Mnemonica.Length {
    var entropyStrength: Int {
        switch self {
        case .w12:
            return 128
        case .w18:
            return 192
        case .w24:
            return 256
        }
    }
}

// MARK: - BIP39.Mnemonica.Length + Codable

extension BIP39.Mnemonica.Length: Codable {}

// MARK: - BIP39.Mnemonica.Length + Hashable

extension BIP39.Mnemonica.Length: Hashable {}

// MARK: - BIP39.Mnemonica.Length + Sendable

extension BIP39.Mnemonica.Length: Sendable {}
