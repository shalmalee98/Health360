const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: 'health360-25343.appspot.com',
  });

const bucket = admin.storage().bucket();
  
module.exports = {admin, bucket};