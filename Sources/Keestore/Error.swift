//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Keestore.Error

public extension Keestore {
    enum Error {
        case unknownFileVersion(Int)
        case unknownAddressFormat
        case wrongKey

        case encryptionFailed
        case decryptionFailed

        case decodingFailed(Swift.Error)
        case encodingFailed(Swift.Error)
    }
}

// MARK: - Keestore.Error + LocalizedError

extension Keestore.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .unknownFileVersion(version):
            return "[Keestore.Error]: Can't parse `.keestore`, unknown version -  `\(version)`."
        case .wrongKey:
            return "[Keestore.Error]: Wrong key."
        case .unknownAddressFormat:
            return "[Keestore.Error]: Unknown address format."
        case .encryptionFailed:
            return "[Keestore.Error]: Can't encrypt value with provided key."
        case .decryptionFailed:
            return "[Keestore.Error]: Can't decrypt value with provided key."
        case let .decodingFailed(error):
            return "[Keestore.Error]: Can't decode - `\(error.localizedDescription)`."
        case let .encodingFailed(error):
            return "[Keestore.Error]: Can't encode - `\(error.localizedDescription)`."
        }
    }
}
