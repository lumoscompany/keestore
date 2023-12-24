//
//  Created by Anton Spivak
//

import Foundation

// MARK: - BIP39.Error

public extension BIP39 {
    enum Error {
        case invalidEntropyCount
        case invalidMnemonicaLength
        case invalidMnemonicaVocabulary
    }
}

// MARK: - BIP39.Error + LocalizedError

extension BIP39.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidEntropyCount: "[BIP39]: Invalid entropy bytes length"
        case .invalidMnemonicaLength: "[BIP39]: Unsupported mnemonica length."
        case .invalidMnemonicaVocabulary: "[BIP39]: Invalid mnemonica words."
        }
    }
}
