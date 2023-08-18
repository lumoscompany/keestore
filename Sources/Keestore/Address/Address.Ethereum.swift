//
//  Created by Anton Spivak
//

import BIP
import Foundation
import ObscureKit

// MARK: - Address.Ethereum

public extension Address {
    struct Ethereum: RawRepresentable {
        // MARK: Lifecycle

        public init?(rawValue: Data) {
            guard rawValue.count == 20
            else {
                return nil
            }

            self.init(rawValue)
        }

        public init(publicKey: Data) {
            let hash = keccak256(publicKey.dropFirst()).concreteBytes.suffix(20)
            self.init(Data(hash))
        }

        private init(_ rawValue: Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public let rawValue: Data
    }
}

// MARK: - Address.Ethereum + CustomDebugStringConvertible

extension Address.Ethereum: CustomDebugStringConvertible {
    public var debugDescription: String {
        "[Address.Ethereum]: \(description)"
    }
}

// MARK: - Address.Ethereum + LosslessStringConvertible

extension Address.Ethereum: LosslessStringConvertible {
    public init?(_ description: String) {
        guard description.starts(with: "0x")
        else {
            return nil
        }

        self.init(rawValue: Data(hexRepresentation: description.dropFirst(2)))
    }

    public var description: String {
        return "0x" + rawValue.hexRepresentation
    }
}

// MARK: - Address.Ethereum + Codable

extension Address.Ethereum: Codable {}

// MARK: - Address.Ethereum + Sendable

extension Address.Ethereum: Sendable {}

// MARK: - Address.Ethereum + Hashable

extension Address.Ethereum: Hashable {}

public extension Address.Ethereum {
    func toChecksumAddress() -> String {
        let lowercasedAddress = rawValue.hexRepresentation.lowercased()
        let lowercasedAddressArray = Array(lowercasedAddress)

        let hash = Array(keccak256([UInt8](lowercasedAddress.utf8)).hexRepresentation)
        var result = "0x"

        for i in 0 ..< lowercasedAddress.count {
            if let val = Int(String(hash[i]), radix: 16), val >= 8 {
                result.append(lowercasedAddressArray[i].uppercased())
            } else {
                result.append(lowercasedAddressArray[i])
            }
        }

        return result
    }

    static func isChecksumAddress(_ address: String) -> Bool {
        var address = address
        if address.starts(with: "0x") {
            address = String(address.dropFirst(2))
        }

        let hash = keccak256([UInt8](address.lowercased().utf8)).hexRepresentation

        for i in 0 ..< address.count {
            let addressElement = String(address[address.index(address.startIndex, offsetBy: i)])
            let hashElement = String(hash[hash.index(hash.startIndex, offsetBy: i)])

            guard let hashValue = Int(hashElement, radix: 16)
            else {
                continue
            }

            if hashValue > 7 && addressElement.uppercased() != addressElement {
                return false
            } else if hashValue <= 7 && addressElement.lowercased() != addressElement {
                return false
            }
        }

        return true
    }
}
