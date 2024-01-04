import Button from '@mui/material/Button';
import { Grid,TextField } from '@mui/material';
import { useState, useEffect } from 'react';
import Question from './Question';
import './Questions.css'
import AddPhotoAlternateIcon from '@mui/icons-material/AddPhotoAlternate';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../../constants';
import { useLocation } from 'react-router-dom';
import { Navigate } from 'react-router';
import Sidebar from '../../Components/Sidebar';
import SelectOption from '../../Components/SelectOption';
import SelectUserGroup from '../../Components/SelectUserGroup';

function Questions(props) {

  const location = useLocation();
  const clinicaltrial = location.state;
  console.log("The Clinical trial is ",clinicaltrial);
  let user;
  const [options,setOptions] = useState([]);
  const [userGroup,setUserGroup] = useState("");

  const getUsergroups = async () => {
    const response = await axios.get(`${BACKEND_ENDPOINT}/usergroups/getByClinicalTrial?clinicalTrialId=${clinicaltrial._id}`)
    const options = response.data.map((option) => {
      return {id:option._id,name:option.groupName}
    })
    console.log("The options are ", options);
    setOptions(options);
  }

  useEffect(() => {
    getUsergroups();
  },[])

  try {
    user = JSON.parse(localStorage.getItem('user'));

  const data = user;

  let baseObject = {
    "question":"",
    "questionImage": "",
    "questionaireNumber": "",
    "clinicalTrial": user._id,
    "questionType":"",
    "questionOptions": [{
        "name":"",
        "imageUrl":""
    }]
  }
  const [questions, setQuestions] = useState([baseObject]);
  const [name,setName] = useState("");
  const [description, setDescription] = useState("");
  
  async function postQuestionnaire() {
    const config = { headers: { 'Content-Type': 'application/json'} }
    const user = JSON.parse(localStorage.getItem('user'))._id;
    const id = location.pathname.split("/")[2];
    questions.questionOptions = questions.options; 
    // const modquestions = questions.map((question) => {
    //   question.questionOptions = question.options.map((option) => {
    //     return ({name: option, imageUrl: ""});
    //   })
    //   return question
    // })
    const body = {
      "clinicalTrial": id,
      "name": name,
      "description": description,
      "user": user,
      "questions": questions,
      "userGroup": userGroup
    }
    const response = await axios.post(`${BACKEND_ENDPOINT}/questionnaires/add`, body, config)
    console.log(response.data)
    if (response.status == 200 || response.status == 201){
      window.alert("Questionnaire added Succesfully");
    }
    window.location.pathname = "/";
    //const response = await axios.post('',questions,config)

  }

  useEffect(() => {
    console.log(questions)
  }, [questions])

  return (
    localStorage.getItem('user') ? 
    <div className='flex'>
      <div>
        <Sidebar clinicaltrialId={clinicaltrial._id} clinicaltrial={clinicaltrial}/>
      </div>

      <div className='bg-gray-300' style={{margin:10, height: '87vh', overflowY:'scroll'}}>
        <div className='bg-white m-1' style={{textAlign:'center'}}>
          <h5 className='font-medium' style={{fontSize:'20px'}}>{clinicaltrial.name} Clinical Trial New Questionnaire creation</h5>
        </div>
      <Grid container justifyContent="center" alignItems="center">
      <Grid item sm={12}>
        <div style={{margin:'1rem 3rem', backgroundColor:'#ffffff', padding: '1.5rem 2rem', borderRadius:'20px'}}>
        <h5>Select User Group</h5>
          <SelectUserGroup options = {options} setUserGroup={setUserGroup}/>
        </div>         
        </Grid>
        <Grid item xs={12}>
        <div style={{margin:'1rem 3rem', backgroundColor:'#ffffff', padding: '1.5rem 2rem', borderRadius:'20px'}}>
        <h5>Questionnaire Name:</h5>
        <TextField sx={{margin:'5px 0'}} onChange={(e) => {
                            setName(e.target.value)
                        }} value={name} fullWidth variant="outlined" />
        <h5>Questionnaire Description:</h5>
        <TextField onChange={(e) => {
          setDescription(e.target.value)
        }} value={description} fullWidth variant="outlined" />
        </div>         
        </Grid>
        <Grid item xs={12}>
          {
            questions.map((i,index) => {
              return(
                <div style={{margin:'2rem 3rem', backgroundColor:'#ffffff', padding: '1.5rem 2rem', borderRadius:'20px'}}>
                    <Question questions={questions} setQuestions={setQuestions} questionNumber={index+1}/>
                </div>

              )
            })
          }
        </Grid>
        
        

        <Grid item xs={12} style={{margin:'0rem 3rem',marginBottom:'1rem',textAlign:'right'}} >
            <Button onClick={() => {
              setQuestions([...questions,baseObject])
            }} variant="contained" color="primary">
                Add Question
              </Button>
          </Grid>

        <Grid sx={{textAlign:'right',margin:'0rem 3rem'}} item sm={12}>
            <Button style={{borderRadius:'10px',marginBottom:'1rem'}} fullWidth onClick={() => {
              postQuestionnaire()
            }} variant='contained'>Submit</Button>
          </Grid>
       
      </Grid>
    </div>
    </div>
    
    : <Navigate to="/login" />
  );
  }catch(e){
    <Navigate to="/login" />
  }

}

export default Questions;
