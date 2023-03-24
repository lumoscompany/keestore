//
//  Created by Anton Spivak
//

import CommonCrypto
import Foundation

// MARK: - PKCS5

public enum PKCS5 {
    enum Error {
        case invalidCCKeyDerivationPBKDF
    }
}

// MARK: - PKCS5.Error + LocalizedError

extension PKCS5.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCCKeyDerivationPBKDF:
            return "[PKCS5.Error]: Unable to generate CCKeyDerivationPBKDF."
        }
    }
}

public extension PKCS5 {
    static func PBKDF2SHA512(
        password: any ContiguousBytes,
        salt: any ContiguousBytes,
        iterations: UInt32,
        derivedKeyLength: Int
    ) throws -> some ContiguousBytes {
        var output = [UInt8](repeating: 0, count: derivedKeyLength)
        try password.withUnsafeBytes({ (passwordBytes: UnsafeRawBufferPointer) in
            try salt.withUnsafeBytes({ (saltBytes: UnsafeRawBufferPointer) in
                let status = CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    passwordBytes.baseAddress?.assumingMemoryBound(to: UInt8.self),
                    password.count,
                    saltBytes.baseAddress?.assumingMemoryBound(to: UInt8.self),
                    salt.count,
                    CCPBKDFAlgorithm(kCCPRFHmacAlgSHA512),
                    iterations,
                    &output,
                    output.count
                )

                guard status == kCCSuccess
                else {
                    throw PKCS5.Error.invalidCCKeyDerivationPBKDF
                }
            })
        })
        return output
    }
}
