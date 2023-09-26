Class DHCEPRFS.BL.BLIDScan Extends %RegisteredObject
{

/// debug w ##class(DHCEPRFS.BL.BLIDScan).Create("43","159","567","/ScanID/ScanID_43_201511211536267287.pdf","/DHCEPRFS2015/11/21/153626-567.pdf","5")
ClassMethod Create(AMREpisodeID As %String, AMedRecordNo As %String, AUserID As %String, AFileMasterID As %String, AFileMasterPath As %String, AFilePhysicalPath As %String, ATotCount As %String)
{
	s obj = ##class(DHCEPRFS.INST.IDScan).%New()
	s obj.MREpisodeID = AMREpisodeID
	s obj.MedRecordNo = AMedRecordNo
	s obj.ActUserID = AUserID
	s obj.FileMasterID = AFileMasterID
	s obj.FileMasterPath = AFileMasterPath
	s obj.FilePhysicalPath = AFilePhysicalPath
	s obj.TotCount = ATotCount
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2) 	
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	获取扫描记录 - 从MRLogDtlFinal表中取数据，表明对一次就诊只取最后一次扫描记录
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserName	用户名
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLIDScan","GetScanIDList","2015-06-01","2015-11-30","","")
Query GetScanIDList(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String) As %Query(ROWSPEC = "ID:%String,ScanUserID:%String,ScanUserName:%String,ScanDateTime:%String,FilePhysicalPath:%String,MRPatientID:%String,MREpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Sex:%String,AdmDateTime:%String,DisDateTime:%String,AdmInLoc:%String,DischgrgeLoc:%String")
{
}

ClassMethod GetScanIDListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
 	s AStartDate = $zdh(AStartDate,3)
 	s AEndDate = $zdh(AEndDate,3)
 	s:(AUserName = $c(0)) AUserName = ""
 	s:(AMedRecordID = $c(0)) AMedRecordID = ""
 	s:(AMedRecordID '= "") AMedRecordID = $zcvt(AMedRecordID,"U")
 	
 	if (AUserName '= "")
 	{
	 	s userID = ""
	 	s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetUserIDByUserName")
	 	s sc = rset.Execute(AUserName)
	 	while (rset.Next())
	 	{
		 	s SSUserID = rset.Data("SSUserID")	
		 	s userID = ""
		 	if ((SSUserID = "") || (SSUserID = $c(0)))
		 	{
				s userID = "TEMP^"_rset.Data("UserID") 	
			}
			else
			{
				s userID = SSUserID	
			}
			
 			for date = AStartDate:1:AEndDate
 			{
	 			s time = ""
	 			for {
		 			s time = $O(^DHCEPRFS.INST.IDScanI("IdxUserID"," "_userID,date,time))
		 			q:(time="")
		 			
		 			s rowID = ""
		 			for {
			 			s rowID = $O(^DHCEPRFS.INST.IDScanI("IdxUserID"," "_userID,date,time,rowID))
			 			q:(rowID="")

				 		do OutputScanIDLog(rowID)  
		 			}
	 			}
 			}
	 	}
	 	d rset.Close()
 	}
 	elseif (AMedRecordID '= "")
 	{
 		for date = AStartDate:1:AEndDate
 		{
	 		s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.IDScanI("IdxMedRecordNo"," "_AMedRecordID,date,time))
		 		q:(time="")
			
		 		s rowID = ""
		 		for {
			 		s rowID = $O(^DHCEPRFS.INST.IDScanI("IdxMedRecordNo"," "_AMedRecordID,date,time,rowID))
			 		q:(rowID="")

				 	do OutputScanIDLog(rowID)  
				}
			}
		}
	}
	else
	{
 		for date = AStartDate:1:AEndDate
 		{
	 		s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.IDScanI("IdxDateTime",date,time))
		 		q:(time="")
			
		 		s rowID = ""
		 		for {
			 		s rowID = $O(^DHCEPRFS.INST.IDScanI("IdxDateTime",date,time,rowID))
			 		q:(rowID="")

				 	do OutputScanIDLog(rowID)  
				}
			}
		}	
	}
 	
 	q $$$OK	
 	
OutputScanIDLog(rowID)
	s obj = ##class(DHCEPRFS.INST.IDScan).%OpenId(rowID) 
	s actUserID = obj.ActUserID
    if ($p(actUserID,"^",1) = "TEMP")
    {
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(actUserID,"^",2))
		s actUserName = objUser.UserName    
	}
	else
	{
    	s actUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(actUserID)
	}
	
	s actDate = obj.ActDate
	s actTime = obj.ActTime
	if (actDate '= "") 
    {
	    s actDateTime = $zd(actDate,3)_" "_$zt(actTime,3)
    }
	
	s physicalPath = ##class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(obj.FileMasterID)
	
	s mrEpisodeID = obj.MREpisodeID
	s objMREpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
    q:(objMREpisode = "")
	s MedRecordNo = objMREpisode.MedRecordNo 
    s AdmDate = objMREpisode.AdmDate
    if AdmDate '= "" s AdmDateTime = $zd(AdmDate,3)
	s AdmTime = objMREpisode.AdmTime
	s DisDate = objMREpisode.DisDate
	if DisDate '= "" s DisDateTime = $zd(DisDate,3)
	s DisTime = objMREpisode.DisTime
	s AdmLoc = objMREpisode.AdmLoc
    s DisLoc = objMREpisode.DisLoc
    s MainDiagDesc = ""
    s MrPatientID = objMREpisode.MRPatientID
    d objMREpisode.%Close()
	
    s objMRPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MrPatientID)
    s Name = objMRPatient.Name
    s Birthday = objMRPatient.Birthday
    if Birthday '= "" s Birthday = $zd(Birthday,3)
    s Age = objMRPatient.Age	
    s Sex = objMRPatient.Gender
    s HouseAddress = objMRPatient.HouseAddress
    s LinkName = objMRPatient.LinkName	
    s LinkRelation = objMRPatient.LinkRelation
    if MedRecordNo = "" s MedRecordNo = objMRPatient.MedRecordNo
    d objMRPatient.%Close()
    
    s ^CacheTemp(repid,ind) = $lb(rowID,actUserID,actUserName,actDateTime,physicalPath,MrPatientID,mrEpisodeID,MedRecordNo,Name,Birthday,Sex,AdmDateTime,DisDateTime,AdmLoc,DisLoc)
	s ind = ind + 1
	
	quit
}

ClassMethod GetScanIDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanIDListExecute ]
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

ClassMethod GetScanIDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanIDListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
