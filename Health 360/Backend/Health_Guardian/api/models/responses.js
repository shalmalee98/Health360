const mongoose = require('mongoose')

const QuestionResponseSchema = new mongoose.Schema({
    question: {
        type: String
    },
    questionType: {
        type: String
    },
    response: [{
        type: String,
        required: true
    }]
})

const userResponsesSchema = new mongoose.Schema({
    user: {
        type: mongoose.Types.ObjectId,
        ref: 'User',
        required: true
    },
    responses: [QuestionResponseSchema]
})

const ResponsesSchema = new mongoose.Schema({
    questionnaire: {
        type: mongoose.Types.ObjectId,
        ref: 'questionnaires',
        required: true
    },
    userResponses: {
        type: [userResponsesSchema]
    }
})

module.exports = Responses = mongoose.model('responses',ResponsesSchema)