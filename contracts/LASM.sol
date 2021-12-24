// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./Manager.sol";


contract LASM is ERC20 ,ERC20Burnable {
   
    uint256 private constant cap =10  ** 18   ;

    Manager manager;
                                    
    constructor() ERC20("LASM", "LASM") {
        
        manager = new Manager(address(this),_msgSender());
        _mint(address(manager) , 10**decimals());
    }

    function manager_addr() public view returns(address){
        return address(manager);
    }

    function _mint(address account, uint256 amount) internal virtual override {
        require(totalSupply() + amount <= cap, "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function burn(uint256 amount) public override {
        _burn(_msgSender(), amount);
    }

}