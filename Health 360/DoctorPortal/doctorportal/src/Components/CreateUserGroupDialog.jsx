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
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../constants';

export default function CreateUserGroupDialog(props) {
  const { open, setOpen } = props;
  const [selectedUsers, setSelectedUsers] = useState([]);
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
        const globalUser = JSON.parse(localStorage.getItem('user'));
        const userList = selectedUsers.map((user) => {
            return user._id
        })
        const response = await axios.post(`${BACKEND_ENDPOINT}/usergroups/add`,{
            groupName: subgroupname,
            groupDesc: subgroupdesc,
            usersList: userList,
            type: "global",
            createdBy: globalUser._id
        });
        console.log(response)
        window.location.reload();
    }
    catch (e){
        console.log(e);
    }
  }

  return (
    <React.Fragment>
      <Dialog fullWidth={true} maxWidth={maxWidth} open={open} onClose={handleClose}>
        <DialogTitle>Create Global Sub Group</DialogTitle>
        <DialogContent>
          <DialogContentText>
            <div className='flex justify-between'>
                <div>
                    This Global sub group that you are creating can be accessed from every clinical trial
                </div>
                <div>
                    <Button onClick= {() => {
                        createSubgroup();
                        setOpen(false)
                    }} className='bg-blue-500'>Create</Button>
                </div>
            </div>
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
            {/* Subgroup Name */}
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

            <DataTable selectedUsers={selectedUsers} setSelectedUsers={setSelectedUsers}/>
          </Box>
        </DialogContent>
        <DialogActions>
          <Button className='bg-blue-500' onClick={handleClose}>Close</Button>
        </DialogActions>
      </Dialog>
    </React.Fragment>
  );
}
