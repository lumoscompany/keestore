//
//  Created by Anton Spivak
//

import Foundation

// MARK: - KeyPair

public enum KeyPair {}

// MARK: - _KeyPair

internal protocol _KeyPair {
    associatedtype PublicKey: _PublicKey
    associatedtype PrivateKey: _PrivateKey<PublicKey>
}

// MARK: - _DataRepresentable

internal protocol _DataRepresentable {
    var rawValue: Data { get }
}

// MARK: - _PublicKey

internal protocol _PublicKey: _DataRepresentable {
    var uncompressed: Self { get }

    func check(signature: any DataProtocol, for data: any DataProtocol) throws -> Bool
}

// MARK: - _PrivateKey

internal protocol _PrivateKey<PublicKey>: _DataRepresentable {
    associatedtype PublicKey: _PublicKey

    var publicKey: PublicKey { get }

    func sign(_ data: any DataProtocol) throws -> any DataProtocol
}
