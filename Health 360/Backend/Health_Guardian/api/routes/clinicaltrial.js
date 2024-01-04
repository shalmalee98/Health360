const express = require('express')
const router = express.Router()
const { response } = require('express');
const ClinicalTrial = require('../models/clinicaltrial')
const Questionairres = require('../models/questionnaires');
const UserGroups = require('../models/usergroup');
const axios = require('axios')
const Users = require('../models/user');
const { ObjectId, mongoose } = require('mongoose');
const user = require('../models/user');

router.post('/add',async (req,res) => {
    let promiseArr = [];
    try {
        const {name,description, createdBy, volunteerDetails, usersList} = req.body;
        const post = new ClinicalTrial({
            _id: new mongoose.Types.ObjectId(),
            createdBy,
            name,
            description,
            volunteerDetails,
            userList: usersList
        })
        const response = await post.save()
        const trialId = response._id;
        // promiseArr.push(response);
        console.log(response)
        const userGroup1 = await UserGroups.find({groupName: `${name} Subscribed`});
        console.log('userGroup 1 length: ', userGroup1.length);
        if (userGroup1.length == 0) {
            console.log("Response inside user group 1 promise: ", response);
            const data = new UserGroups({
                _id: new mongoose.Types.ObjectId(),
                clinicalTrial: response._id,
                groupName: `${name} Subscribed`,
                usersList: [],
                createdBy: createdBy
            }).save();
            promiseArr.push(data);
            // res.status(201).json({
            //     message: "User group created for subscribed users", data,
            // });
        } else {
            throw new Error(`An error since the group ${name} Subscribed already exists`);
        }

        const userGroup2 = await UserGroups.find({groupName: `${name} Non-Subscribed`});
        if (userGroup2.length == 0) {
            const data = new UserGroups({
                _id: new mongoose.Types.ObjectId(),
                clinicalTrial: response._id,
                groupName: `${name} Non-Subscribed`,
                usersList: [],
                createdBy: createdBy
            }).save();
            promiseArr.push(data);
            // res.status(201).json({
            //     message: "User group created for clinical trial of non subscribed users", data,
            // });
        } else {
            throw new Error(`An error since the group ${name} Non-Subscribed already exists`);
        }

        const userGroup3 = await UserGroups.find({groupName: `${name} Not Responded`});
        if (userGroup3.length == 0) {
            const data = new UserGroups({
                _id: new mongoose.Types.ObjectId(),
                clinicalTrial: response._id,
                groupName: `${name} Not Responded`,
                usersList: usersList,
                createdBy: createdBy
            }).save();
            promiseArr.push(data);
            // res.status(201).json({
            //     message: "User group created for clinical trial of non subscribed users", data,
            // });
        } else {
            throw new Error(`An error since the group ${name} Not Responded already exists`);
        }


        // const config = { headers: { 'Content-Type': 'application/json'} }
        // const notificationResponse = await axios.post('https:///spheric-entity-379022.uc.r.appspot.com/send-notification', {id:response._id,name: name, description: description}, config)
        // console.log(notificationResponse)

        // response.populate('clinicalTrial')
        // res.status(200).json(response.populate('questionnaires'))
        Promise.all(promiseArr).then(async function(response) {
            console.log("response: ", response);
            response.map(r => {
                console.log('Response : ', r)
                if(r.status && r.status == 500){
                    error = true;
                }
            });
            const userGroupNotification = await UserGroups.find({groupName: `${name} Not Responded`});
            console.log(userGroupNotification[0]?._id)
            if (userGroupNotification[0]?._id){
                const notificationResponse = await axios.post(`http://128.205.39.59:30500/send-notification`,{
                    usergroupId: userGroupNotification[0]._id,
                    name: name,
                    description: description+'#'+trialId
                });
            }
            })
        
        //console.log(notificationResponse.data)
        res.status(200).send('Clinical trial and its user groups created successfully!');
    } catch(err){
        console.log(err)
        res.status(500).json(err.message)
    }
})


router.post('/addMember', async (req,res) => {
    try {
        const clinicaltrialId = req.body.clinicaltrialId;
        const users = req.body.users;
        const clinicalTrial = await ClinicalTrial.findById(clinicaltrialId);
        const subgroup = await UserGroups.findOne({groupName: `${clinicalTrial.name} Not Responded`})
        users.map((user) => {
            if (! clinicalTrial.userList.includes(user._id)){
                subgroup.usersList.push(user._id)
            }
        })
        let newUserList = clinicalTrial?.userList;
        if (clinicalTrial){
            users.map((user) => {
                newUserList.push(user._id);
            })
        }
        clinicalTrial.userList = newUserList;
        const response = await clinicalTrial.save();
        const groupResponse = await subgroup.save();
        const notificationResponses = [];
        for (var i=0;i<users.length;i++){
            let usr = users[i];
            try {
                let notificationResponse = await axios.post(`http://128.205.39.59:30500/send-notification`,{
                    userId: usr._id,
                    name: "You have been added to new Clinical trial",
                    description: `You are added to clinical trial ${clinicalTrial.name}`
                });
                notificationResponses.push(notificationResponses);
                console.log(notificationResponse);
            }
            catch (e) {
                console.log(e);
            }
        }
        return res.status(200).json({response})
    }catch(e){
        return res.status(500).json({message: e});
    }
})

router.get('/getAll/:user',async (req,res) => {
    try {
        console.log(req.body);
        const {user} = req.params;
        console.log("User is ",user);
        const clinicaltrials = await ClinicalTrial.find({createdBy: user});
        res.status(200).json(clinicaltrials)
        
    } catch(err){
        console.log(err)
        res.status(500).send('Error in fetching all clinical trials')
    }
});

router.get('/getAllapp/:user',async (req,res) => {
    try {
        console.log(req.body);
        const userId = req.params.user;
        const clinicaltrials = await ClinicalTrial.find({userList: userId});
        res.status(200).json(clinicaltrials)
        
    } catch(err){
        console.log(err)
        res.status(500).send('Error in fetching all clinical trials')
    }
});

router.get('/getUsers', async(req, res) => {
  
    try {
        
        const clinicalTrialId = req.query.clinicalTrialId;
        console.log('found clinical trial id: ', clinicalTrialId)
    
        // Find the user group by ID
        const clinicalTrial = await ClinicalTrial.findById(clinicalTrialId);
    
        if (!clinicalTrial) {
          return res.status(404).json({ message: 'Clinical trial not found' });
        }
    
        // Extract the user IDs from the userGroup's usersList array
        const userIds = clinicalTrial.subscribers;
        console.log('Found user ids: ', clinicalTrial.subscribers);
    
        // Use the extracted user IDs to find all users
        const users = await Users.find({ _id: { $in: userIds } });
    
        // Return the list of users
        res.json(users);
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
      }
  }
);

//Delete by ID Method
router.delete('/delete', async (req, res) => {
    try {
        const id = req.query.id;
        console.log('print id to be deleted: ', id)
        const data = await ClinicalTrial.findByIdAndDelete(id)
        res.status(201).json({message: `Document has been deleted..`})
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})


module.exports = router