// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "../math/SafeMath.sol";
import "hardhat/console.sol";
import "./CrowdSale.sol";
import "./NFTCrowdsale.sol";



contract Manager is Context, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
   
    IERC20 token;
    address nft_addr;
    address public crowdsale_addr ;
    address public NftPresale_addr ;
    address public NftPubsale_addr ;
    address public ico_addr ;
    address[] public rounds;


    uint256 private constant cap = 10  ** 18  ;
    uint256 public durationCap = block.timestamp + 94694400 * 1 seconds;
    uint256 totalSuply;
    uint256 public unlock;
    uint256 public spend;
    uint256 public psale;
       
    constructor(address token_,address owner_){
        transferOwnership(owner_);
        token = ERC20(token_);
       
        lock();
        spend=0;
        
    }
    receive () external payable {}



    function updateSpend(uint256 amount) public {
        require(_msgSender()==ico_addr,"not the Owner");
        spend=spend-amount;
    }
    function transferCheck(uint256 amount) internal view returns(bool){
        uint256 current = block.timestamp * 1 seconds;

        if(current < durationCap){
          //  uint256 remaining = cap - token.balanceOf(address(this));

            if(spend+amount <= unlock){
                return true;
        }
        else{
            return false;
        }
        
        }
       else{
           return true;
       }
    }

    function balance() public view returns(uint256){
        return token.balanceOf(address(this));
    }
    
    function lock() public {
        uint256 success = (cap*40)/100;
        unlock = cap - success;    
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public payable virtual onlyOwner {
        require(transferCheck(amount)==true , "cannot transfer :: TOKEN LOCKED");
        token.safeTransfer(recipient, amount);
        spend = spend + amount;
    }

    function create_TokenSale(uint256 lockTime,uint256 rate,uint256 percent,address payable wallet,uint256 min) public onlyOwner{
        if(rounds.length > 0){
            address sale_addr =  rounds[rounds.length-1];
            Crowdsale sale = Crowdsale(payable(sale_addr));
            bool status = sale.finalized();
            require(status == true,"Sale in progress");
        }
        require(percent<=60,"percentage must be less than 60");
        Crowdsale ico;
        psale = (cap*percent)/100;
        ico = new Crowdsale(lockTime,rate,wallet,IERC20(address(token)),payable(address(this)),min,psale); 
        ico_addr = address(ico);
        transfer (ico_addr,psale);
        rounds.push(ico_addr);
    } 

    // function create_NftPreSale(address[] memory accounts,address payable wallet,address _nft) public onlyOwner{
    //     NFTCrowdsale ico;      
    //     ico = new NFTCrowdsale(accounts,wallet,_nft,payable(address(this))); 
    //     NftPresale_addr = address(ico);
      
    // } 

    // function create_NftPubSale(address payable wallet,address _nft) public onlyOwner{
    //     NFTCrowdsale ico;
    //     address[] memory accounts;
    //     ico = new NFTCrowdsale(accounts,wallet,_nft,payable(address(this))); 
    //     NftPubsale_addr = address(ico);
       
    // } 
 

}

//all erc20 transfer functionality
//start-finalize preSale
//start-finalize ICO

