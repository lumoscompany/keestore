//
//  Created by Anton Spivak
//

import Foundation
import XCTest

@testable import ObscureKit

final class DerivedKeyTests: XCTestCase {
    func testSignature() throws {
        let key1 = DerivedKey(string: "test")
        let key2 = DerivedKey(string: "tes")
        let key3 = DerivedKey(string: "test245")
        
        guard let signature = DerivedKey.PublicSignature(key: key1)
        else {
            fatalError("[DerivedKeyTests]: Can't create signature")
        }
        
        XCTAssertEqual(signature.validate(key: key3), false)
        XCTAssertEqual(signature.validate(key: key2), false)
        XCTAssertEqual(signature.validate(key: key1), true)
    }
}
