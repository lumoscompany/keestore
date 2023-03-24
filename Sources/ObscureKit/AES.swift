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
        self.key = SymmetricKey(key)
    }

    // MARK: Public

    /// - parameter data: Data to encrypt
    public func encrypt(_ data: Data) -> Data? {
        let seal = try? CryptoKit.AES.GCM.seal(data, using: key)
        return seal?.combined
    }

    /// - parameter data: Data to decrypt
    public func decrypt(_ data: Data) -> Data? {
        guard let box = try? CryptoKit.AES.GCM.SealedBox(combined: data)
        else {
            return nil
        }

        return try? CryptoKit.AES.GCM.open(box, using: key)
    }

    // MARK: Private

    private let key: SymmetricKey
}
