//
//  Created by Anton Spivak
//

import BigInt
import Foundation

internal extension BigUInt {
    static var curveOrder: BigUInt = {
        let value = BigUInt(
            "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141",
            radix: 16
        )

        guard let value
        else {
            fatalError("[BIP32.BigUInt]: Can't create `curveOrder`.")
        }

        return value
    }()
}
