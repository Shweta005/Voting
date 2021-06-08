pragma solidity 0.8.0;
//Contract for Voting
contract Voting{
    
    uint start;
    uint end;
    uint256 public totalvotes;
    
    struct Voter{
       // uint256 id;
        string  name;
        uint8   age;
        address add;
        bool    isVoter;
        bool    isActive;
        bool    isVoted;
         }
         
         
     struct Candidate{
        //uint256 id;
        string  name;
        bool    isCandidate;
        address cadd;
        uint256 votes;
         }
         
         address public Owner;
         constructor(){
             Owner = msg.sender;
         }
    
     uint256 public counter;
     uint256 public ccounter;
    
    // mapping(address=>Voter) public voters;
    
     mapping(address=>uint256) private voters;
     mapping(uint256=>Voter) private voterId;
     mapping(address=>uint256) public candidates;
     mapping(uint256=>Candidate) public canId;
     
     
    modifier isVoterRegistered(address _add){
        uint256 id=voters[_add];
        require(voterId[id].isVoter ==false, "You are alreaday registered");
        _;
     }
     
    modifier isCandidateRegistered(address _add){
        uint256 id=candidates[_add];
        require(canId[id].isCandidate != true, "You are alreaday registered");
        _;
     }
     
    modifier onlyOwner(){
         require(msg.sender == Owner,"You are not owner");
         _;
     }
     
    
       
    function RegisterVoter(string memory _name,uint8 _age,address _vadd) isVoterRegistered(_vadd) onlyOwner public{
        require(_vadd!=Owner,"Its Owners address");
        counter++;
        Voter memory vote = Voter(_name,_age,_vadd,true,false,false);
        voters[_vadd] = counter;
        voterId[counter] = vote;
        
        }
    
    function getVoter(address _add)public  view returns(string memory,uint8,address,bool,bool,bool){
        uint256 id = voters[_add];
        return (voterId[id].name,
                voterId[id].age,
                voterId[id].add,
                voterId[id].isVoter,
                voterId[id].isActive,
                voterId[id].isVoted);
    }
    
    function RegisterCandidate(string memory _name,address _cadd)isCandidateRegistered(_cadd) onlyOwner  public{
          require(_cadd!=Owner,"Its Owners address");
          ccounter++;
          Candidate memory can = Candidate(_name,true,_cadd,0);
          candidates[_cadd] = ccounter;
          canId[ccounter] = can;
          }
          
    function getCandidate(address _add)isCandidateRegistered(_add)  public  view returns(string memory,bool,address,uint256){
        uint256 id = candidates[_add];
        return (canId[id].name,
                canId[id].isCandidate,
                canId[id].cadd,
                canId[id].votes);
    }
    
    function setActive(address _add) onlyOwner public {
         uint256 id = voters[_add];
         require(voterId[id].age >= 18 , "You are not 18+");
         if(voterId[id].isActive == false)
         voterId[id].isActive = true;
         
    }
    
    function StartVoting() onlyOwner public {
        start = block.timestamp;
    }
    
   function VotingTime(uint _time) onlyOwner public  returns(uint){
       end = _time+ start;
       return (_time * 1 seconds);
       
   }
    
    function TimeLeft() public view returns(uint) {
        //require(block.timestamp == 0, "Voting is not started yet,wait!");
         require(block.timestamp <= end, "The voting time is over");
        return end - block.timestamp;
    }
    
    modifier isVoted(){
        address add = msg.sender;
        uint256 i = voters[add];
        require(voterId[i].isVoted == false,"You are voted already");
        _;
    }
    modifier onlyVoter(){
         address add = msg.sender;
         uint256 i = voters[add];
        require(voterId[i].isActive == true,"You are not active Voter");
        _;
    }
    
    
    function Vote(address _add) onlyVoter isVoted public {
        uint256 vid = voters[msg.sender];
        require(msg.sender ==  voterId[vid].add,"You cant vote");
        totalvotes++;
        uint256 id = candidates[_add];
        canId[id].votes += 1;
        voterId[vid].isVoted = true;
         }
    
    
    function Winner() onlyOwner public view  returns(uint winner_) {
      uint  winner = 0;
       for(uint256 i=1;i <= ccounter ; i++){
        if(canId[i].votes > winner){
            winner = canId[i].votes;
            winner_ = i;
        }
    }
        
    }
    
    function WinnerName() onlyOwner public view returns(string memory winner_){
        uint no = Winner();
        winner_ = canId[no].name;
    }
    
    
}




























 