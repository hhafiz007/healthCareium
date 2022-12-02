//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


contract HealthCareium{
         string public name ;
         address owner;
         mapping(address=>doctor) doctorData;
         mapping(address=>patient) patientData;
         mapping(address=>info) person;
         mapping (address => mapping (address => bool))  canSeePatient;

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
       



          
           constructor() {
                owner = msg.sender;
                name = "HealthCareium";
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

        struct info{
                    address id;
                    string  name;
                   }       




          function createDoctor(address _id,string memory _name,string memory _specialty)  public onlyOwner
           {
              person[_id] = info(_id,_name);
              doctorData[_id] = doctor(true,_specialty);
           }


           function getDoctorDetails(address _id)  public onlyOwner view returns(bool _isDoctor,string memory _name, string memory _specialty)
           {
              _isDoctor = doctorData[_id].isDoctor;
              _name = person[_id].name;
              _specialty = doctorData[_id].specialty;

           }


           function enterPatientPrescription(address _id,string memory _name,string memory _prescription,uint256 _healthScore)  public onlyDoctors
           {
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
 












}


