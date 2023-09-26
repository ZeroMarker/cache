/// 名称: DHCMed.NINFService.Rep.HandHyReport
/// 描述: 手卫生依从性、正确性报告
/// 编写者：zhufei
/// 编写日期: 2012-06-27
Class DHCMed.NINFService.Rep.HandHyReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-27
/// Description:  保存手卫生依从性、正确性报告
/// Table：       DHCMed.NINF.Rep.HandHyReport
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCMed.NINFService.Rep.HandHyReport).SaveRepRec("^117^2013-06-28^^9^3716^沙发垫^打发大水^3721^3727^3732^117^9^1^打发点","^")
ClassMethod SaveRepRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	//Set $ZT="SaveRepRecErr"
	
	Quit:aSeparate="" return
	
	Set ReportID=$p(aInput,aSeparate,1)
	Set ObsLoc=$p(aInput,aSeparate,2)
	Set ObsDate=$p(aInput,aSeparate,3)
	;Set:ObsDate["-" ObsDate=$zdh(ObsDate,3)
	Set:ObsDate'="" ObsDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ObsDate)
	Set ObsTime=$p(aInput,aSeparate,4)
	Set:ObsTime[":" ObsTime=$zth(ObsTime,2)
	Set ObsUser=$p(aInput,aSeparate,5)
	Set StIdentity=$p(aInput,aSeparate,6)
	Set StInitials=$p(aInput,aSeparate,7)
	Set StName=$p(aInput,aSeparate,8)
	Set Point=$p(aInput,aSeparate,9)
	Set Action=$p(aInput,aSeparate,10)
	Set ActionRit=$p(aInput,aSeparate,11)
	Set RepLoc=$p(aInput,aSeparate,12)
	Set RepUser=$p(aInput,aSeparate,13)
	Set RepStatus=$p(aInput,aSeparate,14)
	Set RepStatusID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"NINFHandHyReportStatus")
	Set Resume=$p(aInput,aSeparate,15)
	
	Set $p(aInput,aSeparate,3)=ObsDate
	Set $p(aInput,aSeparate,4)=ObsTime
	Set $p(aInput,aSeparate,14)=RepStatusID
	
	Set return=##Class(DHCMed.NINF.Rep.HandHyReport).Update(aInput,aSeparate)
	Quit return
	
SaveRepRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-08-08
/// Description:  保存手卫生依从性、正确性报告(只更新报告状态)
/// Table：       DHCMed.NINF.Rep.HandHyReport
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCMed.NINFService.Rep.HandHyReport).SaveRepStatus("4^117^9^0^","^")
ClassMethod SaveRepStatus(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveRepStatusErr"
	
	Set RepordID=$p(aInput,aSeparate,1)
	Set LogLoc=$p(aInput,aSeparate,2)
	Set LogUser=$p(aInput,aSeparate,3)
	Set RepStatus=$p(aInput,aSeparate,4)
	Set RepStatus=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatus,"NINFHandHyReportStatus")
	Set LogResume=$p(aInput,aSeparate,5)
	
	Set obj=##class(DHCMed.NINF.Rep.HandHyReport).%OpenId(RepordID)
	Quit:'$IsObject(obj) return
	Set obj.HHRRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatus)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set flg=##Class(DHCMed.NINF.Rep.HandHyReportLog).Update(aInput,aSeparate)
	}
	Do obj.%Close()
	
	Quit return
	
SaveRepStatusErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-07-01
/// Description:  查询手卫生依从、正确性报告信息
/// Table：       DHCMed.NINF.Rep.HandHyReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.HandHyReport","QryHandHyRep","2012-08-27","2012-08-27","","")
Query QryHandHyRep(aDateFrom As %String, aDateTo As %String, aLoc As %String, aRepStatus As %String) As %Query(ROWSPEC = "ReportID:%String,ObsLocID:%String,ObsLocDesc:%String,ObsDate:%String,ObsTime:%String,ObsUserID:%String,ObsUserDesc:%String,StIdentityID:%String,StIdentityDesc:%String,StInitials:%String,StName:%String,PointID:%String,PointDesc:%String,ActionID:%String,ActionDesc:%String,ActionRitID:%String,ActionRitDesc:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepStatusID:%String,RepStatusCode:%String,RepStatusDesc:%String,RepResume:%String")
{
}

