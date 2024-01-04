import * as React from 'react';
import PropTypes from 'prop-types';
import Box from '@mui/material/Box';
import Collapse from '@mui/material/Collapse';
import IconButton from '@mui/material/IconButton';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import { Grid } from '@mui/material';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Typography from '@mui/material/Typography';
import Paper from '@mui/material/Paper';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import KeyboardArrowUpIcon from '@mui/icons-material/KeyboardArrowUp';

function Row(props) {
  const { row, user } = props;
  const [open, setOpen] = React.useState(false);
  const mediaType = (url) => {
    const lowercasedUrl = url.toLowerCase();
    const audioExtensions = ['.wav', '.mp3'];
    if (audioExtensions.some(extension => lowercasedUrl.includes(extension))) {
      return 'audio';
    }
    const imageExtensions = ['.png', '.jpg', '.jpeg'];
    if (imageExtensions.some(extension => lowercasedUrl.includes(extension))) {
      return 'image';
    }
    return 'unknown';
  };

  return (
    <React.Fragment>
      <TableRow sx={{ '& > *': { borderBottom: 'unset' } }}>
        <TableCell>
          <IconButton
            aria-label="expand row"
            size="small"
            onClick={() => setOpen(!open)}
          >
            {open ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
          </IconButton>
        </TableCell>
        <TableCell style={{textAlign:'left'}} align="right">{user}</TableCell>
        {
            row.map((resp,index) => {
              if (!row.response){
                <TableCell align="right"></TableCell>
              }
              if (mediaType(resp.response?.toString()) == 'image'){
                return (
                  <TableCell style={{width:'20%',textAlign:'center'}}><div style={{display:'flex', justifyContent:'center'}}><img style={{height:'20vh'}} src={resp.response.toString()}/></div></TableCell>
              )

              }
              else if (mediaType(resp.response?.toString()) == 'audio'){
                return  (
                  <TableCell style={{width:'20%'}}>
                    <audio controls>
                      <source src={resp.response?.toString()} type="audio/wav"/>
                    </audio></TableCell>
                )
              }
                return (
                    <TableCell style={{width:'20vw',textAlign:'center'}} >{resp.response?.toString()}</TableCell>
                )
            })
        }
      </TableRow>
      <TableRow>
        <TableCell style={{ paddingBottom: 0, paddingTop: 0 }} colSpan={6}>
          <Collapse in={open} timeout="auto" unmountOnExit>
            <Box>
              <Grid container style={{margin: '5px 0px'}} spacing={5} justifyContent={'center'} alignItems={'center'}>

                {
                  row.map((eachRow) => {
                    return (
                      <>
                      <Grid item xs={6} sm={6}>
                        <b>{eachRow.question}</b>
                      </Grid>

                    <Grid item xs={6} sm={6}>
                      {
                         mediaType(eachRow.response.toString()) == 'image' ? <div>

                          <img style={{height:'20vh'}} src={eachRow.response.toString()}/>

                         </div> : mediaType(eachRow.response.toString()) == 'audio' ? <div>
                          <audio controls>
                            <source src={eachRow.response.toString()} type="audio/wav"/>
                          </audio>
                         </div> : <div>{eachRow.response.toString()}</div>
                      }
                    </Grid>
                    </>
                    )
                  })
                }
              </Grid>
            </Box>
            {/* <Box sx={{ margin: 1 }}>
              <Typography variant="h6" gutterBottom component="div">
                History
              </Typography>
              <Table size="small" aria-label="purchases">
                <TableHead>
                  <TableRow>
                    <TableCell>Date</TableCell>
                    <TableCell>Customer</TableCell>
                    <TableCell align="right">Amount</TableCell>
                    <TableCell align="right">Total price ($)</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {row.history.map((historyRow) => (
                    <TableRow key={historyRow.date}>
                      <TableCell component="th" scope="row">
                        {historyRow.date}
                      </TableCell>
                      <TableCell>{historyRow.customerId}</TableCell>
                      <TableCell align="right">{historyRow.amount}</TableCell>
                      <TableCell align="right">
                        {Math.round(historyRow.amount * row.price * 100) / 100}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </Box> */}
          </Collapse>
        </TableCell>
      </TableRow>
    </React.Fragment>
  );
}

Row.propTypes = {
  row: PropTypes.shape({
    calories: PropTypes.number.isRequired,
    carbs: PropTypes.number.isRequired,
    fat: PropTypes.number.isRequired,
    history: PropTypes.arrayOf(
      PropTypes.shape({
        amount: PropTypes.number.isRequired,
        customerId: PropTypes.string.isRequired,
        date: PropTypes.string.isRequired,
      }),
    ).isRequired,
    name: PropTypes.string.isRequired,
    price: PropTypes.number.isRequired,
    protein: PropTypes.number.isRequired,
  }).isRequired,
};


export default function ResultsTable(props) {
    const {responses} = props;
    console.log("I am in resulta table");
    console.log(responses)
  return (
    <TableContainer component={Paper}>
      <Table aria-label="collapsible table">
        <TableHead>
          <TableRow className='bg-blue-400'>
            <TableCell />
            <TableCell style={{textAlign:'left',width:'20%'}}>User</TableCell>
            {
                responses[0]?.responses?.map((eachResponse) => {
                    return ( <TableCell style={{textAlign:'center', overflow: 'hidden',  maxLines: 2,textOverflow: 'ellipsis',width:'20%'}}>{eachResponse?.question}</TableCell>)
                })
            }
          </TableRow>
        </TableHead>
        <TableBody>
          {responses.map((response) => (
            <Row key={response._id} row={response.responses} user={response.user.firstname} />
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
}