import React, { useEffect } from 'react'
import { UsergroupCard } from '../Components/UsergroupCard'
import Sidebar from '../Components/Sidebar'
import { Button } from '@material-tailwind/react'
import Searchbar from '../Components/Searchbar'
import { useParams } from 'react-router-dom'
import axios from 'axios'
import { Grid } from '@mui/material'
import { useState } from 'react'
import { useLocation } from 'react-router-dom'
import { BACKEND_ENDPOINT } from '../constants'
import CreateUserGroupDialog from '../Components/CreateUserGroupDialog'
import background from '../assets/back.jpeg'
import ClinicalUserGroupDialog from '../Components/ClinicalUserGroupDialog'

export default function Usergroups() {

    const {id} = useParams();
    const location = useLocation();
    const clinicaltrial = location.state;
    const [search,setSearch] = useState("");
    const [open,setOpen] = useState(false)
    console.log(clinicaltrial)
    const [userGroups, setUserGroups] = useState([])

    const getUserGroupByClinicalTrial = (query) => {
        axios.get(`${BACKEND_ENDPOINT}/usergroups/getByClinicalTrial?`+ query )
        .then((result) => {
              const rows = [];
              console.log(result.data);
              result.data.map(d => {
                rows.push(d)
              })
              setUserGroups(rows);
          }
        )
        .catch(err=> 
          {
            console.log(err);
            setAlertMessage(err.message);
            setOpenAlert(true);
          }
        )
      }
    useEffect(() => {
        console.log('pathname: ', location.pathname)

        const clinicalTrialId = id;
        console.log('what is coming in from the navigation link', clinicalTrialId);
        if(location!= null){
          const query = new URLSearchParams({clinicalTrialId: clinicalTrialId});
          getUserGroupByClinicalTrial(query)
        } else {
          console.log('id is empty')
        }
    
    },[])
  return (
    <div  className='flex bg-gray-300'>
        <div>
            <Sidebar clinicaltrialId={clinicaltrial?._id} clinicaltrial={clinicaltrial} />
        </div>
        <div style={{flex:1}}>
        <div className='flex justify-between'>
                <div style={{backgroundImage:`url(${background})`,flex:1}}>
                    
                    <div className='m-5 flex justify-between'>
                            <ClinicalUserGroupDialog open={open} setOpen={setOpen} clinicaltrial={clinicaltrial}/>
                            <div>
                                <p>Usergroups you created will be accesed only by this Clinical Trial :</p>
                            </div>
                            <div>
                                <Button onClick={() => {
                                    setOpen(true)
                                }} className='bg-blue-500'>Create New User Group</Button>
                            </div>
                    </div>

                    <div className='m-5'>
                        <Searchbar search={search} setSearch={setSearch}/>
                    </div>
                </div>
            
            </div>
            <div className='m-5' style={{flex:1}}>
                <Grid spacing ={2} container>
                    {
                        userGroups.map((usergroup) => {
                            return (
                                <Grid item sm={3} xs={12}>
                                    <UsergroupCard data={usergroup} clinicaltrial={id}/>
                                </Grid>
                            )
                        })
                    }

                   
                    <Grid item>

                    </Grid>
                </Grid>

            </div>
            {/* <div style={{overflowY:'scroll', maxHeight: '70vh' }}>
                <div className='flex gap-5 m-5'>
                    <div>
                        <UsergroupCard/>
                    </div>
                    <div>
                        <UsergroupCard/>
                    </div>
                    <div>
                        <UsergroupCard/>
                    </div>
                </div>
                <div className='flex gap-5 m-5'>
                    <div>
                        <UsergroupCard/>
                    </div>
                    <div>
                        <UsergroupCard/>
                    </div>
                    <div>
                        <UsergroupCard/>
                    </div>
                </div>
                <div className='flex gap-5 m-5'>
                    <div>
                        <UsergroupCard/>
                    </div>
                    <div>
                        <UsergroupCard/>
                    </div>
                    <div>
                        <UsergroupCard/>
                    </div>
                </div>
            </div> */}
        </div>
    </div>
  )
}
