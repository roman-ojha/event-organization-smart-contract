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

struct Event {
    uint256 id;
    string name;
    string description;
    uint256 ticketPrice;
    uint256 date;
    uint256 availableSeats;
    uint256 soldTicketNo;
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

    // Creating Event
    mapping(uint256 => Event) events;
    uint256 noOfEvent;

    function createEvent(
        string memory _name,
        string memory _description,
        uint256 _ticketPrice,
        uint256 _date,
        uint256 _availableSeats
    ) public {
        require(msg.sender == admin.id, "only admin can create the event");
        Event storage newEvent = events[noOfEvent];
        newEvent.id = noOfEvent;
        newEvent.name = _name;
        newEvent.description = _description;
        newEvent.ticketPrice = _ticketPrice;
        newEvent.date = _date;
        newEvent.availableSeats = _availableSeats;
        noOfEvent++;
    }

    function getEvent(uint256 id) public view returns (Event memory) {
        return events[id];
    }
}
