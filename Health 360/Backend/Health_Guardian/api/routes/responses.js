const express = require('express')
const router = express.Router()
const Responses = require('../models/responses')
const Questionnaires = require('../models/questionnaires');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });

const serviceAccount = require('../serviceAccountKey.json');
const {admin, bucket} = require('../Firebase');

router.post('/add',async (req,res) => {
    try {
        console.log("I am here");
        console.log(req.body)
        const {questionnaire,user, responses} = req.body;
        const questionnnaireBody = await Responses.findOne({questionnaire: questionnaire})
        let response;
        if (questionnnaireBody?.id){
            questionnnaireBody.userResponses.push({
                user: user,
                responses: responses
            })
            response = await questionnnaireBody.save();
        }
        else {
            const responseResult = new Responses({
                questionnaire: questionnaire,
                userResponses: [{
                    user: user,
                    responses: responses
                }]
            })
            response = await responseResult.save();
        }
        res.status(200).json(response)
    } catch(err){
        console.log(err)
        res.status(500).send('Error in Saving posts')
    }
})

router.get('/get/:id',async (req,res) => {
    try {
        console.log("I am here");
        console.log(req.params.id)
        const {id} = req.params;
        const responses = await Responses.find({questionnaire: id}).populate('userResponses.user');
        res.status(200).json(responses)
        
    } catch(err){
        console.log(err)
        res.status(500).send('Error in getting responses')
    }
});

router.post('/upload-media', upload.single('file'), (req, res) => {
    if (!req.file) {
      return res.status(400).send('No file provided.');
    }
    const file = req.file;
    const storagePath = `${file.originalname}`;
    const fileUpload = bucket.file(storagePath);
    const blobStream = fileUpload.createWriteStream({
      metadata: {
        contentType: file.mimetype,
      },
    });
  
    blobStream.on('error', (error) => {
      console.error(error);
      return res.status(500).json({ error: 'Something went wrong.' });
    });
  
    blobStream.on('finish', (snapshot) => {
      fileUpload.getSignedUrl({ action: 'read', expires: '03-01-2500' }, (err, publicUrls) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Error generating public URL.' });
        }
        const publicUrl = publicUrls;
        console.log(publicUrl);
        res.status(200).json({ mediaUrl: publicUrl });
      });
    });
  
    blobStream.end(file.buffer);
  });

module.exports = router