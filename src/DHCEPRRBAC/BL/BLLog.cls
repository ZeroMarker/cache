Class DHCEPRRBAC.BL.BLLog Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.Log).AddLog("159","610","VIEW","1","1||1")
ClassMethod AddLog(AUserID As %String, AEpisodeID As %String, ALogType As %String, AAuthorizationID As %String, AAuthorizationGroupID As %String)
{
	s obj = ##class(DHCEPRRBAC.INST.Log).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.LogType = ALogType
	s obj.UserID = AUserID
	s obj.AuthorizationGroupID = AAuthorizationGroupID
	s obj.AuthorizationID = AAuthorizationID
	s obj.LogDate = $p($h,",",1)
	s obj.LogTime = $p($h,",",2)
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLLog","GetHistoryList","2776","VIEW","2015-04-27","2015-05-04","A")
Query GetHistoryList(AUserID As %String, ALogType As %String, AStartDate As %String, AEndDate As %String, AViewType As %String) As %Query(ROWSPEC = "UserID:%String,UserName:%String,AppointStatus:%String,AppointStatusDesc:%String,AuthorizationID:%String,AuthorizationGroupID:%String,LogDate:%String,LogTime:%String,EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmWard:%String,PAAdmLoc:%String,PADischgeDate:%String,PADischgeTime:%String,PAAdmDoc:%String,PayMode:%String")
{
}

ClassMethod GetHistoryListExecute(ByRef qHandle As %Binary, AUserID As %String, ALogType As %String, AStartDate As %String, AEndDate As %String, AViewType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	Set langid=20  //登录语言
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set EnableTranslation=0  //翻译功能启用标识
	If (##class(%Dictionary.CompiledMethod).%ExistsId("User.Abstract||GetTranByDesc"))
	{
		Set EnableTranslation=1
	}
	
	s:(AStartDate = $c(0)) AStartDate = ""
	s:(AEndDate = $c(0)) AEndDate = ""
	s:(AEndDate '= "") AEndDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(AEndDate)
	s:(AStartDate '= "") AStartDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(AStartDate)
	if (AEndDate = "")
	{
		s AEndDate = $p($h,",",1)
	}
	
	s logDate = AEndDate + 1
	if (AUserID '= "")
	{
		for {
			s logDate = $o(^DHCEPRRBAC.INST.LogI("IdxUserID"," "_AUserID," "_ALogType,logDate),-1)
			q:(logDate = "")
			q:((AStartDate '= "") && (AStartDate > logDate))
			
			s logTime = ""
			for {
				s logTime = $o(^DHCEPRRBAC.INST.LogI("IdxUserID"," "_AUserID," "_ALogType,logDate,logTime),-1)
				q:(logTime = "")
				
				s rowID = ""
				for {
					s rowID = $o(^DHCEPRRBAC.INST.LogI("IdxUserID"," "_AUserID," "_ALogType,logDate,logTime,rowID))
					q:(rowID = "")
					
					s obj = ##class(DHCEPRRBAC.INST.Log).%OpenId(rowID)
					s AuthorizationGroupID = obj.AuthorizationGroupID
					s AuthorizationID = obj.AuthorizationID
					if (AuthorizationID = "default")
					{
						s AppointStatus = "D"
					}
					else
					{
						s objAG = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(AuthorizationGroupID)
						s AppointStatus = objAG.AppointStatus
						if (AppointStatus = "F")
						{
							s ret = ##class(DHCEPRRBAC.BL.BLFSAuthorization).CheckAppointIsActive(AuthorizationGroupID)
							s:(ret = "0") AppointStatus = "I"  //已过期
						}
					}
					if (AViewType = "D")
					{
						continue:(AppointStatus '= "D")
					}
					elseif (AViewType = "N")
					{
						continue:(AppointStatus = "D")
					}
					d OutPutRow
				}
			}
		}
	}
	else  //AUserID为空，取所有用户的浏览日志
	{
		for {
			s logDate = $o(^DHCEPRRBAC.INST.LogI("IdxLogDateTime"," "_ALogType,logDate),-1)
			q:(logDate = "")
			q:((AStartDate '= "") && (AStartDate > logDate))
			
			s logTime = ""
			for {
				s logTime = $o(^DHCEPRRBAC.INST.LogI("IdxLogDateTime"," "_ALogType,logDate,logTime),-1)
				q:(logTime = "")
				
				s rowID = ""
				for {
					s rowID = $o(^DHCEPRRBAC.INST.LogI("IdxLogDateTime"," "_ALogType,logDate,logTime,rowID))
					q:(rowID = "")
					
					s obj = ##class(DHCEPRRBAC.INST.Log).%OpenId(rowID)
					s AuthorizationGroupID = obj.AuthorizationGroupID
					s AuthorizationID = obj.AuthorizationID
					if (AuthorizationID = "default")
					{
						s AppointStatus = "D"
					}
					else
					{
						s objAG = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(AuthorizationGroupID)
						s AppointStatus = objAG.AppointStatus
						if (AppointStatus = "F")
						{
							s ret = ##class(DHCEPRRBAC.BL.BLFSAuthorization).CheckAppointIsActive(AuthorizationGroupID)
							s:(ret = "0") AppointStatus = "I"  //已过期
						}
					}
					if (AViewType = "D")
					{
						continue:(AppointStatus '= "D")
					}
					elseif (AViewType = "N")
					{
						continue:(AppointStatus = "D")
					}
					d OutPutRow
				}
			}
		}
	}
	Quit $$$OK
OutPutRow
	s UserID = obj.UserID
	s UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
	
	s EpisodeID = obj.EpisodeID
	s AuthorizationID = obj.AuthorizationID
	
	s LogDate = obj.LogDate  //浏览日期
	s LogTime = obj.LogTime  //浏览时间
	s:(LogDate '= "") LogDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(LogDate)
	s:(LogTime '= "") LogTime = $zt(LogTime)
	
	s MREpisodeID = ""
	s MREpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_EpisodeID,MREpisodeID))
	
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
	
	s PatientID = objMRPatient.PatientID
	s MedRecordNo = objMREpisode.MedRecordNo
	s RegNo = objMRPatient.RegNo
	
	//就诊类型
	s PAAdmType = objMREpisode.AdmType
	
	//病人姓名
	s PAPMIName = objMRPatient.Name
	
	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""
	s DobDate = objMRPatient.Birthday
	If DobDate '= ""
	{
		s PAPMIDOB = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(DobDate)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	
	//性别 
	s PAPMISex = objMRPatient.Gender
	
	s PAAdmDate = objMREpisode.AdmDate  //入院日期
	s PAAdmTime = objMREpisode.AdmTime  //入院时间
	s:(PAAdmDate '= "") PAAdmDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(PAAdmDate)
	s:(PAAdmTime '= "") PAAdmTime = $zt(PAAdmTime)
	
	s PAAdmWard = objMREpisode.AdmWard  //病区
	
	//当前科室
	s PAAdmLoc = objMREpisode.AdmLoc
	if (PAAdmLoc = $c(0)) s PAAdmLoc = ""
	
	//出院日期时间
	s PADischgeDate = objMREpisode.DisDate  //出院日期
	s PADischgeTime = objMREpisode.DisTime  //出院时间
	s:(PADischgeDate '= "") PADischgeDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(PADischgeDate)
	s:(PADischgeTime '= "") PADischgeTime = $zt(PADischgeTime)
	
	//在院状态
	s PAStatusType = "出院"
	
	//医生
	s PAAdmDoc = objMREpisode.MainDoctor
	
	//付费方式
	s PayMode = objMREpisode.PayMode
	
	s AppointStatusDesc = ##class(DHCEPRRBAC.Util.Utilization).GetStatusDesc(AppointStatus)
	
	if (EnableTranslation = 1)
	{
		s:(UserName'="") UserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",UserName,langid)
		s:(PAAdmLoc'="") PAAdmLoc = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",PAAdmLoc,langid)
		s:(PAAdmWard'="") PAAdmWard = ##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
		s:(PAAdmDoc'="") PAAdmDoc = ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PAAdmDoc,langid)
		s:(PAPMISex'="") PAPMISex = ##class(User.CTSex).GetTranByDesc("CTSEXDesc",PAPMISex,langid)
	}
	
	s data = $lb(UserID,UserName,AppointStatus,AppointStatusDesc,AuthorizationID,AuthorizationGroupID,LogDate,LogTime,EpisodeID,PatientID,MedRecordNo,RegNo,PAStatusType,PAAdmType,PAPMIName,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDate,PAAdmTime,PAAdmWard,PAAdmLoc,PADischgeDate,PADischgeTime,PAAdmDoc,PayMode)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetHistoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHistoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHistoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHistoryListExecute ]
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

}
