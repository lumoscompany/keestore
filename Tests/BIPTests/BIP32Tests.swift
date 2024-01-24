//
//  Created by Anton Spivak
//

import Foundation
import XCTest

@testable import BIP

// MARK: - BIP32Tests

final class BIP32Tests: XCTestCase {
    func testDerivationPath() throws {
        try vectors.forEach({
            guard let derivationPath = BIP32.DerivationPath($0.derivationPath)
            else {
                XCTFail("Can't parse derivation path.")
                return
            }

            let digest = try BIP39.Digest(mnemonica: $0.mnemonica, algorithm: .ethereum())
            let keyPair = BIP32.ExtendedKey(digest, derivationPath).keyPair

            XCTAssertEqual(keyPair.publicKey.rawValue.hexRepresentation, $0.publicKey)
            XCTAssertEqual(keyPair.privateKey.rawValue.hexRepresentation, $0.privateKey)
        })
    }

    func testDerivationPathConvertible() throws {
        ["m/44`/0/0/0", "m/44`/0/0`/0`", "m/44`/0/0`/0", "m/44`/0`/0/0`/34678/97826364"].forEach({
            XCTAssertEqual(BIP32.DerivationPath($0)?.description, $0)
        })

        ["s/1234567890987654345678909876543456789`/0/0/0", "m/44`/0/0\"\"/0`"].forEach({
            XCTAssertEqual(BIP32.DerivationPath($0), nil)
        })
    }
}

private var vectors: [(
    mnemonica: BIP39.Mnemonica,
    derivationPath: String,
    publicKey: String,
    privateKey: String
)] = [
    (
        "solve volcano that zebra miss dune vacuum emotion phone offer smoke stumble",
        "m/44'/0'/0'/0",
        "030b50f2f7ecc1a763d57e6e70e71d0f1bd16ea54e165a2a3d6efdbccc695f3a38",
        "4a90b06688cfb2bf4a5690e2ff65dec30be33f5bf57729444c268aa0fd402163"
    ),
    (
        "solve volcano that zebra miss dune vacuum emotion phone offer smoke stumble",
        "m/44'/2'/100000/1'",
        "037e040ac1b21f2bd71423b000ebb62314646d9e1e410b228d9b79c529f702cb9e",
        "f3a5da2e9e13ff85c2b0115087dce936a0bf6d360ff24ac1fa8ff6c8b732c69d"
    ),
    (
        "solve volcano that zebra miss dune vacuum emotion phone offer smoke stumble",
        "m/17'",
        "0294c0630acd945cdbe5edbfdc5be01e4dc717a6a349ea48c4f026f64e07a15b3b",
        "ee8c73974b92687886e036806df27d4db77f46588b9de4b82aba24eedf0e23f5"
    ),
//    (
//        "solve volcano that zebra miss dune vacuum emotion phone offer smoke stumble",
//    ),
]
