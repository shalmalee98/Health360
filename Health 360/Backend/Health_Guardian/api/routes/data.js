const express = require('express');
//const { router } = require('../../app');
const router = express.Router();
const mongoose = require("mongoose");
const moment = require('moment-timezone')

const Entry = mongoose.model('Entry', {
    uid: String,
    hid: String,
    task_score: Number,
    createdAt: Date,
    updatedAt: Date,
    task_id: String,
    classification: String,
    
    // Add other fields as needed
  }, 'diags');


router.get('/:uid', async (req, res) => {
  
        try {
            const { uid } = req.params;
        
            const entries = await Entry.find({ uid });


            const customResponse = entries.map(entry => {
              const createdAtET = moment(entry.createdAt).tz('America/New_York').format();
              const updatedAtET = moment(entry.updatedAt).tz('America/New_York').format();
                return {
                    created: createdAtET,
                    updated: updatedAtET,
                    uid: entry.uid,
                    hid: entry.hid,
                    task_score: entry.task_score,
                    classification: entry.classification,
                    task_snapshot:{
                    hid: entry.task_id,
                    type: "default task",
                },
                  thread_id: "0"
                };
              });
        
            res.json(customResponse);
          } catch (error) {
            res.status(500).json({ error: 'An error occurred' });
          }


    // ]);
});

module.exports = router