const mongoose = require('mongoose')

const NotificationsSchema = new mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectId,
    notificationTitle: {
       type: String,
       required: true
    },
    notificationDescription: {
        type: String,
        required: true
     },
    recipientUserId: {
        type: [{ type : mongoose.Types.ObjectId, ref: 'User' }],
        required: true
    },
    userGroupId: { 
        type : mongoose.Types.ObjectId, 
        ref: 'userGroups'
    },
    questionnaireId: {
        type: mongoose.Types.ObjectId,
        ref: 'questionnaires'
    },
    timeStamp: { 
        type: Number, 
        default: (new Date()).getTime() 
    },
    createdBy: {
        type: mongoose.Types.ObjectId,
        ref: 'User',
        required: true
    },
    isRead: {
        type: Boolean,
        required: true
    }
})

module.exports = mongoose.model('notifications',NotificationsSchema)