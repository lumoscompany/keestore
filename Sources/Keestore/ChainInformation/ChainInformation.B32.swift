//
//  Created by Anton Spivak
//

import BIP
import Foundation

// MARK: - ChainInformation.B32

public extension ChainInformation {
    struct B32 {
        public init() {}
    }
}

// MARK: - ChainInformation.B32 + Codable

extension ChainInformation.B32: Codable {}

// MARK: - ChainInformation.B32 + Sendable

extension ChainInformation.B32: Sendable {}

// MARK: - ChainInformation.B32 + Hashable

extension ChainInformation.B32: Hashable {}
