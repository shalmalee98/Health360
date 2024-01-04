import * as React from 'react';
import PropTypes from 'prop-types';
import { alpha } from '@mui/material/styles';
import Box from '@mui/material/Box';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TablePagination from '@mui/material/TablePagination';
import TableRow from '@mui/material/TableRow';
import TableSortLabel from '@mui/material/TableSortLabel';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Paper from '@mui/material/Paper';
import Checkbox from '@mui/material/Checkbox';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import FormControlLabel from '@mui/material/FormControlLabel';
import Switch from '@mui/material/Switch';
import DeleteIcon from '@mui/icons-material/Delete';
import FilterListIcon from '@mui/icons-material/FilterList';
import { visuallyHidden } from '@mui/utils';
import { useEffect } from 'react';
import { Navigate, useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../constants';
import AddIcon from '@mui/icons-material/Add';
import { Button, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle, TextField } from '@mui/material';
import GroupIcon from '@mui/icons-material/Group';

function createData(_id, username, firstname, lastname, typeofuser) {
  return {
    _id,
    username,
    firstname,
    lastname,
    typeofuser,
  };
}

function descendingComparator(a, b, orderBy) {
  if (b[orderBy] < a[orderBy]) {
    return -1;
  }
  if (b[orderBy] > a[orderBy]) {
    return 1;
  }
  return 0;
}

function getComparator(order, orderBy) {
  return order === 'desc'
    ? (a, b) => descendingComparator(a, b, orderBy)
    : (a, b) => -descendingComparator(a, b, orderBy);
}

function stableSort(array, comparator) {
  const stabilizedThis = array.map((el, index) => [el, index]);
  stabilizedThis.sort((a, b) => {
    const order = comparator(a[0], b[0]);
    if (order !== 0) {
      return order;
    }
    return a[1] - b[1];
  });
  return stabilizedThis.map((el) => el[0]);
}

const headCells = [
  {
    id: '_id',
    numeric: false,
    disablePadding: true,
    label: 'ID',
  },
  {
    id: 'username',
    numeric: false,
    disablePadding: false,
    label: 'Email id',
  },
  {
    id: 'firstname',
    numeric: false,
    disablePadding: false,
    label: 'First Name',
  },
  {
    id: 'lastname',
    numeric: false,
    disablePadding: false,
    label: 'Last Name',
  },
  {
    id: 'typeofuser',
    numeric: false,
    disablePadding: false,
    label: 'Type of User',
  },
];

function deleteUsers() {
    console.log('Selected users: ')
}


function EnhancedTableHead(props) {
  const { onSelectAllClick, order, orderBy, numSelected, rowCount, onRequestSort } =
    props;
  const createSortHandler = (property) => (event) => {
    onRequestSort(event, property);
  };

  return (
    <TableHead>
      <TableRow style={{backgroundColor: '#dddfde'}}>
        <TableCell padding="checkbox">
          <Checkbox
            color="primary"
            indeterminate={numSelected > 0 && numSelected < rowCount}
            checked={rowCount > 0 && numSelected === rowCount}
            onChange={onSelectAllClick}
            inputProps={{
              'aria-label': 'select all desserts',
            }}
          />
        </TableCell>
        {headCells.map((headCell) => (
          <TableCell
            key={headCell.id}
            width={'100px'}
            align={headCell.numeric ? 'right' : 'left'}
            padding={headCell.disablePadding ? 'none' : 'normal'}
            sortDirection={orderBy === headCell.id ? order : false}
          >
            <TableSortLabel
              active={orderBy === headCell.id}
              direction={orderBy === headCell.id ? order : 'asc'}
              onClick={createSortHandler(headCell.id)}
            >
              {headCell.label}
              {orderBy === headCell.id ? (
                <Box component="span" sx={visuallyHidden}>
                  {order === 'desc' ? 'sorted descending' : 'sorted ascending'}
                </Box>
              ) : null}
            </TableSortLabel>
          </TableCell>
        ))}
      </TableRow>
    </TableHead>
  );
}

EnhancedTableHead.propTypes = {
  numSelected: PropTypes.number.isRequired,
  onRequestSort: PropTypes.func.isRequired,
  onSelectAllClick: PropTypes.func.isRequired,
  order: PropTypes.oneOf(['asc', 'desc']).isRequired,
  orderBy: PropTypes.string.isRequired,
  rowCount: PropTypes.number.isRequired,
};

function EnhancedTableToolbar(props) {
  const { numSelected, selected } = props;
  const location = useLocation();
  const clinicalTrialId = location.pathname.split('/')[2]
  const [openDialog, setOpenDialog] = React.useState(false);
  const [userGroupName, setUserGroupName] = React.useState('');
  const navigate = useNavigate();
  const {state} = useLocation();
    console.log('what is location state: ', state)
  function deleteUsers() {
    console.log('Selected users: ', selected)
  }

  const modifyUserGroup = () => {
    console.log('Selected users: ', selected)
    const query = {id: clinicalTrialId};
    const body = {usersList: selected}
    axios.put(`${BACKEND_ENDPOINT}/usergroups/update?`+ query )
    .then((result) => {
            let data = [];
            console.log(result.data);
            result.data.map(row => {
                console.log('one row:', row)
                data.push(createData(row._id, row.username, row.firstname, row.lastname, row.typeofuser));
            })
            console.log('print rows: ', data);
            // setRows(data);
        }
    ).catch(err=> console.log(err))
  }

  const createGroup = () => {
    console.log('Selected users: ', selected)
    console.log('id: ', clinicalTrialId)
    const body = {
      clinicalService: clinicalTrialId,
      groupName: userGroupName,
      usersList: selected,

    }
    axios.post(`${BACKEND_ENDPOINT}/usergroups/add?`, body )
      .then((response) => {
        console.log(response);
        setOpenDialog(false);
      })
      .catch(err => {
        console.log(err);
        setOpenDialog(false);
      });
  }

  const filterListByName = () => {
    
  }

  return (
    <Toolbar
      sx={{
        pl: { sm: 2 },
        pr: { xs: 1, sm: 1 },
        ...(numSelected > 0 && {
          bgcolor: (theme) =>
            alpha(theme.palette.primary.main, theme.palette.action.activatedOpacity),
        }),
      }}
    >
      {numSelected > 0 ? (
        <Typography
          sx={{ flex: '1 1 100%' }}
          color="inherit"
          variant="subtitle1"
          component="div"
        >
          {numSelected} selected
        </Typography>
      ) : (
        <Typography
          sx={{ flex: '1 1 100%' }}
          variant="h6"
          id="tableTitle"
          component="div"
        >
          <b>Users List </b>
        </Typography>
      )}

      {numSelected > 0 ? (
        <div style={{display: 'flex'}}>
        <Tooltip title="Delete">
          <IconButton onClick={deleteUsers}>
            <DeleteIcon />
          </IconButton>
        </Tooltip>
        <Tooltip title="Create Group">
          <IconButton onClick={() => setOpenDialog(true)}>
            <AddIcon />
          </IconButton>
        </Tooltip>
      </div>
      ) : (
        <Tooltip title="Filter list">
          <IconButton onClick={() => filterListByName()}>
            <FilterListIcon />
          </IconButton>
        </Tooltip>
      )}
      <Dialog open={openDialog} onClose={()=> setOpenDialog(false)}>
        <DialogTitle>Create User Group</DialogTitle>
        <DialogContent>
          <DialogContentText>
            To create a user group please enter a user group name here.
          </DialogContentText>
          <TextField
            autoFocus
            margin="dense"
            id="name"
            label="User Group name"
            type="userGroupName"
            fullWidth
            variant="standard"
            value={userGroupName}
            onChange={e => setUserGroupName(e.target.value)}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={()=> setOpenDialog(false)}>Cancel</Button>
          <Button onClick={createGroup}>Submit</Button>
        </DialogActions>
      </Dialog>
    </Toolbar>
  );
}

EnhancedTableToolbar.propTypes = {
  numSelected: PropTypes.number.isRequired,
  selected: PropTypes.array.isRequired,

};

export default function UsersList() {
  const [order, setOrder] = React.useState('asc');
  const [orderBy, setOrderBy] = React.useState('_id');
  const [selected, setSelected] = React.useState([]);
  const [page, setPage] = React.useState(0);
  const [rowsPerPage, setRowsPerPage] = React.useState(5);
  const [rows, setRows] = React.useState([]);
  const location = useLocation();
  const clinicalTrialId = location.pathname.split('/')[2]
    const {state} = useLocation();
  const getAllUsers = () => {
    axios.get(`${BACKEND_ENDPOINT}/users/getAll?`)
    .then((result) => {
            let data = [];
            console.log(result.data);
            result.data.data.map(row => {
                console.log('one row:', row)
                data.push(createData(row._id, row.username, row.firstname, row.lastname, row.typeofuser));
            })
            console.log('print rows: ', data);
            setRows(data);
        }
    ).catch(err=> console.log(err))
  }

  useEffect(() => {
    getAllUsers()
  }, []);

  const handleRequestSort = (event, property) => {
    const isAsc = order === 'asc';
    setOrder(isAsc ? 'desc' : 'asc');
  };

  const handleSelectAllClick = (event) => {
    if (event.target.checked) {
      const newSelected = rows.map((n) => n._id);
      setSelected(newSelected);
      return;
    }
    setSelected([]);
  };

  const handleClick = (event, id) => {
    const selectedIndex = selected.indexOf(id);
    let newSelected = [];

    if (selectedIndex === -1) {
      newSelected = newSelected.concat(selected, id);
    } else if (selectedIndex === 0) {
      newSelected = newSelected.concat(selected.slice(1));
    } else if (selectedIndex === selected.length - 1) {
      newSelected = newSelected.concat(selected.slice(0, -1));
    } else if (selectedIndex > 0) {
      newSelected = newSelected.concat(
        selected.slice(0, selectedIndex),
        selected.slice(selectedIndex + 1),
      );
    }

    setSelected(newSelected);
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const isSelected = (id) => selected.indexOf(id) !== -1;

  // Avoid a layout jump when reaching the last page with empty rows.
  const emptyRows =
    page > 0 ? Math.max(0, (1 + page) * rowsPerPage - rows.length) : 0;

  const visibleRows = React.useMemo(
    () =>
      stableSort(rows, getComparator(order, orderBy)).slice(
        page * rowsPerPage,
        page * rowsPerPage + rowsPerPage,
      ),
    [order, orderBy, page, rowsPerPage],
  );

  return (
    localStorage.getItem('user') ? 
    <Box fullWidth style={{ marginLeft: 100, marginRight: 100, marginTop:100 }}>
      <Paper sx={{ mb: 2 }}>
        <EnhancedTableToolbar selected={selected} numSelected={selected.length} clinicalTrialId={clinicalTrialId} />
        <TableContainer fullWidth>
          <Table
            sx={{ minWidth: 750 }}
            fullWidth
            aria-labelledby="tableTitle"
            size={'medium'}
          >
            <EnhancedTableHead
              numSelected={selected.length}
              order={order}
              orderBy={orderBy}
              selectedRows={selected}
              onSelectAllClick={handleSelectAllClick}
              onRequestSort={handleRequestSort}
              rowCount={rows.length}
            />
            <TableBody>
              {rows.map((row, index) => {
                const isItemSelected = isSelected(row._id);
                const labelId = `enhanced-table-checkbox-${index}`;

                return (
                  <TableRow
                    hover
                    onClick={(event) => handleClick(event, row._id)}
                    role="checkbox"
                    aria-checked={isItemSelected}
                    tabIndex={-1}
                    key={row.name}
                    selected={isItemSelected}
                    sx={{ cursor: 'pointer' }}
                  >
                    <TableCell padding="checkbox">
                      <Checkbox
                        color="primary"
                        checked={isItemSelected}
                        inputProps={{
                          'aria-labelledby': labelId,
                        }}
                      />
                    </TableCell>
                    <TableCell
                      component="th"
                      id={labelId}
                      scope="row"
                      padding="none"
                    >
                      {row._id ? row._id : null}
                    </TableCell>
                    <TableCell align="left">{row.username ? row.username : null }</TableCell>
                    <TableCell align="left">{row.firstname ? row.firstname : null}</TableCell>
                    <TableCell align="left">{row.lastname ? row.lastname : null}</TableCell>
                    <TableCell align="left">{row.typeofuser ? row.typeofuser : null}</TableCell>
                  </TableRow>
                );
              })}
              {emptyRows > 0 && (
                <TableRow
                  style={{
                    height: (53) * emptyRows,
                  }}
                >
                  <TableCell colSpan={6} />
                </TableRow>
              )}
            </TableBody>
          </Table>
        </TableContainer>
        <TablePagination
          rowsPerPageOptions={[5, 10, 25]}
          component="div"
          count={rows.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </Paper>
    </Box>
    : <Navigate to="/login" />
  );
}
