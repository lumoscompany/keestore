//
//  Created by Anton Spivak
//

import BIP
import Foundation

// MARK: - ChainInformation.B44

public extension ChainInformation {
    struct B44 {
        // MARK: Lifecycle

        init(coin: BIP44.CoinKind) {
            self.coin = coin
        }

        // MARK: Public

        public let coin: BIP44.CoinKind
    }
}

// MARK: - BIP44.CoinKind + Codable

extension BIP44.CoinKind: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        guard let rawValue = BIP32.DerivationPath.KeyIndex(value)
        else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "\(value) can't be an KeyIndex."
            ))
        }

        self.init(rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue.description)
    }
}

// MARK: - ChainInformation.B44 + Codable

extension ChainInformation.B44: Codable {}

// MARK: - ChainInformation.B44 + Sendable

extension ChainInformation.B44: Sendable {}

// MARK: - ChainInformation.B44 + Hashable

extension ChainInformation.B44: Hashable {}
