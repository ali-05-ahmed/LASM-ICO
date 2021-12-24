// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Manager.sol";



contract Crowdsale is Context, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    
    // The token being sold
    IERC20 private _token;

    // Address where funds are collected
    address payable private _wallet;
    address payable public _manager;
    Manager manager;

    // How many token units a buyer gets per wei.
    // The rate is the conversion between wei and the smallest and indivisible token unit.
    // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
    // 1 wei will give you 1 unit, or 0.001 TOK.
    uint256 private _rate;
    uint256 public min;
    uint256 public max;
    uint256 public minBuy = 0.5 ether;
    uint256 public maxBuy = 1 ether;
    

    // Amount of wei raised
    uint256 private _weiRaised;
    uint256 private _tokenPurchased;
    bool public success;
    bool public finalized;
    bool public _buyable;

    
    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    
    
    mapping (address => uint256) purchase;
    mapping (address => uint256) msgValue;
    uint256 current = block.timestamp * 1 seconds;
    uint256 immutable limitationtime ;
    uint256 buyTime = block.timestamp + 15 days;
     mapping(address => bool) private _whitelist;
    // address[] private _whitelist;
    //  bool public isFinalized = false;
    //  Manager manager;
    constructor (uint256 lockTime,uint256 rate_, address payable wallet_, IERC20 token_, address payable manager_,
    uint256 _min , uint256 _max) {
        require(rate_ > 0, "Crowdsale: rate is 0");
        
        require(address(token_) != address(0), "Crowdsale: token is the zero address");

        // for (uint256 i = 0; i < accounts.length; i++) {
        //     _addPayee(accounts[i]);
        // }
        _rate = rate_;
        _wallet = wallet_;
        _token = token_;
        _manager = manager_;
        manager = Manager(manager_);
        min=_min;
        max = _max;
        limitationtime = block.timestamp + lockTime   * 1 seconds;
      
    }
    // function sale () public{
    //     uint buy ;
    // }


    /**
     * @dev fallback function ***DO NOT OVERRIDE***
     * Note that other contracts will transfer funds with a base gas stipend
     * of 2300, which is not enough to call buyTokens. Consider calling
     * buyTokens directly when purchasing tokens from a contract.
     */
    fallback () external payable {
        buyTokens();
    }

    receive () external payable {
        buyTokens();
    }

    /**
     * @return the token being sold.
     */
    function token() public view returns (IERC20) {
        return _token;
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

    function buyable()public returns(bool) { 
        if(buyTime > block.timestamp){
            _buyable = true;
        }
        return _buyable;
    }

    
    function buyTokens() public nonReentrant payable {
       // require (_whitelist[_msgSender()] == true,"you are not whitelisted");
        require ( buyTime > block.timestamp, "not running");

        uint256 weiAmount = msg.value;
        require(weiAmount >=minBuy && weiAmount <=maxBuy,"please send value according to limit");
        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(weiAmount);

        require(_token.balanceOf(address(this)) >= tokens,"buy amount exceeds not enough Tokens remaining");
        _tokenPurchased = _tokenPurchased + tokens;

        // update state
        _weiRaised = _weiRaised.add(weiAmount);

      //  _updatePurchasingState(beneficiary, weiAmount);
            msgValue[_msgSender()] = msgValue[_msgSender()] + weiAmount;
            purchase[msg.sender]=purchase[msg.sender]+tokens;
       
    }

    function claim() public payable {

    //    require (_whitelist[_msgSender()] == true,"Address not allowed");
        require (block.timestamp > limitationtime);
        require (finalized,"ICO not finalized yet");

      
        uint256 t = purchase[_msgSender()];  
        require (t>0,"0 tokens to claim");
        _processPurchase(_msgSender(), t);
         delete purchase[_msgSender()];
     
    }
    
    function balance() public view returns(uint){
        return _token.balanceOf(address(this));
    }

    function Finalize() public  returns(bool) {
        require( buyTime < block.timestamp, "the crowdSale is in progress");
        require(!finalized,"already finalized");
        require(_msgSender() == _wallet,"you are not the owner");
        if(_weiRaised >= min ){
            success = true;
        }
        else{
             success = false;   
        }
         uint256 remainingTokensInTheContract = _token.balanceOf(address(this)) - _tokenPurchased;
        _token.safeTransfer(address(_manager),remainingTokensInTheContract);
         manager.updateSpend(remainingTokensInTheContract);
        _forwardFunds(_weiRaised);
        finalized = true;
        return success;
    }

    

  

    // function end () external{
    //     if(block.timestamp >= limitationtime){
    //         address afr;
    //        return afr=address(manager);
    //     }else{

    //     }
    // }
    
    // function finalization() internal {
    //   token.transferOwnership(msg.sender);
    //   super.finalization();
    // }
    // function finalizeIfNeeded () internal {
    // if (!finalized && block.timestamp >= crowdsaleEndTime) {
    //     finalization ();
    //     finalized = true;
    // }


    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
     * Use `super` in contracts that inherit from Crowdsale to extend their validations.
     * Example from CappedCrowdsale.sol's _preValidatePurchase method:
     *     super._preValidatePurchase(beneficiary, weiAmount);
     *     require(weiRaised().add(weiAmount) <= cap);
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    // function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
    //     require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
    //     require(weiAmount != 0, "Crowdsale: weiAmount is 0");
    //     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    // }

    /**
     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
     * conditions are not met.
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    // function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
    //     // solhint-disable-previous-line no-empty-blocks
    // }

    /**
     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
     * its tokens.
     * @param beneficiary Address performing the token purchase
     * @param tokenAmount Number of tokens to be emitted
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        _token.safeTransfer(beneficiary, tokenAmount);
    }

    /**
     * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
     * tokens.
     * @param beneficiary Address receiving the tokens
     * @param tokenAmount Number of tokens to be purchased
     */
    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
        _deliverTokens(beneficiary, tokenAmount);
    }

    /**
     * @dev Override for extensions that require an internal state to check for validity (current user contributions,
     * etc.)
     * @param beneficiary Address receiving the tokens
     * @param weiAmount Value in wei involved in the purchase
     */
    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Override to extend the way in which ether is converted to tokens.
     * @param weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _weiAmount
     */
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount.mul(_rate);
    }

    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    function _forwardFunds(uint256 amount) internal {
        _wallet.transfer(amount);
    }

    //  function _addPayee(address account) private {
    //     require(account != address(0), "PaymentSplitter: account is the zero address");
    //     _whitelist[account]=true;
       
    // }
      
}