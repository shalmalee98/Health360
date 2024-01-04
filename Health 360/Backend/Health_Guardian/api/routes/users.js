const express = require("express");
const router = express.Router();
const mongoose = require("mongoose");
const UserGroups = require('../models/usergroup');
const Clinicaltrials = require('../models/clinicaltrial')

const User = require('../models/user');
const { createSecretToken } = require("../util/SecretToken");
const bcrypt = require("bcryptjs");
const clinicaltrial = require("../models/clinicaltrial");
const usergroup = require("../models/usergroup");
const questionnaires = require("../models/questionnaires");

router.post("/signup", (req, res, next) => {
  User.find({ username: req.body.username })
    .exec()
    .then(user => {
      if (user.length >= 1) {
        return res.status(409).json({
          message: "username exists"
        });
      } else {
        const user = new User({
          _id: new mongoose.Types.ObjectId(),
          firstname: req.body.firstname,
          lastname: req.body.lastname,
          username: req.body.username,
          password: req.body.password,
          age: req.body.age,
          height: req.body.height,
          weight: req.body.weight,
          gender: req.body.gender,
          disease: req.body.disease,
          region: req.body.region,
          typeofuser: req.body.typeofuser
        });
        user
          .save()
          .then(async result => {
            console.log('is user created?', result);
            res.status(201).json({
              message: "User created",
            });

            const maingroup = await UserGroups.findOne({groupName: "Main Global User Group"});
            if (maingroup && req.body.typeofuser == 'PATIENT'){
              maingroup.usersList.push(result._id);
              const response = maingroup.save();
            }
          })
          .catch(err => {
            console.log(err);
            res.status(500).json({
              error: err
            });
          });
      }
    });
});

router.post('/login', async (req, res, next) => {
  console.log(req.body)
  User.findOne({ username: req.body.username })
    .exec()
    .then(async user => {
      console.log("What user was found: ", user)
      if (user.length < 1) {
        return res.status(401).json({
          message: 'Auth failed'
        });
      }
      const isAMatch = await bcrypt.compare(req.body.password, user.password);
      if (isAMatch) {
        const token = createSecretToken(user._id);
        res.cookie("token", token, {
          withCredentials: true,
          httpOnly: false,
        });
        return res.status(200).json({
          message: 'Auth successful',
          user: user
        });
        // const token = createSecretToken(user._id);
        // res.cookie("token", token, {
        //   withCredentials: true,
        //   httpOnly: false,
        // });
        // res
        //   .status(201)
        //   .json({ message: "User signed in successfully", success: true, user });
        // next();
      }
      res.status(401).json({
        detail: 'No active account found with the given credentials'
      });
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({
        error: err
      });
    });
  })

router.delete("/:userId", (req, res, next) => {
  User.deleteOne({ _id: req.params.userId })
    .exec()
    .then(result => {
      res.status(200).json({
        message: "User deleted"
      });
    })
    .catch(err => {
      console.log(err);
      res.status(500).json({
        error: err
      });
    });
});

router.post("/addToken", async (req, res, next) => {

  const {username, token} = req.body;
  const user = await User.findOneAndUpdate(
    { username: username },
    { $set: { token: token } },
    { new: true } 
  );

  if (!user) {
    return res.status(500).json({
      message: "User not found"
    })
  }

  return res.status(201).json({
    message: "User token updated",
  });
});

router.post("/addSubscription", async (req, res, next) => {

  const {clinicalTrial, user, response} = req.body
  if(response == 'yes' ){
    console.log("I am here");
    const clinicalResponse = await clinicaltrial.findOne({_id: clinicalTrial})
    const userGroup = await usergroup.findOne({groupName: `${clinicalResponse.name} Subscribed`})
    clinicalResponse.subscribers.push(user);
    const savingSubscriber = clinicalResponse.save();
    userGroup.usersList.push(user);
    console.log('list of user group ids: ', userGroup)
    const userGroupNotResponded = await usergroup.findOne({groupName: `${clinicalResponse.name} Not Responded`})
    userGroupNotResponded.usersList = userGroupNotResponded.usersList.filter((userId) => {
      if (userId._id != user){
      return (
          userId
      ) 
      }
    })
    userGroupNotResponded.save();
    const response = userGroup.save();
  } else if(response == 'no') {
    const userGroup = await usergroup.findOne({groupName: `${clinicalResponse.name} Non-Subscribed`})
    userGroup.usersList.push(user);
    const userGroupNotResponded = await usergroup.findOne({groupName: `${clinicalResponse.name} Not Responded`})
    userGroupNotResponded.usersList = userGroupNotResponded.usersList.filter((userId) => {
      if (userId != user){
      return (
          userId
      ) 
      }
    })
    userGroupNotResponded.save();
    console.log('list of user group ids: ', userGroup)
  }
  return res.status(200).json({
    message: response
  });
});

router.post("/subscribedTo", async (req, res, next) => {

  const {userId} = req.body;
  const clinicalTrials = await Clinicaltrials.find({subscribers: userId}).populate('questionnaire');

  return res.status(201).send(clinicalTrials);
});

//Get All Users Method
router.get('/getAll', async(req, res) => {

  User.find({typeofuser: "PATIENT"})
    .then(data => {
      if (!data)
        res.status(404).send({ message: "Not found users " });
      else  res.status(201).json({
          message: "Users found",
          data
      });
    })
    .catch(err => {
      res
        .status(500)
        .send({ message: "Error retrieving Users" });
    });
}
);
//Get by ID Method
router.get('/getOne', async(req, res) => {
  const id = req.query.id;

  User.findById(id)
    .then(data => {
      if (!data)
        res.status(404).send({ message: "Not found User with id " + id });
      else  res.status(201).json({
          message: "User found",
          data
      });
    })
    .catch(err => {
      res
        .status(500)
        .send({ message: "Error retrieving User with id=" + id });
    });
}
);

router.get('/dashboard', async (req,res) => {
  const clinicalTrialCount = (await Clinicaltrials.find({})).length;
  const questionnaireCount = (await questionnaires.find({})).length;
  const userCount = (await User.find({})).length;
  const userGroupCount = (await UserGroups.find({})).length;
  return res.status(200).json({clinicalTrialCount,questionnaireCount,userCount,userGroupCount})
})

router.put('/update', async(req, res, next) => {
  const user = new User({
    _id: req.query.id,
    firstname: req.body.firstname,
    lastname: req.body.lastname,
    age: req.body.age,
    height: req.body.height,
    weight: req.body.weight
  });
  User.updateOne({_id: req.query.id}, user).then(
    () => {
      res.status(201).json({
        message: 'User updated successfully!'
      });
    }
  ).catch(
    (error) => {
      res.status(400).json({
        error: error
      });
    }
  );
});


module.exports = router;