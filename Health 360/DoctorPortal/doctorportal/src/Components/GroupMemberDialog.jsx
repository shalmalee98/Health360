import * as React from 'react';
import Box from '@mui/material/Box';
import { useState, useEffect } from 'react';
import Dialog from '@mui/material/Dialog';
import GroupIcon from '@mui/icons-material/Group';
import DialogActions from '@mui/material/DialogActions';
import DeleteIcon from '@mui/icons-material/Delete';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import { Button } from '@material-tailwind/react';
import UserMembersTable from './UserMembersTable';
import SubgroupWithPresentGroup from './SubgroupWithPresentGroup';
import {
    MagnifyingGlassIcon,
    ChevronUpDownIcon,
    UserPlusIcon,
  } from "@heroicons/react/24/outline";
  import { PencilIcon } from "@heroicons/react/24/solid";
import NotificationsNoneIcon from '@mui/icons-material/NotificationsNone';
import {
    Card,
    CardHeader,
    Input,
    Typography,
    CardBody,
    Chip,
    CardFooter,
    Tabs,
    TabsHeader,
    Tab,
    Avatar,
    IconButton,
    Tooltip,
  } from "@material-tailwind/react";
import { TextField } from '@mui/material';
import DataTable from './DataTable';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../constants';
import NotificationDialog from './NotificationDialog';
import AddMember from './AddMember';

export default function GroupMemberDialog(props) {
  const { open, setOpen, id,clinicaltrial, groupName, groupDesc } = props;
  const [users,setUsers] = useState([]);
  const [addmem, setAddmem] = useState(false);
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [subgroupname, setSubgroupname] = useState("");
  const [subgroupdesc, setSubgroupdesc] = useState("");
  const [maxWidth, setMaxWidth] = React.useState('xl');
  const[subOpen, setSubOpen] = useState(false);
  const [notOpen, setNotOpen] = useState(false);

  const getUsers = async () => {
    const response = await axios.get(`${BACKEND_ENDPOINT}/usergroups/getUsersByGroup?userGroupId=${id}`)
    console.log(response.data)
    setUsers(response.data)
  }

  const deleteUsers = async () => {
    const response = await axios.post(`${BACKEND_ENDPOINT}/usergroups/deleteMember`, {
      users: selectedUsers,
      subgroupId: id,
      clinicaltrailId: clinicaltrial 
    });
    console.log(response);
    window.location.reload();
  }

  useEffect(() => {
    if(id){
        getUsers();
    }
  },[])

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
        const response = await axios.post(`${BACKEND_ENDPOINT}/usergroups/add`,{
            groupName: subgroupname,
            groupDesc: subgroupdesc,
            usersList: userList,
            type: "global"
        });
        console.log(response)
    }
    catch (e){
        console.log(e);
    }
  }


  return (
    <React.Fragment>
      <Dialog fullWidth={true} maxWidth={maxWidth} open={open} onClose={handleClose}>
        <DialogTitle>{groupName}</DialogTitle>
        <DialogContent>
          <AddMember id={id} open={addmem} setOpen={setAddmem}/>
          <DialogContentText>
            <div className='flex justify-between'>
                <div>
                    {groupDesc}
                </div>
                {/* <div>
                    <Button onClick= {() => {
                        createSubgroup();
                    }} className='bg-blue-500'>Create</Button>
                </div> */}
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

<Card className="h-full w-full" >
      <CardHeader floated={false} shadow={false} className="rounded-none">
        <div className="mb-8 flex items-center justify-between gap-8">
          <div>
            <Typography style={{fontFamily:'"Poppins", Arial, sans-serif'}}  variant="h5" color="blue-gray">
              Members list
            </Typography>
            <Typography style={{fontFamily:'"Poppins", Arial, sans-serif'}} color="gray" className="mt-1 font-normal">
              See information about all members
            </Typography>
          </div>
          <div className="flex shrink-0 flex-col gap-2 sm:flex-row">
            {
                selectedUsers.length > 0 && (<><Button onClick={() => {
                  deleteUsers();
              }} variant='outlined' style={{fontFamily:'"Poppins", Arial, sans-serif'}} size="sm">
             <DeleteIcon variant='outlined'/>
                  Delete Users
          </Button><Button onClick={() => {
                    setSubOpen(true)
                }} className='bg-blue-500' style={{fontFamily:'"Poppins", Arial, sans-serif'}} size="sm">
                <GroupIcon/>
                    Create a New Sub Group
            </Button>
            
            </>)
            }
            <SubgroupWithPresentGroup users={selectedUsers} open={subOpen} setOpen={setSubOpen} clinicaltrial={clinicaltrial} />
            <NotificationDialog open={notOpen} setOpen={setNotOpen} users={selectedUsers} userGroupId={id}/>
            <Button onClick={() => {
                setNotOpen(true)
            }} style={{fontFamily:'"Poppins", Arial, sans-serif'}} variant="outlined" size="sm">
                <NotificationsNoneIcon/>
              Send Notifications
            </Button>
            <Button onClick={() => {setAddmem(true)}} className="flex items-center gap-3 bg-blue-500" size="sm">
              <UserPlusIcon strokeWidth={2} className="h-4 w-4" /> Add member
            </Button>
            
          </div>
        </div>
        {/* <div className="flex flex-col items-center justify-between gap-4 md:flex-row">
          <div className="w-full md:w-72">
            <Input
              label="Search"
              icon={<MagnifyingGlassIcon className="h-5 w-5" />}
            />
          </div>
        </div> */}
        <div style={{marginTop:'10px',height: '65vh', overflowY:'scroll'}} className="mt-5 border-2 shadow-lg">
            <UserMembersTable users={users} selectedUsers={selectedUsers} setSelectedUsers={setSelectedUsers}/>
       </div>
      </CardHeader>
      
    </Card>
            {/* Subgroup Name */}
            </Box>
        </DialogContent>
        <DialogActions>
          <Button className='bg-blue-500' onClick={handleClose}>Close</Button>
        </DialogActions>
      </Dialog>
    </React.Fragment>
  );
}
