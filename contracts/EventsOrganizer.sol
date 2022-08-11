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

    // mapping(uint256 => User) users;

    // function register(string memory username, string memory password)
    //     public
    //     view
    // {}
}
