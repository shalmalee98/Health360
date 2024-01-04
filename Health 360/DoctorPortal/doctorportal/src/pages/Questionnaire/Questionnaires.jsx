import React, { useEffect, useState } from 'react';
import Grid from '@mui/material/Grid';
import { Box, Button, Card, CardActionArea, CardActions, CardContent, CardMedia, IconButton, Tab, Tabs, Tooltip, Typography } from '@mui/material';
import MenuCards from '../MenuCards';
import { Link, Navigate } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
import Newtrail from '../Newtrail';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../../constants';
import AddCircleOutlineRoundedIcon from '@mui/icons-material/AddCircleOutlineRounded';

export default function Questionnaires (props) {
  const {clinicalTrialId} = props
  const [clinicalTrials, setClinicalTrials] = useState([]);
  const [open,setOpen] = useState(false);
  const [value, setValue] = React.useState(0);

  const navigate = useNavigate();

  async function fetchData() {
    const response = await axios.post(`${BACKEND_ENDPOINT}/questionnaires/getByClinicalTrial`,{ "clinicalTrialId": clinicalTrialId})
    setClinicalTrials(response.data)
  } 

  useEffect(() => {
    fetchData();
  },[]) 
  {
    return (
      <div><h1 >Questionnaires</h1>
          {/* <AddCircleOutlineRoundedIcon/> */}
          <div style={{display: 'flex'}}>
          <Tooltip style={{marginLeft: 'auto'}} title="Create Notification">
            <IconButton onClick={() => navigate(`/questions/${clinicalTrialId}`)}>
              <AddCircleOutlineRoundedIcon />
            </IconButton>
          </Tooltip>
          </div>
   {clinicalTrials.map((row) => {
        return (
          
        <Card sx={{ maxWidth: 345 }} style={{margin: '50px'}}  >
        <CardActionArea>
          <CardMedia
            component="img"
            height="140"
            image="https://picsum.photos/400/200"
            alt="green iguana"
          />
          <CardContent>
            <Typography gutterBottom variant="h5" component="div">
              {row.name}
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {row.description}
            </Typography>
          </CardContent>
        </CardActionArea>
        <CardActions>
        <Link to={`/responses/${row._id}`} state={{user: row}}>
          <Button size="small" color="primary">
            See Responses
          </Button>
        </Link>
        </CardActions>
         </Card>
        )
    })}
    </div>)
  }

}