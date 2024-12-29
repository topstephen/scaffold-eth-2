// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Pair {
    address  public factory;

    address public token0;

    address public token1;


    constructor() payable{
        factory = msg.sender;
    }


    function initialize(address _token0, address _token1) external  {
        require(msg.sender == factory, "!factory");
        token0 = _token0;
        token1 = _token1;
    }
}


contract PairFactory{

    mapping(address => mapping(address => address))  public pairMapping;

    address[] public allPairs;

    function createPair(address tokenA, address tokenB) external returns (address pairAddr) {
        Pair pair = new Pair();
        pair.initialize(tokenA, tokenB);
        pairAddr = address(pair);
        pairMapping[tokenA][tokenB] = pairAddr;
        pairMapping[tokenB][tokenA] = pairAddr;
        allPairs.push(pairAddr);
        return pairAddr;

    }
}
