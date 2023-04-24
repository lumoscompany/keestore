//
//  Created by Anton Spivak
//

import BIP
import Foundation
import ObscureKit

// MARK: - Address.TRON

public extension Address {
    struct TRON: RawRepresentable {
        // MARK: Lifecycle

        public init?(rawValue: Data) {
            guard rawValue.count == 21, [UInt8](rawValue)[0] == TRON.prefix
            else {
                return nil
            }

            self.init(rawValue)
        }

        public init(publicKey: Data) {
            let publicKey = KeyPair.Secp256k1.PublicKey(rawValue: publicKey)
            let uncompressed = publicKey.uncompressed.rawValue

            let hash = keccak256(uncompressed.dropFirst()).concreteBytes.suffix(20)
            self.init(Data([TRON.prefix] + hash))
        }

        private init(_ rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public let rawValue: Data

        // MARK: Private

        private static let prefix = UInt8(0x41)
    }
}

// MARK: - Address.TRON + CustomDebugStringConvertible

extension Address.TRON: CustomDebugStringConvertible {
    public var debugDescription: String {
        "[Address.TRON]: \(description)"
    }
}

// MARK: - Address.TRON + LosslessStringConvertible

extension Address.TRON: LosslessStringConvertible {
    public init?(_ description: String) {
        guard description.starts(with: "T"),
              let bytes = [UInt8](base58EncodedCheksumString: description)
        else {
            return nil
        }

        self.init(rawValue: Data(bytes))
    }

    public var description: String {
        return [UInt8](rawValue).base58EncodedCheksumString
    }
}

// MARK: - Address.TRON + Codable

extension Address.TRON: Codable {}

// MARK: - Address.TRON + Sendable

extension Address.TRON: Sendable {}

// MARK: - Address.TRON + Hashable

extension Address.TRON: Hashable {}
