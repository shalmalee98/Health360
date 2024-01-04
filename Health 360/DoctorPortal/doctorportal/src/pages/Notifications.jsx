import * as React from 'react';
import Divider from '@mui/material/Divider';
import { useEffect } from 'react';
import axios from 'axios';
import CheckCircleOutlineRoundedIcon from '@mui/icons-material/CheckCircleOutlineRounded';
import DeleteIcon from '@mui/icons-material/Delete';
// import { Button, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle, IconButton, MenuItem, Select, TextField, Toolbar, Tooltip } from '@mui/material';
import AddCircleOutlineRoundedIcon from '@mui/icons-material/AddCircleOutlineRounded';
import {
    List,
    ListItem,
    ListItemPrefix,
    Avatar,
    Card,
    Typography,
    Tooltip,
    IconButton,
    Dialog,
    DialogHeader,
    DialogBody,
    Input,
    Select,
    MenuItem,
    DialogFooter,
    Button,
    Option
  } from "@material-tailwind/react";
import { BACKEND_ENDPOINT } from '../constants';
import Sidebar from '../Components/Sidebar';

export default function Notifications(props) {
    const {message, type} = props;
    const [notificationsList, setNotificationsList] = React.useState([]);
    const [openDialog, setOpenDialog] = React.useState(false);
    const [notificationTitle, setNotificationTitle] = React.useState('');
    const [notificationDescription, setNotificationDescription] = React.useState('');
    const [userGroups, setUserGroups] = React.useState([]);
    const [recipientUserGroup, setRecipientUserGroup] = React.useState('');
    const [clinicalTrialList, setClinicalTrialList] = React.useState([]);
    const [clinicalTrialId, setClinicalTrialId] = React.useState('');
    const [questionnaireList, setQuestionnaireList] = React.useState([]);
    const [questionnaireId, setQuestionnaireId] = React.useState('');
    const createNotification = async() => {
        try{
            const userGroupId = recipientUserGroup;
            console.log('User group: ', recipientUserGroup)
            const user = localStorage.getItem('user');
            console.log('user: ', user)
            const createdBy = JSON.parse(user)._id;
            let userGroup = userGroups.filter((item) => {
                console.log(item);
                return item._id == userGroupId;
            });
            console.log('user group is: ', userGroup)
            console.log('User id: ', createdBy)
            const recipientUserId = userGroup[0].usersList;
            console.log('recipient user ids list: ', recipientUserId)
            const body = {
                createdBy,
                notificationTitle,
                notificationDescription,
                recipientUserId,
                userGroupId
            };
            console.log(body)
            const res = await axios.post(`${BACKEND_ENDPOINT}/notifications/add`, body);
            if(res.status = 200) {
                console.log('request is successful')
                setOpenDialog(false);
            }

        } catch(err){
            console.log(err);
        }

    }

    const getNotificationsByUser = (query) => {
        axios.get(`${BACKEND_ENDPOINT}/notifications/getByUser?`+ query )
        .then((result) => {
                let data = [];
                console.log('Did we get a result? ', result);
                result.data.map(row => {
                    console.log('one row:', row)
                    data.push({id: row._id, notificationTitle: row.notificationTitle, notificationDescription: row.notificationDescription, timeStamp: row.timeStamp, createdBy: row.createdBy, isRead: row.isRead});
                })
                console.log('print rows: ', data);
                setNotificationsList(data);
            }
        ).catch(err=> console.log(err))
    }

    const ReadNotification = (id) => {
        console.log('ID: ', id)
        const query = new URLSearchParams({id});
        axios.put(`${BACKEND_ENDPOINT}/notifications/readNotification?`+ query)
        .then((result) => {
            window.location.reload();
        }
    ).catch(err=> console.log(err))
    }

   const getAllUserGroups = () => {
        axios.get(`${BACKEND_ENDPOINT}/usergroups/getAll` )
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
            // setAlertMessage(err.message);
            // setOpenAlert(true);
            }
        )
    }

    const getAllClinicalTrials = () => {
        const user = new URLSearchParams(JSON.parse(localStorage.getItem("user"))._id);
        axios.get(`${BACKEND_ENDPOINT}/clinicaltrials/getAll?`+ user)
        .then((result) => {
                const rows = [];
                console.log(result.data);
                result.data.map(d => {
                rows.push(d)
                })
                setClinicalTrialList(rows);
            }
        )
        .catch(err=> 
            {
                console.log(err);
            }
        )
    }

    const getQuestionnairesByClinicalTrial = async (clinicalTrialId) => {
        if(clinicalTrialId!= '') {
            try{
                const response = await axios.post(`${BACKEND_ENDPOINT}/questionnaires/getByClinicalTrial`,{ "clinicalTrialId": clinicalTrialId});
                setQuestionnaireList(response.data);
            }
            catch(err)
            {
                console.log(err);
            }
            
        }
    }

    const DeleteNotification = async( id ) => {
        const query = new URLSearchParams({id: id});
        if(id!= '') {
            try{
                const response = await axios.delete(`${BACKEND_ENDPOINT}/notifications/deleteById?`+query)
                console.log(response)
                if(response.status == 201){
                    const user = localStorage.getItem('user');
                    const query = new URLSearchParams({userId: JSON.parse(user)._id});
                    getNotificationsByUser(query);
                }
            }
            catch(err)
            {
                console.log(err);
            }
            
        }
    }

    useEffect(() => {
        const user = localStorage.getItem('user');
        console.log(user)
        if(user){
            const query = new URLSearchParams({userId: JSON.parse(user)._id});
            getNotificationsByUser(query);
            getAllUserGroups();
            getAllClinicalTrials();
            // getQuestionnairesByClinicalTrial();
        }
      }, []);
      
  return (
    <div className='flex'>

        <div>
            <Sidebar/>
        </div>

        <div style={{flex:1, height:'90vh',backgroundColor:'#e5e5e5'}}>
            <div style={{display: 'flex', flexDirection: "column", alignItems: 'flex-end'}}>
            <Button style={{margin:'10px'}} onClick={() => {
                        setOpenDialog(true)
                    }} className='bg-blue-500'>Create New Notification</Button>
            
            </div>
            <Dialog open={openDialog} onClose={()=>  {
                setQuestionnaireList([]);
                setOpenDialog(false);
            }}>
            <DialogHeader>Create Notification</DialogHeader>
            <DialogBody>
                Create a notification by entering the following fields
                <div className='m-5'>
                    <Input
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
                </div>

                <div className='m-5'>
                    <Input
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
                </div>

                <div className='m-5'>
                    <Select
                    labelId="Recipient User Group Select"
                    id="demo-simple-select"
                    value={recipientUserGroup}
                    label='Select Recipient User Group'
                    selected={(element)=> {
                        if (element) {
                            const selectedValue = element.props.value;
                            setRecipientUserGroup(selectedValue)
                          return element.props.name;
                          }
                    }}
                    fullWidth
                    >
                        {userGroups.map((data) => {
                            return <Option value={data._id} name={data.groupName}>{data.groupName}</Option>
                        })}
                    </Select>
                </div>

                <div className='m-5'>

                <Select
                labelId="Select Clinical Trial"
                value={clinicalTrialId}
                label='Select Clinical Trial'
                selected={(element)=> {
                    if (element) {
                        const selectedValue = element.props.value;
                        setClinicalTrialId(selectedValue);
                        getQuestionnairesByClinicalTrial(selectedValue);
                        return element.props.name;
                      }
                }}
                fullWidth
                >
                {clinicalTrialList.map((data) => {
                    return <Option value={data._id} name={data.name}>{data.name}</Option>
                })}
                </Select>

                </div>
                { clinicalTrialId!= '' ? 
                <div className='m-5'>
                    <Select
                    labelId="Select Questionnaire"
                    id="demo-simple-select"
                    value={questionnaireId}
                    label='Select Questionnaire'
                    selected={(element)=> {
                        if (element) {
                            const selectedValue = element.props.value;
                            setQuestionnaireId(selectedValue)
                            return element.props.name;
                          }
                    }}
                    fullWidth
                    >
                        {questionnaireList.map((data) => {
                            return <Option value={data._id} name={data.name}>{data.name}</Option>
                        })}
                    </Select> 
                    </div>
                : null}
            </DialogBody>
            <DialogFooter>
            <Button className='bg-blue-500 mr-3' onClick={()=> {
                setQuestionnaireList([]);
                setOpenDialog(false);
            }}>Cancel</Button>
            <Button className='bg-blue-500' onClick={createNotification}>Submit</Button>
            </DialogFooter>
            </Dialog>
            <div style={{ overflowY:'scroll',height:'80vh',margin:'0px 20px'}}>
                <List sx={{ bgcolor: 'background.paper' }} style={{padding: '0px'}}>
                    {notificationsList.map(notification => {
                                return <ListItem style={{backgroundColor: notification.isRead ? 'rgb(33 150 243 / 0.5)' : 'white', border: 'solid', borderBlockColor: 'white', borderLeftColor: 'white', borderRightColor: 'white', borderRadius:'20px'}}>
                                <ListItemPrefix>
                                    <Avatar variant="circular" alt="emma" src="https://docs.material-tailwind.com/img/face-3.jpg" />
                                </ListItemPrefix>
                                <div style={{width: '100%'}}>
                                    <Typography variant="h6" color="blue-gray" style={{display: 'flex', flexDirection: "row", justifyContent:"space-between"}}>
                                        {notification.notificationTitle}
                                        <IconButton className='mt-2 bg-blue-500' onClick={() => DeleteNotification(notification.id)}><DeleteIcon/></IconButton>
                                    </Typography>
                                    <Typography variant="small" color="gray" className="font-normal" style={{display: 'flex', flexDirection: "row", justifyContent:"space-between"}}>
                                        {notification.notificationDescription}
                                        {!notification.isRead ? <IconButton className='mt-2 bg-blue-500' onClick={() => ReadNotification(notification.id)}><CheckCircleOutlineRoundedIcon/></IconButton> : null}
                                    </Typography>
                                </div>
                                </ListItem>

                            //     <ListItem alignItems="flex-start" style={{backgroundColor: notification.isRead ? 'cadetblue' : 'white', border: 'solid', borderBlockColor: 'white', borderLeftColor: 'white', borderRightColor: 'white'}}>
                            //     <ListItemAvatar>
                            //     <Avatar alt="User" src="/static/images/avatar/1.jpg" />
                            //     </ListItemAvatar>
                            //     <ListItemText
                            //     primary={ <div style={{
                            //         display: 'flex',
                            //         alignItems: 'flex-start',
                            //         justifyContent: 'space-between'
                            //       }}>
                            //     <Typography
                            //         // sx={{ display: 'flex' }}
                            //         component="span"
                            //         variant="body2"
                            //         color="text.primary"
                            //     >
                            //         {notification.notificationTitle}
                            //     </Typography>
                            //     <IconButton onClick={() => DeleteNotification(notification.id)}><DeleteIcon/></IconButton>
                            //     {/* {notification.notificationDescription} */}
                            //     </div>}
                            //     secondary={
                            //         <div style={{
                            //             display: 'flex',
                            //             alignItems: 'flex-start',
                            //             justifyContent: 'space-between'
                            //           }}>
                            //         <Typography
                            //             // sx={{ display: 'flex' }}
                            //             component="span"
                            //             variant="body2"
                            //             color="text.primary"
                            //         >
                            //             {notification.notificationDescription}
                            //         </Typography>
                            //         {!notification.isRead ? <IconButton onClick={() => ReadNotification(notification.id)}><CheckCircleOutlineRoundedIcon/></IconButton> : null}
                            //         {/* {notification.notificationDescription} */}
                            //         </div>
                            //     }
                            //     />
                            //     <Divider variant="inset" component="li" />
                            // </ListItem>
                            
                    })}
                
                <Divider variant="inset" component="li" />
                
                </List>
            </div>
        </div>

    </div>
  );
}