import React from 'react'
import Sidebar from '../Components/Sidebar'
import ClinicaltrialCard from '../Components/ClinicaltrialCard'
import { Search } from '@mui/icons-material'
import Searchbar from '../Components/Searchbar'
import { Button, Spinner } from '@material-tailwind/react'
import { Grid } from '@mui/material'
import { useState, useEffect } from 'react'
import axios from 'axios'
import { BACKEND_ENDPOINT } from '../constants'
import { Link } from 'react-router-dom'
import NewClinicalTrailDialog from '../Components/NewClinicalTrailDialog'
import background from '../assets/back.jpeg'

export default function Clinicaltrials(props) {
    const {setOpenpopup} = props;
    const [open,setOpen] = useState(false);
    const [search,setSearch] = useState("");
    const [clinicalTrials, setClinicalTrials] = useState(null);
    const [fixedtrials,setFixedtrials] = useState(null);
    const [alertMessage, setAlertMessage] = useState('');
    const user = JSON.parse(localStorage.getItem('user'));
    const userId = user._id;

    useEffect(() => {
        if(search.length > 0){
        const filtered = fixedtrials.filter((clinicaltrial) => {
            if (clinicaltrial.name.toLowerCase().includes(search.toLowerCase())){
                return clinicaltrial
            }
        })
        setClinicalTrials(filtered)
    }else {
        setClinicalTrials(fixedtrials)
    }
    },[search])
    const getClinicalTrials = (query) => {
        axios.get(`${BACKEND_ENDPOINT}/clinicaltrials/getAll/${userId}`)
        .then((result) => {
              const rows = [];
              console.log(result.data);
              result.data.map(d => {
                rows.push(d)
              })
              setClinicalTrials(rows);
              setFixedtrials(rows);
          }
        )
        .catch(err=> console.log(err))
      }
    useEffect(() => {
        const query = {}
        getClinicalTrials(query)
    },[])
  return (
    <div className='flex'>
         <NewClinicalTrailDialog setOpenpopup={setOpenpopup} open={open} setOpen={setOpen} setAlertMessage={setAlertMessage} setClinicalTrials={setClinicalTrials}/>
        <div>
            <Sidebar/>
        </div>

        <div style={{flex:1, height:'90vh'}} className='bg-gray-200'>
            
            <div className='flex justify-between'>
                <div style={{backgroundImage:`url(${background})`,flex:1}}>
                    
                    <div className='m-5 flex justify-between'>
                            <div>
                                <p>Clinical Trials created by you :</p>
                            </div>
                            <div>
                                <Button onClick={() => {
                                    setOpen(true)
                                }} className='bg-blue-500'>Create New Clinical Trial</Button>
                            </div>
                    </div>

                    <div className='m-5'>
                        <Searchbar search={search} setSearch={setSearch}/>
                    </div>
                </div>
            
            </div>
            <div className='p-5' style={{flex:1, overflowY:'scroll', height: '70vh',display: 'flex'}}>
                {
                    clinicalTrials ? 
                <Grid container spacing={2}>
                    {
                        clinicalTrials?.map((clinicaltrial) => {
                            return (
                                <Grid item xs={12} sm={4}>
                                    <Link to={`/clinicaltrial/${clinicaltrial._id}?data=${encodeURIComponent(JSON.stringify(clinicaltrial))}`}><ClinicaltrialCard onClick={() => {

                                    }} data={clinicaltrial}/></Link>
                                </Grid>
                            )
                        })
                    }
                </Grid> :
                <div style={{display:'flex',justifyContent:'center',alignItems:'center',flex:1}}>
                    <Spinner className="h-12 w-12"  color="blue"/>
                </div>

                }
            </div>
        </div>
    </div>
  )
}