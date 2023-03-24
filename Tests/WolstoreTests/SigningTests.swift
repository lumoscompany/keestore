//
//  Created by Anton Spivak
//

import Foundation
import XCTest

@testable import Wolstore

// MARK: - SigningTests

final class SigningTests: XCTestCase {
    func testTONSigning() throws {
        let key = DerivedKey(string: "123456")

        try vectors0.forEach({
            let account = try Account.Blockchain.create(
                for: .ton,
                with: .mnemonica(
                    $0.mnemonica.components(separatedBy: " "),
                    nil
                ),
                using: key
            )
            
            guard let signer = try account.signer(using: key)
            else {
                XCTAssert(false)
                return
            }

            try $0.signs.forEach({
                let data = Data(hexRepresentation: $0.key)
                let signature = Data(hexRepresentation: $0.value)
                try XCTAssertEqual(
                    signer.check(signature: signature, for: data),
                    true
                )
            })
        })
    }

    func testStandartSigning() throws {
        let key = DerivedKey(string: "123456")

        try vectors1.forEach({
            let account = try Account.Blockchain.create(
                for: .ethereum(.mainnnet),
                with: .mnemonica(
                    $0.mnemonica.components(separatedBy: " "),
                    HDWallet(coin: .ethereum).derivationPath
                ),
                using: key
            )
            
            guard let signer = try account.signer(using: key)
            else {
                XCTAssert(false)
                return
            }

            try $0.signs.forEach({
                let data = Data(hexRepresentation: $0.key)
                let signature = try signer.sign(data)
                XCTAssertEqual(
                    [UInt8](signature),
                    [UInt8](hexRepresentation: $0.value)
                )
            })
        })
    }
}

private var vectors0: [(mnemonica: String, signs: [String: String])] = [
    (
        "spoon keep labor chalk cover grid before struggle physical cram empower trigger outdoor skill clutch loud venture assume inch put idle crop mask mesh",
        [
            "2632E314A000": "29a4cfb95ce40fb293ed61e0bea3147224262fca77c4c5031c4ff7f12046f79dd11188a26954b36433f88237aa65df59b5776501cc038320ed6728c9d5fdfd08",
        ]
    ),
]

private var vectors1: [(mnemonica: String, signs: [String: String])] = [
    (
        "solve volcano that zebra miss dune vacuum emotion phone offer smoke stumble",
        [
            "2632E314A000": "3fe66ff89780b6e47d8cd14d2c8fb8cc33ed44e67ddaf24d26122e38fa801b25698bf215e9e7236256de5b3b69136253d89a873cd76e73bf0f02a34f2f777bda00",
        ]
    ),
]
