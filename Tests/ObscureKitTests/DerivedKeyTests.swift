//
//  Created by Anton Spivak
//

import Foundation
import XCTest

@testable import ObscureKit

final class DerivedKeyTests: XCTestCase {
    func testSignature() throws {
        let key1 = DerivedKey(string: "test")
        let key2 = DerivedKey(string: "test245")
        
        XCTAssertEqual(DerivedKey.PublicSignature(key: key1).validate(key: key2), false)
        XCTAssertEqual(DerivedKey.PublicSignature(key: key1).validate(key: key1), true)
    }
}
