import "dapple/test.sol";

contract EtherTube {
  event LogVideo (bytes11 video, address account, uint bid, uint time);
  
  struct Suggestion {
    bytes11 video;
    address account;
    uint bid;
    uint time;
  }

  Suggestion public current;
  address public owner;

  function EtherTube() {
    owner = msg.sender;
  }

  function transfer() {
    if (owner != msg.sender) {
      throw;
    }
    msg.sender.send(this.balance);
  }

  function getCurrentVideo() returns (bytes11) {
    return current.video;
  }

  function getTimeRemaining() returns (uint) {
    var time = this.getCurrentTime();
    var nextTime = ((time + 1 days) / 1 days) * 1 days;
    return nextTime - time;
  }

  function getCurrentTime() returns (uint) {
    return now;
  }

  function bid(bytes11 video) {
    uint time = this.getCurrentTime();
    if ((current.account == 0) ||
        ((current.time / 1 days) < (time / 1 days)) ||
        (current.bid < msg.value)) {
      current = Suggestion({
        video: video,
        account: msg.sender,
        bid: msg.value,
        time: time
      });
    } else {
      throw;
    }
  }
}

contract TestableEtherTube is EtherTube {
  uint currentTime;

  function getCurrentTime() returns (uint) {
    return currentTime;
  }

  function setCurrentTime(uint time) {
    currentTime = time;
  }
}

contract EtherTubeTest is Test {
  function testInitialZero() {
    var tube = new EtherTube();
    assertEq11(tube.getCurrentVideo(), 0);
  }
  
  function testFirstBid() {
    var tube = new EtherTube();
    tube.bid("1234567890a");
    assertEq11(tube.getCurrentVideo(), "1234567890a");
  }
  
  function testErrorSecondBadBid() {
    var tube = new EtherTube();
    tube.bid("1234567890a");
    tube.bid("1234567890b");
  }

  function testSecondGoodBid() {
    var tube = new EtherTube();
    tube.bid("1234567890a");
    tube.bid.value(1)("1234567890b");
    assertEq11(tube.getCurrentVideo(), "1234567890b");
  }

  function testErrorBidNextHour() {
    var tube = new TestableEtherTube();
    tube.setCurrentTime(1 days);
    tube.bid("1234567890a");
    tube.setCurrentTime(1 days + 1 hours);
    tube.bid("1234567890b");
  }

  function testSuccessfulBidNextDay() {
    var tube = new TestableEtherTube();
    tube.setCurrentTime(1 days);
    tube.bid("1234567890a");
    tube.setCurrentTime(2 days);
    tube.bid("1234567890b");
  }

  function testTimeRemaining() {
    var tube = new TestableEtherTube();
    assertEq(tube.getTimeRemaining(), 1 days);
    tube.setCurrentTime(12 hours);
    assertEq(tube.getTimeRemaining(), 12 hours);
    tube.setCurrentTime(1 days);
    assertEq(tube.getTimeRemaining(), 1 days);
    tube.setCurrentTime(1 days + 1 hours);
    assertEq(tube.getTimeRemaining(), 23 hours);
  }
}
