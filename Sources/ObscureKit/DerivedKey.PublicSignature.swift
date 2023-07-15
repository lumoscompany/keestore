//
//  Created by Anton Spivak
//

import CryptoKit
import Foundation

// MARK: - DerivedKey.PublicSignature

public extension DerivedKey {
    struct PublicSignature: RawRepresentable {
        // MARK: Lifecycle

        public init(rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        /// - note: 64 bytes
        public var rawValue: Data
    }
}

// MARK: - DerivedKey.PublicSignature + Codable

extension DerivedKey.PublicSignature: Codable {}

// MARK: - DerivedKey.PublicSignature + Sendable

extension DerivedKey.PublicSignature: Sendable {}

// MARK: - DerivedKey.PublicSignature + Hashable

extension DerivedKey.PublicSignature: Hashable {}

public extension DerivedKey.PublicSignature {
    private static let Header = [UInt8](repeating: 0x2A, count: 64)

    init?(key: DerivedKey) {
        var entropy = [UInt8](repeating: 0, count: 64)
        _ = SecRandomCopyBytes(kSecRandomDefault, entropy.count, &entropy)

        let data = Data(DerivedKey.PublicSignature.Header + entropy)
        guard let rawValue = AES(key).encrypt(data)
        else {
            return nil
        }

        self.init(rawValue: rawValue)
    }

    func validate(key: DerivedKey) -> Bool {
        guard let data = AES(key).decrypt(rawValue)
        else {
            return false
        }

        let hex = [UInt8](data)
        guard hex.count == 128
        else {
            return false
        }

        return Array(hex[0 ..< 64]) == DerivedKey.PublicSignature.Header
    }
}
