 
const { exec } = require('child_process');
const express = require('express');

const router = express.Router();

router.use(express.json());
router.use(express.urlencoded({extended: true}));

// const multer = require('multer');
const mongoose = require("mongoose");

const diag = require("../models/diag");


router.post('/score_calculate_alz',(req, res, next)=>{
  // console.log('Audio received and saved as audio.wav.');

  // res.json({ message: 'ok' });
  const user = req.body.user;
    const pythonCode = req.body.text;

    const scriptPath = 'python_scripts/alzheimer_script.py'
    

    exec(`python3 ${scriptPath} "${pythonCode}"`, (error, stdout, stderr) => {
        if (error) {
          console.error('Error:', error);
          console.error('Error Output:', stderr);
          res.status(500).json({ error: 'An error occurred while running the Python script.' });
        } else {
          console.log('Python Output:', stdout);
          // res.status(200).json({ output: stdout });
          if (stdout=='1'){
            sum = 1;
            condition = "AD"
          }
          else{
            sum = 0
            condition = "No AD"
          }
  
          const diags = new diag({
            _id: new mongoose.Types.ObjectId(),
            uid: user,
            hid:user+'_alzheimer_'+new Date().toISOString().replace(/\D/g, ''),
            task_id: 'alzheimer',
            task_score: sum,
            classification: condition
        })
        diags.save().then((result)=>{
            console.log(result);
            res.status(200).json({ 
                id: result._id
        })
    })
        }

        
      });

      // print(stdout)
    
    
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