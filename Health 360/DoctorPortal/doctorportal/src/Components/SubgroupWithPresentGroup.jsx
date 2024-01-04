import React from 'react'
import DialogTitle from '@mui/material/DialogTitle';
import Dialog from '@mui/material/Dialog';
import { Box } from '@mui/material';
import { TextField } from '@mui/material';
import { useState } from 'react';
import { Button } from '@material-tailwind/react';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../constants';

export default function SubgroupWithPresentGroup(props) {
    const {open,setOpen, users, clinicaltrial} = props;
    const [subgroupname, setSubgroupname] = useState("");
    const [subgroupdesc, setSubgroupdesc] = useState("");

    const createSubgroup = async () => {
        try {
            const userList = users.map((user) => {
                return user._id
            })
            const userId = JSON.parse(localStorage.getItem('user'))._id;
            if (clinicaltrial){
                const response = await axios.post(`${BACKEND_ENDPOINT}/usergroups/add`,{
                    groupName: subgroupname,
                    createdBy: userId,
                    groupDesc: subgroupdesc,
                    clinicalService: clinicaltrial,
                    usersList: userList,
                    type: "local"
                });
                console.log(response)
                setOpen(false)
                window.location.reload();
            }
            else {
            const response = await axios.post(`${BACKEND_ENDPOINT}/usergroups/add`,{
                groupName: subgroupname,
                groupDesc: subgroupdesc,
                createdBy: userId,
                usersList: userList,
                type: "global"
            });
            console.log(response)
            setOpen(false)
            window.location.reload();
        }
        }
        catch (e){
            console.log(e);
        }
    }

  return (
    <Dialog 
    fullWidth={true}
    onClose={() => [
        setOpen(false)
    ]} open={open}>
      <DialogTitle>Create New Sub Group</DialogTitle>
      <Box
            noValidate
            component="form"
            fullWidth
            sx={{
              display: 'flex',
              flexDirection: 'column',
              padding:5
            }}
          >
            {/* Subgroup Name */}
            <TextField
              id="subgroupName"
              value={subgroupname}
              onChange={(e) => {
                setSubgroupname(e.target.value)
              }}
              label="Subgroup Name"
              variant="outlined"
              margin='normal'
              required
              fullWidth
            />

            {/* Subgroup Description */}
            <TextField
              id="subgroupDescription"
              value={subgroupdesc}
              onChange={(e) => {
                setSubgroupdesc(e.target.value)
              }}
              label="Subgroup Description"
              variant="outlined"
              margin="normal"
              required
              fullWidth
              multiline
              rows={4}
            />
            <Button onClick={() => {
                createSubgroup()
            }} className='bg-blue-500'>Create Sub Group</Button>
          </Box>
    </Dialog>
  )
}
