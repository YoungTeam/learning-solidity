
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Event{

    event Log(Vote vote);

    struct Vote{
        string title;
        uint count;
    }

    Vote[] votes;

    function add(string calldata _title) external{
        Vote memory tVote = Vote({title:_title,count:0});
        votes.push(tVote);
        emit Log(tVote);
    }


    function doVote(uint idx) external{
        Vote storage tVote = votes[idx];
        tVote.count++;
         emit Log(tVote);
    }


    function getMax() external returns (Vote memory vote){
        Vote memory maxVote;

        for(uint i = 0;i <votes.length;i++){
            if(votes[i].count > maxVote.count){
                maxVote = votes[i];
            }
        }
        emit Log(maxVote);
        return maxVote;
    }
}