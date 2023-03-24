//
//  Created by Anton Spivak
//

import BIP
import Foundation

// MARK: - Network

public enum Network {
    case ton
    case tron
    case ethereum(EthereumChain)
}

public extension Network {
    var coin: BIP44.CoinKind {
        switch self {
        case .ton:
            return .ton
        case let .ethereum(chain):
            return chain.coin
        case .tron:
            return .tron
        }
    }
}

// MARK: Codable

extension Network: Codable {}

// MARK: Sendable

extension Network: Sendable {}

// MARK: Hashable

extension Network: Hashable {}

// MARK: Network.EthereumChain

public extension Network {
    enum EthereumChain: Int, RawRepresentable {
        case mainnnet = 1
        case bsc = 56
        case polygon = 137
    }
}

public extension Network.EthereumChain {
    var coin: BIP44.CoinKind {
        switch self {
        case .mainnnet:
            return .ethereum
        case .bsc:
            return .bsc
        case .polygon:
            return .matic
        }
    }
}

// MARK: - Network.EthereumChain + Codable

extension Network.EthereumChain: Codable {}

// MARK: - Network.EthereumChain + Sendable

extension Network.EthereumChain: Sendable {}

// MARK: - Network.EthereumChain + Hashable

extension Network.EthereumChain: Hashable {}

public extension BIP39.Digest {
    init(for network: Network) {
        switch network {
        case .ethereum, .tron:
            self.init(length: .w12, configuration: .standart())
        case .ton:
            self.init(length: .w24, configuration: .ton())
        }
    }

    init(for network: Network, with mnemonica: Mnemonica) throws {
        switch network {
        case .ethereum, .tron:
            try self.init(mnemonica, configuration: .standart())
        case .ton:
            try self.init(mnemonica, configuration: .ton())
        }
    }
}
