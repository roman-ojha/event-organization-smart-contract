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
    Admin private admin;

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
    uint256 public noOfUsers;

    function register(string memory _username, string memory _password) public {
        User storage newUser = users[noOfUsers];
        noOfUsers++;
        newUser.username = _username;
        newUser.id = msg.sender;
        newUser.password = _password;
    }
}
