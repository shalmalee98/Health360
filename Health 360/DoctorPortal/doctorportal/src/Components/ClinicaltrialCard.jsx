import * as React from 'react';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import Typography from '@mui/material/Typography';
import { CardActionArea } from '@mui/material';
import { Button } from '@material-tailwind/react';
import DeleteIcon from '@mui/icons-material/Delete';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../constants';

export default function ClinicaltrialCard(props) {
  const {data} = props;

  const deleteTrial = async (data) => {
    const response = await axios.delete(`${BACKEND_ENDPOINT}/clinicaltrials/delete/?id=${data._id}`);
    console.log(response);
    window.location.pathname = '/clinicaltrials'
  }
  return (
    <Card style={{height:'32vh'}} className='shadow-lg'>
      <CardActionArea>
        <div className='bg-blue-400 text-center flex text-white items-center justify-center' style={{flex:1, height: 100}}>
            <h5 style={{fontSize:'30px'}} className='font-extrabold uppercase'>{data?.name}</h5>
        </div>
       
        <CardContent style={{height:'13vh'}}>
          <Typography gutterBottom variant="h5" component="div">
            {data?.name}
          </Typography>
          <Typography variant="body2" color="text.secondary">
            {data?.description}
          </Typography>
        </CardContent>

        


        <div className='flex justify-between align-middle'>

       
          <div>
          <a href="#" className="inline-block m-2">
          <Button style={{ fontFamily: "Poppins, sans-serif" }} size="sm" variant="text" className="flex items-center gap-2 hover:text-blue-500">
            See Details
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth={2}
              stroke="currentColor"
              className="h-4 w-4"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3"
              />
            </svg>
          </Button>
        </a>
        </div>

        
        <div>

          <Button onClick={() => {
            deleteTrial(data);
          }} style={{ fontFamily: "Poppins, sans-serif" }} size="sm" variant="text" className="flex items-center gap-2 hover:text-blue-500 mt-2">
              <DeleteIcon/>
            </Button>
          </div>
        

        </div>
      </CardActionArea>
       
    </Card>
  );
}
