//
//  Created by Anton Spivak
//

import Foundation

public extension BIP39 {
    struct Entropy {
        // MARK: Lifecycle

        public init(length: Mnemonica.Length) {
            let count = length.entropyStrength / 8
            self.init(count: count)
        }

        public init(count: Int) {
            var bytes = [UInt8](repeating: 0, count: count)
            _ = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
            self.init(bytes)
        }

        public init(_ bytes: any ContiguousBytes) {
            self.count = bytes.concreteBytes.count
            self.bytes = bytes
        }

        // MARK: Public

        public let count: Int
        public let bytes: any ContiguousBytes

        // MARK: Internal

        static func _entropy(with length: BIP39.Mnemonica.Length) -> ContiguousBytes {
            let count = length.entropyStrength / 8
            var entropy = [UInt8](repeating: 0, count: count)
            _ = SecRandomCopyBytes(kSecRandomDefault, entropy.count, &entropy)
            return entropy
        }
    }
}
