//
//  Created by Anton Spivak
//

import CommonCrypto
import CryptoKit
import Foundation

// MARK: - DerivedKey

public struct DerivedKey {
    // MARK: Lifecycle

    /// - parameter rawValue: 32 bytes buffer (AES256)
    public init?(rawValue: Data) {
        guard rawValue.count == kCCKeySizeAES256
        else {
            return nil
        }

        self.rawValue = .init(rawValue)
    }

    /// - parameter string: Any UTF8 string
    public init(string: String) {
        let data = [UInt8](string.utf8)
        let hash = try? PKCS5.PBKDF2SHA512(
            password: data.sha512,
            salt: [UInt8]("derived key encryption seed".utf8),
            iterations: UInt32(100_000),
            derivedKeyLength: 32
        )

        guard let hash
        else {
            fatalError("[SymmetricKey]: PKCS5.PBKDF2SHA512 error.")
        }

        self.rawValue = .init(Data(hash.concreteBytes.sha256))
    }

    // MARK: Public

    public func perform<T>(with body: (Data) throws -> T) rethrows -> T {
        try rawValue.perform(with: body)
    }

    public func perform<T>(with body: (Data) async throws -> T) async rethrows -> T {
        try await rawValue.perform(with: body)
    }

    // MARK: Private

    /// - note: 32 bytes
    private let rawValue: SecureStorage
}

// MARK: Sendable

extension DerivedKey: Sendable {}

// MARK: Hashable

extension DerivedKey: Hashable {}

// MARK: CustomStringConvertible

extension DerivedKey: CustomStringConvertible {
    public var description: String {
        "[DerivedKey]: ******"
    }
}

// MARK: CustomDebugStringConvertible

extension DerivedKey: CustomDebugStringConvertible {
    public var debugDescription: String {
        "[DerivedKey]: ******"
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: DerivedKey) {
        appendInterpolation(value.description)
    }
}

///  - note: Do not implement it by default due security.
// extension DerivedKey: Codable {}