ClassMethod QryHandHyRepExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLoc As %String, aRepStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("HandHy",0,"IndexObsDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.NINFi("HandHy",0,"IndexObsDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Continue:(aLoc'="")&&(xLoc'=aLoc)
			
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("HandHy",0,"IndexObsDateLoc",xDate,xLoc,xId))
				Quit:xId=""
				
				Set obj=##class(DHCMed.NINF.Rep.HandHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				
				Set (ReportID,ObsLocID,ObsLocDesc,ObsDate,ObsTime,ObsUserID,ObsUserDesc)=""
				Set (StIdentityID,StIdentityDesc,StInitials,StName,PointID,PointDesc,ActionID,ActionDesc,ActionRitID,ActionRitDesc)=""
				Set (RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepStatusID,RepStatusCode,RepStatusDesc,RepResume)=""
				
				Set ReportID=obj.%Id()
				If $IsObject(obj.HHRRepStatus) {
					Set RepStatusID=obj.HHRRepStatus.%Id()
					Set RepStatusCode=obj.HHRRepStatus.Code
					//Continue:RepStatusCode="0"
					Set RepStatusDesc=obj.HHRRepStatus.Description
					Continue:(aRepStatus'="")&&(aRepStatus'[RepStatusCode)
				}
				
				Set ObsLocID=obj.HHRObsLoc
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(ObsLocID)
				If $IsObject(objLoc) {
					Set ObsLocID=objLoc.Rowid
					Set ObsLocDesc=objLoc.Descs
				}
				Set ObsDate=obj.HHRObsDate
				;Set:ObsDate'="" ObsDate=$zd(ObsDate,3)
				Set:ObsDate'="" ObsDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ObsDate)
				Set ObsTime=obj.HHRObsTime
				Set:ObsTime'="" ObsTime=$zt(ObsTime,2)
				Set ObsUserID=obj.HHRObsUser
				Set objUser=##class(DHCMed.Base.SSUser).GetObjById(ObsUserID)
				If $IsObject(objUser) {
					Set ObsUserID=objUser.Rowid
					Set ObsUserDesc=objUser.Name
				}
				If $IsObject(obj.HHRStIdentity) {
					Set StIdentityID=obj.HHRStIdentity.%Id()
					Set StIdentityDesc=obj.HHRStIdentity.Description
				}
				Set StInitials=obj.HHRStInitials
				Set StName=obj.HHRStName
				If $IsObject(obj.HHRPoint) {
					Set PointID=obj.HHRPoint.%Id()
					Set PointDesc=obj.HHRPoint.Description
				}
				If $IsObject(obj.HHRAction) {
					Set ActionID=obj.HHRAction.%Id()
					Set ActionDesc=obj.HHRAction.Description
				}
				If $IsObject(obj.HHRActionRit) {
					Set ActionRitID=obj.HHRActionRit.%Id()
					Set ActionRitDesc=obj.HHRActionRit.Description
				}
				
				Set RepDate=obj.HHRRepDate
				;Set:RepDate'="" RepDate=$zd(RepDate,3)
				Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
				Set RepTime=obj.HHRRepTime
				Set:RepTime'="" RepTime=$zt(RepTime,2)
				Set RepLocID=obj.HHRRepLoc
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
				If $IsObject(objLoc) {
					Set RepLocID=objLoc.Rowid
					Set RepLocDesc=objLoc.Descs
				}
				Set RepUserID=obj.HHRRepUser
				Set objUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
				If $IsObject(objUser) {
					Set RepUserID=objUser.Rowid
					Set RepUserDesc=objUser.Name
				}
				Set RepResume=obj.HHRResume
				
				Set Data=$lb(ReportID,ObsLocID,ObsLocDesc,ObsDate,ObsTime,ObsUserID,ObsUserDesc)
				Set Data=Data_$lb(StIdentityID,StIdentityDesc,StInitials,StName,PointID,PointDesc)
				Set Data=Data_$lb(ActionID,ActionDesc,ActionRitID,ActionRitDesc)
				Set Data=Data_$lb(RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc)
				Set Data=Data_$lb(RepStatusID,RepStatusCode,RepStatusDesc,RepResume)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryHandHyRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHandHyRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyRepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2013-07-01
/// Description:  手卫生依从、正确性统计
/// Table：       DHCMed.NINF.Rep.HandHyReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.HandHyReport","QryHandHyToStat","2012-01-01","2013-08-01","")
Query QryHandHyToStat(aDateFrom As %String, aDateTo As %String, aLoc As %String) As %Query(ROWSPEC = "ReportID:%String,ObsLocID:%String,ObsLocDesc:%String,ObsDate:%String,ObsTime:%String,ObsUserID:%String,ObsUserDesc:%String,StIdentityID:%String,StIdentityDesc:%String,StInitials:%String,StName:%String,PointID:%String,PointDesc:%String,ActionID:%String,ActionDesc:%String,ActionRitID:%String,ActionRitDesc:%String,RepDate:%String,RepTime:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepStatusID:%String,RepStatusCode:%String,RepStatusDesc:%String,RepResume:%String") [ SqlProc ]
{
}

ClassMethod QryHandHyToStatExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINFi("HandHy",0,"IndexObsDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xLoc=""
		For {
			Set xLoc=$o(^DHCMed.NINFi("HandHy",0,"IndexObsDateLoc",xDate,xLoc))
			Quit:xLoc=""
			Continue:(aLoc'="")&&(xLoc'=aLoc)
			
			Set xId=0
			For {
				Set xId=$o(^DHCMed.NINFi("HandHy",0,"IndexObsDateLoc",xDate,xLoc,xId))
				Quit:xId=""
				
				Set obj=##class(DHCMed.NINF.Rep.HandHyReport).GetObjById(xId)
				Continue:'$IsObject(obj)
				
				Set (ReportID,ObsLocID,ObsLocDesc,ObsDate,ObsTime,ObsUserID,ObsUserDesc)=""
				Set (StIdentityID,StIdentityDesc,StInitials,StName,PointID,PointDesc,ActionID,ActionDesc,ActionRitID,ActionRitDesc)=""
				Set (RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepStatusID,RepStatusCode,RepStatusDesc,RepResume)=""
				
				Set ReportID=obj.%Id()
				If $IsObject(obj.HHRRepStatus) {
					Set RepStatusID=obj.HHRRepStatus.%Id()
					Set RepStatusCode=obj.HHRRepStatus.Code
					Continue:RepStatusCode="0"
					Set RepStatusDesc=obj.HHRRepStatus.Description
				}
				
				Set ObsLocID=obj.HHRObsLoc
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(ObsLocID)
				If $IsObject(objLoc) {
					Set ObsLocID=objLoc.Rowid
					Set ObsLocDesc=objLoc.Descs
				}
				Set ObsDate=obj.HHRObsDate
				Set:ObsDate'="" ObsDate=$zd(ObsDate,3)
				Set ObsTime=obj.HHRObsTime
				Set:ObsTime'="" ObsTime=$zt(ObsTime,2)
				Set ObsUserID=obj.HHRObsUser
				Set objUser=##class(DHCMed.Base.SSUser).GetObjById(ObsUserID)
				If $IsObject(objUser) {
					Set ObsUserID=objUser.Rowid
					Set ObsUserDesc=objUser.Name
				}
				If $IsObject(obj.HHRStIdentity) {
					Set StIdentityID=obj.HHRStIdentity.%Id()
					Set StIdentityDesc=obj.HHRStIdentity.Description
				}
				Set StInitials=obj.HHRStInitials
				Set StName=obj.HHRStName
				If $IsObject(obj.HHRPoint) {
					Set PointID=obj.HHRPoint.%Id()
					Set PointDesc=obj.HHRPoint.Description
				}
				If $IsObject(obj.HHRAction) {
					Set ActionID=obj.HHRAction.%Id()
					Set ActionDesc=obj.HHRAction.Description
				}
				If $IsObject(obj.HHRActionRit) {
					Set ActionRitID=obj.HHRActionRit.%Id()
					Set ActionRitDesc=obj.HHRActionRit.Description
				}
				
				Set RepDate=obj.HHRRepDate
				Set:RepDate'="" RepDate=$zd(RepDate,3)
				Set RepTime=obj.HHRRepTime
				Set:RepTime'="" RepTime=$zt(RepTime,2)
				Set RepLocID=obj.HHRRepLoc
				Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
				If $IsObject(objLoc) {
					Set RepLocID=objLoc.Rowid
					Set RepLocDesc=objLoc.Descs
				}
				Set RepUserID=obj.HHRRepUser
				Set objUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
				If $IsObject(objUser) {
					Set RepUserID=objUser.Rowid
					Set RepUserDesc=objUser.Name
				}
				Set RepResume=obj.HHRResume
				
				Set Data=$lb(ReportID,ObsLocID,ObsLocDesc,ObsDate,ObsTime,ObsUserID,ObsUserDesc)
				Set Data=Data_$lb(StIdentityID,StIdentityDesc,StInitials,StName,PointID,PointDesc)
				Set Data=Data_$lb(ActionID,ActionDesc,ActionRitID,ActionRitDesc)
				Set Data=Data_$lb(RepDate,RepTime,RepLocID,RepLocDesc,RepUserID,RepUserDesc)
				Set Data=Data_$lb(RepStatusID,RepStatusCode,RepStatusDesc,RepResume)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryHandHyToStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyToStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHandHyToStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyToStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
