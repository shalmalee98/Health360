import React from 'react'
import { useState, useEffect } from 'react';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../constants';
import { Button, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle, IconButton, MenuItem, Select, TextField, Toolbar, Tooltip } from '@mui/material';

export default function NotificationDialog(props) {
    const {open,setOpen, users, userGroupId} = props;
    const [notificationTitle,setNotificationTitle] = useState("");
    const [notificationDescription, setNotificationDescription] = useState("");
    const createNotification = async() => {
        try{
            const createdBy = JSON.parse(localStorage.getItem('user'))._id;
            let body;
            if (users.length > 0){
                const recipientUserId = users.map((user) => {
                    return (user._id);
                });
                body = {
                    createdBy,
                    notificationTitle,
                    notificationDescription,
                    recipientUserId
                }; 
            }
            else {
                body = {
                    createdBy,
                    notificationTitle,
                    notificationDescription,
                    userGroupId
                };
            }
            console.log(body)
            const response = await axios.post(`${BACKEND_ENDPOINT}/notifications/add`, body);
            if(response.status = 200) {
                console.log('request is successful')
                setOpen(false);
            }

        } catch(err){
            console.log(err);
        }

    }
  return (
    <Dialog open={open} onClose={()=>  {
        setQuestionnaireList([]);
        setOpen(false);
      }}>
    <DialogTitle>Create Notification</DialogTitle>
    <DialogContent>
      <DialogContentText>
        Create a notification by entering the following fields
      </DialogContentText>
      <TextField
        autoFocus
        margin="dense"
        id="title"
        label="Notification Title"
        type="notifTitle"
        fullWidth
        variant="standard"
        value={notificationTitle}
        onChange={e => setNotificationTitle(e.target.value)}
      />
      <TextField
        autoFocus
        margin="dense"
        id="title"
        label="Notification Description"
        type="notifDescription"
        fullWidth
        variant="standard"
        value={notificationDescription}
        onChange={e => setNotificationDescription(e.target.value)}
      />
    </DialogContent>
    <DialogActions>
      <Button onClick={()=> {
        setOpen(false);
      }}>Cancel</Button>
      <Button onClick={createNotification}>Submit</Button>
    </DialogActions>
  </Dialog>
  )
}
