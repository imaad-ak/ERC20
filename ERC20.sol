// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint public _totalSupply;
    mapping(address => uint) public _balanceOf;
    mapping(address => mapping(address => uint)) public allowances;
    string public name;
    string public symbol;
    uint8 public decimals;
    address immutable public i_owner;

    constructor(string memory _name, string memory _symbol, uint8  _decimals) {
        i_owner = msg.sender;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    error not_Owner();

    error not_Enough_Tokens();

    modifier onlyOwner() {
        if(msg.sender != i_owner) {
            revert not_Owner();
        }
        _;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        if(_balanceOf[msg.sender] < amount) {
             revert not_Enough_Tokens();
        }

        _balanceOf[msg.sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(amount <= _balanceOf[from]);
        require(amount <= allowances[from][msg.sender]);
        require(to != address(0));

        allowances[from][msg.sender] -= amount;
        _balanceOf[from] -= amount;
        _balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balanceOf[account];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return allowances[owner][spender];
    }

    function mint(address to, uint amount) external onlyOwner {
        _balanceOf[to] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(address from, uint amount) external onlyOwner {
        _balanceOf[from] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

