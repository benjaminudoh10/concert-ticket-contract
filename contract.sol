// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
/// @title Voting with delegation.
contract Concert {
    // Parameters of the concert. Times are either
    // absolute unix timestamps (seconds since 1970-01-01)
    // or time periods in seconds.
    address payable public artist;
    uint concertCapacity;

    enum TicketType { Regular, VIP, VVIP }

    struct Ticket {
        TicketType type;
        uint price;
    }

    mapping(address => Ticket) purchases;
    address[] addresses;

    error CapacityReached(string message);

    event TicketPurchased(type: TicketType);

    modifier capacityFull() {
        if (addresses.length >= concertCapacity)
            revert CapacityReached(
                "Capacity reached. All tickets have been purchased."
            );
        _;
    }

    /// Create a concert with `startTime` and 
    /// `artistAddress` which will receive the concert fund
    /// if the concert starts as scheduled
    constructor(
        uint startTime,
        address payable artistAddress,
        uint capacity,
    ) {
        artist = artistAddress;
        concertCapacity = capacity;
    }

    /// Purchase a ticket and store the value in the `purchases` map.
    function buyTicket(TicketType type) payable capacityFull {
        if (type == TicketType.Regular) {
            require(
                msg.value >= 1000,
                "You need to have above 1000 to purchase the Regular ticket."
            );
            purchases[msg.sender] = Ticket({
                type: TicketType.Regular,
                price: msg.value
            })
        } else if (type == TicketType.VIP) {
            require(
                msg.value >= 10000,
                "You need to have above 10000 to purchase the Regular ticket."
            );
            purchases[msg.sender] = Ticket({
                type: TicketType.VIP,
                price: msg.value
            })
        } else if (type == TicketType.VVIP) {
            require(
                msg.value >= 100000,
                "You need to have above 100000 to purchase the Regular ticket."
            );
            purchases[msg.sender] = Ticket({
                type: TicketType.VVIP,
                price: msg.value
            })
        }

        addresses.push(msg.sender);
        emit TicketPurchased(type);
    }

    // functionality for signifying if the concert starts at the appropriate time (census)

    // functionality for payout to artist

    // functionality for payment reversal if concert does not start in time
}
