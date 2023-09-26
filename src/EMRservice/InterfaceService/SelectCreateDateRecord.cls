Class EMRservice.InterfaceService.SelectCreateDateRecord Extends (%RegisteredObject, %XML.Adaptor)
{

/// do ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.SelectCreateDateRecord","GetAllInstanceIDQueryByDate","2015-07-18","2016-07-18","")
Query GetAllInstanceIDQueryByDate(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "HappenDate,HappenTime,CreateDate,CreateTime,OperateDate,OperateTime,EpisodeID,InstanceID,CreateUser")
{
}

ClassMethod GetAllInstanceIDQueryByDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1,Count=300
 	
 	s InstanceID=""
	q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)	
	s sdate=startDate-1
	s startOutDate="",startOutTime="",startInDate="",startIntTime=""

  
    s TheECRecord=""
	for {	

	        s sdate=$o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate))
	        q:(sdate = "")
			q:(sdate>endDate)			
			s stime=""			
			for
			  {   
				  s stime = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime))
		          q:(stime = "")		         
		          s EpisodeID=""
		          for
		             {
			             s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime,EpisodeID))		                
		                 q:(EpisodeID = "")	
		                 s OperateDate =""
		                 s OperateTime =""
	                     s EMRDocID = ""	                
		                 for
			             {

				             s EMRDocID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime,EpisodeID,EMRDocID))		                
			                 q:(EMRDocID = "")		                
			                 s EMRNum = ""	                
			                 for
				             {

					             s EMRNum = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime,EpisodeID,EMRDocID,EMRNum))		                
				                 q:(EMRNum = "")		                
				                  s logRow = ""	                
				                 for
					             {

						             s logRow = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime,EpisodeID,EMRDocID,EMRNum,logRow))		                
					                 q:(logRow = "")		                
					                 s objEmrLogs = ##class(EMRinstance.EMRLogs).%OpenId(logRow)
					                  s inlogrow = ""	                
					                 for
						             {

							             s inlogrow = $o(^DHCEMRI.InstanceLogI("IdxParRef",logRow,inlogrow))		                
						                 q:(inlogrow = "")
						                 s intLotR = logRow_"||"_inlogrow                
						                 s objinLogs = ##class(EMRinstance.InstanceLog).%OpenId(intLotR)
						                 q:(objinLogs="")
						                 if (objinLogs.Action ="participantCheck")
						                 {
							                 s OperateDate = objinLogs.OperateDate
							                 s OperateTime = objinLogs.OperateTime
							                 q
						                 }
						                 
						             }
					                 
					             }
				             }
			             }
			             q:((OperateDate="")||(OperateTime=""))
		                 s EpisodeID=$tr(EpisodeID," ","")			                	                
		                 s InstanceID=..GetInstanceID(sdate,stime,EpisodeID)
		                 q:(InstanceID="")
				         s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
	                     q:(objInstance = "")
	                     q:(objInstance.Status'="Save")
	                     s CreateUser = objInstance.CreateUser
	                     s HappenDate=objInstance.HappenDate
	                     s HappenTime=objInstance.HappenTime
	                     s CreateDate=objInstance.CreateDate
	                     s CreateTime=objInstance.CreateTime
	                     s HappenDate = $ZDATE(HappenDate,3)
	                     s HappenTime = $ZTIME(HappenTime,1)
	                     s CreateDate = $ZDATE(CreateDate,3)
	                     s CreateTime = $ZTIME(CreateTime,1)
	                     s OperateDate = $ZDATE(OperateDate,3)
	                     s OperateTime = $ZTIME(OperateTime,1)
	                     
						 //s HappenTime = $zth($p(HappenTime," ",2))
	                    	                     
	                               
				         s ^CacheTemp(repid,ind) = $lb(HappenDate,HappenTime,CreateDate,CreateTime,OperateDate,OperateTime,EpisodeID,InstanceID,CreateUser)
	                     s ind=ind+1
	                     q		
		             }
			  }	
	   }
  
   Quit $$$OK
}

ClassMethod GetAllInstanceIDQueryByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllInstanceIDQueryByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllInstanceIDQueryByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllInstanceIDQueryByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetInstanceID(aCreateDate As %String, aCreateTime As %String, aEpisodeID As %String)
{
	
	s InstanceID=""
	&SQL(Select ID into :InstanceID From EMRinstance.InstanceData Where CreateDate=:aCreateDate and CreateTime=:aCreateTime and EpisodeID=:aEpisodeID)
	q InstanceID
}

}
