// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";
import "./CrowdSale.sol";
import "./LASM.sol";




contract Manager is Context, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
   
    LASM token;
    address token_addr;
    address public ico_addr ;
    address[] public rounds;
    
    receive () external payable {}

    function setToken(address token_) public onlyOwner{
        token_addr = token_;
          token = LASM(token_);
    }
    function getToken() public view returns(address){
          return token_addr;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public payable virtual onlyOwner returns(bool) {
        token.transfer(recipient, amount);
        return true;
    }

    function create_TokenSale(uint256 lockTime,uint256 rate,uint256 amount,address payable wallet,uint256 min) public onlyOwner{
        require(getToken()!=address(0),"set Token forSale");
        if(rounds.length > 0){
            address sale_addr =  rounds[rounds.length-1];
            Crowdsale sale = Crowdsale(payable(sale_addr));
            bool status = sale.finalized();
            require(status == true,"Sale in progress");
        }
        require(amount <= token.balanceOf(address(this)),"not enough amount");
        Crowdsale ico;
        ico = new Crowdsale(lockTime,rate,wallet,IERC20(address(token)),payable(address(this)),min); 
        ico_addr = address(ico);
        token.addNoTax(ico_addr);
        require(transfer(ico_addr,amount));
        rounds.push(ico_addr);
    }
}
