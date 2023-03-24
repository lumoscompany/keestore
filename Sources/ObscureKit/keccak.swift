//
//  Created by Anton Spivak
//

import Foundation
import libkeccak

public func keccak256(_ value: any ContiguousBytes) -> some ContiguousBytes {
    var inputValue = value.concreteBytes
    var outputValue = [UInt8](repeating: 0, count: 32)

    _ = keccack_256(
        &outputValue,
        outputValue.count,
        &inputValue,
        inputValue.count
    )

    return outputValue
}
