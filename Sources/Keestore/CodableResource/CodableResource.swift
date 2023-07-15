//
//  Created by Anton Spivak
//

import Foundation

// MARK: - CodableResource

public enum CodableResource {
    case rgba(RGBA)
    case png(PNG)
    case svg(SVG)
}

public extension CodableResource {
    typealias RGBA = PlatformColor
    typealias PNG = PlatformImage
}

// MARK: Codable

extension CodableResource: Codable {
    private enum CodingKeys: CodingKey {
        case rgba
        case png
        case svg
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.allKeys.contains(.rgba) {
            self = try .rgba(container.decode(RGBA.self, forKey: .rgba))
        } else if container.allKeys.contains(.png) {
            self = try .png(container.decode(PNG.self, forKey: .png))
        } else if container.allKeys.contains(.svg) {
            self = try .svg(container.decode(SVG.self, forKey: .svg))
        } else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: [CodingKeys.rgba, .png, .svg],
                debugDescription: "Can't localte any supported resource type"
            ))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .rgba(value):
            try container.encode(value, forKey: .rgba)
        case let .png(value):
            try container.encode(value, forKey: .png)
        case let .svg(value):
            try container.encode(value, forKey: .svg)
        }
    }
}

// MARK: Sendable

extension CodableResource: Sendable {}

// MARK: Hashable

extension CodableResource: Hashable {}

// MARK: CodableResource.SVG

public extension CodableResource {
    struct SVG: RawRepresentable {
        // MARK: Lifecycle

        public init(rawValue: Foundation.Data) {
            self.rawValue = rawValue
        }

        // MARK: Public

        public var rawValue: Foundation.Data
    }
}

// MARK: - CodableResource.SVG + Codable

extension CodableResource.SVG: Codable {}

// MARK: - CodableResource.SVG + Sendable

extension CodableResource.SVG: Sendable {}

// MARK: - CodableResource.SVG + Hashable

extension CodableResource.SVG: Hashable {}
