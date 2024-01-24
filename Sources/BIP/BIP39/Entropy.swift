//
//  Created by Adam Stragner
//

import Foundation

public extension BIP39 {
    struct Entropy {
        // MARK: Lifecycle

        public init(length: Mnemonica.Length) {
            self.init(count: length.entropyBytesCount)
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
    }
}
