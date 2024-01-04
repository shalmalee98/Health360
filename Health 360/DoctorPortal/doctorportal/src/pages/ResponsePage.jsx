import React, { useEffect, useState } from 'react';
import ResultsTable from '../Components/ResultsTable';
import Sidebar from '../Components/Sidebar';
import { Button } from '@material-tailwind/react';
import { useLocation, useParams } from 'react-router-dom';
import axios from 'axios';
import { BACKEND_ENDPOINT } from '../constants';
import * as XLSX from 'xlsx'

export default function ResponsePage(props) {
  const { id } = useParams();
  const location = useLocation();
  const clinicaltrial = location.state;
  const [userRes, setUserRes] = useState([]);

  const getResponse = async () => {
    const response = await axios.get(`${BACKEND_ENDPOINT}/responses/get/${id}`);
    setUserRes(response.data);
  };

  const downloadExcel = () => {
    const questionsSet = new Set();
    userRes.forEach((item) => {
      item.userResponses.forEach((userResponse) => {
        userResponse.responses.forEach((response) => {
          questionsSet.add(response.question);
        });
      });
    });
  
    const questions = Array.from(questionsSet);
  
    const data = userRes.flatMap((item) =>
      item.userResponses.map((userResponse) => {
        const rowData = {
          username: userResponse.user.username,
        };
  
        userResponse.responses.forEach((response) => {
          rowData[response.question] = response.response.join(', ');
        });
  
        return rowData;
      })
    );
    const columns = ['username', ...questions];
    const ws = XLSX.utils.json_to_sheet([{}].concat(data), { header: columns });
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Responses');
    XLSX.writeFile(wb, 'userResponses.xlsx');
  };
  

  useEffect(() => {
    getResponse();
  }, []);

  return (
    <div>
      <div className='bg-gray-200' style={{ flex: 1 }}>
        <div className='m-2 bg-white-200  p-5 bg-blue'>
          <div className='flex justify-between'>
            <div>
              <h3 className='font-medium' style={{ fontSize: '20px' }}>
                Clinical Trail's Questionnaire 1 Responses:
              </h3>
              <p className='font-light mt-1'>This is the response of users</p>
            </div>
            <div>
              <Button onClick={downloadExcel} className='bg-blue-500'>
                Download Response
              </Button>
            </div>
          </div>
          <div style={{ flex: 1 }}>
            <div className='shadow-2xl p-1 bg-gray-300'>
              {userRes.length > 0 && <ResultsTable responses={userRes[0]?.userResponses} />}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
