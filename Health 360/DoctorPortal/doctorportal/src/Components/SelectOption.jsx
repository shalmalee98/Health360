import * as React from 'react';
import Box from '@mui/material/Box';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import { useState } from 'react';

export default function SelectOption(props) {
  const {options, setUsersList} = props;
  const [selectedOption, setSelectedOption] = useState("");

  const handleChange = (event) => {
    const option = options.filter((option) => {
      if (option._id == event.target.value){
        return (
          option
        );
      }
    });
    setSelectedOption(event.target.value);
    console.log(option[0].usersList);
    setUsersList(option[0].usersList);
  };

  return (
    <Box sx={{ minWidth: 120 }}>
      <FormControl fullWidth>
        <InputLabel id="demo-simple-select-label">Select Global User Group</InputLabel>
        <Select
          labelId="demo-simple-select-label"
          id="demo-simple-select"
          value={selectedOption}
          label="Age"
          onChange={handleChange}
        >
          {
            options.map((options) => {
              return (
                <MenuItem value={options._id}>{options.groupName}</MenuItem>
              )
            })
          }
        </Select>
      </FormControl>
    </Box>
  );
}