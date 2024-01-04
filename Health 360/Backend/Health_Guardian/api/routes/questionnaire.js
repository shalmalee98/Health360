const express = require('express')
const router = express.Router()
const { response } = require('express');
const Questionnaires = require('../models/questionnaires');
const ClinicalTrial = require('../models/clinicaltrial')
const axios = require('axios')

router.post('/add',async (req,res) => {
    try {
        console.log("I am here");
        console.log(req.body)
        const questions = req.body
        const clinicalTrial = questions.clinicalTrial
        const name = questions.name || "test"
        const description = questions.description || "testDes"
        // const {questions, name,description, clinicalTrail} = req.body;
        const post = new Questionnaires({
            clinicalTrial,
            name,
            description,
            questions : questions.questions,
            userGrop: questions.userGroup
        })
        const response = await post.save()
        const sendQuestionnaireNotification = await axios.post(`http://128.205.39.59:30500/send-notification`,{
            usergroupId: questions.userGroup,
            name: `A new Questionnaire created ${name}`,
            description: `${description} Please take attempt`
        });
        console.log(sendQuestionnaireNotification.data);
        console.log(response._id)
        const clinicalTrialResponse = await ClinicalTrial.findById(clinicalTrial);
        clinicalTrialResponse.createdBy = questions.user;
        clinicalTrialResponse.questionnaire.push(response._id)
        const finalResponse = await clinicalTrialResponse.save();
        res.status(200).json(finalResponse)
    } catch(err){
        console.log(err)
        res.status(500).send('Error in Saving posts')
    }
})

//Get questionnaires by clinical trial ID Method
router.post('/getByClinicalTrial', async(req, res) => {
    try{
        const clinicalTrialId = req.body.clinicalTrialId;
        console.log('found clinical trial id: ', clinicalTrialId)
        const usergroups = await Questionnaires.find({clinicalTrial: clinicalTrialId});
        if (!usergroups)
          res.status(404).send({ message: "Not found Questionnaire with clinical trial id " + id });
        else return res.send(usergroups);
      
    }
    catch(error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
  }
}
);

module.exports = router