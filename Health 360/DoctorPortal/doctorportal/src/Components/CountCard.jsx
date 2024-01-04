import {
    Card,
    CardBody,
    CardFooter,
    Typography,
    Button,
  } from "@material-tailwind/react";
  import VaccinesIcon from '@mui/icons-material/Vaccines';
  import MonitorHeartIcon from '@mui/icons-material/MonitorHeart';
  import MedicalInformationIcon from '@mui/icons-material/MedicalInformation';
  import HelpCenterIcon from '@mui/icons-material/HelpCenter';
  import LocalHospitalIcon from '@mui/icons-material/LocalHospital';
   
  export function CountCard(props) {
    const {data,clinicaltrial} = props;
    return (
      <Card style={{height:'35vh'}}>
        <CardBody style={{height:'30vh'}}>
          <div className="flex justify-between">
          <MonitorHeartIcon sx={{fontSize:'45px'}} className='text-blue-500'/>

            <div className="mb-5">
              <h6 style={{fontSize:'20px'}} className="font-extrabold">{data?.questions.length}</h6>
              <h5>Questions</h5>
            </div>
          </div>
          <Typography style={{display: '-webkit-box', WebkitBoxOrient: 'vertical', overflow: 'hidden', WebkitLineClamp: 3, fontFamily: "Poppins, sans-serif",textOverflow:'ellipsis' }} variant="h5" color="blue-gray" className="mb-2">
          {data?.name}
          </Typography>
          <Typography style={{display: '-webkit-box', WebkitBoxOrient: 'vertical', overflow: 'hidden', WebkitLineClamp: 3, fontFamily: "Poppins, sans-serif", textOverflow:'ellipsis' }}>
            {data?.description}
          </Typography>
        </CardBody>
        <CardFooter className="pt-0">
          <a href="#" className="inline-block">
            <Button style={{ fontFamily: "Poppins, sans-serif" }} size="sm" variant="text" className="flex items-center gap-2 hover:text-blue-500">
              See Responses
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
        </CardFooter>
      </Card>
    );
  }