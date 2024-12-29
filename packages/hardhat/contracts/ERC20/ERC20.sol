// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./IERC20.sol";

contract ERC20 is IERC20 {

    /*我们需要状态变量来记录账户余额，授权额度和代币信息。其中balanceOf, allowance和totalSupply为public类型，
    会自动生成一个同名getter函数，实现IERC20规定的balanceOf()
    , allowance()和totalSupply()。而name, symbol, decimals则对应代币的名称，代号和小数位数。*/
    mapping(address => uint256)  public  override balanceOf;

    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;

    address public owner;

    string public name;

    string public symbol;

    uint8 public decimals = 18;


    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }


    function transfer(address to, uint256 amount) balanceCheck(amount) public override returns (bool) {
        address _sender = msg.sender;
        balanceOf[_sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(_sender, to, amount);
        return true;
    }


    function approve(address spender, uint256 amount) balanceCheck(amount) public override returns (bool) {
        allowance[msg.sender][spender] += amount; //spender 可以是EOA账户，也可以是合约账户
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address payer, address recipient, uint256 amount) public override returns (bool) {
        allowance[payer][msg.sender] -= amount; //msg.sender 可以是EOA账户，也可以是合约账户
        balanceOf[payer] -= amount;
        balanceOf[recipient] += amount;
        return true;
    }

    //铸造代币函数，不在IERC20标准中
    function mint(uint amount) onlyOwner external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    //销毁代币函数，不在IERC20标准中
    function burn(uint amount) onlyOwner external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    modifier balanceCheck(uint256 amount) {
        require(balanceOf[msg.sender] >= amount, "Not enough tokens");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

}
