import React, { useEffect, useState } from 'react'
import Sidebar from '../Components/Sidebar'
import { BasicCard } from '../Components/Card'
import { DashboardCountCard } from '../Components/DashboardCountCard'
import Clinitrial from '../assets/ClinicalTrials.jpeg'
import usergroup from '../assets/usergroups.png'
import notifi from '../assets/notifications.png'
import axios from 'axios'
import { BACKEND_ENDPOINT } from '../constants'

export default function Dashboard() {
    const [data,setData] = useState(null);
    const getDashboard = async () => {
        const response = await axios.get(`${BACKEND_ENDPOINT}/users/dashboard`);
        console.log(response.data)
        setData(response.data)
    }
    useEffect(() => {
        getDashboard();
    },[])
  return (
    <div className="flex bg-gray-300">
        <div>
        <Sidebar/>
        </div>
        <div classngrid grid-cols-1 md:grid-cols-6>
            <div className='flex gap-5 m-5 mb-10'>
                <div style={{flex:1}}>
                    <DashboardCountCard title="Clinical Trails" description="These are the total number of Clinical trials created" count={data?.clinicalTrialCount}/>
                </div>
                <div  style={{flex:1}}>
                    <DashboardCountCard title="Questionnaire" description="These are the total number of Questionnaire created" count={data?.questionnaireCount}/>
                </div>
                <div  style={{flex:1}}>
                    <DashboardCountCard title="User groups" description="These are the total number of User groups created" count={data?.userGroupCount}/>
                </div>
                <div  style={{flex:1}}>
                    <DashboardCountCard title="All Users" description="These are the total number of Users created" count={data?.userCount}/>
                </div>
                   
            </div>

            <div className='flex gap-5 m-5'>
                   <div style={{flex:1}}>
                        <BasicCard picture={Clinitrial} name="Clinical Trials" description="This is place where you can manage all the clinical trials, where you can create and manage those trials"/>
                   </div>

                   <div  style={{flex:1}}>
                        <BasicCard picture={usergroup} name="Global User Groups" description="This is place where you can manage all the User groups, where you can create and manage User groups"/>
                   </div>

                   <div  style={{flex:1}}>
                        <BasicCard picture={notifi} name="Notifications" description="This is place where you can manage all the Notifications, where you can create and manage those Notifications"/>
                   </div>
            </div>
            
        </div>
    </div>
  )
}
