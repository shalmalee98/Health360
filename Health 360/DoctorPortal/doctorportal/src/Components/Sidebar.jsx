import {
    Card,
    Typography,
    List,
    ListItem,
    ListItemPrefix,
    ListItemSuffix,
    Chip,
  } from "@material-tailwind/react";
  import {
    PresentationChartBarIcon,
    ShoppingBagIcon,
    UserCircleIcon,
    Cog6ToothIcon,
    InboxIcon,
    PowerIcon,
  } from "@heroicons/react/24/solid";
  import { Link } from "react-router-dom";
   
  export default function Sidebar(props) {
    const {clinicaltrialId, clinicaltrial} = props;
    return (
      <Card style={{height:'90vh'}} className="w-full max-w-[20rem] p-4 shadow-xl shadow-blue-gray-900/5">
        <div className="mb-2 p-4">
          <Typography style={{ fontFamily: "Poppins, sans-serif" }} variant="h5" color="blue-gray">
              {clinicaltrialId ? clinicaltrial?.name : "Sidebar"}
          </Typography>
        </div>
        {

        clinicaltrialId ?(
          <List>
          <Link to={`/clinicaltrial/${clinicaltrial}?data=${encodeURIComponent(JSON.stringify(clinicaltrial))}`}><ListItem style={{ fontFamily: "Poppins, sans-serif" }}>
              <ListItemPrefix>
                <PresentationChartBarIcon className="h-5 w-5 text-blue-500" />
              </ListItemPrefix>
              {clinicaltrial?.name} Trial
            </ListItem></Link>
            <Link state={clinicaltrial} to={`/questionnaire/${clinicaltrial?._id}`}><ListItem style={{ fontFamily: "Poppins, sans-serif" }}>
              <ListItemPrefix>
                <ShoppingBagIcon className="h-5 w-5 text-blue-500" />
              </ListItemPrefix>
              Questionnaire
            </ListItem></Link>
            <Link state={clinicaltrial} to={`/usergroups/${clinicaltrial._id}`}><ListItem style={{ fontFamily: "Poppins, sans-serif" }}>
              <ListItemPrefix>
                <UserCircleIcon className="h-5 w-5 text-blue-500" />
              </ListItemPrefix>
              Trial User Groups
            </ListItem></Link>
            <Link state={clinicaltrial} to={`/usergroupmembers/${clinicaltrial._id}`}><ListItem style={{ fontFamily: "Poppins, sans-serif" }}>
              <ListItemPrefix>
                <UserCircleIcon className="h-5 w-5 text-blue-500" />
              </ListItemPrefix>
              Trial Members
            </ListItem></Link>
            
            
          </List>
       ): (
        <List>
        <Link to="/"><ListItem style={{ fontFamily: "Poppins, sans-serif" }}>
            <ListItemPrefix>
              <PresentationChartBarIcon className="h-5 w-5 text-blue-500" />
            </ListItemPrefix>
            Dashboard
          </ListItem></Link>
          <Link to="/clinicaltrials"><ListItem style={{ fontFamily: "Poppins, sans-serif" }}>
            <ListItemPrefix>
              <ShoppingBagIcon className="h-5 w-5 text-blue-500" />
            </ListItemPrefix>
            Clinical Trials
          </ListItem></Link>
          <Link to="/globalusergroup"><ListItem style={{ fontFamily: "Poppins, sans-serif" }}>
            <ListItemPrefix>
              <UserCircleIcon className="h-5 w-5 text-blue-500" />
            </ListItemPrefix>
            Global User Groups
          </ListItem></Link>
          
        </List>)
        }

      </Card>
    );
  }