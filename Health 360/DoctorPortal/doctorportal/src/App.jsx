import { useState } from 'react'
import { BrowserRouter as Router, Routes, Route,Navigate } from 'react-router-dom'
import Header from './Components/Header'
import {Dashboard, Users} from './pages/Index'
import UsergroupMembers from './pages/UsergroupMembers'
import Usergroups from './pages/Usergroups';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import Clinicaltrials from './pages/Clinicaltrials'
import AboutClinicalTrial from './pages/AboutClinicalTrial'
import Questionnaires from './pages/Questionnaires'
import ResponsePage from './pages/ResponsePage'
import Login from './pages/Login'
import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom';
import Signup from './pages/Signup'
import GlobalUserGroups from './pages/GlobalUserGroups'
import Questions from './pages/Questionnaire/Questions'
import './App.css';
import Notifications from './pages/Notifications'
import Popup from './Components/Popup'
import UserProfile from './Components/Profile'



function App() {
  const darkTheme = createTheme
  ({
    typography: {
      fontFamily: '"Poppins", Arial, sans-serif'
    }
  });

  const [user,setUser] = useState(null);
  const [openpopup,setOpenpopup] = useState(false);

  useEffect(() => {
    const storedUser = localStorage.getItem('user');
    try {
      if (storedUser) {
      const userJSON = JSON.parse(storedUser);
      setUser(userJSON);
      }
    }
    catch(e){

    }
  },[])


  useEffect(() => {
    const storedUser = localStorage.getItem('user');
    console.log("Bye")
    console.log(user)
    if (storedUser) {
      try {
        const userJSON = JSON.parse(storedUser);
      }
      catch(e){
        window.location.replace('/login');
      }
    }
    else{
      if (window.location.pathname != '/login' && window.location.pathname != '/signup')
      window.location.replace('/login');
    }
  }, [user]);

  

  return (
    <ThemeProvider theme = {darkTheme}>
    <div style={{maxHeight:'100vh'}}>
      <Header user={user}/>
      <Router>
        <Routes>
            <Route path="/login" element={<Login user={user} setUser={setUser}/>}/>
            <Route path="/signup" element={<Signup user={user} setUser={setUser}/>}/>
            {
              user ? <>
            <Route path="/" element={<Dashboard/>}/>
            <Route path="/users" element={<Users/>}/>
            <Route path="/usergroups/:id" element={<Usergroups/>}/>
            <Route path="/usergroupmembers/:id" element={<UsergroupMembers/>}/>
            <Route path="/clinicaltrials" element={<Clinicaltrials setOpenpopup={setOpenpopup}/>} />
            <Route path="/questionnaire/:id" element={<Questionnaires/>}/>
            <Route path="/response/:id" element={<ResponsePage/>}/>
            <Route path="/questions/:id" element={<Questions/>} />
            <Route path="/globalusergroup" element={<GlobalUserGroups/>}/>
            <Route path="/clinicaltrial/:id" element={<AboutClinicalTrial/>} />
            <Route path="/notifications" element={<Notifications/>} />
            <Route path="/profile" element={<UserProfile/>} />
            </> : null
            }
        </Routes>
      </Router>
      <Popup message={"Clinical Trial Created Succesfully!"} open={openpopup} setOpen={setOpenpopup}/>
    </div>
    </ThemeProvider>
  )
}

export default App