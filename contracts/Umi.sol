//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Umi is ERC721URIStorage, Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address public umi;

    constructor(address _umi) ERC721("Umi", "UMI") Ownable(){
        umi = _umi;
    }

    string[4] public adviceList = [
        unicode"Your mother is right.",
        unicode"Enthusiasm is worth 25 IQ points.",
        unicode"Strict with yourself, forgiving of others.",
        unicode"Be the elf"
    ];
    
    //returns a random piece of advice as a string
    function generateAdvice() public view returns (string memory){
        uint randIndex = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, umi))) % adviceList.length;
        string memory output = adviceList[randIndex];
        return output;
    }

    //returns random coordinate between 0 and 350
    function randomCoord(uint _seed) public view returns (string memory){
        return uint2str(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, umi, _seed))) % 350);
    }

    //returns random num between 10 and 125
    function randomRadius() public view returns (string memory){
        return uint2str(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, umi))) % 115 + 10);
    }

    function randomNumCircle() public view returns (uint){
        return (uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, umi))) % 3) + 1;
    }

    // From: https://stackoverflow.com/a/65707309/11969592
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function svgMaker() private view returns (string memory finalSvg){
        finalSvg = string(abi.encodePacked('<svg width="350" height="350" fill= "none" xmlns="http://www.w3.org/2000/svg">'));
        finalSvg = string(abi.encodePacked(finalSvg, '<style>.base { fill: black; font-family: sans-serif; font-size: 14px; }</style>'));

        for(uint i = 0; i < 2; i++) {
            // we get a new random number for each path
            string memory circleSvg = generateCircle();
            finalSvg = string(abi.encodePacked(finalSvg, circleSvg));
        }
        string memory advice = generateAdvice();
        string memory text = string(abi.encodePacked('<text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" class="base">', advice ,'</text>'));
        finalSvg = string(abi.encodePacked(finalSvg, text, '</svg>'));
    }

    function generateCircle() private view returns (string memory) {
        string memory cx = randomCoord(1);
        string memory cy = randomCoord(2);
        string memory r = randomRadius();
        string memory circleSvg = string(abi.encodePacked('<g><circle cx=\"', cx,'\" cy=\"', cy ,'\" r=\"', r,'\" fill="#FFCA42"/></g>'));
        return circleSvg;
    }


    function svgToImageURI(string memory _svg) private pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(_svg))));
        string memory imageURI = string(abi.encodePacked(baseURL, svgBase64Encoded));
        return imageURI;
    }

    function formatTokenURI(string memory imageURI) private pure returns (string memory) {
        return string(
                abi.encodePacked( "data:application/json;base64,", Base64.encode(bytes(abi.encodePacked(
                                '{"name":"',
                                "Happy Birthday, Umi", // You can add whatever name here
                                '", "description":"Advice on your birthday.", "attributes":"", "image":"', imageURI,'"}')))));
    }

    function createNFT() public onlyOwner returns (uint256){
        _tokenIds.increment();
        uint256 adviceToken = _tokenIds.current();

        console.log(adviceToken);

        string memory newSvg = svgMaker();
        string memory imageURI = svgToImageURI(newSvg);
        _safeMint(umi, adviceToken);
        _setTokenURI(adviceToken, formatTokenURI(imageURI));
        
        return adviceToken;
    }
 
}
