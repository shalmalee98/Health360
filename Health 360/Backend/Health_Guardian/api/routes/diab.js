const express = require('express');

const router = express.Router();

router.use(express.json());
router.use(express.urlencoded({extended: true}));

const mongoose = require("mongoose");

const diag = require("../models/diag");


router.post('/score_calculate_diab', (req, res, next)=>{
    const user = req.body.user;
    const score = req.body.score;
    const sum = parseInt(score, 10);
    let condition;

    if (sum == 0) {
    
        condition = 'Non Diabetic';
    } else if (sum == 1) {
    
        condition = 'Pre Diabetic';
    } else if (sum == 2) {
        
        condition = 'Diabetic';
    }

    const diags = new diag({
        _id: new mongoose.Types.ObjectId(),
        uid: user,
        hid: user+'_diabetes_'+new Date().toISOString().replace(/\D/g, ''),
        task_id: 'diabetes',
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
                score: result.task_score
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