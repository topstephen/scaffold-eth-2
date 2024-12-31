// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {MyERC20} from "../ERC20/MyERC20.sol";
import {IERC20} from "../ERC20/IERC20.sol";


contract Faucet {

    uint256 internal amount = 100;
    address public myErc20Contract;
    mapping(address =>bool)  public getRecordsMapping;

    event TokenTransferred(address indexed recipient ,uint256 amount,uint256 timestam);
    constructor(address _myErc20Contract){
        myErc20Contract = _myErc20Contract;
    }

    function getFaucet() external {
        require(!getRecordsMapping[msg.sender],"You have already received the tokens");
        IERC20 erc20 = IERC20(myErc20Contract);
        require(erc20.balanceOf(address(this)) > amount,"no balance");
        erc20.transfer(msg.sender,amount);
        getRecordsMapping[msg.sender]  = true;
        emit TokenTransferred(msg.sender,amount,block.timestamp);
    }

    function modifyErc2OAddress(address newContractAddr) public  {
        myErc20Contract = newContractAddr;
    }

}
