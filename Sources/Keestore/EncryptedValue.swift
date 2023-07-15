//
//  Created by Anton Spivak
//

import Foundation
import ObscureKit

// MARK: - EncryptedValue

public struct EncryptedValue<T> where T: Codable {
    // MARK: Lifecycle

    public init(decryptedValue: T, using key: DerivedKey) throws {
        let encodedValue = try JSONEncoder.encode(decryptedValue)
        guard let encryptedValue = AES(key).encrypt(encodedValue)
        else {
            throw Keestore.Error.encryptionFailed
        }

        self.encryptedValue = encryptedValue
    }

    internal init(encryptedValue: Data) {
        self.encryptedValue = encryptedValue
    }

    // MARK: Public

    public let encryptedValue: Data

    public func decrypt(using key: DerivedKey) throws -> T {
        guard let decryptedValue = AES(key).decrypt(encryptedValue)
        else {
            throw Keestore.Error.decryptionFailed
        }

        return try JSONDecoder.decode(T.self, from: decryptedValue)
    }
}

// MARK: Codable

extension EncryptedValue: Codable {}

// MARK: Sendable

extension EncryptedValue: Sendable {}

// MARK: Hashable

extension EncryptedValue: Hashable {}
