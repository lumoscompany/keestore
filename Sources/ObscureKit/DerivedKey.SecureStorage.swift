//
//  Created by Anton Spivak
//

import CommonCrypto
import Foundation

// MARK: - DerivedKey.SecureStorage

internal extension DerivedKey {
    final class SecureStorage {
        // MARK: Lifecycle

        internal init(_ data: Data) {
            precondition(data.count == kCCKeySizeAES256)
            data.withUnsafeBytes({ (p: UnsafeRawBufferPointer) in
                guard let baseAddress = p.baseAddress
                else {
                    fatalError("[SecureStorage]: Can't copy bytes from data")
                }

                pointer.copyMemory(from: baseAddress, byteCount: kCCKeySizeAES256)
            })
        }

        internal init(_ buffer: [UInt8]) {
            precondition(buffer.count == kCCKeySizeAES256)
            pointer.copyMemory(from: buffer, byteCount: kCCKeySizeAES256)
        }

        deinit {
            let zeros = [UInt8](repeating: 0, count: kCCKeySizeAES256)
            pointer.copyMemory(from: zeros, byteCount: kCCKeySizeAES256)
            pointer.deallocate()
        }

        // MARK: Internal

        internal func perform(with body: (Data) throws -> Void) rethrows {
            let data = Data(bytesNoCopy: pointer, count: kCCKeySizeAES256, deallocator: .none)
            try body(data)
        }

        internal func perform(with body: (Data) async throws -> Void) async rethrows {
            let data = Data(bytesNoCopy: pointer, count: kCCKeySizeAES256, deallocator: .none)
            try await body(data)
        }

        // MARK: Private

        private let pointer: UnsafeMutableRawPointer = .allocate(
            byteCount: kCCKeySizeAES256,
            alignment: MemoryLayout<UInt8>.size
        )
    }
}

// MARK: - DerivedKey.SecureStorage + Sendable

extension DerivedKey.SecureStorage: Sendable {}

// MARK: - DerivedKey.SecureStorage + Hashable

extension DerivedKey.SecureStorage: Hashable {
    static func == (lhs: DerivedKey.SecureStorage, rhs: DerivedKey.SecureStorage) -> Bool {
        var result = false
        lhs.perform(with: { lhs in
            rhs.perform(with: { rhs in
                result = lhs == rhs
            })
        })
        return result
    }

    func hash(into hasher: inout Hasher) {
        perform(with: {
            hasher.combine($0)
        })
    }
}

// MARK: - DerivedKey.SecureStorage + CustomStringConvertible

extension DerivedKey.SecureStorage: CustomStringConvertible {
    public var description: String {
        "[DerivedKey.SecureStorage]: ******"
    }
}

// MARK: - DerivedKey.SecureStorage + CustomDebugStringConvertible

extension DerivedKey.SecureStorage: CustomDebugStringConvertible {
    public var debugDescription: String {
        "[DerivedKey.SecureStorage]: ******"
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: DerivedKey.SecureStorage) {
        appendInterpolation(value.description)
    }
}
