// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

struct Admin {
    string username;
    address id; // user address
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

    mapping(string => User) users;
    uint256 noOfUsers;

    // register User
    function register(string memory _username, string memory _password)
        public
        returns (string memory status)
    {
        string memory userUsername = users[_username].username;
        if (
            keccak256(abi.encodePacked(_username)) ==
            (keccak256(abi.encodePacked(admin.username)))
        ) {
            // comparing with admin username
            revert("username already exist, please try another one");
        }
        if (
            keccak256(abi.encodePacked(_username)) ==
            (keccak256(abi.encodePacked(userUsername)))
        ) {
            // comparing with users username
            revert("username already exist, please try another one");
        }
        User storage newUser = users[_username];
        noOfUsers++;
        newUser.username = _username;
        newUser.id = msg.sender;
        newUser.password = _password;
        return "register successfully";
    }

    function searchUser(string memory _username)
        public
        view
        returns (string memory username, address id)
    {
        if (
            keccak256(abi.encodePacked(_username)) ==
            (keccak256(abi.encodePacked(admin.username)))
        ) {
            revert("searched user is admin");
        }
        address userId = users[_username].id;
        if (userId == 0x0000000000000000000000000000000000000000) {
            revert("searched user doesn't exist");
        }
        return (users[_username].username, users[_username].id);
    }
}
