//
//  Created by Anton Spivak
//

import Foundation

// MARK: - ChainInformation.AddressFormatting

public extension ChainInformation {
    enum AddressFormatting: RawRepresentable {
        case ethereum
        case tron
        case custom(String)

        // MARK: Lifecycle

        public init(rawValue: String) {
            switch rawValue {
            case "ethereum":
                self = .ethereum
            case "tron":
                self = .tron
            default:
                self = .custom(rawValue)
            }
        }

        // MARK: Public

        public var rawValue: String {
            switch self {
            case .ethereum:
                return "ethereum"
            case .tron:
                return "tron"
            case let .custom(name):
                return name
            }
        }
    }
}

// MARK: - ChainInformation.AddressFormatting + Codable

extension ChainInformation.AddressFormatting: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = .init(rawValue: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

// MARK: - ChainInformation.AddressFormatting + Sendable

extension ChainInformation.AddressFormatting: Sendable {}

// MARK: - ChainInformation.AddressFormatting + Hashable

extension ChainInformation.AddressFormatting: Hashable {}

public extension ChainInformation.AddressFormatting {
    internal static var _storage: [
        ChainInformation.AddressFormatting: Account.Blockchain.AddressProvider
    ] = [.ethereum: .ethereum, .tron: .tron]

    var addressProvider: Account.Blockchain.AddressProvider? {
        Self._storage[self]
    }

    func register(_ addressProvider: Account.Blockchain.AddressProvider) {
        Self._storage[self] = addressProvider
    }
}
