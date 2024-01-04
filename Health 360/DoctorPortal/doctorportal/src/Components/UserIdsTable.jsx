import * as React from 'react';
import { DataGrid, GridToolbar } from '@mui/x-data-grid';
import Checkbox from '@mui/material/Checkbox';
import Button from '@mui/material/Button';
import { GridToolbarContainer } from '@mui/x-data-grid';
import { GridToolbarFilterButton } from '@mui/x-data-grid';
import { GridToolbarExport } from '@mui/x-data-grid';
import { BACKEND_ENDPOINT } from '../constants';
import { useState } from 'react';
import axios from 'axios';

const VISIBLE_FIELDS = ['username', 'firstname', 'lastname', 'typeofuser','age','region','gender','height','weight','disease'];


export default function UserIdsTable(props) {
  const {selectedUsers,setSelectedUsers, users, page} = props;

  const [allusers, setAllusers] = useState([]);

  async function getUsers () {
    const response = await axios.post(`${BACKEND_ENDPOINT}/usergroups/getUsersByIds`, {
        userIds: users
    })
    setAllusers(response.data);
  }

  React.useEffect(() => {
    getUsers();
  },[])
  const [userData,setUserData] = React.useState([]);
  
  React.useEffect(() => {
    console.log(selectedUsers)
  },[selectedUsers])
  
//   const userData = [
//     {
//       "_id": "6511b37d01e6a5fa169d4288",
//       "username": "shalmalee",
//       "password": "$2a$12$VOAiWUS.JbqtRj1U5v4CNefYZUKl7IXE8h9Goq7VfbIJG9mAC4/we",
//       "__v": 0
//     },
//     {
//       "_id": "6511bd031a42d349f2635491",
//       "firstname": "Shalmalee",
//       "lastname": "Shenolikar",
//       "username": "shalmalee@gmail.com",
//       "password": "$2a$12$U3BDc3dQaGbPWDnWWzJKLuI.e4bAyhYWSpSDza1FrWYJxiu1/iSbK",
//       "typeofuser": "DOCTOR",
//       "__v": 0
//     },
//     // Add more user data objects as needed
//   ];

  // Add a unique id to each user for DataGrid usage

  const usersWithId = allusers?.map((user, index) => ({
    ...user,
    id: index + 1,
  }));

  const [selectedRows, setSelectedRows] = React.useState([]);

  const handleSelectionChange = (selection) => {
    setSelectedRows(selection);
    const selecUsers = selection.map((selectedId) =>
      usersWithId.find((user) => user.id === selectedId)
    );
    // Use the selectedUsers array as needed
    console.log(selectedUsers);
    setSelectedUsers(selecUsers)
  };


  const handleSelectAllClick = () => {
    setSelectedRows(usersWithId.map((user) => user.id));
    setSelectedUsers(usersWithId.map((user) => user.id));
  };

  const handleDeselectAllClick = () => {
    setSelectedRows([]);
  };

  function CustomToolbar() {
    return (
      <GridToolbarContainer>
        <GridToolbarFilterButton />
        <GridToolbarExport />
      </GridToolbarContainer>
    );
  }
  

  return (
    <div style={{ height: 400, width: '100%' }}>
      <DataGrid
        rows={usersWithId}
        columns={VISIBLE_FIELDS.map((field) => ({ field, headerName: field, flex: 1 }))}
        checkboxSelection = {page != "Trial Members" ? true : false}
        density="compact"
        getRowId={(row) => row.id}
        onRowSelectionModelChange={handleSelectionChange}
        components={{
          Toolbar: () => (
            <div>
              <CustomToolbar />
            </div>
          ),
        }}
      />
    </div>
  );
}
