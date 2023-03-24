//
//  Created by Anton Spivak
//

import Foundation

extension UInt32 {
    var littleEndianBytes: [UInt8] {
        return [
            UInt8((self & 0xFF000000) >> 24),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8((self & 0x000000FF) >> 0),
        ]
    }
}
