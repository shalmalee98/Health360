const express = require('express')
const router = express.Router()
const { response } = require('express');
const UserGroups = require('../models/usergroup');
const User = require('../models/user');
const clinicalTrial = require('../models/clinicaltrial');
const { default: mongoose } = require('mongoose');
const clinicaltrial = require('../models/clinicaltrial');

//get all user groups method
router.get('/getAll', async (req, res) => {
    try{
        const data = await UserGroups.find();
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

router.post('/addMember', async (req, res) => {
    try{
        const userGroupID = req.body.subgroupId;
        const userGroup = await UserGroups.findOne({_id: userGroupID});
        const userList = req.body.usersList;
        userList.map((userId) => {
            if (! userGroup.usersList.includes(userId._id)){
                userGroup.usersList.push(userId._id);
            }
        })
        const response = await userGroup.save();
        res.status(200).json({response});
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

router.post('/deleteMember', async (req, res) => {
    try{
        const userGroupID = req.body.subgroupId;
        const clinicaltrailId = req.body.clinicaltrailId;
        const users = req.body.users;
        const userGroup = await UserGroups.findOne({_id: userGroupID});
        const newUserList = userGroup.usersList?.filter((user) => {

            let isPresent = users.filter((eachUser) => {
                if (eachUser._id == user._id){
                    return eachUser._id
                }
            })
            if(! (isPresent.length > 0)){
                return user._id;
            }
        })
        userGroup.usersList = newUserList;
        const response = await userGroup.save();
        if (clinicaltrailId){
            const clinicalTrial = await clinicaltrial.findById(clinicaltrailId);
            const newList = clinicalTrial.userList.filter((user) => {
                let isPresent = users.filter((eachUser) => {
                    if ((eachUser._id == user.toString())){
                        return user
                    }
                })
                if (isPresent.length == 0){
                    return user; 
                }
            });
            clinicalTrial.userList = newList;
            const res = await clinicalTrial.save(); 
            console.log(res);
        }
        res.status(200).json({response});
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

router.get('/getGlobal/:user', async (req, res) => {
    try{
        const {user} = req.params;
        const data = await UserGroups.find({
            $or: [
                {type:"global",createdBy: user},
                {groupName: "Main Global User Group"}
            ]
        });
        res.json(data)
    }
    catch(error){
        res.status(500).json({message: error.message})
    }
})

//Create user group method
router.post('/add', async (req, res) => {
    try{
        const clinicalservice = await clinicalTrial.find({ _id: req.body.clinicalService});
        // if(clinicalservice.length == 1){
            const userGroup = await UserGroups.find({groupName: req.body.groupName});
            if (userGroup.length >= 1) {
                res.status(400).json({ message: "User group with the same name exists" })
            } else {
                const data = await new UserGroups({
                    _id: new mongoose.Types.ObjectId(),
                    clinicalTrial: req.body.clinicalService,
                    groupName: req.body.groupName,
                    usersList: req.body.usersList || [],
                    type: req.body.type,
                    groupDesc: req.body.groupDesc,
                    createdBy: req.body.createdBy
                }).save();
                res.status(201).json({
                    message: "User group created", data,
                });
            }
        // } 
    } catch(error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

//Get by ID Method
router.get('/getOne', async(req, res) => {
    const id = req.query.id;
  
    UserGroups.findById(id)
      .then(data => {
        if (!data)
          res.status(404).send({ message: "Not found Tutorial with id " + id });
        else  res.status(201).json({
            message: "User group created",
            data
        });
      })
      .catch(err => {
        res
          .status(500)
          .send({ message: "Error retrieving Tutorial with id=" + id });
      });
  }
);

//Get user groups by clinical trial ID Method
router.get('/getByClinicalTrial', async(req, res) => {
    try{
        const clinicalTrialId = req.query.clinicalTrialId;
        console.log('found clinical trial id: ', clinicalTrialId)
    
        const usergroups = await UserGroups.find({clinicalTrial: clinicalTrialId});
     
        if (!usergroups)
          res.status(404).send({ message: "Not found UserGroup with clinical trial id " + id });
        else return res.send(usergroups);
      
    }
    catch(error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    
  }
}
);

//Get users by user group id Method
router.get('/getUsersByGroup', async(req, res) => {
  
    try {
        
        const userGroupId = req.query.userGroupId;
        console.log('found clinical trial id: ', userGroupId)
    
        // Find the user group by ID
        const userGroup = await UserGroups.findById(userGroupId);
    
        if (!userGroup) {
          return res.status(404).json({ message: 'User group not found' });
        }
    
        // Extract the user IDs from the userGroup's usersList array
        const userIds = userGroup.usersList;
    
        // Use the extracted user IDs to find all users
        const users = await User.find({ _id: { $in: userIds } });
    
        // Return the list of users
        res.json(users);
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
      }
  }
);

router.post('/getUsersByIds', async(req, res) => {
  
    try {
        
        const userIds = req.body.userIds;
        const users = await User.find({ _id: { $in: userIds } });
    
        // Return the list of users
        return res.json(users);
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
      }
  }
);

router.post('/getUsersByGroupName', async(req, res) => {
  
    try {
        
        const userGroupName = req.body.userGroupName;
    
        // Find the user group by ID
        const userGroup = await UserGroups.findOne({groupName: userGroupName,});
    
        if (!userGroup) {
          return res.status(404).json({ message: 'User group not found' });
        }
    
        // Extract the user IDs from the userGroup's usersList array
        const userIds = userGroup.usersList;
    
        // Use the extracted user IDs to find all users
        const users = await User.find({ _id: { $in: userIds } });
    
        // Return the list of users
        res.json(users);
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
      }
  }
);


//update user group by id
router.put('/update', async (req, res) => {
    try {
        const id = req.query.id;
        const updatedData = req.body;
        const options = { new: true };

        const result = await UserGroups.findByIdAndUpdate(
            id, updatedData, options
        );
        res.send(result);
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
});

//Delete by ID Method
router.delete('/delete', async (req, res) => {
    try {
        const id = req.query.id;
        const data = await UserGroups.findByIdAndDelete(id)
        res.status(201).json({message: `Document with name ${data.groupName} has been deleted..`})
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})

module.exports = router