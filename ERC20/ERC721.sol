// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 {
    string private name;
    string private symbol;
    uint private decimal;
    uint private totalSupply;

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(string memory _name, string memory _symbol, uint _TotalSupply) {
        name = _name;
        symbol = _symbol;
        decimal = 18;
        totalSupply = _TotalSupply * (10 ** decimal);
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function tokenName() public view returns (string memory) {
        return name;
    }

    function tokenSymbol() public view returns (string memory) {
        return symbol;
    }

    function tokenDecimals() public view returns (uint) {
        return decimal;
    }

    function _totalSupply() public view returns (uint) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "Insufficient Balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address spender, uint _value) public returns (bool success) {
        allowed[msg.sender][spender] = _value;
        emit Approval(msg.sender, spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint) {
        return allowed[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
        require(balances[_from] >= _amount, "Insufficient Balance");
        require(allowed[_from][msg.sender] >= _amount, "Allowance exceeded");

        balances[_from] -= _amount;
        balances[_to] += _amount;
        allowed[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);
        return true;
    }
}
