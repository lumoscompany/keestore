//
//  Created by Anton Spivak
//

import Foundation

// MARK: - InsertedAsset

public enum InsertedAsset {
    case base64(value: Data)
    case url(value: URL)
}

// MARK: Codable

extension InsertedAsset: Codable {}

// MARK: Sendable

extension InsertedAsset: Sendable {}

// MARK: Hashable

extension InsertedAsset: Hashable {}
