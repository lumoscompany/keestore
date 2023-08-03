//
//  Created by Anton Spivak
//

import CryptoKit
import Foundation
import libsecp256k1

// MARK: - secp256k1

public enum secp256k1 {}

// MARK: secp256k1.Error

public extension secp256k1 {
    enum Error {
        case unableCreateContext
        case unableCreationSignatureECDSA
        case invalidSecretKey
        case invalidContext
        case unableSerializePublicKey
    }
}

// MARK: - secp256k1.Error + LocalizedError

extension secp256k1.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableCreateContext:
            return "[libsecp256k1]: Unable to create `secp256k1_context`"
        case .unableCreationSignatureECDSA:
            return "[libsecp256k1]: Recoverable ECDSA signature creation failed."
        case .invalidSecretKey:
            return "[libsecp256k1]: Failed to generate a public key: Invalid secret key."
        case .invalidContext:
            return "[libsecp256k1]: Failed to generate a public key: invalid context."
        case .unableSerializePublicKey:
            return "[libsecp256k1]: Public key could not be serialized."
        }
    }
}

public extension secp256k1 {
    /// - returns: Public key as a `ContiguousBytes`
    static func generatePublicKey(
        from secretKey: any ContiguousBytes,
        compressed: Bool
    ) throws -> some ContiguousBytes {
        let flags = UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY)
        guard let context = secp256k1_context_create(flags)
        else {
            throw secp256k1.Error.unableCreateContext
        }

        defer {
            secp256k1_context_destroy(context)
        }

        let publicKey = try _createPublicKey(context: context, secretKey: secretKey)
        let serializedPublicKey = try _serializePublicKey(
            context: context,
            publicKey: publicKey,
            compressed: compressed
        )

        return serializedPublicKey
    }

    /// - returns: Public key as a `ContiguousBytes`
    static func parsePublicKey(
        from publicKey: any ContiguousBytes,
        compressed: Bool
    ) throws -> some ContiguousBytes {
        let flags = UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY)
        guard let context = secp256k1_context_create(flags)
        else {
            throw secp256k1.Error.unableCreateContext
        }

        defer {
            secp256k1_context_destroy(context)
        }

        let publicKey = try _parsePublicKey(context: context, publicKey: publicKey)
        let serializedPublicKey = try _serializePublicKey(
            context: context,
            publicKey: publicKey,
            compressed: compressed
        )

        return serializedPublicKey
    }

    struct Signature {
        // MARK: Lifecycle

        init(r: any ContiguousBytes, s: any ContiguousBytes, recovery: UInt8) {
            self.r = r
            self.s = s
            self.recovery = recovery
        }

        // MARK: Public

        public let r: any ContiguousBytes
        public let s: any ContiguousBytes
        public let recovery: UInt8

        public var combined: some ContiguousBytes {
            r.concreteBytes + s.concreteBytes + [recovery]
        }
    }

    /// - returns: Signature of given `value` as a `ContiguousBytes`
    static func sign(
        value: any ContiguousBytes,
        with secretKey: any ContiguousBytes
    ) throws -> Signature {
        let flags = UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY)
        guard let context = secp256k1_context_create(flags)
        else {
            throw secp256k1.Error.unableCreateContext
        }

        defer { secp256k1_context_destroy(context) }

        var value = value.concreteBytes
        var secretKey = secretKey.concreteBytes

        let recoverableSignature = UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>
            .allocate(capacity: 1)

        defer { recoverableSignature.deallocate() }

        guard secp256k1_ecdsa_sign_recoverable(
            context,
            recoverableSignature,
            &value,
            &secretKey,
            nil,
            nil
        ) == 1
        else {
            throw secp256k1.Error.unableCreationSignatureECDSA
        }

        let output = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        defer { output.deallocate() }

        var recID: Int32 = 0
        secp256k1_ecdsa_recoverable_signature_serialize_compact(
            context,
            output,
            &recID,
            recoverableSignature
        )

        guard recID < Int32(UInt8.max)
        else {
            throw secp256k1.Error.unableCreationSignatureECDSA
        }

        let _output = UnsafeMutablePointer<UInt8>.allocate(capacity: 65)
        defer { _output.deallocate() }

        _output.update(from: output, count: 64)
        let data = Data(bytes: _output, count: 64)

        return Signature(r: data[0 ..< 32], s: data[32 ..< 64], recovery: UInt8(recID))
    }
}

internal extension secp256k1 {
    static func _createPublicKey(
        context: OpaquePointer,
        secretKey: any ContiguousBytes
    ) throws -> secp256k1_pubkey {
        var secretKey = secretKey.concreteBytes

        guard secp256k1_ec_seckey_verify(context, &secretKey) == 1
        else {
            throw secp256k1.Error.invalidSecretKey
        }

        let publicKey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        guard secp256k1_ec_pubkey_create(context, publicKey, &secretKey) == 1
        else {
            throw secp256k1.Error.invalidContext
        }

        defer {
            publicKey.deallocate()
        }

        let result = publicKey.pointee
        return result
    }

    static func _parsePublicKey(
        context: OpaquePointer,
        publicKey: any ContiguousBytes
    ) throws -> secp256k1_pubkey {
        let publicKey = publicKey.concreteBytes
        let parsedPublicKey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)

        guard secp256k1_ec_pubkey_parse(context, parsedPublicKey, publicKey, publicKey.count) == 1
        else {
            throw secp256k1.Error.invalidContext
        }

        defer {
            parsedPublicKey.deallocate()
        }

        let result = parsedPublicKey.pointee
        return result
    }

    static func _serializePublicKey(
        context: OpaquePointer,
        publicKey: secp256k1_pubkey,
        compressed: Bool
    ) throws -> some ContiguousBytes {
        let flags = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)

        var publicKey = publicKey
        var serializedPublicKey = [UInt8](repeating: 0, count: compressed ? 33 : 65)
        var serializedPublicKeyLength = serializedPublicKey.count

        guard secp256k1_ec_pubkey_serialize(
            context,
            &serializedPublicKey,
            &serializedPublicKeyLength,
            &publicKey,
            flags
        ) == 1
        else {
            throw secp256k1.Error.unableSerializePublicKey
        }

        return serializedPublicKey
    }
}
