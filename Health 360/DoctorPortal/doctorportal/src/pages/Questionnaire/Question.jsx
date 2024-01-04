import React, { useEffect } from 'react'
import { Button, Grid, TextField } from '@mui/material';
import { useState } from 'react';
import Questiontype from './Questiontype';
import DeleteIcon from '@mui/icons-material/Delete';
import AddPhotoAlternateIcon from '@mui/icons-material/AddPhotoAlternate';
import CloseIcon from '@mui/icons-material/Close';
import { Navigate } from 'react-router';
import app from '../../Firebase'
import { useRef } from 'react';
import { getDownloadURL, getStorage, ref, uploadBytes } from 'firebase/storage'


export default function Question(props) {
    const {questionNumber, questions, setQuestions} = props;
    const [questionType, setQuestiontype] = useState('select');
    const [file,setFile] = useState(null);
    const fileInputRef = useRef(null);

    useEffect(() => {
        handleUpload();
    },[file])
    const handleButtonClick = () => {
        // Trigger the click event on the file input
        fileInputRef.current.click();
      };
    const handleFileChange = (e) => {
        const selectedFile = e.target.files[0];
        setFile(selectedFile);
    }
    const handleUpload = async () => {
        if(file){
            const storage = getStorage(app);
            const min = 10000000;
            const max = 99999999;
            const uniqueNumber = Math.floor(Math.random() * (max - min + 1)) + min;
            const mediaRef = ref(storage, `images/${uniqueNumber}.${file.name}`);
            try {
                const uploadTask = await uploadBytes(mediaRef, file);
                const imageUrl = await getDownloadURL(mediaRef);
                setQuestions([...questions.slice(0,questionNumber-1),{...questions[questionNumber - 1], questionImage: imageUrl},...questions.slice(questionNumber,questions.length)])
                return imageUrl;
            }catch (e){
                console.log("There is an error while uploading the picture ",e);
                return "";
            }
        }
    }
    
    const GetOptions = (type) => {
        const [questionOptions, setQuestionoptions] = useState([]);
        if (type == 'select' || type == 'multiselect'){
            return (
                localStorage.getItem('user') ? 
                <>
                  <Grid style={{textAlign:'right'}} item sm={4}>
                        <Button variant="outlined" onClick={() => {
                            setQuestionoptions([...questionOptions,{name:"",imageUrl:""}]);
                            setQuestions([...questions.slice(0,questionNumber -1), {...questions[questionNumber -1 ], questionOptions : questionOptions }, ...questions.slice(questionNumber, questions.length)])
                        }} container>Add Option</Button>
                    
                  </Grid>
                   <Grid item container justifyContent="center" alignItems="center" sm={12}>                 
                      {
                        questionOptions.map ((option, index) => {
                            return (
                            <>
                               
                                <Grid sx={{margin: '5px 0'}} item sm={8}>
                                Option {index+1}:
                                    <TextField fullWidth onChange={(e) => {
                                        if (e.target.value != ""){
                                            setQuestionoptions([...questionOptions.slice(0,index), {name:e.target.value, imageUrl: ""}, ...questionOptions.slice(index+1,questionOptions.length)])
                                            setQuestions([...questions.slice(0,questionNumber -1), {...questions[questionNumber -1 ], questionOptions : [...questionOptions.slice(0,index), {name:e.target.value, imageUrl: ""}, ...questionOptions.slice(index+1,questionOptions.length)] }, ...questions.slice(questionNumber, questions.length)])
                                        }
                                        else
                                        setQuestionoptions([...questionOptions.slice(0,index), {name:e.target.value, imageUrl: ""}, ...questionOptions.slice(index+1,questionOptions.length)])
                                    }} onKeyDown={(e) => {
                                        if (e.key == 'Enter'){
                                            setQuestionoptions([...questionOptions,{name:"",imageUrl:""}])
                                        }
                                    }} value ={option.name}/>

                               
                                </Grid>
                                <Grid item sm={4}>
                                
                                <AddPhotoAlternateIcon/>
                                <DeleteIcon sx={{color:'red'}} onClick={() => {
                                        console.log("Heyy")
                                        setQuestionoptions(questionOptions.slice(0, index).concat(questionOptions.slice(index + 1)));
                                    }} />
                                </Grid>
                            </>
                        )})
                    }
                    </Grid>
                </>
                : <Navigate to="/login" />
            )
                }
     }
        


    
  return (
        <Grid container  alignItems="center" justifyContent="space-between">
           
                <h5>Question {questionNumber}:</h5>
                <Grid container sx={{margin:'5px 0'}} iten sm={12} xs={12} justifyContent="center" alignItems="center">
                    <Grid sm={11}>
                        <TextField onChange={(e) => {
                            setQuestions([...questions.slice(0,questionNumber-1), {...questions[questionNumber -1], question : e.target.value }, ...questions.slice(questionNumber, questions.length)])
                        }} value={questions[questionNumber -1].question} fullWidth variant="outlined" />
                     </Grid>
                    <Grid sx={{textAlign:'right'}} sm={1}>
                    <input
                        type="file"
                        ref={fileInputRef}
                        style={{ display: 'none' }}
                        onChange={(e) => {
                            handleFileChange(e)
                        }}
                    />
                    <button onClick={handleButtonClick}><AddPhotoAlternateIcon/></button>
                    <CloseIcon onClick={() => {
                            console.log("Clicked")
                            setQuestions([...questions.slice(0, (questionNumber -1)).concat(questions.slice((questionNumber - 1) + 1, questions.length))])
                        }} style={{color:'red'}}/>
                    </Grid>

                    {
                        questions[questionNumber-1].questionImage.length > 0 ?
                    <Grid item justifyContent={'center'} alignItems={'center'} xs={12}>
                       <Grid item>
                         <img style={{height:'30vh', margin:'2vh'}} src={questions[questionNumber-1].questionImage} />
                         </Grid>
                    </Grid> : <Grid></Grid>
                    
                    }
                </Grid>

                <Grid sx={{margin:'5px 0'}} item xs ={8} sm={8}>
                    <h5>Question Type:</h5>
                    <Questiontype questionNumber={questionNumber} questions={questions} setQuestions={setQuestions} questionType={questionType} setQuestiontype={setQuestiontype}/>
                </Grid>
                    {
                    GetOptions(questionType)
                    }        
        </Grid>
  )
                }

