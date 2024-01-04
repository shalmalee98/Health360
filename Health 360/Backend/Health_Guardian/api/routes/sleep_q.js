const express = require('express');
const router = express.Router();

const mongoose = require("mongoose");

router.use(express.json());
router.use(express.urlencoded({extended: true}));

const diag = require("../models/diag");



router.post('/get_scale', (req, res, next)=>{
    const user = req.body.user;
    const { question1 } = req.body;

    const sum = parseInt(question1, 10);

    let condition;

    if (sum >= 6) {
        condition = 'No longer fighting sleep;sleep onset soon,having dreamlike thoughts';
    } else if (sum >= 5) {
        condition = 'Sleepy,woozy,fighting sleep;prefer to lie down';
    } else if (sum >= 4) {
        condition = 'Foggy;losing interest in remaining awake;slowed down';
    } else if (sum >= 3) {
        condition = 'Somewhat foggy, let down';
    } else if (sum >= 2) {
        condition = 'Awake,but relaxed;responsive but not fully alert';
    } else if (sum >= 1) {
        condition = 'Functioning at high levels,but not fully alert';
    } else {
        condition = 'Feeling active,vital,alert,or wide awake';
    }

    const diags = new diag({
        _id: new mongoose.Types.ObjectId(),
        uid: user,
        hid: user+'_sleep_questionnaire_'+new Date().toISOString().replace(/\D/g, ''),
        task_id: 'sleep_questionnaire',
        task_score: sum,
        classification: condition
    })
    diags.save().then((result)=>{
        console.log(result);
        res.status(200).json({
            id: result._id
    })
})
});

router.get('/:qstnid', (req, res, next) => {
    const { qstnid } = req.params;
  
    diag.findById(qstnid)
      .then((result) => {
        if (!result) {
          return res.status(404).json({ error: 'Data not found' });
        }
  
        res.status(200).json({

            data: ({
                label: result.classification,
                sleep_scale: result.task_score
            }),

            metadata: ({
                creation_timestamp: result.createdAt,
                task_id: result._id,
                user_id: result.uid
            }),
            type: result.task_id


        });
      })
      .catch((error) => {
        res.status(500).json({ error: 'Internal server error' });
      });
});

module.exports = router

