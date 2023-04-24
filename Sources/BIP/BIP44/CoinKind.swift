//
//  Created by Anton Spivak
//

import Foundation

// MARK: - BIP44.CoinKind

public extension BIP44 {
    struct CoinKind: RawRepresentable {
        // MARK: Lifecycle

        public init(rawValue: BIP32.DerivationPath.KeyIndex) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: BIP32.DerivationPath.KeyIndex
    }
}

public extension BIP44.CoinKind {
    init(_ rawValue: BIP32.DerivationPath.KeyIndex) {
        self.init(rawValue: rawValue)
    }
}

/// - note: https://github.com/satoshilabs/slips/blob/master/slip-0044.md
public extension BIP44.CoinKind {
    static let testnet = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x80000001))

    static let bitcoin = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x80000000))
    static let litecoin = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x80000002))
    static let dogecoin = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x80000003))
    static let ethereum = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x8000003c))
    static let tron = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x800000c3))
    static let ton = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x8000025f))
    static let bsc = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x80000207))
    static let matic = BIP44.CoinKind(BIP32.DerivationPath.KeyIndex(rawValue: 0x800003c6))
}

// MARK: - BIP44.CoinKind + Hashable

extension BIP44.CoinKind: Hashable {}

// MARK: - BIP44.CoinKind + Sendable

extension BIP44.CoinKind: Sendable {}
