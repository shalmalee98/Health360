import * as React from 'react';
import PropTypes from 'prop-types';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import { Navigate, useLocation, useNavigate } from 'react-router-dom';
import UsersTable1 from '../components/ClinicalTrial/UsersTable1';
import Questions from '../components/Questionnaire/Questions';
import Questionnaires from '../components/Questionnaire/Questionnaires';

function CustomTabPanel(props) {
  const { children, value, index, ...other } = props;
  const navigate = useNavigate();

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

CustomTabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

export default function ClinicalService() {
  const [value, setValue] = React.useState(0);
  
  const location = useLocation();
  const clinicalTrialId = location.pathname.split('/')[2];
  console.log(clinicalTrialId);

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  return (
    localStorage.getItem('user') ?
    <Box sx={{ width: '100%' }}>
      <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
        <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
          <Tab label="Users"  {...a11yProps(0)} />
          <Tab label="Questionnaires" {...a11yProps(1)} />
          <Tab label="Notification" {...a11yProps(2)} />
        </Tabs>
      </Box>
      <CustomTabPanel value={value} index={0}>
        <UsersTable1 clinicalTrialId={clinicalTrialId}/>
      </CustomTabPanel>
      <CustomTabPanel value={value} index={1}>
        {/* <Questions/> */}
        <Questionnaires clinicalTrialId={clinicalTrialId}/>
      </CustomTabPanel>
    </Box>
    : <Navigate to="/login" />
  );
}
