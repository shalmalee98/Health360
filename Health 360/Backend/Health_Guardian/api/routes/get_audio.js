const express = require('express');
const { Storage } = require('@google-cloud/storage');

const router = express.Router();

router.use(express.json());
router.use(express.urlencoded({extended: true}));

const fs = require('fs');
const path = require('path');
 


const gc = new Storage({
  projectId: 'health-diary-v2',
  keyFilename: path.join(__dirname, "../../uploads/health-diary-v2-a1da090b9683.json")
});

const bucket = gc.bucket('artifacts.health-diary-v2.appspot.com');

// Define a route to retrieve audio files by filename
router.get('/file/:filename', async (req, res, next) => {
  const filename = req.params.filename;

  try {
    // Create a reference to the file in Google Cloud Storage
    const file = bucket.file(`audio_files/${filename}`); // Adjust the path as needed

    // Check if the file exists
    const [exists] = await file.exists();

    if (!exists) {
      return res.status(404).send('File not found');
    }

    // Create a read stream to stream the file data to the response
    const readStream = file.createReadStream();

    // Set the appropriate response headers for audio files
    res.setHeader('Content-Type', 'audio/wav'); // Adjust the content type as needed

    // Pipe the file data to the response
    readStream.pipe(res);
  } catch (err) {
    console.error('Error retrieving audio file:', err);
    res.status(500).send('Error retrieving audio file');
  }
});


router.get('/all', (req, res) => {
    // Get the file name from the URL parameter
    
  
    // Construct the file path based on the "uploads" directory and the provided file name
    const uploadsDir = path.join('uploads');

  // Read the contents of the "uploads" directory
  fs.readdir(uploadsDir, (err, files) => {
    if (err) {
      console.error('Error reading directory:', err);
      res.status(500).send('Internal Server Error');
      return;
    }

    // Filter out any subdirectories and only keep filenames
    const fileNames = files.filter((file) => !fs.lstatSync(path.join(uploadsDir, file)).isDirectory());

    // Send the list of filenames as a JSON response
    res.json({ files: fileNames });
  });
});

router.delete('/del/:fileName', (req, res) => {
  // Get the filename from the URL parameter
  const fileName = req.params.fileName;

  if (fileName === 'health-diary-v2-a1da090b9683.json') {
    return res.status(403).send('This file cannot be deleted.');
  }


  // Construct the file path based on the "uploads" directory and the provided file name
  const filePath = path.join('uploads', fileName);

  // Check if the file exists
  if (fs.existsSync(filePath)) {
    // Delete the file
    fs.unlinkSync(filePath);
    res.status(200).send('File deleted successfully');
  } else {
    // If the file doesn't exist, send a 404 Not Found response
    res.status(404).send('File not found');
  }
});
  
 
  module.exports = router;