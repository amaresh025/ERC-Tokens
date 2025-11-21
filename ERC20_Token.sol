// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint public totalSupply;
    address public owner;

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowances;

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed owner, address indexed spender, uint tokens);
    event Mint(address indexed _to, uint tokens);
    event Burn(address indexed _to, uint tokens);

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply * (10 ** decimals);
        owner = msg.sender;

        balances[msg.sender] += totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    function mint(address to, uint amount) external {
        require(to != address(0), "Address Invalid!");
        require (msg.sender == owner, "Not owner!");

        uint ercAmount = amount * (10 ** decimals);

        totalSupply += ercAmount;
        balances[to] += ercAmount;
        emit Transfer(address(0), to, ercAmount);
        emit Mint(to, ercAmount);
    }

    function burn(uint amount) external {
        uint ercAmount = amount * (10 ** decimals);
        require(balances[msg.sender] >= ercAmount, "Insufficient Balance!");


        totalSupply -= ercAmount;
        balances[msg.sender] -= ercAmount;
        emit Burn(msg.sender, ercAmount);
        emit Transfer(msg.sender, address(0), ercAmount);
    }
    function transfer(address receiver, uint value) public returns (bool success) {
        uint ercToken = value * (10 ** decimals);
        require(balances[msg.sender] >= ercToken, "Insufficient balance");
        require(receiver != address(0));

        balances[msg.sender] -= ercToken;
        balances[receiver] += ercToken;
        emit Transfer(msg.sender, receiver, ercToken);
        return true;
    }

    function approve(address spender, uint token) public returns (bool success) {
        uint erctoken = token * (10 ** decimals);
        allowances[msg.sender][spender] = erctoken;

        emit Approval(msg.sender, spender, erctoken);
        return true;
    }

    function allowance(address _owner, address spender) public view returns (uint remaining) {
        return allowances[_owner][spender];

    }

    function transferFrom(address _from, address _to, uint value) public returns (bool success) {
        uint ercToken = value * (10 ** decimals);
        require(allowances[_from][msg.sender] >= ercToken, "allowance exceeded");
        require (balances[_from] >= ercToken, "Insufficient balance");
        require(_to != address(0));

        allowances[_from][msg.sender] -= ercToken;

        balances[_from] -= ercToken;
        balances[_to] += ercToken;

        emit Transfer(_from, _to, ercToken);
        return true;
    }
}
