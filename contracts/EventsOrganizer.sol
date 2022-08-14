// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

struct Admin {
    string username;
    address payable id; // user address
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

struct Ticket {
    uint256 eventId;
    uint256 quantity;
}

struct User {
    string username;
    address id;
    string password;
    mapping(uint256 => Ticket) tickets;
    // eventId => Ticket
}

contract EventsOrganizer {
    // Admin :
    Admin admin;

    constructor(string memory _username, string memory _password) {
        admin.username = _username;
        admin.id = payable(msg.sender);
        admin.password = _password;
    }

    modifier isAdmin() {
        require(msg.sender == admin.id, "Permission Denied,You are not admin");
        _;
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
    // username => User
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
    uint256 noOfEvent = 1;

    // event id start from 1

    function createEvent(
        string memory _name,
        string memory _description,
        uint256 _ticketPrice,
        uint256 _date,
        uint256 _availableSeats
    ) public isAdmin {
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
        if (events[id].id == 0) {
            revert("Event doesn't exist");
        }
        return events[id];
    }

    function buyTicket(
        uint256 _eventId,
        uint256 _quantity,
        string memory _username
    ) public payable {
        // authenticate User
        address userId = users[_username].id;
        if (
            userId == 0x0000000000000000000000000000000000000000 ||
            userId != msg.sender
        ) {
            revert("UnAuthorized");
        }

        // given eventId should exist
        require(events[_eventId].id != 0, "Event doesn't exist");

        // if deadline had passed
        // require(block.timestamp < events[_eventId].date, "Deadline had passed");

        // doest minimum ticketPrice is been send
        require(
            msg.value / _quantity >= events[_eventId].ticketPrice,
            "Minimum Ticket price is not met"
        );

        // Check seats are available or not according to quantity
        require(
            events[_eventId].availableSeats >=
                events[_eventId].soldTicketNo + _quantity,
            "Given Quantity of ticket is not available"
        );

        // if user already buy the ticket for particular event and again try to buy on same event that we have to add quantity
        if (users[_username].tickets[_eventId].eventId != 0) {
            users[_username].tickets[_eventId].quantity += _quantity;
            events[_eventId].availableSeats -= _quantity;
            events[_eventId].soldTicketNo += _quantity;
            return;
        }
        // create new ticket
        Ticket storage newTicket = users[_username].tickets[_eventId];
        newTicket.eventId = _eventId;
        newTicket.quantity = _quantity;
        events[_eventId].availableSeats -= _quantity;
        events[_eventId].soldTicketNo += _quantity;

        // transfer send price into contract
        // admin.id.transfer(msg.value);
    }

    function ticketInfo(uint256 _eventId, string memory _username)
        public
        view
        returns (Ticket memory)
    {
        // authenticate User
        address userId = users[_username].id;
        if (
            userId == 0x0000000000000000000000000000000000000000 ||
            userId != msg.sender
        ) {
            revert("UnAuthorized");
        }

        if (events[_eventId].id == 0) {
            revert("Event doesn't exist");
        }

        if (users[_username].tickets[_eventId].eventId == 0) {
            revert("You have to buy ticket for this particular event");
        }

        return users[_username].tickets[_eventId];
    }

    function getBalance() public view isAdmin returns (uint256) {
        return admin.id.balance;
    }

    function getContractBalance() public view isAdmin returns (uint256) {
        return address(this).balance;
    }

    function transferBAlanceToAdmin() public isAdmin {
        if (getContractBalance() == 0) {
            revert("Empty contract balance");
        }
        admin.id.transfer(address(this).balance);
    }
}
