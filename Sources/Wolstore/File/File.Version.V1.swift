//
//  Created by Anton Spivak
//

import Foundation
import ObscureKit

// MARK: - File.Version.V1

internal extension File.Version {
    struct V1 {
        // MARK: Lifecycle

        internal init(signature: DerivedKey.Signature, accounts: [Account]) {
            self.signature = signature
            self.accounts = accounts
        }

        // MARK: Internal

        internal let signature: DerivedKey.Signature
        internal let accounts: [Account]
    }
}

// MARK: - File.Version.V1 + Codable

extension File.Version.V1: Codable {}
