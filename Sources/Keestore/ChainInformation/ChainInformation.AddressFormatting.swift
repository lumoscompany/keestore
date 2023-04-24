//
//  Created by Anton Spivak
//

import Foundation

// MARK: - ChainInformation.AddressFormatting

public extension ChainInformation {
    enum AddressFormatting: String {
        case ethereum
        case tron
    }
}

// MARK: - ChainInformation.AddressFormatting + Codable

extension ChainInformation.AddressFormatting: Codable {}

// MARK: - ChainInformation.AddressFormatting + Sendable

extension ChainInformation.AddressFormatting: Sendable {}

// MARK: - ChainInformation.AddressFormatting + Hashable

extension ChainInformation.AddressFormatting: Hashable {}
