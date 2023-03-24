//
//  Created by Anton Spivak
//

import Foundation

// MARK: - BIP44.HDWallet

public extension BIP44 {
    struct HDWallet {
        // MARK: Lifecycle

        public init(
            purpose: BIP32.DerivationPath.KeyIndex = .hardened(44),
            coin: CoinKind,
            account: BIP32.DerivationPath.KeyIndex = .hardened(0),
            change: BIP32.DerivationPath.KeyIndex = .ordinary(0),
            index: BIP32.DerivationPath.KeyIndex = .ordinary(0)
        ) {
            self.purpose = purpose
            self.coin = coin
            self.account = account
            self.change = change
            self.index = index
        }

        // MARK: Public

        /// Purpose is a constant set to 44' (or 0x8000002C) following the BIP43 recommendation. It
        /// indicates that the subtree of this node is used according to this specification.
        ///
        /// Hardened derivation is used at this level.
        public let purpose: BIP32.DerivationPath.KeyIndex

        /// One master node (seed) can be used for unlimited number of independent cryptocoins such
        /// as Bitcoin, Litecoin or Namecoin. However, sharing the same space for various
        /// cryptocoins has some disadvantages.
        ///
        /// This level creates a separate subtree for every cryptocoin, avoiding reusing addresses
        /// across cryptocoins and improving privacy issues.
        ///
        /// Coin type is a constant, set for each cryptocoin. Cryptocoin developers may ask for
        /// registering unused number for their project.
        ///
        /// The list of already allocated coin types is in the chapter "Registered coin types"
        /// below.
        ///
        /// Hardened derivation is used at this level.
        public let coin: CoinKind

        /// This level splits the key space into independent user identities, so the wallet never
        /// mixes the coins across different accounts.
        ///
        /// Users can use these accounts to organize the funds in the same fashion as bank accounts;
        /// for donation purposes (where all addresses are considered public), for saving purposes,
        /// for common expenses etc.
        ///
        /// Accounts are numbered from index 0 in sequentially increasing manner. This number is
        /// used as child index in BIP32 derivation.
        ///
        /// Hardened derivation is used at this level.
        ///
        /// Software should prevent a creation of an account if a previous account does not have
        /// a transaction history (meaning none of its addresses have been used before).
        ///
        /// Software needs to discover all used accounts after importing the seed from an external
        /// source. Such an algorithm is described in "Account discovery" chapter.
        public let account: BIP32.DerivationPath.KeyIndex

        /// Constant 0 is used for external chain and constant 1 for internal chain (also known as
        /// change addresses). External chain is used for addresses that are meant to be visible
        /// outside of the wallet (e.g. for receiving payments). Internal chain is used for
        /// addresses which are not meant to be visible outside of the wallet and is used for return
        /// transaction change.
        ///
        /// Public derivation is used at this level.
        public let change: BIP32.DerivationPath.KeyIndex

        /// Addresses are numbered from index 0 in sequentially increasing manner. This number is
        /// used as child index in BIP32 derivation.
        ///
        /// Public derivation is used at this level.
        public let index: BIP32.DerivationPath.KeyIndex
    }
}

public extension BIP32.ExtendedKey {
    init<D>(_ seed: D, _ hdwallet: BIP44.HDWallet) where D: ContiguousBytes {
        self.init(seed, hdwallet.derivationPath)
    }

    init(_ digest: BIP39.Digest, _ hdwallet: BIP44.HDWallet) {
        self.init(digest.seed, hdwallet.derivationPath)
    }
}

public extension BIP44.HDWallet {
    var derivationPath: BIP32.DerivationPath {
        BIP32.DerivationPath(.master, [purpose, coin.rawValue, account, change, index])
    }
}

// MARK: - BIP44.HDWallet + Equatable

extension BIP44.HDWallet: Equatable {}

// MARK: - BIP44.HDWallet + Sendable

extension BIP44.HDWallet: Sendable {}
