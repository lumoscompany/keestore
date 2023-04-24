# Wolstore [![Tests](https://github.com/lumoscompany/keestore/actions/workflows/swift.yml/badge.svg)](https://github.com/lumoscompany/keestore/actions/workflows/swift.yml)

Pure Swift account manager for some blockchain networks

- BIP32, BIP39, BIP44

## Maybe supported networks

- Ethereum
- TON
- TRON

## Installation

```swift
.package(
    url: "https://github.com/lumoscompany/keestore.git",
    .upToNextMajor(from: "0.9.0")
)
```

## Usage samples

### Importing blockhain accounts

```swift
import Keestore

let key = DerivedKey(string: "123456")
let passphrase = "12/24/32 words"

let account = try Account.Blockchain.create(
    for: .ethereum(),
    with: .mnemonica(
        passphrase.components(separatedBy: " "),
        HDWallet(coin: .ethereum).derivationPath
    ),
    using: key
)

print(account.address)
```

### Getting accounts using .keestore file

```swift
let fileName = "default"
let directoryURL = URL(fileURLWithPath: "file:///")
let file = File(direcotryURL: directoryURL, fileNamed: fileName)

guard file.isExists
else {
    return
}

let keestore = try await file.read()
let account = keestore.accounts[0]

switch account.kind {
case let .blockchain(value):
    let key = DerivedKey(string: "${key}")
    let credentials = try? account.credentials?.decrypt(using: key)
    print(credentials)
default:
    break
}

```

### Signing

```swift
let account: Account
let key: DerivedKey

let signature = try? account.signer?.sign(data, using: key)
print(signature)
```

## Authors

- adam@stragner.com
