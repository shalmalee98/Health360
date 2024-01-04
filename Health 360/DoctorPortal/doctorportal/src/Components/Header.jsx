import React, { useEffect, useState } from "react";
import NotificationsNoneIcon from '@mui/icons-material/NotificationsNone';
import {
  Navbar,
  Collapse,
  Typography,
  Button,
  IconButton,
  Card,
  Badge
} from "@material-tailwind/react";
import { Link } from "@mui/material";
import NotificationsIcon from '@mui/icons-material/Notifications';
import { useNavigation } from "react-router-dom";
 
export default function Header(props) {
  const {user} = props;
  const [openNav, setOpenNav] = React.useState(false);
  const [notificationCount, setNotificationsCount] = useState(3)

  // const location = useLocation();
 
  React.useEffect(() => {
    window.addEventListener(
      "resize",
      () => window.innerWidth >= 960 && setOpenNav(false),
    );
  }, []);
 
  const navList = (
    <ul className="mt-2 mb-4 flex flex-col gap-2 lg:mb-0 lg:mt-0 lg:flex-row lg:items-center lg:gap-6">
        <Typography
          as="li"
          color="blue-gray"
          style={{ fontFamily: "Poppins, sans-serif" }}
          className="p-1 font-normal hover:text-blue-500"
        >
          <a href="/" className="flex items-center">
            Dashboard
          </a>
        </Typography>
      <Typography
        as="li"
        
        color="blue-gray"
        style={{ fontFamily: "Poppins, sans-serif" }}
        className="p-1 font-normal hover:text-blue-500"
      >
        <a href="/clinicaltrials" className="flex items-center">
          Clinical Trials
        </a>
      </Typography>
      <Typography
        as="li"
        
        color="blue-gray"
        style={{ fontFamily: "Poppins, sans-serif" }}
        className="p-1 font-normal hover:text-blue-500"
      >
        <a href="/globalusergroup" className="flex items-center">
          User Groups
        </a>
      </Typography>
      <Typography
        as="li"
        color="blue-gray"
        style={{ fontFamily: "Poppins, sans-serif" }}
        className="p-1 font-normal hover:text-blue-500"
      >
        <a href="/profile" className="flex items-center">
          Profile
        </a>
      </Typography>
      <Badge badgeContent={notificationCount} color="error">
        <Link href="/notifications"><span><NotificationsIcon style={{cursor:'pointer'}}/></span></Link>
      </Badge>
    </ul>
  );
 
  return (
   
      <Navbar style={{height:'10vh'}} className="sticky top-0 bg-transparent z-10 h-max max-w-full rounded-none px-4 py-2 lg:px-8 lg:py-4">
        <div className="flex items-center justify-between text-blue-gray-900">
          
            <Typography
              href="/"
              as="a"
              variant="h3"
              style={{ fontFamily: "Poppins, sans-serif" }}
              className="mr-4 cursor-pointer py-1.5 text-blue-500 font-extrabold"
            >
              Health 360
            </Typography>
          
         
          <div className="flex items-center gap-4">
            <div className="mr-4 hidden lg:block">{navList}</div>
            <div className="flex items-center gap-x-1">
              {
                user ?  (<Button
                sx={{ fontFamily: "Poppins, sans-serif" }}
                onClick={() => {
                  localStorage.removeItem('user');
                  window.location.pathname="/login";
                }}
                size="sm"
                className="hidden lg:inline-block bg-blue-500"
              >
                <span>Log out</span>
              </Button>):( <Button
                sx={{ fontFamily: "Poppins, sans-serif" }}
                size="sm"
                className="hidden lg:inline-block bg-blue-500"
              >
                <span>Sign in</span>
              </Button>)
              }      
            </div>
            <IconButton
              variant="text"
              className="ml-auto h-6 w-6 text-inherit hover:bg-transparent focus:bg-transparent active:bg-transparent lg:hidden"
              ripple={false}
              onClick={() => setOpenNav(!openNav)}
            >
              {openNav ? (
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  className="h-6 w-6"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  strokeWidth={2}
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              ) : (
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  className="h-6 w-6"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth={2}
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                </svg>
              )}
            </IconButton>
          </div>
        </div>
        <Collapse open={openNav}>
          {navList}
          <div className="flex items-center gap-x-1">
            <Button fullWidth variant="text" size="sm" className="">
              <span>Log In</span>
            </Button>
            <Button fullWidth variant="gradient" size="sm" className="">
              <span>Sign in</span>
            </Button>
          </div>
        </Collapse>
      </Navbar>
   
  );
}