import React from 'react'
import Sidebar from '../Components/Sidebar'
import { Button } from '@material-tailwind/react'
import Searchbar from '../Components/Searchbar'
import { CountCard } from '../Components/CountCard'
import { useLocation, useParams } from 'react-router-dom'
import Spinner from '@material-tailwind/react'
import { BACKEND_ENDPOINT } from '../constants'
import { useState, useEffect } from 'react'
import { Grid } from '@mui/material'
import { Link } from 'react-router-dom'
import axios from 'axios'
import background from '../assets/back.jpeg'

export default function Questionnaires() {
    const {id} = useParams();
    const [search,setSearch] = useState("");
    const location = useLocation();
    const clinicaltrial = location.state;
    const data = new URLSearchParams(location.search).get('data');
    const questionnaireArray = data ? JSON.parse(decodeURIComponent(data)): null;
    const [questionnaire, setQuestionnaire] = useState([]);

    const fetchQuestionnaire = async () => {
        try {
          const response = await axios.post(`${BACKEND_ENDPOINT}/questionnaires/getByClinicalTrial`, {clinicalTrialId: id});
           setQuestionnaire(response.data); 
        } catch (error) {
          console.error(`Error fetching questionnaire ${error}`);
        }
      };
    useEffect(() => {

        console.log("Hii");
        fetchQuestionnaire();
    },[])
  return (
    <div className='flex'>
        <div>
            <Sidebar clinicaltrialId={clinicaltrial?._id} clinicaltrial={clinicaltrial}/>
        </div>


        <div style={{flex:1}} className='bg-gray-200'>
            
            <div className='flex justify-between'>
                    <div style={{backgroundImage:`url(${background})`,flex:1}}>
                    <div className='m-5 flex justify-between'>
                            <div>
                                <p>Questionnaire of this Clinical Trial created by you :</p>
                            </div>
                            <div>
                            <Link state={clinicaltrial} to={`/questions/${id}`}><Button className='bg-blue-500 text-right' style={{ fontFamily: "Poppins, sans-serif" }}>New Questionnaire</Button></Link>
                            </div>
                    </div>
                    <div className='m-5'>
                        <Searchbar search={search} setSearch={setSearch}/>
                    </div>
                </div>
                
            </div>


            <div style={{flex: 1,height:'65vh',overflowY:'scroll'}} className='m-5'>
                {
                    questionnaire != null ?
                <Grid container spacing={2}>
                    {
                        questionnaire && questionnaire.length > 0 ?
                        questionnaire && questionnaire.length > 0 && questionnaire.map((eachquestionnaire) => {
                            return (
                                <Grid item xs={12} sm={3}>
                                    <Link state={clinicaltrial} to={`/response/${eachquestionnaire._id}`}><CountCard data={eachquestionnaire}/></Link>
                                </Grid>
                            )
                        })

                        

                        : 

                        <div style={{flex: 1, justifyContent:'center', alignItems:'center',display:'flex',height:'70vh'}}>

                            <div>No Questionnaire for this Clinical Trial</div>
                        </div>
                    }
                </Grid>

                :
                (
                <div style={{display:'flex',justifyContent:'center',alignItems:'center',flex:1}}>
                    <Spinner className="h-12 w-12"  color="blue"/>
                </div>
                )
                



                }
            </div>
           
        </div>
    </div>
  )
}
