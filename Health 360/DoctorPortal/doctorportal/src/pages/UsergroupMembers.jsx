import React from 'react'
import Sidebar from '../Components/Sidebar'
import { UsersTable } from '../Components/UsersTable'
import { useLocation } from 'react-router-dom'

export default function UsergroupMembers(props) {
  const location = useLocation();
  const clinicaltrial = location.state;
  //window.alert(JSON.stringify(clinicaltrial))
  return (
    <div className="bg-gray-200 flex">
        <div>
            <Sidebar clinicaltrialId={clinicaltrial._id} clinicaltrial={clinicaltrial} />
        </div>
        <div className='mt-5 ml-5' style={{height:'88vh', overflowY:'scroll', flex: 1}}>
            <UsersTable page="Trial Members" clinicaltrial={clinicaltrial}/>
        </div>
    </div>
  )
}
