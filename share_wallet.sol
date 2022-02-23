// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

contract Owner {
    address owner;
     constructor()  {
      owner = msg.sender;
    }
    modifier onlyOwner {
      require(msg.sender == owner, "You are not allowed to do this.");
      _;
   }
}

contract Receiver {
    event ValueReceived(address user, uint amount);
    
    receive() external payable {
        emit ValueReceived(msg.sender, msg.value);
    }
}

contract ShareWallet is Owner, Receiver {

    //User Stuff
    address [] registeredUsers;
    mapping(address => bool) public isUserRegistered;
    mapping(address => uint) public permittedAllowance;

    //Events
    event AllowanceChanged(address _user, uint _amount);
    event MoneyWithdrawn(address _user, uint _amount);


    function changeAllowance(address _userAddress, uint _amount)public onlyOwner{
        permittedAllowance[_userAddress] = _amount;
        emit AllowanceChanged(_userAddress,_amount);
    }

    function registerUser(address _newUser) public {
       require(!isUserRegistered[_newUser],"User is already Registered");
       registeredUsers.push(_newUser);
       isUserRegistered[_newUser] = true;
    }

    function getRegisteredUsersCount() public view returns(uint count) {
        return registeredUsers.length;
    }

    function getWalletBalance() public view returns (uint){
        return address(this).balance;    
    }

    function withDrawMoney(uint _amount) public {
        require((permittedAllowance[msg.sender] >= _amount &&  msg.sender != owner) || msg.sender == owner, "You are trying to withdraw more money than you are allowed");
        require(address(this).balance >= _amount, "The wallet doesn't have enough Funds");
        payable(msg.sender).transfer(_amount);

        emit MoneyWithdrawn(msg.sender ,_amount);
    }

}