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

export default function AddMember(props) {
  const { open, setOpen, id } = props;
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [subgroupname, setSubgroupname] = useState("");
  const [subgroupdesc, setSubgroupdesc] = useState("");
  const [maxWidth, setMaxWidth] = React.useState('md');

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setSubgroupname("");
    setSubgroupdesc("");
    setOpen(false);
  };

  const addMember = async () => {
    try {
        const globalUser = JSON.parse(localStorage.getItem('user'));
        const response = await axios.post(`${BACKEND_ENDPOINT}/usergroups/addMember`,{
            subgroupId: id,
            usersList: selectedUsers
        });
        console.log(response)
        window.location.pathname = "/";
    }
    catch (e){
        console.log(e);
    }
  }

  return (
    <React.Fragment>
      <Dialog fullWidth={true} maxWidth={maxWidth} open={open} onClose={handleClose}>
        <DialogTitle>Add New Memeber to Sub Group</DialogTitle>
        <DialogContent>
          <DialogContentText>
            <div className='flex justify-between'>
                <div>
                    You can Add new Memeber to the exsisting Sub Group
                </div>
                <div>
                    <Button onClick= {() => {
                        addMember();
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
