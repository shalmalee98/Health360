//imports

const { Storage } = require('@google-cloud/storage');
const express = require('express');
const multer = require('multer');
const mongoose = require("mongoose");
const { exec } = require('child_process');
const path = require('path'); 
const router = express.Router();
const diag = require("../models/diag");


//middlewares
router.use(express.urlencoded({extended: true}));

router.use(express.json());



//connecting to google cloud storage

const gc = new Storage({
  projectId: 'health-diary-v2',
  keyFilename: path.join(__dirname, "../../uploads/health-diary-v2-a1da090b9683.json")
});

const bucket = gc.bucket('artifacts.health-diary-v2.appspot.com');

//middlewares for disk storage

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads'); // Specify the destination directory
  },
  
  filename: (req, file, cb) => {
    const user = req.body.user; // Replace with the actual username
    const condition = 'parkinsons'; // Replace with the actual condition
    const timestamp = new Date().toISOString().replace(/\D/g, ''); // Get the current timestamp
    const filename = `${user}_${condition}_${timestamp}`;
    const savename = `${filename}.wav`
    cb(null, savename); // Save the file as audio.wav
  }
});

const upload = multer({ storage: storage });


router.post('/score_calculate_pard', upload.single('audio'),async (req, res, next)=>{
  
  console.log('User Field:', req.body.user); 
  const user = req.body.user;
  const filename = req.file.filename;
    const scriptPath = 'python_scripts/park.py'

    const destination = `audio_files/${filename}`;


    try {
      // Upload the audio file to Google Cloud Storage
      await bucket.upload(`uploads/${filename}`, { destination });
      
      // Run the Python script with the uploaded filename
      exec(`python3 ${scriptPath} "${filename}"`, (error, stdout, stderr) => {
        if (error) {
          console.error('Error:', error);
          console.error('Error Output:', stderr);
          res.status(500).json({ error: 'An error occurred while running the Python script.' });
        } else {
          console.log('Python Output:', stdout);
          console.log(`File ${filename} uploaded to Google Cloud Storage`);
          if (stdout[1]=='1'){
            sum = 1;
            condition = "Parkinson"
          }
          else{
            sum = 0
            condition = "No Parkinson"
          }

          const diags = new diag({
            _id: new mongoose.Types.ObjectId(),
            uid: user,
            hid: filename.split('.')[0],
            task_id: 'parkinsons',
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
    } catch (err) {
      console.error('Error uploading to Google Cloud Storage:', err);
      res.status(500).send('Error uploading to Google Cloud Storage');
    }
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