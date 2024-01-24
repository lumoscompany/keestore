//
//  Created by Adam Stragner
//

import Foundation

// MARK: - BIP39.Mnemonica.Length

public extension BIP39.Mnemonica {
    enum Length {
        case w12
        case w18
        case w24

        // MARK: Internal

        internal var entropyBitsCount: Int {
            switch self {
            case .w12: 128
            case .w18: 192
            case .w24: 256
            }
        }
    }
}

// MARK: - BIP39.Mnemonica.Length + RawRepresentable

extension BIP39.Mnemonica.Length: RawRepresentable {
    public init?(rawValue: Int) {
        switch rawValue {
        case Self.w12.rawValue: self = .w12
        case Self.w18.rawValue: self = .w18
        case Self.w24.rawValue: self = .w24
        default: return nil
        }
    }

    // MARK: Public

    public var rawValue: Int {
        switch self {
        case .w12: 12
        case .w18: 18
        case .w24: 24
        }
    }
}

public extension BIP39.Mnemonica.Length {
    init?(entropyBytesCount: Int) {
        switch entropyBytesCount {
        case Self.w12.entropyBytesCount: self = .w12
        case Self.w18.entropyBytesCount: self = .w18
        case Self.w24.entropyBytesCount: self = .w24
        default: return nil
        }
    }

    var entropyBytesCount: Int {
        entropyBitsCount / 8
    }
}

public extension BIP39.Mnemonica.Length {
    init?(wordsCount: Int) {
        self.init(rawValue: wordsCount)
    }

    var wordsCount: Int {
        rawValue
    }
}

// MARK: - BIP39.Mnemonica.Length + Codable

extension BIP39.Mnemonica.Length: Codable {}

// MARK: - BIP39.Mnemonica.Length + Hashable

extension BIP39.Mnemonica.Length: Hashable {}

// MARK: - BIP39.Mnemonica.Length + Sendable

extension BIP39.Mnemonica.Length: Sendable {}
