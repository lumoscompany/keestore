//
//  Created by Anton Spivak
//

import Foundation
import ObscureKit

// MARK: - EncryptedValue

public struct EncryptedValue<T> where T: Codable {
    // MARK: Lifecycle

    public init(decryptedValue: T, using key: DerivedKey) throws {
        let encodedValue: Data
        do {
            encodedValue = try JSONEncoder.wolstore.encode(decryptedValue)
        } catch {
            throw Wolstore.Error.encodingFailed(error)
        }

        guard let encryptedValue = AES(key).encrypt(encodedValue)
        else {
            throw Wolstore.Error.encryptionFailed
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
            throw Wolstore.Error.decryptionFailed
        }

        let decodedValue: T
        do {
            decodedValue = try JSONDecoder.wolstore.decode(T.self, from: decryptedValue)
        } catch {
            throw Wolstore.Error.decodingFailed(error)
        }

        return decodedValue
    }
}

// MARK: Codable

extension EncryptedValue: Codable {}

// MARK: Sendable

extension EncryptedValue: Sendable {}

// MARK: Hashable

extension EncryptedValue: Hashable {}
