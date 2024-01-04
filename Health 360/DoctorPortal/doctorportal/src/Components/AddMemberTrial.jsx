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

export default function AddMemberTrial(props) {
  const { open, setOpen, clinicaltrial } = props;
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [subgroupname, setSubgroupname] = useState("");
  const [subgroupdesc, setSubgroupdesc] = useState("");
  const [maxWidth, setMaxWidth] = React.useState('md');

  const handleClose = () => {
    setOpen(false);
  };

  const addMember = async () => {
    try {
        const globalUser = JSON.parse(localStorage.getItem('user'));
        const response = await axios.post(`${BACKEND_ENDPOINT}/clinicaltrials/addMember`,{
            clinicaltrialId: clinicaltrial._id,
            users: selectedUsers
        });
        console.log(response)
        setOpen(false)
        window.location.reload();
    }
    catch (e){
        console.log(e);
    }
  }

  return (
    <React.Fragment>
      <Dialog fullWidth={true} maxWidth={maxWidth} open={open} onClose={handleClose}>
        <DialogTitle>Add New Memeber to {clinicaltrial.name} trial</DialogTitle>
        <DialogContent>
          <DialogContentText>
            <div className='flex justify-between'>
                <div>
                    You can Add new Memeber to Clinical Trial {clinicaltrial.name}
                </div>
                <div>
                    <Button onClick= {() => {
                        setOpen(false)
                        addMember();
                    }} className='bg-blue-500'>Add Member</Button>
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
