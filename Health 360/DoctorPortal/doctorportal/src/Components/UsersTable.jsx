import React, { useEffect } from "react";
import { useState } from "react";
import axios from "axios";
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import AddMemberTrial from "./AddMemberTrial";
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
  Button,
  CardBody,
  Chip,
  CardFooter,
  Avatar,
  IconButton,
  Tooltip,
} from "@material-tailwind/react";
import UserMembersTable from "./UserMembersTable";
import { BACKEND_ENDPOINT } from "../constants";
import UserIdsTable from "./UserIdsTable";


export function UsersTable(props) {
  const {clinicaltrial,page} = props;
  const [filter, setFilter] = React.useState("all");
  const [value,setValue] = useState(0);
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [checkedRows, setCheckedRows] = React.useState([]);
  const [enrolled,setEnrolled] = useState([]);
  const [rejected,setRejected] = useState([]);
  const [notresponded, setNotResponded] = useState([]);
  const [addmem,setAddmem] = useState(false);

  const getUsersData = async () => {
    const enrolledUsers = await axios.post(`${BACKEND_ENDPOINT}/usergroups/getUsersByGroupName`,{
      userGroupName: `${clinicaltrial.name} Subscribed`
    });
    setEnrolled(enrolledUsers.data)

    const rejectedUsers = await axios.post(`${BACKEND_ENDPOINT}/usergroups/getUsersByGroupName`,{
      userGroupName: `${clinicaltrial.name} Non-Subscribed`
    });
    setRejected(rejectedUsers.data)


    const notrespondedUsers = await axios.post(`${BACKEND_ENDPOINT}/usergroups/getUsersByGroupName`,{
      userGroupName: `${clinicaltrial.name} Not Responded`
    });
    setNotResponded(notrespondedUsers.data)
  }


  useEffect(() => {
    getUsersData();
  },[])


  

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };
  

  const handleFilterChange = (value) => {
    setFilter(value);
  };

  const handleCheckAll = () => {
    const allRows = TABLE_ROWS.map((row, index) => index);
    setCheckedRows(allRows);
  };

  const handleRowCheck = (index) => {
    if (checkedRows.includes(index)) {
      setCheckedRows(checkedRows.filter((rowIndex) => rowIndex !== index));
    } else {
      setCheckedRows([...checkedRows, index]);
    }
  };

  function CustomTabPanel(props) {
    const { children, value, index, ...other } = props;
  
    return (
      <div
        role="tabpanel"
        hidden={value !== index}
        id={`simple-tabpanel-${index}`}
        aria-labelledby={`simple-tab-${index}`}
        {...other}
      >
        {value === index && (
          <Box sx={{ p: 3 }}>
            <Typography>{children}</Typography>
          </Box>
        )}
      </div>
    );
  }

  const getUsers = async () => {

    //const response = await axios(`${BACKEND_ENDPOINT}/`)
  }

  useEffect(() => {
    getUsers();
  },[])

  return (
    <Card className="h-full w-full" >
      <CardHeader floated={false} shadow={false} className="rounded-none">
        <div className="mb-8 flex items-center justify-between gap-8">
          <div className="flex justify-between" style={{flex:1}}>
            <div>
            <Typography style={{fontFamily:'"Poppins", Arial, sans-serif'}}  variant="h5" color="blue-gray">
              Members list
            </Typography>
            <Typography style={{fontFamily:'"Poppins", Arial, sans-serif'}} color="gray" className="mt-1 font-normal">
              See information about all members
            </Typography>
            </div>
                
            <div>
              <Button onClick={() => {
                console.log(addmem)
                setAddmem(true)
              }} className="bg-blue-500">Add New Member to Clinical Trial</Button>
            </div>
          </div>

          {
            page != "Trial Members" ?
            <div className="flex shrink-0 flex-col gap-2 sm:flex-row">
              <Button style={{fontFamily:'"Poppins", Arial, sans-serif'}} variant="outlined" size="sm">
                  <NotificationsNoneIcon/>
                Send Notifications
              </Button>
              <Button className="flex items-center gap-3 bg-blue-500" size="sm">
                <UserPlusIcon strokeWidth={2} className="h-4 w-4" /> Add member
              </Button>
            </div> : <div></div>

          }



        </div>
        <div className="flex flex-col items-center justify-between gap-4 md:flex-row">
        <AddMemberTrial clinicaltrial={clinicaltrial} open={addmem} setOpen={setAddmem}/>
        <Box sx={{ width: '100%' }}>
      <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
        <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
          <Tab label="Enrolled" />
          <Tab label="Rejected"  />
          <Tab label="Not Responded" />
        </Tabs>
      </Box>
      <CustomTabPanel value={value} index={0}>
      <UserIdsTable page={page} selectedUsers = {selectedUsers} setSelectedUsers={setSelectedUsers} users={enrolled}/>
        {/* <div style={{marginTop:'10px',height: '65vh', overflowY:'scroll',flex:1}} className="mt-5 border-2 shadow-lg">
           
            
       
      </div> */}
      </CustomTabPanel>
      <CustomTabPanel value={value} index={1}>
        <div style={{marginTop:'10px',height: '65vh', overflowY:'scroll'}} className="mt-5">
           
            
        <UserIdsTable page={page} selectedUsers = {selectedUsers} setSelectedUsers={setSelectedUsers} users={rejected}/>
      </div>
      </CustomTabPanel>
      <CustomTabPanel value={value} index={2}>
        <div style={{marginTop:'10px',height: '65vh', overflowY:'scroll'}} className="mt-5">
           <UserIdsTable page={page} selectedUsers = {selectedUsers} setSelectedUsers={setSelectedUsers} users={notresponded}/>
      </div>
      </CustomTabPanel>
    </Box>
          
        </div>
      </CardHeader>
      
    </Card>
  );
}
