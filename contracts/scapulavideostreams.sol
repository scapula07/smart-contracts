//SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
pragma abicoder v2;

contract ScapulaVids{


    uint public videoCount=0;
    string public name="Scapula videos";

    struct Video{
        string id;
        string title;
        string videoCid;
        string thumbnailCid;
        string tag;
        string description;
        address author;
        uint length;
    }


    mapping(uint => Video) public videos;
    
    event VideoUploaded(
    string id,
    string vidCid,
    string thumbnailCid,
    string title,
    string tag,
    address author,
    uint length

  );
    
    function uploadVideo(string memory vidId, string memory _vidCid,string memory _thumbnailCid,string memory _description, string memory _title, uint length, string memory _tag) public {
    // Make sure the video hash exists
    require(bytes(_vidCid).length > 0);
    // Make sure video title exists
    require(bytes(_title).length > 0);
    // Make sure uploader address exists
    require(msg.sender!=address(0));

    // Increment video id
    videoCount ++;

    // Add video to the contract
    videos[videoCount] = Video(vidId, _vidCid,_thumbnailCid, _title,_tag,_description, msg.sender, length);
    // Trigger an event
    emit VideoUploaded(vidId, _vidCid,_thumbnailCid, _title,_tag, msg.sender,length);
  }
    
    function getVideos() public view returns(Video[] memory) {
        Video[] memory videolist= new Video[](videoCount);

        for (uint i = 0; i < videoCount; i++) {
              videolist[i] = videos[i];
         }

         return videolist;
    }


    
}