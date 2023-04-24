//
//  Created by Anton Spivak
//

import Foundation
import XCTest

@testable import Wolstore

// MARK: - AddressTests

final class AddressTests: XCTestCase {
    func testEtherieumAddress() throws {
        let key = DerivedKey(string: "123456")

        try vectors0.forEach({
            let account = try Account.Blockchain.create(
                for: .ethereum(),
                with: .mnemonica(
                    $0.mnemonica.components(separatedBy: " "),
                    HDWallet(coin: .ethereum).derivationPath
                ),
                using: key
            )

            let address = Address.Ethereum(publicKey: account.pkey)
            XCTAssertEqual(address.description.lowercased(), $0.address.lowercased())
        })

        vectors1.forEach({
            guard let address = Address.Ethereum($0.address)
            else {
                fatalError()
            }

            XCTAssertEqual(address.toChecksumAddress(), $0.checksumAddress)
            XCTAssertEqual(Address.Ethereum.isChecksumAddress($0.checksumAddress), true)
        })
    }

    func testTRONAddress() throws {
        let key = DerivedKey(string: "123456")

        try vectors3.forEach({
            let account = try Account.Blockchain.create(
                for: .tron(),
                with: .mnemonica(
                    $0.mnemonica.components(separatedBy: " "),
                    HDWallet(coin: .tron).derivationPath
                ),
                using: key
            )

            let address = Address.TRON(publicKey: account.pkey)
            XCTAssertEqual(address.description.lowercased(), $0.address.lowercased())
        })
    }
}

private var vectors0: [(mnemonica: String, address: String)] = [
    (
        "solve volcano that zebra miss dune vacuum emotion phone offer smoke stumble",
        "0x6C841f93B6Bc5d14f8cd676d35B24C116D889d6c"
    ),
]

private var vectors1: [(address: String, checksumAddress: String)] = [
    ("0x12ae66cdc592e10b60f9097a7b0d3c59fce29876", "0x12AE66CDc592e10B60f9097a7b0D3C59fce29876"),
    ("0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1", "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1"),
]

private var vectors3: [(mnemonica: String, address: String)] = [
    (
        "seed vanish prize knife choose pony clutch child suspect speak sign wife",
        "TDPf4avJyK8rdWR9Gv3JdKcEN95eitEFTc"
    ),
]
