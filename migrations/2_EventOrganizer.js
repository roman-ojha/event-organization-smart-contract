const EventsOrganizer = artifacts.require("EventsOrganizer");

module.exports = function (deployer) {
  deployer.deploy(EventsOrganizer);
};
