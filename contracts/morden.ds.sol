import "dapple/script.sol";
contract Deploy is Script {
  function Deploy() {
    var ethertube = new EtherTube();
    exportObject("ethertube", ethertube);
  }
}
