const healthCareium = artifacts.require("healthCareium");

// contract is like describe in mocha , accounts will give access to all accounts 
// before
contract("healthCareium", (accounts) =>{
    before(async () =>{
        instance = await healthCareium.deployed()
    })

    it('Validates an owner/admin  can create a doctor',async() =>{
        result = await instance.createDoctor(accounts[1],"Dr. James",{from : accounts[0]})
        //console.log(result.receipt.status)
        assert.equal(result.receipt.status,true,"Checking whwether the admin can create doctor")

        
    })
    it('Validates the doctor name is mapped correctly as created',async() =>{
        await instance.createDoctor(accounts[1],"Dr. James",{from : accounts[0]})
        //console.log(result.receipt.status)
        
        let doctor = await instance.getDoctorDetails(accounts[1],{from : accounts[0]})
        assert.equal(doctor._isDoctor,true,"The doctor flag has been set to true")
        assert.equal(doctor._name,"Dr. James","The doctor Name is also correctly mapped")
        
    })
    it('Check if the doctor can create a patient',async() =>{
        result = await instance.enterPatientPrescription(accounts[2],"Brian","Symptoms of mild fever","7",{from : accounts[1]})
        assert.equal(result.receipt.status,true,"Checking whether the doctor can create doctor")

        //console.log(result.receipt.status)
    })
    it('Check whether the patient can get his details ',async() =>{
        //console.log(result.receipt.status)
        
        let patient = await instance.getPatientDetails(accounts[2],{from : accounts[2]})
       // console.log(patient)
        assert.equal(patient._isPatient,true,"The Patient flag has been set to true")
        assert.equal(patient._name,"Brian","The Patient Name is also correctly mapped")
        
    })

    it('Check whether the patient can manage his access',async() =>{
        //console.log(result.receipt.status)
        
        await instance.enableAccess(accounts[1],{from : accounts[2]})

        let patient = await instance.getPatientDetails(accounts[2],{from : accounts[1]})
        
       // console.log("The doctor is able to see details of patient",patient)

        assert.equal(patient._isPatient,true,"The Patient flag has been set to true")
        assert.equal(patient._name,"Brian","The Patient Name is also correctly mapped")
        
    })

})