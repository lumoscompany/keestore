//
//  Created by Anton Spivak
//

import Foundation

// MARK: - RawRepresentableCodable

public protocol RawRepresentableCodable: RawRepresentable, Codable {
    init(rawValue: RawValue)
}

public extension RawRepresentableCodable where RawValue: Codable {
    init?(rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        self.init(rawValue: rawValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
