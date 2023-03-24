//
//  Created by Anton Spivak
//

import CommonCrypto
import Foundation

internal extension String {
    var unescaped: String {
        replacingOccurrences(of: "\'", with: "`").replacingOccurrences(of: "'", with: "`")
    }
}
