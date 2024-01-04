import {
    Card,
    CardHeader,
    CardBody,
    CardFooter,
    Typography,
    Button,
  } from "@material-tailwind/react";
  import { Link } from "react-router-dom";
  import Clinitrial from '../assets/ClinicalTrials.jpeg'
   
  export function BasicCard(props) {
    const {name, description, picture} = props;
    return (
      <Card sx={{fontFamily:'"Poppins", Arial, sans-serif'}}>
        <CardHeader color="blue-gray" className="relative ">
          <img
            style={{width:'30vw', height:'25vh'}}
            src={picture}
            alt="card-image"
          />
        </CardHeader>
        <CardBody style={{height:'20vh'}}>
          <Typography style={{ fontFamily: "Poppins, sans-serif" }} variant="h5" color="blue-gray" className="mb-2">
            {name}
          </Typography>
          <Typography style={{ display: '-webkit-box', WebkitBoxOrient: 'vertical', overflow: 'hidden', WebkitLineClamp: 3, fontFamily: 'Poppins, sans-serif' }}>
            {description}
          </Typography>
        </CardBody>
        <CardFooter className="pt-0">
          {name == 'Notifications' ? <Link to="/notifications"><Button style={{ fontFamily: "Poppins, sans-serif" }} className='bg-blue-500'>Manage</Button></Link>
          : name == 'Clinical Trials' ? <Link to="/clinicaltrials"><Button style={{ fontFamily: "Poppins, sans-serif" }} className='bg-blue-500'>Manage</Button></Link>
          : name == 'Global User Groups' ? <Link to="/globalusergroup"><Button style={{ fontFamily: "Poppins, sans-serif" }} className='bg-blue-500'>Manage</Button></Link>
          : null}
        </CardFooter>
      </Card>
    );
  }