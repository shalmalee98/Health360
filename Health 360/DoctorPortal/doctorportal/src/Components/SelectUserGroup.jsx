import * as React from 'react';
import Box from '@mui/material/Box';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import { useState } from 'react';

export default function SelectUserGroup(props) {
  const {options, setUserGroup} = props;
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
    setUserGroup(event.target.value);
  };

  return (
    <Box sx={{ minWidth: 120 }}>
      <FormControl fullWidth>
        <Select
          labelId="demo-simple-select-label"
          id="demo-simple-select"
          value={selectedOption}
          onChange={handleChange}
        >
          {
            options.map((options) => {
              return (
                <MenuItem value={options.id}>{options.name}</MenuItem>
              )
            })
          }
        </Select>
      </FormControl>
    </Box>
  );
}