import React, { useEffect } from 'react'
import { UsergroupCard } from '../Components/UsergroupCard'
import Sidebar from '../Components/Sidebar'
import { Button } from '@material-tailwind/react'
import Searchbar from '../Components/Searchbar'
import { useParams } from 'react-router-dom'
import axios from 'axios'
import { Grid } from '@mui/material'
import { useState } from 'react'
import { BACKEND_ENDPOINT } from '../constants'
import CreateUserGroupDialog from '../Components/CreateUserGroupDialog'
import {
    Typography,
  } from "@material-tailwind/react";
import GroupMemberDialog from '../Components/GroupMemberDialog'
import background from '../assets/back.jpeg'

export default function GlobalUserGroups() {

    const {id} = useParams();
    const [userGroups, setUserGroups] = useState([])
    const [open,setOpen] = useState(false);
    const [search,setSearch] = useState("");
    console.log(id);

    const getGlobalUserGroup = async (query) => {
        const user = JSON.parse(localStorage.getItem('user'));
        const userId = user._id;
        console.log(userId);
        //onst response = await axios.get(`${BACKEND_ENDPOINT}/usergroups/getGlobal/${userId}`);
        axios.get(`${BACKEND_ENDPOINT}/usergroups/getGlobal/${userId}`)
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

        getGlobalUserGroup();
    
    },[])
  return (
    <div  className='flex bg-gray-300'>
        <CreateUserGroupDialog open={open} setOpen={setOpen}/>
        <div>
            <Sidebar/>
        </div>
        <div style={{flex:1}}>
            

            <div className='flex justify-between'>
                <div style={{backgroundImage:`url(${background})`,flex:1}}>
                <div className='m-5 flex justify-between'>
                        <div>
                            <p>Global User Groups:</p>
                        </div>
                        <div>
                            <Button onClick={() => {
                                setOpen(true)
                            }} className='bg-blue-500'>Create New Global User Group</Button>
                        </div>
                </div>
                <div className='m-5'>
                    <Searchbar/>
                </div>
            </div>


                {/* <div className='flex justify-between'>
                    <div className='m-5'>
                    <Typography style={{ fontFamily: "Poppins, sans-serif" }}  variant="h5" color="blue-gray" className="mb-2">
                        The Global User Groups
                    </Typography>
                    </div>
                <div  className='m-5'> 
                        <Button onClick={() => {
                            setOpen(true)
                        }} className='bg-blue-500 text-right' style={{ fontFamily: "Poppins, sans-serif" }}>New Global Sub Group</Button>
                    </div>
                </div>
                <div className='m-5 mt-2'>
                    <Searchbar/>
                </div> */}
            </div>
            <div className='m-5' style={{flex:1, overflowY:'scroll', height:'65vh'}}>
                <Grid spacing={2} container>
                    {
                        userGroups.map((usergroup) => {
                            return (
                                <>
                                <Grid item sm={3} xs={12}>
                                    <UsergroupCard data={usergroup}/>
                                </Grid>
                                </>
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
