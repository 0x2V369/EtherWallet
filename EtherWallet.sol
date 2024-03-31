//SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

// @title Ether Wallet

contract EtherWallet{
    mapping(address => uint256) addressBalance;

    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, address indexed by, uint256 amount);

    
    function checkBalance() public view returns(uint256){
        return addressBalance[msg.sender];
    }

    function transferTo(address payable _recipient, uint256 _amount) public payable{
        require(addressBalance[msg.sender] >= _amount, "Insufficient funds");
        addressBalance[msg.sender] -= _amount;
        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "Transfer failed");
        emit Withdrawn(_recipient, msg.sender, _amount);
    }

    function withdrawAll()public payable{
        uint _amount = addressBalance[msg.sender];
        require(_amount > 0, "No Ether left in the smart contract");
        addressBalance[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer of funds failed");
        emit Withdrawn(msg.sender, msg.sender, _amount);
    }

    function deposit() public payable {
        addressBalance[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    receive() external payable{
        deposit();
    }
    
}
