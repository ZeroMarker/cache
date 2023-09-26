/// 名称: DHCHAI.IRS.INFICDSrv
/// 描述: 感染报告-疾病诊断相关服务
/// 编写者：liyi
/// 编写日期: 2017-09-19
Class DHCHAI.IRS.INFICDSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-09-19
/// Description:  查询感染报告疾病诊断
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.INFICDSrv","QryINFICDByRep","","6")
Query QryINFICDByRep(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,MRDiagID:%String,ICDDesc:%String,ICDDesc2:%String,ICDDate:%String,ICDTime:%String,UpdateDate:%String,UpdateTime:%String,UpdateUserID:%String,UpdateUser:%String")
{
}

ClassMethod QryINFICDByRepExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
 	
 	If aReportID'=""{ 
	 	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(aReportID)
	 	Quit:'$isobject(objRep) $$$OK
	 	Quit:'$IsObject(objRep.IREpisodeDr) $$$OK
		
		Set LinkICDs = objRep.IRLinkICDs
		Quit:LinkICDs="" $$$OK
	 	For indx = 1:1:$length(LinkICDs,","){
			Set ID = $p(LinkICDs,",",indx)
			Continue:ID=""
			Set Data = ..BuildINFICDData(ID)
			Continue:Data=""
			
			Set ^CacheTemp(repid,ind)=Data
	    	Set ind=ind+1
	 	}
 	}else{
	 	Set xID=""
		For {
			Set xID=$o(^DHCHAI.DP.MRDiagnosI("IndexEpisodeDr",aEpisodeID,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.DP.MRDiagnos).GetObjById(xID)
			Continue:'$isobject(obj)
			Set IsActive=obj.MRIsActive
			Continue:IsActive'=1
			
			Set ICD10  		= obj.MRDiagICD10
			Set DiagDesc   	= obj.MRDiagDesc
			Set DiagDate    = obj.MRDiagDate
			Set:DiagDate'="" DiagDate=##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DiagDate)
			Set DiagTime    = obj.MRDiagTime
			Set:DiagTime'="" DiagTime=$zt(DiagTime)
			Set Data=$lb("",aEpisodeID,"",xID,DiagDesc,"",DiagDate,DiagTime,"","","","")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryINFICDByRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryINFICDByRepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryINFICDByRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryINFICDByRepExecute ]
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

/// 取单个疾病诊断信息
ClassMethod BuildINFICDData(aINFICDID As %String) As %String
{
	New (aINFICDID)
	Set return=""
	Quit:aINFICDID="" return
	
	Set objINFICD = ##class(DHCHAI.IR.INFICD).GetObjById(aINFICDID)
	Quit:'$IsObject(objINFICD) return
	Quit:'$IsObject(objINFICD.IREpisodeDr) return
	
	Set EpisodeID=objINFICD.IREpisodeDr.%Id()
	Set objMRDiag = objINFICD.IRICDDr
	Set MRDiagID = ""
	If $IsObject(objMRDiag){
		Set MRDiagID = objMRDiag.%Id()
	}
	Set ICDDesc = objINFICD.IRICDDesc
	Set ICDDesc2 = objINFICD.IRICDDesc2
	Set ICDDate = objINFICD.IRICDDate
	Set:ICDDate'="" ICDDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ICDDate)
	Set ICDTime = objINFICD.IRICDTime
	Set:ICDTime'="" ICDTime=$zt(ICDTime)
	Set UpdateDate = objINFICD.IRUpdateDate
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(UpdateDate)
	Set UpdateTime = objINFICD.IRUpdateTime
	Set:UpdateTime'="" UpdateTime=$zt(UpdateTime)
	Set objUpdateUser = objINFICD.IRUpdateUserDr
	Set (UpdateUserID,UpdateUser)=""
	If $IsObject(objUpdateUser){
		Set UpdateUserID = objUpdateUser.%Id()
		Set UpdateUser = objUpdateUser.BTDesc
	}
	Set return = $lb(aINFICDID,EpisodeID,MRDiagID,ICDDesc,ICDDesc2,ICDDate,ICDTime,UpdateDate,UpdateTime,UpdateUserID,UpdateUser)
	Quit return
}

}
