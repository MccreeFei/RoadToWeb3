// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract BuyMeACoffee {

    event NewMemo (
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

   struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    
    address owner;
    address payable withdrawAddress;

    Memo[] memos;

    constructor() {
        owner = msg.sender;
        withdrawAddress = payable(msg.sender);
    }


    function buyCoffee(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "can not buy cofee for 0 eth");
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));
        emit NewMemo(msg.sender, block.timestamp, _name, _message);

    
    }

    function withdrawTips() public {
        require(withdrawAddress.send(address(this).balance));
    }

     function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    function changeWithdrawAddress(address addr) public {
        require(msg.sender == owner, "only contract owner can change withdraw address!");
        withdrawAddress = payable(addr);
    }

    function getWithdrawAddress() public view returns (address addr) {
        return withdrawAddress;
    }
    
}
