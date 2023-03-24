//
//  Created by Anton Spivak
//

import Foundation

// MARK: - BIP39.Error

public extension BIP39 {
    enum Error {
        case invalidMnemonicaLength
        case invalidMnemonicaVocabulary
    }
}

// MARK: - BIP39.Error + LocalizedError

extension BIP39.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidMnemonicaLength:
            return "[BIP39]: Unsupported mnemonica length."
        case .invalidMnemonicaVocabulary:
            return "[BIP39]: Invalid mnemonica words."
        }
    }
}
