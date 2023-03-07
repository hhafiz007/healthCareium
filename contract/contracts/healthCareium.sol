//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MyContract is ERC20{
    uint public number;
    address owner;

    modifier onlyOwner() 
            { 
                require(msg.sender == owner);
            _   ;
            }

    constructor() public ERC20("Governmenterium", "GVT") {        
        _mint(msg.sender,10000000*10**18);
        owner = msg.sender;
    }    
   
     // ERC20 Methods
            
          

        
           function rewardDoctor(address receiver,uint amount) public onlyOwner
           {
                
                 _mint(receiver,amount);    
           }

            function rewardPatient(address receiver,uint amount) public onlyOwner 
           {
                
                 _mint(receiver,amount);
                 
           }

           function getInsurance(address sender,address agent,uint256 amount) public onlyOwner
           { 
              _transfer(sender,agent,amount);
           }

           function sellTokens(address receiver,uint256 amount) public onlyOwner 
           {
                
                 _mint(receiver,amount);
                 
           }


}


contract HealthCareium{

        
        MyContract public token;

         string public name ;
         address owner;
         mapping(address=>doctor) doctorData;
         mapping(address=>patient) patientData;
         mapping(address=>insuranceAgent) agentData;
         mapping(address=>info) person;
         mapping (address => mapping (address => bool))  canSeePatient;
         mapping(uint256 => address ) insurance;

        enum patientCondition{ EXCELLENT, GOOD, BAD }


          
        modifier onlyOwner() 
            { 
                require(msg.sender == owner);
            _   ;
            }
        modifier onlyPatients() 
            { 
                require(patientData[msg.sender].isPatient == true);
            _   ;
            }
        modifier onlyDoctors() 
            { 
                require(doctorData[msg.sender].isDoctor == true);
            _   ;
            }    
       



          
           constructor() payable {
                owner = msg.sender;
                name = "HealthCareium";
                token = new MyContract();
                
            }

// All the Information regarding the person

        struct doctor{
                    bool isDoctor;
                    string specialty;
                   }


        struct patient{
                    bool isPatient;
                    string[] healthRecords;
                    uint256[] healthScore;
                   }

        struct insuranceAgent{
                    bool isInsuranceAgent;
                    string company;
                   }           

        struct info{
                    address id;
                    string  name;
                   }       




          function createDoctor(address _id,string memory _name,string memory _specialty)  public onlyOwner
           {
               if(doctorData[_id].isDoctor == false)
                    {
                            token.rewardDoctor(_id,5000*10**18);
                    }
              person[_id] = info(_id,_name);
              doctorData[_id] = doctor(true,_specialty);
           }

            function createInsuranceAgent(address _id,string memory _name,string memory _company)  public onlyOwner
           {
               
              person[_id] = info(_id,_name);
              agentData[_id] = insuranceAgent(true,_company);
              insurance[0] = _id;
           }


           function getDoctorDetails(address _id)  public onlyOwner view returns(bool _isDoctor,string memory _name, string memory _specialty)
           {
               
              _isDoctor = doctorData[_id].isDoctor;
              _name = person[_id].name;
              _specialty = doctorData[_id].specialty;

           }
           
            function getAgentDetails()  public onlyOwner view returns(address adAgent)
           {
              adAgent = insurance[0];
           }


           function enterPatientPrescription(address _id,string memory _name,string memory _prescription,uint256 _healthScore)  public onlyDoctors
           {

               if(patientData[_id].isPatient == false)
                    {
                            token.rewardPatient(_id,5000*10**18);
                    }  
               person[_id] = info(_id,_name);
               patientData[_id].isPatient = true;
               patientData[_id].healthRecords.push(_prescription);
               patientData[_id].healthScore.push(_healthScore);
           }


           function getPatientDetails(address _id)  public  view  returns(bool _isPatient,string memory _name,string[] memory _prescriptions,patientCondition category)
           {
               require((patientData[msg.sender].isPatient == true && _id == msg.sender) || canSeePatient[_id][msg.sender] == true,"You dont have permission to view data");
               _isPatient = patientData[_id].isPatient;
               _name = person[_id].name;
               _prescriptions = patientData[_id].healthRecords;
                category = getPatientCondition(_id);
           }

           function enableAccess(address _id) public onlyPatients
           {
               canSeePatient[msg.sender][_id] = true;
           }

           function getPatientCondition(address _id) private view  returns(patientCondition category)
           {
                uint i;
                uint256 sum = 0;
                for(i = 0; i < patientData[_id].healthScore.length ; i++)
                    sum = sum + patientData[_id].healthScore[i];

                uint256 score = sum/patientData[_id].healthScore.length;

                if(score < 5)
                {
                 category = patientCondition.BAD ;
                }
                else if(score < 8)
                {
                   category = patientCondition.GOOD ; 
                }
                else
                {
                     category = patientCondition.EXCELLENT ;
                }

           }
           // ERC20 Token Methods

           
            function getBalance(address _id) public view  returns(uint256 balance)
           {
               balance = token.balanceOf(_id);
           }

            function getInsurance(uint256 amount) public onlyPatients
           { 
              token.getInsurance(msg.sender,insurance[0], amount*10**18);
           }

            function buyTokens(uint256 amount) public
           { 
              token.sellTokens(msg.sender, amount*10**18);
           }
           


           


}


