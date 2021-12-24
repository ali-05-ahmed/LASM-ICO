// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./NFT.sol";



contract NFTCrowdsale is Context, ReentrancyGuard,Ownable {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    
    // The token being sold
    IERC20 private _token;
    NFT private nft;
    // Address where funds are collected
    address payable private _wallet;
    address payable public _manager;

    
    uint256 private _rate;
    uint256 private limit = 666;
    uint256 public min;
    uint256 public max;
    uint256 public whitePrice = 0.2 ether;
    uint256 public pubPrice = 0.3 ether;
    

    // Amount of wei raised
    uint256 private _weiRaised;
    uint256 private _nftPurchased;
    bool public success;
    bool public finalized;
    bool public pub;


    
    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    
    
    mapping (address => uint256) purchase;
    mapping (address => uint256) msgValue;
    uint256 current = block.timestamp * 1 seconds;
    uint256 limitationtime = block.timestamp + 7776000   * 1 seconds;
     mapping(address => bool) private _whitelist;
   
    

    
    function startSale(address[] memory accounts, address payable wallet_ ,address _nft) public onlyOwner {
        //NFT(_nft) req
        require(address(_nft) != address(0), "NFT: token is the zero address");
        nft = NFT(_nft);
        if(accounts.length==0){
        pub = true;
        }
        else{
            pub = false;
            for (uint256 i = 0; i < accounts.length; i++) {
                _addPayee(accounts[i]);
            }
        }
        _wallet = wallet_;
    }
 
    fallback () external payable {
        buyNFT();
    }

    receive () external payable {
        buyNFT();
    }


    /**
     * @return the address where funds are collected.
     */
    function wallet() public view returns (address payable) {
        return _wallet;
    }

    /**
     * @return the number of token units a buyer gets per wei.
     */
    function rate() public view returns (uint256) {
        return _rate;
    }

    /**
     * @return the amount of wei raised.
     */
    function weiRaised() public view returns (uint256) {
        return _weiRaised;
    }

    
    function buyNFT() public nonReentrant payable {
        uint256 price;
        if(!pub){
            require (purchase[_msgSender()] < 1,"cant buy more nft");
            require (_whitelist[_msgSender()] == true,"you are not whitelisted");
            require(_nftPurchased < 666,"All nft Sold");
            price = whitePrice;
        }
        else{
            price = pubPrice;
        }
        require (!finalized,"Sale Ended");
        uint256 weiAmount = msg.value;
        require (weiAmount ==  price,"please provide exact amount for one NFT");

        nft.createToken("4321",_msgSender());

        
        _nftPurchased ++;

        purchase[_msgSender()]++;

        // update state
        _weiRaised = _weiRaised.add(weiAmount);

        _wallet.transfer(weiAmount);   
    }

    function Finalize() public  returns(bool) {
        require(!finalized,"already finalized");
        if(pub){
            require( nft.maxSupply() - limit == _nftPurchased, "the crowdSale is in progress");
            //nft.transferOwnership(_wallet);
            finalized = true;
        }
        else{
            require( limit == _nftPurchased, "the crowdSale is in progress");
            //nft.transferOwnership(_wallet);
            finalized = true;
        }
        return finalized;
    }

    function _addPayee(address account) private {
        require(account != address(0), "PaymentSplitter: account is the zero address");
        _whitelist[account]=true;
       
    }
      
}