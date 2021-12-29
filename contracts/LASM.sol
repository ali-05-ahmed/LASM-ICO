// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";



contract LASM is ERC20 , ERC20Burnable, Ownable {

    // beneficiary of tokens after they are released
    address private immutable _beneficiary;

    // timestamp when token release is enabled
    uint256 private immutable _releaseTime;
   
    uint256 private constant cap = 8*10**26;

    address public immutable _manager;


    address public constant team = address(0xA756262bDF22dDC488BF22c3d4b83EE4493110ee);
    address public constant Development = address(0x17ee3fB7737B14192A787101da9c07FdfDaddDe4);
    address public constant Marketing = address(0x361967dA580Ff440fAa3730d5d7207BDb5E1C816);
    address public constant GameRewards = address(0xc3584Db27d65b57bc17D861198B876A6dE452E1B);
    address public constant airdrop = address(0x15cE2fc86a5006d1d81Ef07Ee3e29f379c6eC92B);
    address public constant GameDev = address(0xE68e7125C7017c69295A936869fba0438A45B8C8);
    address public constant LP = address(0x100C4fD051e977AD622be774b6e9b90177fEF8Cd);
    //address public constant holders = address(0x15cE2fc86a5006d1d81Ef07Ee3e29f379c6eC92B);

    mapping(address=>bool) private noTax;

                                    
    constructor(address manager,address beneficiary_ ,uint256  releaseTime_ ) ERC20("LASM", "LASM") 
         {

        _beneficiary = beneficiary_;
        _releaseTime = block.timestamp + releaseTime_ * 1 seconds;
        _manager = manager;
        _mint(manager , (cap/100)*15);
        _mint(address(this) , (cap/100)*40);
        _mint(team , (cap/100)*10);
        _mint(Development , (cap/100)*10);
        _mint(Marketing , (cap/100)*8);
        _mint(GameRewards , (cap/100)*10);
        _mint(airdrop , (cap/100)*7);
        noTax[_msgSender()]=true;
        noTax[beneficiary_]=true;
        noTax[address(this)]=true;
        noTax[manager]=true;
        noTax[team]=true;
        noTax[Development]=true;
        noTax[Marketing]=true;
        noTax[GameRewards]=true;
        noTax[airdrop]=true;
    }

    

    function addNoTax(address account)public{
        require(_msgSender()==owner() || _msgSender()==_manager,"Ownable: caller is not the owner");
         noTax[account]=true;
    }

    function _mint(address account, uint256 amount) internal virtual override {
        require(totalSupply() + amount <= cap, "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function burn(uint256 amount) public override {
        _burn(_msgSender(), amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        if(noTax[_msgSender()]){
            ERC20.transfer(recipient, amount);
            return true;
        }else{
             uint256 tax = (amount/100)*10;
        amount = amount -tax;
        ERC20._transfer(_msgSender(),team, (tax/100)*6);
        ERC20._transfer(_msgSender(),Development, (tax/100)*6);
        ERC20._transfer(_msgSender(),Marketing, (tax/100)*6);
        ERC20._transfer(_msgSender(),GameRewards, (tax/100)*6);
        ERC20._transfer(_msgSender(),airdrop, (tax/100)*6);
        ERC20._transfer(_msgSender(),GameDev, (tax/100)*40);
        ERC20._transfer(_msgSender(),LP, (tax/100)*30);
        ERC20._transfer(_msgSender(),recipient, amount);
        return true;
        }
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public  override returns (bool) {
         if(noTax[sender]){
            ERC20.transferFrom(sender,recipient, amount);
            return true;
        }else{
        uint256 tax = (amount/100)*10;
        amount = amount -tax;
        ERC20.transferFrom(sender,recipient, amount);
        ERC20._transfer(sender,team, (tax/100)*6);
        ERC20._transfer(sender,Development, (tax/100)*6);
        ERC20._transfer(sender,Marketing, (tax/100)*6);
        ERC20._transfer(sender,GameRewards, (tax/100)*6);
        ERC20._transfer(sender,airdrop, (tax/100)*6);
        ERC20._transfer(sender,GameDev, (tax/100)*40);
        ERC20._transfer(sender,LP, (tax/100)*30);
       
        return true;
        }
    }

    /**
     * @return the beneficiary of the tokens.
     */
    function beneficiary() public view virtual returns (address) {
        return _beneficiary;
    }

    /**
     * @return the time when the tokens are released.
     */
    function releaseTime() public view virtual returns (uint256) {
        return _releaseTime;
    }

    /**
     * @notice Transfers tokens held by timelock to beneficiary.
     */
    function release() public virtual {
        require(block.timestamp >= releaseTime(), "TokenTimelock: current time is before release time");

        uint256 amount = balanceOf(address(this));
        require(amount > 0, "TokenTimelock: no tokens to release");

        ERC20._transfer(address(this),beneficiary(),  amount);
    }

}