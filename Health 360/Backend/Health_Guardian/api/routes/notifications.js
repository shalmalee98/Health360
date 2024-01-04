const express = require('express')
const router = express.Router()
const { response } = require('express');
const axios = require('axios')
const Users = require('../models/user');
const { mongoose } = require('mongoose');
const notifications = require('../models/notifications');
const admin = require('firebase-admin');
const usergroup = require('../models/usergroup');

//add a new notification in DB
router.post('/add',async (req,res) => {
    const {notificationTitle,notificationDescription , recipientUserId,questionnaireId, createdBy, userGroupId} = req.body;
    let recipientUserIds = [];
    if(recipientUserId != undefined){
        recipientUserIds = recipientUserId;
    }
    let promiseArr = []; 
    if(userGroupId) {
        const userGroup = await usergroup.findOne({"_id": userGroupId}).populate('usersList');
        console.log('User group found : ', userGroup)
        if(userGroup.usersList.length > 0){
            userGroup.usersList.map(user => {
                console.log('What is user id found: ', user._id)
                recipientUserIds.push(user._id)
            })
        }
    }
    console.log('Recipient user ids: ', recipientUserIds);
    const promise1 = new Promise((resolve, reject) => {
        const post = new notifications({
            _id: new mongoose.Types.ObjectId(),
            createdBy,
            notificationTitle,
            notificationDescription,
            recipientUserId: recipientUserIds,
            userGroupId,
            questionnaireId,
            isRead: false
        });
        resolve(post.save());
      });
    const promise2 = new Promise((resolve, reject) => {
        const config = { headers: { 'Content-Type': 'application/json'} }
        if(userGroupId!= null) {
            console.log('inside if')
            resolve(axios.post(`http://128.205.39.59:30500/send-notification`, {
                "name": notificationTitle,
                "description": notificationDescription,
                "userGroupId": userGroupId
            }, config));
        } else {
            console.log('inside else')
            recipientUserId.map(async id => {
                resolve(axios.post('http://128.205.39.59:30500/send-notification', {
                    "name": notificationTitle,
                    "description": notificationDescription,
                    "userId": id
                }, config ));
            })
        }
      });
      promiseArr.push(promise1);
      promiseArr.push(promise2);
        
    Promise.all(promiseArr).then(function(response) {
        // console.log("response: ", response);
        response.map(r => {
            console.log('Response : ', r)
            if(r.status && r.status == 500){
                error = true;
            }
        });
        res.status(200).send('Notification sent successfully!');
        
    }).catch(err => {
        console.log("inside catch block")
        console.log('We got an error', err.response);
        res.status(500).json(err)
    })
    // } catch(err){
    //     console.log("inside catch block")
    //     console.log('We got an error', err.response.statusText);
    //     res.status(500).send(err.response.statusText)
    // }
})

//delete notification by id
router.delete('/deleteById', async(req, res) => {
    try {
        const id = req.query.id;
        console.log('print id to be deleted: ', id);
        if(id == null) {
            res.status(501).send('Notification ID not defined')
        } else {
            const data = await notifications.findByIdAndDelete(id)
            res.status(201).json({message: `Notification has been deleted..`, data})
        }
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})

//get all notifications for particular user
router.get('/getByUser',async (req,res) => {
    try {

        const userId = req.query.userId;
        if(userId == null) {
            res.status(501).send('User ID not defined')
        } else {
            const notificationByuserId = await notifications.find({recipientUserId: userId})
            res.status(200).json(notificationByuserId)
        }
        
    } catch(err){
        console.log(err)
        res.status(500).send('Error in fetching notifications by user')
    }
});

//read notification update by id
router.put('/readNotification', async(req, res) => {
    try {
        console.log('req object: ', req.query.id)
        const notificationId = req.query.id;
        const updatedData = {isRead: true};
        const options = { new: true };

        const result = await notifications.findByIdAndUpdate(
            notificationId, updatedData, options
        );
        res.send(result);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
})

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

//Delete notification by ID Method
router.delete('/delete', async (req, res) => {
    try {
        const notificationId = req.query.notificationId;
        console.log('print id to be deleted: ', notificationId)
        const data = await notifications.findByIdAndDelete(notificationId)
        res.status(201).json({message: `Document has been deleted.. ${data}`})
    }
    catch (error) {
        res.status(400).json({ message: error.message })
    }
})


module.exports = router