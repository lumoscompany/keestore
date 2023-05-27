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
        var seal: CryptoKit.AES.GCM.SealedBox?
        try? key.perform(with: {
            let key = SymmetricKey(data: $0)
            seal = try CryptoKit.AES.GCM.seal(data, using: key)
        })
        return seal?.combined
    }

    /// - parameter data: Data to decrypt
    public func decrypt(_ data: Data) -> Data? {
        guard let box = try? CryptoKit.AES.GCM.SealedBox(combined: data)
        else {
            return nil
        }

        var result: Data?
        try? key.perform(with: {
            let key = SymmetricKey(data: $0)
            result = try CryptoKit.AES.GCM.open(box, using: key)
        })
        return result
    }

    // MARK: Private

    private let key: DerivedKey
}
