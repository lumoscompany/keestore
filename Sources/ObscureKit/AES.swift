//
//  Created by Anton Spivak
//

import CommonCrypto
import CryptoKit
import Foundation

// MARK: - AES

public struct AES {
    // MARK: Lifecycle

    public init(_ key: DerivedKey) {
        self.key = key
    }

    // MARK: Public

    /// - parameter data: Data to encrypt
    public func encrypt(_ data: Data) -> Data? {
        try? key.perform(with: {
            let key = SymmetricKey(data: $0)
            return try CryptoKit.AES.GCM.seal(data, using: key).combined
        })
    }

    /// - parameter data: Data to decrypt
    public func decrypt(_ data: Data) -> Data? {
        guard let box = try? CryptoKit.AES.GCM.SealedBox(combined: data)
        else {
            return nil
        }

        return try? key.perform(with: {
            let key = SymmetricKey(data: $0)
            return try CryptoKit.AES.GCM.open(box, using: key)
        })
    }

    // MARK: Private

    private let key: DerivedKey
}
