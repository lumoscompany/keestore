//
//  Created by Anton Spivak
//

import BIP
import Foundation

// MARK: - ChainInformation.B39

public extension ChainInformation {
    struct B39 {
        // MARK: Lifecycle

        public init(words: Mnemonica.Length, algorithm: [BIP39.DerivationAlgorithm]) {
            self.words = words
            self.algorithm = algorithm
        }

        // MARK: Public

        public let words: Mnemonica.Length
        public let algorithm: [BIP39.DerivationAlgorithm]
    }
}

// MARK: - ChainInformation.B39 + Codable

extension ChainInformation.B39: Codable {}

// MARK: - ChainInformation.B39 + Sendable

extension ChainInformation.B39: Sendable {}

// MARK: - ChainInformation.B39 + Hashable

extension ChainInformation.B39: Hashable {}
