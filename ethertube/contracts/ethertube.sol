import "dapple/test.sol";

contract EtherTube {
  event LogVideo (bytes11 video, address chosenBy);
  
  bytes11 video;
  address chosenBy;

  function getVideo() constant returns (bytes11) {
    return video;
  }

  function setVideo(bytes11 newVideo) {
    video = newVideo;
    chosenBy = msg.sender;
    LogVideo(video, chosenBy);
  }
}

contract EtherTubeTest is Test {
  function testSetVideo() {
    var tube = new EtherTube();
    tube.setVideo("UFDAtStVXbc");
    assertEq11(tube.getVideo(), "UFDAtStVXbc");
  }
}
