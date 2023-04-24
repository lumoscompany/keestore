//
//  Created by Anton Spivak
//

import Foundation

// MARK: - File.Version

internal extension File {
    enum Version {
        case v1(V1)
    }
}

// MARK: - File.Version + Codable

extension File.Version: Codable {
    internal enum CodingKeys: CodingKey {
        case version
        case data
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let version = try container.decode(Int.self, forKey: .version)

        switch version {
        case 1:
            self = try .v1(container.decode(V1.self, forKey: .data))
        default:
            throw Keestore.Error.unknownFileVersion(version)
        }
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .v1(store):
            try container.encode(1, forKey: .version)
            try container.encode(store, forKey: .data)
        }
    }
}

internal extension Keestore {
    init(_ version: File.Version) {
        switch version {
        case let .v1(v1):
            self.init(signature: v1.signature, accounts: v1.accounts)
        }
    }

    var version: File.Version {
        .v1(File.Version.V1(signature: signature, accounts: accounts))
    }
}
