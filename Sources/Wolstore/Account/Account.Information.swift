//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Account.Information

public extension Account {
    struct Information {
        // MARK: Lifecycle

        public init() {
            self.data = [:]
        }

        // MARK: Public

        public typealias InformationType = Int32

        public var data: [InformationType: Data]
    }
}

// MARK: - Account.Information + Codable

extension Account.Information: Codable {}

// MARK: - Account.Information + Sendable

extension Account.Information: Sendable {}

// MARK: - Account.Information + Hashable

extension Account.Information: Hashable {}

public extension Account.Information {
    mutating func encode<T>(
        _ value: T,
        for informationType: InformationType
    ) throws where T: Encodable {
        data[informationType] = try JSONEncoder.wolstore.encode(value)
    }

    func decode<T>(
        _ type: T.Type,
        for informationType: InformationType
    ) throws -> T? where T: Decodable {
        guard let data = data[informationType]
        else {
            return nil
        }

        return try JSONDecoder.wolstore.decode(type, from: data)
    }
}
