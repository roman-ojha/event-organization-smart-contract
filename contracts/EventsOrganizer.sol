// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

struct Admin {
    string username;
    address id;
    string password;
}

struct User {
    string username;
    address id;
    string password;
}

contract EventsOrganizer {
    // Admin :
    Admin admin;

    constructor(string memory _username, string memory _password) {
        admin.username = _username;
        admin.id = msg.sender;
        admin.password = _password;
    }

    function getAdmin()
        public
        view
        returns (string memory username, address id)
    {
        return (admin.username, admin.id);
    }

    // User:

    mapping(uint256 => User) users;
    uint256 noOfUsers;

    function register(string memory _username, string memory _password)
        public
        returns (bool)
    {
        if (
            keccak256(abi.encodePacked(admin.username)) ==
            keccak256(abi.encodePacked(_username))
        ) {
            return false;
        }
        User storage newUser = users[noOfUsers];
        noOfUsers++;
        newUser.username = _username;
        newUser.id = msg.sender;
        newUser.password = _password;
        return true;
    }

    function getUser(uint256 _userNo)
        public
        view
        returns (string memory username, address id)
    {
        return (users[_userNo].username, users[_userNo].id);
    }
}