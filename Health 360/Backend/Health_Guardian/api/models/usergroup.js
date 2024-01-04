const mongoose = require('mongoose')

const UserGroupSchema = new mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectId,
    clinicalTrial: {
        type: mongoose.Types.ObjectId,
        ref: 'clinicaltrial',
        // required: [true, 'User group needs to be associated with a clinical trial']
    },
    groupDesc: {
        type: String
    },
    groupName: {
        type: String,
        required: [true, 'User group should have a name'],
        unique: [true, 'User group name should be unique']
    },
    usersList: {
        type: [{ type : mongoose.Types.ObjectId, ref: 'User' }],
        required: true
    },
    type: {
        type: String,
        default: "local"
    },
    createdBy: {
        type: mongoose.Types.ObjectId,
        ref: 'User',
        required: true
    }
})

module.exports = mongoose.model('userGroups',UserGroupSchema)