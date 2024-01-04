import {
    Card,
    CardBody,
    CardFooter,
    Typography,
    Button,
  } from "@material-tailwind/react";
  import { useState } from "react";
  import DeleteIcon from '@mui/icons-material/Delete';
  import GroupMemberDialog from "./GroupMemberDialog";
  import axios from "axios";
import { BACKEND_ENDPOINT } from "../constants";
   
  export function UsergroupCard(props) {
    const {data,clinicaltrial} = props;
    const [open,setOpen] = useState(false);

    const deleteSubgroup = async (id) => {
      const response = await axios.delete(`${BACKEND_ENDPOINT}/usergroups/delete?id=${id}`);
      console.log(response);
      window.location.reload();
    }
    
    return (
      <>
      <GroupMemberDialog groupName={data.groupName} groupDesc={data.groupDesc} open={open} setOpen={setOpen} id={data._id} clinicaltrial={clinicaltrial}/>
      <Card style={{height:'30vh'}}>
        <CardBody style={{height:'25vh'}}>
          <Typography style={{ fontFamily: "Poppins, sans-serif", display: '-webkit-box', WebkitBoxOrient: 'vertical', overflow: 'hidden', WebkitLineClamp: 2,height:'7vh' }}  variant="h5" color="blue-gray" className="mb-2">
            {data.groupName}
          </Typography>
          <Typography  style={{display: '-webkit-box', WebkitBoxOrient: 'vertical', overflow: 'hidden', WebkitLineClamp: 3, fontFamily: 'Poppins, sans-serif',height:'7vh' }}>
            {data.groupDesc || `This is the clinical usergroup  ${data.groupName}`}
          </Typography>
        </CardBody>
        <CardFooter className="pt-0">
          <div className="flex justify-between align-middle">

           
          <Button onClick={() => {
            setOpen(true)
          }} className='bg-blue-500'>See Users</Button>
          

          <div className="flex justify-center align-middle text-blue-500 cursor-pointer text-center">
            <DeleteIcon onClick = {() => {
              deleteSubgroup(data._id);
            }} className="mt-2"/>
          </div>

          </div>
        </CardFooter>
      </Card>
      </>
    );
  }