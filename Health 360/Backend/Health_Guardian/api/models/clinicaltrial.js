const mongoose = require('mongoose')

const ClinicaltrialSchema = new mongoose.Schema({
    name: {
       type: String,
       required: true
    },
    userList: {
        type: [{ type : mongoose.Types.ObjectId, ref: 'User' }],
        required: true
    },
    subscribers: {
        type: [{ type : mongoose.Types.ObjectId, ref: 'User' }],
        required: true
    },
    description: {
        type: String 
    },
    volunteerDetails: {
        type: String
    },
    questionnaire: {
        type: [mongoose.Types.ObjectId],
        ref: 'questionnaires'
    },
    createdBy: {
        type: mongoose.Types.ObjectId,
        ref: 'User',
        required: true
    }
})

module.exports = mongoose.model('clinicaltrial',ClinicaltrialSchema)