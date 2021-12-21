//SPDX-License-Identifier: GNU General Public License v3.0 or later
pragma solidity ^0.8.0;

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

    string[37] public adviceList = [
        unicode"Your mother is right.",
        unicode"Enthusiasm is worth 25 IQ points.",
        unicode"Be strict with yourself and forgiving of others.",
        unicode"Work to become, not to aquire.",
        unicode"Calm is contagious.",
        unicode"Dance with your hips.",
        unicode"The greatest teacher is called “doing”.",
        unicode"No rain, no rainbow.",
        unicode"Always give credit, take blame.",
        unicode"Don't take advice.",
        unicode"If you can’t tell what you desperately need, it’s probably sleep.",
        unicode"To quiet a crowd or a drunk, just whisper.",
        unicode"Always cut away from yourself.",
        unicode"A multitude of bad ideas is necessary for one good idea.",
        unicode"Don’t be the best. Be the only.",
        unicode"Art is in what you leave out.",
        unicode"How to apologize: Quickly, specifically, sincerely.",
        unicode"A vacation + a disaster = an adventure.",
        unicode"Eliminating clutter makes room for your true treasures.",
        unicode"If you are not falling down occasionally, you are just coasting.", 
        unicode"Compliment people behind their back. It’ll come back to you.",
        unicode"Being wise means having more questions than answers.",
        unicode"Don’t trust all-purpose glue.",
        unicode"Show up, then keep showing up.",
        unicode"While you invent, don’t select. While you sketch, don’t inspect.",
        unicode"The more you give to others, the more you’ll get.",
        unicode"Learn how to take a 20-minute power nap without embarrassment.",
        unicode"Sustained outrage makes you stupid.",
        unicode"Compliment people behind their back. It’ll come back to you.",
        unicode"When hitchhiking, look like the person you want to pick you up.",
        unicode"Even in the tropics it gets colder at night than you think.",
        unicode"Ignore what others may be thinking of you, because they aren’t.",
        unicode"Always say less than necessary.",
        unicode"Don’t treat people as bad as they are. Treat them as good as you are.", //max characters
        unicode"You can eat any dessert you want if you take only 3 bites.",
        unicode"Bad things can happen fast, but almost all good things happen slowly.",
        unicode"Promptness is a sign of respect."
    ];

    string [20] public bdayCount = [
        "1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th",
        "11th", "12th", "13th", "14th", "15th", "16th", "17th", "18th", "19th", "20th"
    ];
    
    //returns a random piece of advice as a string
    function generateAdvice() public view returns (string memory){
        uint randIndex = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, umi))) % adviceList.length;
        string memory output = adviceList[randIndex];
        return output;
    }

    //returns psuedo-random coordinate between 0 and 350
    function randomCoord(uint _seed) public view returns (string memory coords){
        string memory cx = uint2str(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, umi, _seed))) % 350);
        string memory cy = uint2str(uint256(keccak256(abi.encodePacked(block.number, block.gaslimit, umi, _seed))) % 350);
        coords = string(abi.encodePacked('cx=\"', cx,'\" cy=\"', cy , '\"'));
    }

    // returns psuedo-random num between 10 and 125
    function randomRadius(uint _seed) public view returns (string memory){
        return uint2str(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, umi, _seed))) % 115 + 10);
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
        finalSvg = string(abi.encodePacked('<svg width="350" height="350" xmlns="http://www.w3.org/2000/svg">'));
        finalSvg = string(abi.encodePacked(finalSvg, '<style>.base { fill: black; font-family: sans-serif; font-size: 11px; }</style><rect width="100%" height="100%" fill="white"/>'));

        for(uint i = 0; i < 3; i++) {
            // we get a new circle each loop
            string memory circleSVG = generateCircle(i);
            finalSvg = string(abi.encodePacked(finalSvg, circleSVG));
        }
        string memory advice = generateAdvice();
        string memory text = string(abi.encodePacked('<text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" class="base">', advice ,'</text>'));
        finalSvg = string(abi.encodePacked(finalSvg, text, '</svg>'));
    }

    function generateCircle(uint i) private view returns (string memory circleSvg) {
        string memory coords = randomCoord(i);
        string memory r = randomRadius(i);
        circleSvg = string(abi.encodePacked('<g><circle ', coords ,' r=\"', r,'\" fill="#FFCA42"/></g>'));
    }


    function svgToImageURI(string memory _svg) private pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(_svg))));
        string memory imageURI = string(abi.encodePacked(baseURL, svgBase64Encoded));
        return imageURI;
    }

    function formatTokenURI(string memory imageURI, uint bdayDay) private view returns (string memory) {
        string memory day;
        if (bdayDay <= 19){ 
            day = bdayCount[bdayDay];
        } else if (bdayDay >= 20 && bdayDay <= 99) {
            uint bdayDayB = bdayDay / 10;
            uint bdayDayC = bdayDay % 10;
            day = string(abi.encodePacked(uint2str(bdayDayB), bdayCount[bdayDayC]));
        } else if (bdayDay >= 100){
            day = "99+";
        }
        return string(
                abi.encodePacked( "data:application/json;base64,", Base64.encode(bytes(abi.encodePacked(
                                '{"name":"',
                                "Happy ", day ," Birthday, Umi", 
                                '", "description":"Unsolicited advice on your birthday.", "attributes":"', day,'","image":"', imageURI,'"}')))));
    }

    function createNFT() public onlyOwner returns (uint256){
        _tokenIds.increment();
        uint256 adviceToken = _tokenIds.current();

        string memory newSvg = svgMaker();
        string memory imageURI = svgToImageURI(newSvg);
        _safeMint(umi, adviceToken);
        _setTokenURI(adviceToken, formatTokenURI(imageURI, (adviceToken - 1)));
        
        return adviceToken;
    }
 
}
