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

// MARK: - AddressFormattingStorage

private actor AddressFormattingStorage {
    // MARK: Internal

    func get(_ key: ChainInformation.AddressFormatting) -> Account.Blockchain.AddressProvider? {
        storage[key]
    }

    func set(_ key: ChainInformation.AddressFormatting, value: Account.Blockchain.AddressProvider) {
        storage[key] = value
    }

    // MARK: Private

    private var storage: [
        ChainInformation.AddressFormatting: Account.Blockchain.AddressProvider
    ] = [.ethereum: .ethereum, .tron: .tron]
}

public extension ChainInformation.AddressFormatting {
    private static var _storage = AddressFormattingStorage()

    var addressProvider: Account.Blockchain.AddressProvider? {
        get async {
            await Self._storage.get(self)
        }
    }

    func register(_ addressProvider: Account.Blockchain.AddressProvider) async {
        await Self._storage.set(self, value: addressProvider)
    }
}
