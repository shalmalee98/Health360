const mongoose = require('mongoose')

const OptionSchema = new mongoose.Schema({
    name: {
      type: String,
      required: false
    },
    image: {
      type: String,
      required: false
    }
  });

const QuestionsSchema = new mongoose.Schema({
    question: {
        type: String,
        required: true
    },
    questionType: {
        type: String,
        required: true
    },
    questionImage: {
      type: String
    },
    questionOptions: {
        type: [OptionSchema]
    }
})

const QuestionnairesSchema = new mongoose.Schema({
  questions: {
      type: [QuestionsSchema]
  },
  clinicalTrial: {
    type: mongoose.Types.ObjectId,
    ref: 'clinicaltrial',
    required: false
  },
  name: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  userGrop: {
    type: mongoose.Types.ObjectId,
    ref: 'userGroups'
  }
})

module.exports = mongoose.model('questionnaires',QuestionnairesSchema)