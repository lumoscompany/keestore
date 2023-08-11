//
//  Created by Anton Spivak
//

import Foundation
import XCTest

@testable import Keestore

// MARK: - SigningTests

final class SigningTests: XCTestCase {
    func testTONSigning() async throws {
        let key = DerivedKey(string: "123456")

        ChainInformation.AddressFormatting.custom("ton").register(
            .init(generator: { _ in "" }, validator: { _ in true })
        )

        for vector in vectors0 {
            let account = try await Account.Blockchain.create(
                for: .ton(),
                with: .mnemonica(
                    vector.mnemonica.components(separatedBy: " "),
                    nil
                ),
                using: key
            )

            guard let signer = try account.signer(using: key)
            else {
                XCTAssert(false)
                return
            }

            try vector.signs.forEach({
                let data = Data(hexRepresentation: $0.key)
                let signature = Data(hexRepresentation: $0.value)
                try XCTAssertEqual(
                    signer.check(signature: signature, for: data),
                    true
                )
            })
        }
    }

    func testStandartSigning() async throws {
        let key = DerivedKey(string: "123456")

        for vector in vectors1 {
            let account = try await Account.Blockchain.create(
                for: .ethereum(),
                with: .mnemonica(
                    vector.mnemonica.components(separatedBy: " "),
                    HDWallet(coin: .ethereum).derivationPath
                ),
                using: key
            )

            guard let signer = try account.signer(using: key)
            else {
                XCTAssert(false)
                return
            }

            try vector.signs.forEach({
                let data = Data(hexRepresentation: $0.key)
                let signature = try signer.sign(data: data)
                XCTAssertEqual(
                    [UInt8](signature),
                    [UInt8](hexRepresentation: $0.value)
                )
            })

            try vector.messages.forEach({
                let message = $0.key
                let signature = try signer.sign(message: message)
                XCTAssertEqual(
                    [UInt8](signature),
                    [UInt8](hexRepresentation: $0.value)
                )
            })
        }
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

private var vectors1: [(mnemonica: String, signs: [String: String], messages: [String: String])] = [
    (
        "solve volcano that zebra miss dune vacuum emotion phone offer smoke stumble",
        [
            "2632E314A000": "3fe66ff89780b6e47d8cd14d2c8fb8cc33ed44e67ddaf24d26122e38fa801b25698bf215e9e7236256de5b3b69136253d89a873cd76e73bf0f02a34f2f777bda00",
        ],
        [
            "hello world": "868ae148fb08919e062a7ef98736c7e8f152adbb858a8dd7eeeab792081ce5683d7cc59ac654c584c59dc60c51c9f77e67e3acb538e6f7a4ba513381602b2d4c00",
            // 1b - 27 ??
        ]
    ),
]
