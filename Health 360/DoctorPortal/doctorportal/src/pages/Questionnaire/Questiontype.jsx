import * as React from 'react';
import Box from '@mui/material/Box';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import { useState } from 'react';
import { Navigate } from 'react-router';

export default function Questiontype(props) {
  const {questiontype, setQuestiontype, questions, setQuestions, questionNumber} = props;

  const handleChange = (event) => {
    setQuestiontype(event.target.value);
    setQuestions([...questions.slice(0,questionNumber -1), {...questions[questionNumber -1 ], questionType : event.target.value }, ...questions.slice(questionNumber, questions.length)])
  };

  return (
    localStorage.getItem('user') ? 
      <FormControl fullWidth>
        <Select
          value={questiontype}
          onChange={handleChange}
        >
          <MenuItem value='select'>Select</MenuItem>
          <MenuItem value='multiselect'>Multi Select</MenuItem>
          <MenuItem value='media'>Image</MenuItem>
          <MenuItem value='text'>Text</MenuItem>
          <MenuItem value='voice'>Voice</MenuItem>
        </Select>
      </FormControl>
      : <Navigate to="/login" />
  );
}
