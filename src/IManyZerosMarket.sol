// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @author philogy <https://github.com/philogy>
interface IManyZerosMarket {
    error AccountBalanceOverflow();
    error AlreadyInitialized();
    error AlreadyMinted();
    error BalanceQueryForZeroAddress();
    error DeploymentFailed();
    error DomainSeparatorsInvalidated();
    error InsufficientValue();
    error InvalidSignature();
    error NoRenderer();
    error NonceAlreadyInvalidated();
    error NotAuthorizedBuyer();
    error NotAuthorizedClaimer();
    error NotOwnerNorApproved();
    error PastDeadline();

    error TokenAlreadyExists();
    error TokenDoesNotExist();
    error TransferFromIncorrectOwner();
    error TransferToNonERC721ReceiverImplementer();
    error TransferToZeroAddress();
    error Unauthorized();

    event Approval(address indexed owner, address indexed account, uint256 indexed id);
    event ApprovalForAll(address indexed owner, address indexed operator, bool isApproved);
    event FeeSet(uint16 fee);
    event OwnershipHandoverCanceled(address indexed pendingOwner);
    event OwnershipHandoverRequested(address indexed pendingOwner);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
    event RendererSet(address indexed renderer);
    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    function DEPLOY_PROXY_INITHASH() external view returns (bytes32);

    ////////////////////////////////////////////////////////////////
    //                           ERC712                           //
    ////////////////////////////////////////////////////////////////

    function CROSS_CHAIN_DOMAIN_SEPARATOR() external view returns (bytes32);
    function FULL_DOMAIN_SEPARATOR() external view returns (bytes32);

    function getNonceIsSet(address user, uint256 nonce) external view returns (bool);
    function invalidateNonce(uint256 nonce) external;

    ////////////////////////////////////////////////////////////////
    //                        VANITY TOKEN                        //
    ////////////////////////////////////////////////////////////////

    function computeAddress(bytes32 salt, uint8 nonce) external view returns (address vanity);
    function feeBps() external view returns (uint16);
    function calculateBuyCost(uint256 sellerPrice) external view returns (uint256);

    function mint(address to, uint256 id, uint8 nonce) external;
    function mintAndBuyWithSig(
        address to,
        uint256 id,
        uint8 saltNonce,
        address beneficiary,
        uint256 sellerPrice,
        address buyer,
        uint256 nonce,
        uint256 deadline,
        bytes memory signature
    ) external payable;
    function claimGivenUpWithSig(
        address to,
        uint256 id,
        uint8 nonce,
        address claimer,
        uint256 deadline,
        bytes memory signature
    ) external;

    function addressOf(uint256 id) external view returns (address vanity);
    function deploy(uint256 id, bytes memory initcode) external payable returns (address deployed);
    function getTokenData(uint256 id) external view returns (bool minted, uint8 nonce);

    ////////////////////////////////////////////////////////////////
    //                          METADATA                          //
    ////////////////////////////////////////////////////////////////

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function tokenURI(uint256 id) external view returns (string memory);
    function contractURI() external view returns (string memory);

    function owner() external view returns (address result);
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        returns (address receiver, uint256 royaltyAmount);

    ////////////////////////////////////////////////////////////////
    //                           ERC721                           //
    ////////////////////////////////////////////////////////////////

    function balanceOf(address owner) external view returns (uint256 result);
    function ownerOf(uint256 id) external view returns (address result);
    function getApproved(uint256 id) external view returns (address result);
    function isApprovedForAll(address owner, address operator) external view returns (bool result);

    function setApprovalForAll(address operator, bool isApproved) external;
    function approve(address account, uint256 id) external;
    function permitForAll(address owner, address operator, uint256 nonce, uint256 deadline, bytes memory signature)
        external;

    function transferFrom(address from, address to, uint256 id) external;
    function safeTransferFrom(address from, address to, uint256 id) external;
    function safeTransferFrom(address from, address to, uint256 id, bytes memory data) external;
}
