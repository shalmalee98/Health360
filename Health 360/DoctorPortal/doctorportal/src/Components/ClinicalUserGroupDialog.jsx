import * as React from 'react';
import Box from '@mui/material/Box';
import { useState, useEffect } from 'react';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import { Button } from '@material-tailwind/react';
import { TextField } from '@mui/material';
import DataTable from './DataTable';
import UserMembersTable from './UserMembersTable';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../constants';
import Popup from './Popup';

export default function ClinicalUserGroupDialog(props) {
  const { open, setOpen, users, clinicaltrial,getUserGroupByClinicalTrial } = props;
  console.log(clinicaltrial)
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [popup,setPopup] = useState(false);  
  const [message,setMessage] = useState("User group created");
  const [subgroupname, setSubgroupname] = useState("");
  const [subgroupdesc, setSubgroupdesc] = useState("");
  const [maxWidth, setMaxWidth] = React.useState('xl');

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setSubgroupname("");
    setSubgroupdesc("");
    setOpen(false);
  };

  const createSubgroup = async () => {
    try {
        const userList = selectedUsers.map((user) => {
            return user._id
        })
        const userId = JSON.parse(localStorage.getItem('user'))._id;
        const query = new URLSearchParams({clinicalTrialId: clinicaltrial?._id});
        const response = await axios.post(`${BACKEND_ENDPOINT}/usergroups/add`,{
            groupName: subgroupname,
            createdBy: userId,
            groupDesc: subgroupdesc,
            usersList: userList,
            clinicalService: clinicaltrial?._id,
            type: "local"
        });
        console.log(response)
        setOpen(false)
        setPopup(true)
        getUserGroupByClinicalTrial(query);
        
    }
    catch (e){
        console.log(e);
    }
  }

  return (
    <React.Fragment>
      <Dialog fullWidth={true} maxWidth={maxWidth} open={open} onClose={handleClose}>
        <DialogTitle>Create Clinical Trial Sub Group</DialogTitle>
        <DialogContent>
          <DialogContentText>
            <div className='flex justify-between'>
                <div>
                    This Local Sub group that you are creating will be only accessed by this clinical trial
                </div>
                <div>
                    <Button onClick= {() => {
                        createSubgroup();
                    }} className='bg-blue-500'>Create</Button>
                </div>
            </div>
            <Popup open={popup} setOpen={setPopup} message={message}/>
          </DialogContentText>
          <Box
            noValidate
            component="form"
            fullWidth
            sx={{
              display: 'flex',
              flexDirection: 'column',
              m: 'auto',
            }}
          >
            <TextField
              id="subgroupName"
              value={subgroupname}
              onChange={(e) => {
                setSubgroupname(e.target.value)
              }}
              label="Subgroup Name"
              variant="outlined"
              margin="normal"
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

            <UserMembersTable users={clinicaltrial.userList} selectedUsers={selectedUsers} setSelectedUsers={setSelectedUsers}/>
          </Box>
        </DialogContent>
        <DialogActions>
          <Button className='bg-blue-500' onClick={handleClose}>Close</Button>
        </DialogActions>
      </Dialog>
    </React.Fragment>
  );
}
