import {
    Card,
    CardBody,
    CardFooter,
    Typography,
    Button,
  } from "@material-tailwind/react";
  import MonitorHeartIcon from '@mui/icons-material/MonitorHeart';
   
  export function DashboardCountCard(props) {
    const {title, description, count} = props;
    // const {data} = props;
    return (
      <Card style={{height:'30vh'}}>
        <CardBody>
          <div className="flex justify-between">
          <MonitorHeartIcon sx={{fontSize:'45px'}} className='text-blue-500'/>

          <div className="mb-5">
            <h6 style={{fontSize:'20px'}} className="font-extrabold">{count}</h6>
            <h5>{title}</h5>
          </div>
          </div>
          <Typography style={{ fontFamily: "Poppins, sans-serif" }} variant="h5" color="blue-gray" className="mb-2">
           {title}
          </Typography>
          <Typography style={{ fontFamily: "Poppins, sans-serif" }}>
            {description || "This is the random description about the Somehting"}
          </Typography>
        </CardBody>
        
      </Card>
    );
  }