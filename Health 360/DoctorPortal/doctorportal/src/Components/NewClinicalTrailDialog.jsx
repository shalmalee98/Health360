import * as React from 'react';
import PropTypes from 'prop-types';
import Button from '@mui/material/Button';
import Avatar from '@mui/material/Avatar';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemAvatar from '@mui/material/ListItemAvatar';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import DialogTitle from '@mui/material/DialogTitle';
import Dialog from '@mui/material/Dialog';
import PersonIcon from '@mui/icons-material/Person';
import AddIcon from '@mui/icons-material/Add';
import Typography from '@mui/material/Typography';
import { blue } from '@mui/material/colors';
import { DialogActions, Select, TextField, MenuItem, InputLabel } from '@mui/material';
import {Grid} from '@mui/material';
import { useState } from 'react';
import { BACKEND_ENDPOINT } from '../constants';
import SelectOption from './SelectOption';
import axios from 'axios';
import { useEffect } from 'react';
import Popup from './Popup';

const emails = ['username@gmail.com', 'user02@gmail.com'];

function SimpleDialog(props) {
  const { onClose, selectedValue, open, setOpen, setOpenAlert, setAlertMessage, setClinicalTrials,setOpenpopup } = props;

  const handleClose = () => {
    onClose(selectedValue);
  };

  const handleListItemClick = (value) => {
    onClose(value);
  };

  const [name,setName] = useState("");
  const [description, setDescription] = useState("");
  const [volunteerDetails, setVolunteerDetails] = useState("");
  const [options,setOptions] = useState([]);
  const [usersList, setUsersList] = useState([]);

  const getClinicalTrials = (query) => {
    const userId = JSON.parse(localStorage.getItem('user'))._id;
    axios.get(`${BACKEND_ENDPOINT}/clinicaltrials/getAll/${userId}`)
    .then((result) => {
          const rows = [];
          console.log(result.data);
          result.data.map(d => {
            rows.push(d)
          })
          setClinicalTrials(rows);
      }
    )
    .catch(err=> console.log(err))
  }

  async function getGlobalUserGroups() {
    try {
      const user = JSON.parse(localStorage.getItem('user'));
      const userId = user._id;
      console.log(userId);
      const response = await axios.get(`${BACKEND_ENDPOINT}/usergroups/getGlobal/${userId}`)
      console.log("I am here")
      console.log(response.data)
      setOptions(response.data);
    }catch (e) {
      console.log(e)
    }

  }

  useEffect(() => {
    console.log("I am in useEffect of Global User groups");
    getGlobalUserGroups();
  },[])

  useEffect(() => {
    console.log("I am at userslist "+usersList);
  },[usersList])

  async function handleSubmit(){
    const user = JSON.parse(localStorage.getItem('user'));
    console.log(user);
    const config = { headers: { 'Content-Type': 'application/json'} }
    const content = {
        createdBy: user._id,
        name: name,
        description: description,
        usersList:usersList,
        volunteerDetails: volunteerDetails,
    }
    const response = await axios.post(`${BACKEND_ENDPOINT}/clinicaltrials/add`, content, config)
    console.log(response.data)
    setOpenpopup(true)
    getClinicalTrials();
    setName("");
    setDescription("");
    setVolunteerDetails("");
    setAlertMessage(`Clinical Trial ${name} added successfully!`);
    setOpen(false)
  } 

  return (
    <Dialog onClose={handleClose} open={open}>
      <DialogTitle>Create New Clinical Trail</DialogTitle>
      <Grid container spacing={2} justifyContent="center" alignItems="center" padding={10}>
        <Grid xs={12} item>
            <TextField fullWidth value={name} onChange={(e) => {
                setName(e.target.value);
            }} label="Clinical Trail Name"/>
        </Grid>
        <Grid xs={12} item>
            <TextField value={description} onChange={(e) => {
                setDescription(e.target.value)
            }} fullWidth label="Clinical Trail Description"/>
        </Grid>
        <Grid xs={12} sm={12} item>
            <SelectOption setUsersList={setUsersList} options={options}/>
            <p className='text-blue-500'>*By default global users who accepted enrolling in clinicaltrails will be there you can change the user group (It's mandatory to select one global user group)</p>
        </Grid>
        <Grid xs={12} item>
            <TextField value={volunteerDetails} onChange={(e) => {
                setVolunteerDetails(e.target.value)
            }} fullWidth label="Volunteer Benifits"/>
        </Grid>
        <Grid xs={12} item>
            <Button onClick={() => {
                handleSubmit();
            }} fullWidth variant='contained'>Add New Trail</Button>
        </Grid>
      </Grid>
    </Dialog>
  );
}

SimpleDialog.propTypes = {
  onClose: PropTypes.func.isRequired,
  open: PropTypes.bool.isRequired,
  selectedValue: PropTypes.string.isRequired,
};

export default function NewClinicalTrailDialog(props) {
  const {open,setOpen, setOpenAlert, setAlertMessage, setClinicalTrials, setOpenpopup} = props;
  const [selectedValue, setSelectedValue] = React.useState(emails[1]);

  const handleClickOpen = () => {
    setOpen(true);
  };

  

  const handleClose = (value) => {
    setOpen(false);
    setSelectedValue(value);
  };

  return (
    <div>
      <SimpleDialog
        selectedValue={selectedValue}
        open={open}
        setOpen={setOpen}
        onClose={handleClose}
        setOpenalert={setOpenAlert}
        setOpenpopup={setOpenpopup}
        setClinicalTrials={setClinicalTrials}
        setAlertMessage={setAlertMessage}
      />
    </div>

  );
}
