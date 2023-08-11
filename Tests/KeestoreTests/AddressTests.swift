//
//  Created by Anton Spivak
//

import Foundation
import XCTest

@testable import Keestore

// MARK: - AddressTests

final class AddressTests: XCTestCase {
    func testEtherieumAddress() async throws {
        let key = DerivedKey(string: "123456")

        for vector in vectors0 {
            let account = try await Account.Blockchain.create(
                for: .ethereum(),
                with: .mnemonica(
                    vector.mnemonica.components(separatedBy: " "),
                    HDWallet(coin: .ethereum).derivationPath
                ),
                using: key
            )

            XCTAssertEqual(account.address.lowercased(), vector.address.lowercased())
        }
        
        for vector in vectors1 {
            guard let address = Address.Ethereum(vector.address)
            else {
                fatalError()
            }

            XCTAssertEqual(address.toChecksumAddress(), vector.checksumAddress)
            XCTAssertEqual(Address.Ethereum.isChecksumAddress(vector.checksumAddress), true)
        }
    }

    func testTRONAddress() async throws {
        let key = DerivedKey(string: "123456")
        
        for vector in vectors3 {
            let account = try await Account.Blockchain.create(
                for: .tron(),
                with: .mnemonica(
                    vector.mnemonica.components(separatedBy: " "),
                    HDWallet(coin: .tron).derivationPath
                ),
                using: key
            )

            XCTAssertEqual(account.address.lowercased(), vector.address.lowercased())
        }
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
