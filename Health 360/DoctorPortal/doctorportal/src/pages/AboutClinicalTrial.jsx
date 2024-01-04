import React, { useEffect } from 'react'
import Sidebar from '../Components/Sidebar'
import { Button } from '@material-tailwind/react'
import { useState } from 'react';
import { useLocation, useParams, Link } from 'react-router-dom';
import { BACKEND_ENDPOINT } from '../constants';
import axios from 'axios';
import background from '../assets/back.jpeg'


export default function AboutClinicalTrial() {

    const location = useLocation();
    const data = new URLSearchParams(location.search).get('data');
    const clinicaltrial = data ? JSON.parse(decodeURIComponent(data)): null;
    const [usergroupcount, setUsergroupcount] = useState(null);

    async function getInfo() {
        const response = await axios.get(`${BACKEND_ENDPOINT}/usergroups/getByClinicalTrial?clinicalTrialId=${clinicaltrial._id}`)
        setUsergroupcount(response.data.length)
    }

    useEffect(() => {
        console.log("Hello")
        getInfo();
    },[])

  return (
    <div className='flex'>
        <div>
            <Sidebar clinicaltrialId={clinicaltrial._id} clinicaltrial={clinicaltrial}/>
        </div>
        <div style={{flex:1}} className='bg-gray-200'>
        <div className='flex justify-between'>
                <div style={{backgroundImage:`url(${background})`,flex:1}}>
                    
                    <div className='m-5 flex justify-center'>
                            <div>
                            <div className='text-center font-bold'>
                                 <h2 className="font-extrabold m-5">{clinicaltrial?.name}</h2>
                            </div>
                            </div>
                    </div>
                </div>
            
            </div>
            
            <div className='font-medium m-5'>
                <h4>{clinicaltrial?.description}</h4>
            </div>
            <div className='font-medium m-5'>
                <h4>{clinicaltrial?.volunteerdetails}</h4>
            </div>
            <div className='flex justify-between m-5'>
            <div style={{flex:1, height:'50vh', flexDirection:'column'}} className='text-center shadow-2xl flex items-center justify-evenly'>
                <div>
                    <h1 className='font-extrabold'>{clinicaltrial?.questionnaire.length}</h1>
                    <p>Total Number of Questionnaires</p>
                </div>

                <div>
                    <Link state={clinicaltrial} to={`/questionnaire/${clinicaltrial._id}?data=${encodeURIComponent(JSON.stringify(clinicaltrial?.questionnaire))}`}><Button className='bg-blue-500'>See All Questioners</Button></Link>
                </div>
            </div>
            <div className='text-center shadow-2xl flex items-center justify-evenly' style={{flex:1,flexDirection:'column'}}>
                <div>
                    <h1 className='font-extrabold'>{usergroupcount}</h1>
                    <p>Total Number of Sub groups</p>
                </div>
                <div>
                    <Link state={clinicaltrial} to={`/usergroups/${clinicaltrial._id}`}><Button className='bg-blue-500'>See All User groups in this Clinical trail</Button></Link>
                </div>
            </div>
            </div>
        </div>
    </div>
  )
}
