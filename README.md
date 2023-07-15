# Keestore [![Tests](https://github.com/lumoscompany/keestore/actions/workflows/swift.yml/badge.svg)](https://github.com/lumoscompany/keestore/actions/workflows/swift.yml)

Pure Swift account manager for web2 & web3

- BIP32, BIP39, BIP44

## Installation

```swift
.package(
    url: "https://github.com/lumoscompany/keestore.git",
    .upToNextMajor(from: "0.9.0")
)
```

## Usage samples

### Importing blockchain accounts

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

### Storing accounts using .keestore document

```swift

let fileName = "default"
let directoryURL = URL(fileURLWithPath: "file:///")
let file = Document(direcotryURL: directoryURL, fileNamed: fileName)

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
