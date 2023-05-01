//
//  Created by Anton Spivak
//

import Foundation

// MARK: - CodableAsset

public enum CodableAsset {
    case color(Color)
    case image(Image)
}

// MARK: Codable

extension CodableAsset: Codable {}

// MARK: Sendable

extension CodableAsset: Sendable {}

// MARK: Hashable

extension CodableAsset: Hashable {}

// MARK: CodableAsset.Image

public extension CodableAsset {
    struct Image {
        // MARK: Lifecycle

        public init(rawValue: Unimage) {
            self.rawValue = rawValue
        }

        // MARK: Public

        @CodableImage
        public var rawValue: Unimage
    }
}

// MARK: - CodableAsset.Image + Codable

extension CodableAsset.Image: Codable {}

// MARK: - CodableAsset.Image + Sendable

extension CodableAsset.Image: Sendable {}

// MARK: - CodableAsset.Image + Hashable

extension CodableAsset.Image: Hashable {}

// MARK: - CodableAsset.Color

public extension CodableAsset {
    struct Color {
        // MARK: Lifecycle

        public init(rawValue: Unicolor) {
            self.rawValue = rawValue
        }

        // MARK: Public

        @CodableColor
        public var rawValue: Unicolor
    }
}

// MARK: - CodableAsset.Color + Codable

extension CodableAsset.Color: Codable {}

// MARK: - CodableAsset.Color + Sendable

extension CodableAsset.Color: Sendable {}

// MARK: - CodableAsset.Color + Hashable

extension CodableAsset.Color: Hashable {}
