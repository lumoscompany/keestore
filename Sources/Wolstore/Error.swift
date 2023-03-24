//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Wolstore.Error

public extension Wolstore {
    enum Error {
        case unknownWolstoreVersion(Int)

        case missingPrivateKey
        case invalidPublicKeyFormat

        case notFileURL(URL)
        case fileNotExists(URL)

        case encryptionFailed
        case decryptionFailed

        case decodingFailed(Swift.Error)
        case encodingFailed(Swift.Error)

        case wrongKey
    }
}

// MARK: - Wolstore.Error + LocalizedError

extension Wolstore.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .unknownWolstoreVersion(version):
            return "[Wolstore.Error]: Can't parse `.wolsotre`, unknown version -  `\(version)`."
        case .missingPrivateKey:
            return "[Wolstore.Error]: Missing private key."
        case .invalidPublicKeyFormat:
            return "[Wolstore.Error]: Public key has invalid format (secp, ed)."
        case let .notFileURL(url):
            return "[Wolstore.Error]: Provided URL must be file URL - \(url.absoluteString)."
        case let .fileNotExists(url):
            return "[Wolstore.Error]: File does not exists - \(url.absoluteString)."
        case .encryptionFailed:
            return "[Wolstore.Error]: Can't encrypt value with provided key."
        case .decryptionFailed:
            return "[Wolstore.Error]: Can't decrypt value with provided key."
        case let .decodingFailed(error):
            return "[Wolstore.Error]: Can't decode - `\(error.localizedDescription)`."
        case let .encodingFailed(error):
            return "[Wolstore.Error]: Can't encode - `\(error.localizedDescription)`."
        case .wrongKey:
            return "[Wolstore.Error]: Wrong key."
        }
    }
}
