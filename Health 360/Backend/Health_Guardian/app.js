const express = require('express');
const req = require('express/lib/request');
const res = require('express/lib/response');
const app = express();
const mongoose = require('mongoose')

const productRoutes = require('./api/routes/phq_8')
const productRoutes2 = require('./api/routes/sleep_q')
const productRoutes3 = require('./api/routes/gad_7');
const productRoutes4 = require('./api/routes/audit');
const productRoutes5 = require('./api/routes/par_d');
const productRoutes6 = require('./api/routes/alzh_d');
const productRoutes7 = require('./api/routes/get_audio');
const productRoutes8 = require('./api/routes/diab');

const productlist = require('./api/routes/data');
const userRoutes = require('./api/routes/users');
const questionnaireRoutes = require('./api/routes/questionnaire');
const responsesRoutes = require('./api/routes/responses');
const clinicalRoutes = require('./api/routes/clinicaltrial');
const userGroupRoutes = require('./api/routes/usergroups');
const notificationRoutes = require('./api/routes/notifications');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const cors = require('cors');
const { MONGO_URL, PORT } = process.env
const Users = require('./api/models/user')

const admin = require('firebase-admin');

const serviceAccount = require('./api/serviceAccountKey.json');
const usergroup = require('./api/models/usergroup');


mongoose.connect('mongodb+srv://ubhealth360:Health360@cluster0.r6onhli.mongodb.net/?retryWrites=true&w=majority')
//mongoose.connect('mongodb://nodejs-kubernetes-mongodb:27017/nodejs-kubernetes')
.then(() => {
    console.log("Successfully connect to MongoDB.");
    // initial();
  })
  .catch(err => {
    console.error("Connection error", err);
    process.exit();
  });
// mongoose
//   .connect(MONGO_URL)
//   .then(() => console.log("MongoDB is  connected successfully"))
//   .catch((err) => console.error(err));

// app.listen(PORT, () => {
//   console.log(`Server is listening on port ${PORT}`);
// });
app.get('/', function(req, res, next) {
    res.send("Hello World");
});

app.use(cors());
app.use(cookieParser());
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());


app.get('/vissu', function(req, res, next) {
    res.send("Hello World");
});

app.post('/send-notification', async function(req, res, next) {

  try {

    const {usergroupId, userId,name,description} = req.body;

    const message = {
      notification: {
        title: name || 'Test Notification',
        body: description || 'Test Notification Body'
      },
      token: 'd7L-JAixS7GVf8mQiNuICo:APA91bGf1mwaKJlL8wq4i2LoEGxOW2BNQ8_bV2bVvmNqIxCfv7sP9Luz67NciCokCqb2wc_y5W7qFHpcnAWUeDUajLh7ehPsrUQU4KWTacXrPLLFiFttC1rPfpPM7PLwtBRMvzS7SA1-',
    };

    if (usergroupId){
      const userGroup = await usergroup.findOne({"_id": usergroupId}).populate('usersList')
      console.log(userGroup)
      if (userGroup?.usersList){
        const userGroupPromises = userGroup.usersList.filter(async (user) => {
            if (user.token){
              try {
                const response =  await admin.messaging().send({...message, token : user.token});
                return response;
              }
              catch (error){
                console.log(error)
                res.status(500).send("Error occured");
              }
            }
        })
        try {
          const results = await Promise.all(userGroupPromises);
          console.log('Notifications sent successfully:', results);
          res.status(200).send('Notifications sent successfully');
        }
        catch (e){
          //console.log("The exception is ",e);
          res.status(500).send("Error encountered: ")
        }
      } 
    } else if (userId){
      const user = await Users.findOne({_id: userId});
      const result = await admin.messaging().send({...message, token : user.token});
      console.log('Notifications sent successfully:', result);
      res.status(200).send('Notifications sent successfully');
  } else {
        const users = await Users.find({});  
        let tokens = users.map(user => user.token);
      
        tokens = tokens.filter((token) => {
          if (token){
              return token
          }
        })

        const sendNotificationsPromises = tokens.map((token) => {
          return admin.messaging().send({...message, token : token});
        });
    
        const results = await Promise.all(sendNotificationsPromises);
        console.log('Notifications sent successfully:', results);
        res.status(200).send('Notifications sent successfully');
    }
  }catch (e){
    console.log("The exception is",e);
    res.status(500).send("Error occured");
  }
});

app.get('/send-notification',  function(req, res, next) {
    res.send('Hello')
})
app.use((error, req, res, next)=>{
    res.status(error.status || 500);
    res.json({
        error:{
            message: error.message
        }
    })
});

app.use('/phq_8', productRoutes);
app.use('/sleep_q', productRoutes2);
app.use('/data', productlist);
app.use('/users', userRoutes);
app.use('/gad_7', productRoutes3);
app.use('/audit', productRoutes4);
app.use('/par_d', productRoutes5);
app.use('/alzh_d', productRoutes6);
app.use('/get_audio', productRoutes7);
app.use('/diab', productRoutes8);
app.use('/questionnaires', questionnaireRoutes);
app.use('/usergroups', userGroupRoutes)
app.use('/responses', responsesRoutes);
app.use('/clinicaltrials',clinicalRoutes)
app.use('/notifications', notificationRoutes)
// app.use((req, res, next)=>{
//     const error = new Error('Not found');
//     error.status=404;
//     next(error);
// });

module.exports = app;

//lj5ciKMmr8sd7xUv