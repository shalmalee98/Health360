const mongoose = require('mongoose');
const bcrypt = require("bcryptjs");

const userSchema = mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectId,
    token: {
        type: String,
    },
    firstname: { 
        type: String, 
        required: [true, "Your first name is required"]
    },
    lastname: { 
        type: String, 
        required: [true, "Your last name is required"]
    },
    username: { 
        type: String, 
        required: [true, "Your email address is required"],
        // unique: true, 
        //match: /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/
    },
    password: { 
        type: String, 
        required: [true, "Your password is required"], 
    },
    typeofuser: {
        type: String,
        enum: ['DOCTOR', 'PATIENT'],
        required:  [true, "Type of user needs to be defined"], 
    },
    age: {
        type: Number,
    },
    height: {
        type: Number,
    },
    weight: {
        type: Number,
    },
    gender: {
        type: String
    },
    disease: {
        type: String
    },
    region: {
        type: String
    },

});

userSchema.pre("save", async function () {
    this.password = await bcrypt.hash(this.password, 12);
  });

module.exports = mongoose.model('User', userSchema);