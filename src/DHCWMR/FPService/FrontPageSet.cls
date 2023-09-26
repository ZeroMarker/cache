/// 名称: DHCWMR.FPService.FrontPageSet
/// 描述: 编目基本信息保存相关服务
/// 编写者：zhufei
/// 编写日期: 2014-11-24
Class DHCWMR.FPService.FrontPageSet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询编目未保存基本信息的数据
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.FPService.FrontPageSet","QryList","2016-12-15","2017-01-13")
Query QryList(aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,MrNo:%String,PatName:%String,EpisodeID:%String,BuildDate:%String,BuildTime:%String,BuildUser:%String,Type:%String")
{
}

ClassMethod QryListExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",1,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xTime=""
		For {
			Set xTime=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",1,xDate,xTime))
			Quit:xTime=""
			
			Set xFpID=0
			For {
				Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",1,xDate,xTime,xFpID))
				Quit:xFpID=""
				
				Set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
				Continue:'$IsObject(objFP)
				Continue:'$IsObject(objFP.FPVolumeDr)
				Set VolID=objFP.FPVolumeDr.%Id()
				Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(VolID)
				Continue:'$IsObject(objVol) 
				Continue:objVol.SVIsActive'=1 
				Continue:'$IsObject(objVol.SVMainDr) 
				Continue:objVol.SVMainDr.SMIsActive'=1 
				Continue:'$IsObject(objVol.SVMainDr.SMMrType)
				Set BuildDate=objFP.FPBuildDate
				Set BuildDate=$zd(BuildDate,3)
				Set BuildTime=objFP.FPBuildTime
				Set BuildTime=$zt(BuildTime,2)
				Set BuildUser=objFP.FPBuildUser
				Set Type=objFP.FPType
				
				Set MrNo=objVol.SVMainDr.SMMrNo
				Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolID)
				Continue:EpisodeID="" 
				Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
				Continue:PatientID="" 
				Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
				Set PatName =$p($g(^PAPER(+PatientID,"ALL")),"^",1)
				Continue:$d(^DHCMRQ.MR.DataMasterI("IndexEpisodeID"," V2012.HA"," HA.SY.CODING",EpisodeID))
				
				Set Data=$lb(ind,MrNo,PatName,EpisodeID,BuildDate,BuildTime,BuildUser,Type)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryListExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询编目主诊断重复的数据
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.FPService.FrontPageSet","QryDiagList","2016-12-15","2017-01-13")
Query QryDiagList(aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ind:%String,MrNo:%String,PatName:%String,EpisodeID:%String,BuildDate:%String,BuildTime:%String,BuildUser:%String,Type:%String")
{
}

ClassMethod QryDiagListExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",1,xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xTime=""
		For {
			Set xTime=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",1,xDate,xTime))
			Quit:xTime=""
			
			Set Flg=0
			
			Set xFpID=0
			For {
				Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",1,xDate,xTime,xFpID))
				Quit:xFpID=""
				Continue:Flg=1
				Set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
				Continue:'$IsObject(objFP)
				Continue:'$IsObject(objFP.FPVolumeDr)
				Set VolID=objFP.FPVolumeDr.%Id()
				Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(VolID)
				Continue:'$IsObject(objVol) 
				Continue:objVol.SVIsActive'=1 
				Continue:'$IsObject(objVol.SVMainDr) 
				Continue:objVol.SVMainDr.SMIsActive'=1 
				Continue:'$IsObject(objVol.SVMainDr.SMMrType)
				Set BuildDate=objFP.FPBuildDate
				Set BuildDate=$zd(BuildDate,3)
				Set BuildTime=objFP.FPBuildTime
				Set BuildTime=$zt(BuildTime,2)
				Set BuildUser=objFP.FPBuildUser
				Set Type=objFP.FPType
				
				Set MrNo=objVol.SVMainDr.SMMrNo
				Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolID)
				Continue:EpisodeID=""
				
				
				Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
				Continue:PatientID="" 
				Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
				Set PatName =$p($g(^PAPER(+PatientID,"ALL")),"^",1)
				Set Count=0
				Set xIndex=0
				For {
					Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPD","IndexTypeIndex",xFpID,177,xIndex))
					Quit:xIndex=""
					Continue:Flg=1
					Set xSubID=0
				 	For {
						Set xSubID=$o(^DHCWMR.FP.FrontPageI("FPD","IndexTypeIndex",xFpID,177,xIndex,xSubID))
						Quit:xSubID=""	
					  	Set Count=Count+1
					
				 	}
				 	Continue:Count<2
					Set Flg=1
				 
				 	Set Data=$lb(ind,MrNo,PatName,EpisodeID,BuildDate,BuildTime,BuildUser,Type)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				 }
				 
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryDiagListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDiagListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagListExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
