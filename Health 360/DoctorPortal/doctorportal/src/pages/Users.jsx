import React from 'react'
import Sidebar from '../Components/Sidebar'
import { BasicCard } from '../Components/Card'
import { UserCard } from '../Components/UserCard'

export default function Users() {
  return (
    <div className="flex bg-green-50">
        <div>
        <Sidebar/>
        </div>
        <div>

            <div className='flex gap-5 m-5'>
                   <div className=''>
                        <UserCard/>
                   </div>


                   <div>
                        <UserCard/>
                   </div>

                   <div>
                        <UserCard/>
                   </div>
                   <div>
                        <UserCard/>
                   </div>
            </div>
            
        </div>
    </div>
  )
}
