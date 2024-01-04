const express = require('express');

const router = express.Router();

router.use(express.json());
router.use(express.urlencoded({extended: true}));

const mongoose = require("mongoose");

const diag = require("../models/diag");


router.post('/score_calculate_gad7', (req, res, next)=>{
    const user = req.body.user;
    const { question1, question2, question3, question4, question5, question6, question7 } = req.body;
    const sum = parseInt(question1, 10) + parseInt(question2, 10) + parseInt(question3, 10) + parseInt(question4, 10) + parseInt(question5, 10) + parseInt(question6, 10) + parseInt(question7, 10) ;

    let condition;

    if (sum >= 15) {
        condition = 'Severe Anxiety';
    } else if (sum >= 10) {
        condition = 'Moderate Anxiety';
    } else if (sum >= 5) {
        condition = 'Mild Anxiety';
    } else {
        condition = 'Minimal Anxiety';
    }


    const diags = new diag({
        _id: new mongoose.Types.ObjectId(),
        uid: user,
        hid: user+'_GAD-7_'+new Date().toISOString().replace(/\D/g, ''),
        task_id: 'GAD-7',
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
                classification: result.classification,
                score: parseInt(result.task_score)
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

module.exports = router;