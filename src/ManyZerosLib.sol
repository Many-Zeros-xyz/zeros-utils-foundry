// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IManyZerosMarket} from "./IManyZerosMarket.sol";

IManyZerosMarket constant MANY_ZEROS_MARKET = IManyZerosMarket(0x000000000000b361194cfe6312EE3210d53C15AA);

struct GiveUpEverywhere {
    uint256 id;
    uint8 nonce;
    address claimer;
    uint256 deadline;
}

struct MintAndSell {
    uint256 id;
    uint8 saltNonce;
    uint256 price;
    address beneficiary;
    address buyer;
    uint256 nonce;
    uint256 deadline;
}

using ManyZerosLib for GiveUpEverywhere global;
using ManyZerosLib for MintAndSell global;

/// @author philogy <https://github.com/philogy>
library ManyZerosLib {
    using ManyZerosLib for IManyZerosMarket;

    /// @dev keccak256("GiveUpEverywhere(uint256 id,uint8 nonce,address claimer,uint256 deadline)")
    bytes32 internal constant GIVE_UP_EVERWHERE_TYPEHASH =
        0x3d27e7c5806b97e91e45fdf6c7d4b7e7b8aa85f091a2fa2999a87ea3bafc7ca6;

    /// @dev keccak256("MintAndSell(uint256 id,uint8 saltNonce,uint256 price,address beneficiary,address buyer,uint256 nonce,uint256 deadline)")
    bytes32 internal constant MINT_AND_SELL_TYPEHASH =
        0xd7297ff8cc8b0abf17e5590f0b14e1c876bb758ce21d250e9d39e37f61d77f5e;

    /// @dev Computes the ERC-712 struct hash of `self`.
    function structHash(GiveUpEverywhere memory self) internal pure returns (bytes32) {
        return keccak256(abi.encode(GIVE_UP_EVERWHERE_TYPEHASH, self.id, self.nonce, self.claimer, self.deadline));
    }

    /// @dev Computes the ERC-712 struct hash of `self`.
    function structHash(MintAndSell memory self) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                MINT_AND_SELL_TYPEHASH,
                self.id,
                self.saltNonce,
                self.price,
                self.beneficiary,
                self.buyer,
                self.nonce,
                self.deadline
            )
        );
    }

    function digestHash(IManyZerosMarket market, GiveUpEverywhere memory giveUp) internal view returns (bytes32) {
        bytes32 crossChainDomain = market.CROSS_CHAIN_DOMAIN_SEPARATOR();
        return keccak256(abi.encodePacked(bytes2(0x1901), crossChainDomain, giveUp.structHash()));
    }

    function digestHash(IManyZerosMarket market, MintAndSell memory mintAndSell) internal view returns (bytes32) {
        bytes32 crossChainDomain = market.FULL_DOMAIN_SEPARATOR();
        return keccak256(abi.encodePacked(bytes2(0x1901), crossChainDomain, mintAndSell.structHash()));
    }

    function default_digestHash(GiveUpEverywhere memory giveUp) internal view returns (bytes32) {
        return MANY_ZEROS_MARKET.digestHash(giveUp);
    }

    function default_digestHash(MintAndSell memory mintAndSell) internal view returns (bytes32) {
        return MANY_ZEROS_MARKET.digestHash(mintAndSell);
    }

    /// @dev Create an ID owned by `owner` with `ext` as the lower bits.
    function ownerPlusExtensionToId(address owner, uint96 ext) internal pure returns (uint256 id) {
        id = (uint256(uint160(owner)) << 96) | ext;
    }
}
