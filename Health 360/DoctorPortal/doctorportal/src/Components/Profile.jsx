// IMPORTS
import React, { createContext, useContext, useEffect, useState } from "react";
import profilePic from '../assets/user.png'
import { BACKEND_ENDPOINT } from "../constants";
import axios from "axios";
import { createSearchParams } from "react-router-dom";
import { Button, Dialog, DialogBody, DialogHeader, Input, Typography } from "@material-tailwind/react";
import { Box } from "@mui/material";
import Sidebar from "./Sidebar";
// APP
export default function UserProfile() {
  let currentUser = '';
  const [user, setUser] = useState({});
  // const [user, load, error] = useAuthState(auth);
  const [userId, setUserId] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [age, setAge] = useState(null);
  const [height, setHeight] = useState(null);
  const [weight, setWeight] = useState(null);
  const [userType, setUserType] = useState("");
  const [photo, setPhoto] = useState(profilePic);
  const [photoURL, setPhotoURL] = useState(
    "https://static.vecteezy.com/system/resources/previews/002/318/271/original/user-profile-icon-free-vector.jpg"
  );
  const [bio, setBio] = useState("");
  const [loading, setLoading] = useState(false);
  const [editable, setEditable] = useState(false);
  const [openAlert, setOpenAlert] = useState(false);
  const [alertMessage, setAlertMessage] = useState('');
  const handleAlertClose = () => {
    setAlertMessage('');
    setOpenAlert(false);
  }
  const editProfile = async () => {
    const body =  {
      firstname: firstName,
      lastname: lastName,
      username: email,
      height: height,
      weight: weight,
      age: age
    }
    const query = {id: user._id};
    axios.put(`${BACKEND_ENDPOINT}/users/update?` + createSearchParams(query), body )
    .then((result) => {
            console.log(result);
            setAlertMessage('You have updated your profile successfully!')
            setOpenAlert(true)
        }
    ).catch(err=> console.log(err))
    // await updateUser(displayName, phoneNumber, photoURL, bio);
  };
  function handleChange(e) {
    if (e.target.files[0]) {
      setPhoto(e.target.files[0]);
    }
  }
  function handleClick() {
  }
  useEffect(() => {
    currentUser = localStorage.getItem("user");
    console.log(JSON.parse(currentUser));
    currentUser = JSON.parse(currentUser);
    const query={id: currentUser._id}
    axios.get(`${BACKEND_ENDPOINT}/users/getOne?`+ createSearchParams(query))
    .then((result) => {
        let res = JSON.stringify(result.data.data);
        console.log("current User: ", res)
        res = JSON.parse(res);
        setFirstName(res.firstname);
        setLastName(res.lastname);
        setEmail(res.username);
        setAge(res.age);
        setHeight(res.height);
        setWeight(res.weight);
        setUserType(res.typeofuser);
        setUserId(res._id)
        setUser(res);
      }
    )
    .catch(err=> 
      console.log(err)
    )
  }, []);
  return (
    <div className="flex">
      <div>
          <Sidebar/>
      </div>

      <div className="flex justify-center">
      <Box style={{ width: "100%" }}>
    {/* <Toolbar /> */}
    <Box
      style={{
        minWidth: "600px",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <Box
        style={{
          width: "100%",
          height: "20vh",
          display: "flex",
          flexDirection: "row",
          alignItems: "center",
        //   backgroundColor: "lightgreen",
        }}
      >
        <Box
          style={{
            width: "80%",
            paddingLeft: "20px",
            display: "flex",
            flexDirection: "row",
            alignItems: "center",
            // marginBottom: "-200px",
          }}
        >
          <img src={photoURL} alt="profile picture" width={150}></img>
          <Typography variant="h4" style={{ marginTop: "20px", marginLeft: "20px" }}>
            Hi, {firstName} {lastName}
          </Typography>
        </Box>
        <Box
          style={{
            width: "20%",
            display: "flex",
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "center",
            // marginBottom: "-230px",
          }}
        >
          <Button variant="outlined" color="primary" onClick={editProfile}>
            Save Changes
          </Button>
        </Box>
      </Box>
      <Box style={{ display: "flex", flexDirection: "column", marginTop: "50px" }}>
        <Typography variant="h6">First Name</Typography>
        <Input
          className=""
          id=""
          label=""
          placeholder=""
          value={firstName}
          variant="outlined"
          style={{ width: "400px", marginBottom: "30px" }}
          onChange={(e) => setFirstName(e.target.value)}
          // onChange={(event: ChangeEvent<HTMLInputElement>) => setName(event.target.value)}
        />
        <Typography variant="h6">Last Name</Typography>
        <Input
          className=""
          id=""
          label=""
          placeholder=""
          value={lastName}
          variant="outlined"
          style={{ width: "400px", marginBottom: "30px" }}
          onChange={(e) => setLastName(e.target.value)}
          // onChange={(event: ChangeEvent<HTMLInputElement>) => setName(event.target.value)}
        />
        <Typography variant="h6">User Type</Typography>
        <Input
          className=""
          id=""
          label=""
          placeholder=""
          value={userType}
          inputProps={{ readOnly: false }}
          variant="outlined"
          style={{ width: "400px", marginBottom: "30px" }}
          disabled
          contentEditable = {false}
        //   onChange={(e) => setPhoneNumber(e.target.value)}
          // onChange={(event: ChangeEvent<HTMLInputElement>) => setName(event.target.value)}
        />
        <Typography variant="h6">E-Mail</Typography>
        <Input
          className=""
          id=""
          label=""
          placeholder=""
          value={email}
          // disabled
          inputProps={{ readOnly: false }}
          variant="outlined"
          style={{ width: "400px", marginBottom: "30px" }}
          onChange={(e) => setEmail(e.target.value)}
        />
        <Typography variant="h6">Age</Typography>
        <Input
          className=""
          id="age"
          label="Age"
          placeholder=""
          value={age}
          variant="outlined"
          style={{ width: "400px", marginBottom: "30px" }}
          onChange={(e) => setAge(e.target.value)}
          // onChange={(event: ChangeEvent<HTMLInputElement>) => setName(event.target.value)}
        />
        <Typography variant="h6">Height (in cm)</Typography>
        <Input
          className=""
          id="height"
          label="Height (in cm)"
          placeholder=""
          value={height}
          variant="outlined"
          style={{ width: "400px", marginBottom: "30px" }}
          onChange={(e) => setHeight(e.target.value)}
          // onChange={(event: ChangeEvent<HTMLInputElement>) => setName(event.target.value)}
        />

        <Typography variant="h6">Weight (in lbs)</Typography>
        <Input
          className=""
          id="weight"
          label="Weight (in lbs)"
          placeholder=""
          value={weight}
          variant="outlined"
          style={{ width: "400px", marginBottom: "30px" }}
          onChange={(e) => setWeight(e.target.value)}
          // onChange={(event: ChangeEvent<HTMLInputElement>) => setName(event.target.value)}
        />
        <Typography variant="h6">Profile Picture</Typography>
        <input type="file" onChange={handleChange} />
        <button disabled={loading || !photo} onClick={handleClick}>
          Upload
        </button>
        {/* {photo && (
        <div>
          <img
            alt="not found"
            width={"250px"}
            src={URL.createObjectURL(photo)}
          />
          <br />
          <button onClick={() => setPhoto(null)}>Remove</button>
        </div>
      )} */}
      {/* <br/>
      <input
        type="file"
        name="myImage"
        onChange={(event) => {
          console.log(event.target.files[0]);
          setPhoto(event.target.files[0]);
        }}
      /> */}
      {/* {openAlert ?  */}
      <Dialog
        open={openAlert}
        onClose={handleAlertClose}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <DialogHeader id="alert-dialog-title">
          {alertMessage}
        </DialogHeader>
        {/* <DialogContent>
          <DialogContentText id="alert-dialog-description">
            Let Google help apps determine location. This means sending anonymous
            location data to Google, even when no apps are running.
          </DialogContentText>
        </DialogContent> */}
        <DialogBody>
          <Button onClick={handleAlertClose}>Close</Button>
        </DialogBody>
      </Dialog>
      {/* : null} */}
      </Box>
    </Box>
  </Box>
      </div>
    </div>
    
  );
}