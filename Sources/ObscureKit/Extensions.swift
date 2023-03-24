//
//  Created by Anton Spivak
//

import CryptoKit
import Foundation

public extension Array where Element == UInt8 {
    init<S>(hexRepresentation: S) where S: StringProtocol {
        var hexRepresentation = String(hexRepresentation)
        if hexRepresentation.starts(with: "0x") {
            hexRepresentation = String(hexRepresentation.dropFirst(2))
        }

        var startIndex = hexRepresentation.startIndex
        self = stride(from: 0, to: hexRepresentation.count, by: 2).compactMap({ _ in
            let endIndex = hexRepresentation.index(after: startIndex)
            defer {
                startIndex = hexRepresentation.index(after: endIndex)
            }

            let substring = hexRepresentation[startIndex ... endIndex]
            return UInt8(substring, radix: 16)
        })
    }

    var hexRepresentation: String {
        map({ String(format: "%02hhx", $0) }).joined()
    }

    var sha256: [UInt8] {
        SHA256.hash(data: Data(self)).concreteBytes
    }

    var sha512: [UInt8] {
        SHA512.hash(data: Data(self)).concreteBytes
    }
}

public extension Data {
    init<S>(hexRepresentation: S) where S: StringProtocol {
        self = Data([UInt8](hexRepresentation: hexRepresentation))
    }

    var hexRepresentation: String {
        [UInt8](self).hexRepresentation
    }

    var sha256: Data {
        Data([UInt8](self).sha256)
    }

    var sha512: Data {
        Data([UInt8](self).sha512)
    }
}

public extension ContiguousBytes {
    var concreteBytes: [UInt8] {
        var bytes = [UInt8]()
        let _ = withUnsafeBytes({ buffer in
            bytes.append(contentsOf: buffer)
        })
        return bytes
    }

    var hexRepresentation: String {
        concreteBytes.hexRepresentation
    }

    var count: Int {
        concreteBytes.count
    }
}
