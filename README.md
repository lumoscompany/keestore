# Wolstore [![Tests](https://github.com/lumoscompany/wolstore/actions/workflows/default.yml/badge.svg)](https://github.com/lumoscompany/wolstore/actions/workflows/default.yml)

Pure Swift account manager for some blockchain networks

- BIP32, BIP39, BIP44

## Supported networks

- Ethereum
- TON
- TRON

## Installation

```swift
.package(
    url: "https://github.com/lumoscompany/wolstore.git",
    .upToNextMajor(from: "0.1.0")
)
```

## Usage samples

### Importing accounts

```swift
let key = AES.KEY32(string: "123456")
let mnemonica = "12/24/32 words"

let account = try Account.import(
    using: key,
    network: .ethereum(.mainnet),
    options: .mnemonica(
        $0.mnemonica.components(separatedBy: " "),
        HDWallet(coin: .ethereum).derivationPath
    )
)

let keyPair = try account.keyPair(using: key)
let address = try Address.Ethereum(keyPair)

print(address)
```

### Getting accounts using .wolstore file

```swift
let readerWriter = try Wolstore.ReaderWriter(
    direcotryURL: directoryURL,
    fileNamed: fileName
)

guard !readerWriter.isFileExists
else {
    return
}

print(accounts)

let account = accounts[0]
let key = AES.KEY32(string: "${key}")

let keyPair = try account.keyPair(using: key)
let address = try Address.Ethereum(keyPair)

print(address)
```

### Signing

```swift
let account: Account
let data: Data
let key: AES.KEY32

let signature = try account.sign(data, using: key)

print(signature)
```

## Authors

- adam@stragner.com
