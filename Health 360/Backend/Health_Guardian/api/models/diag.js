const mongoose = require('mongoose');

const taskSchema = mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectId,
    uid: {
        type: String,
        required: true,
    },
    hid: {
        type: String,
        required: true,
    },
    task_id:{
        type: String,
        required: true,
    },
    task_score:{
        type: Number,
        required: false,
    },
    classification:{
        type: String,
        required: true,
    },
},{ timestamps: true });

module.exports = mongoose.model('Diag', taskSchema);