Class DHCEPRRBAC.BL.BLFSAuthorization Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: w ##class(DHCEPRRBAC.BL.BLFSAuthorization).Cancel("153","9","test")
ClassMethod Cancel(AUserID As %String, AAuthorizationIDList As %String, AReason As %String) As %String
{
	s return = "0"
	s:(AAuthorizationIDList = $c(0)) AAuthorizationIDList = ""
	q:(AAuthorizationIDList = "") return
	
	s flag = "true"
	TSTART
	s $zt = "OnCancelErrorHandler"
	
	s return = "-1"
	for index=1:1:$l(AAuthorizationIDList,"^")
	{
		s authorizationID = $p(AAuthorizationIDList,"^",index)
		s objGroup = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(authorizationID)
		s objGroup.AppointUserID = AUserID
		s objGroup.AppointEndDate = $p($h,",",1)
		s objGroup.AppointEndTime = $p($h,",",2)
		s objGroup.AppointComment = AReason
		s sc = objGroup.%Save()
		if ($$$ISERR(sc))
		{
			s flag = "false"
			q
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnCancelErrorHandler
	TROLLBACK
	q "-100"
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLFSAuthorization).Reject("153","9","test")
ClassMethod Reject(AUserID As %String, AAuthorizationIDList As %String, AReason As %String) As %String
{
	s return = "0"
	s:(AAuthorizationIDList = $c(0)) AAuthorizationIDList = ""
	q:(AAuthorizationIDList = "") return
	
	s flag = "true"
	TSTART
	s $zt = "OnRejectErrorHandler"
	
	s return = "-1"
	for index=1:1:$l(AAuthorizationIDList,"^")
	{
		s authorizationID = $p(AAuthorizationIDList,"^",index)
		
		s objGroup = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(authorizationID)
		s date = $p($h,",",1)
		s time = $p($h,",",2)
		s objGroup.AppointDate = date
		s objGroup.AppointTime = time
		s objGroup.AppointStatus = "R"
		s objGroup.AppointType = "0"
		s objGroup.AppointUserID = AUserID
		s objGroup.AppointEndDate = date
		s objGroup.AppointEndTime = time
		s objGroup.AppointComment = AReason
		
		s sc = objGroup.%Save()
		if ($$$ISERR(sc))
		{
			s flag = "false"
			q
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnRejectErrorHandler
	TROLLBACK
	q "-100"
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLFSAuthorization).AddUserRole("153","1","1","1","12")
ClassMethod AddUserRole(AUserID As %String, ARoleID As %String, AOpID As %String, AAuthorizationIDList As %String, ASpanTimeList As %String)
{
	s return = "0"
	s:(AAuthorizationIDList = $c(0)) AAuthorizationIDList = ""
	q:(AAuthorizationIDList = "") return
	
	s flag = "true"
	TSTART
	s $zt = "OnAddUserRoleErrorHandler"
	
	s return = "-1"
	for index=1:1:$l(AAuthorizationIDList,"^")
	{
		s authorizationID = $p(AAuthorizationIDList,"^",index)
		s spanTime = $p(ASpanTimeList,"^",index)
		
		s objGroup = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(authorizationID)
		s objGroup.AppointDate = $p($h,",",1)
		s objGroup.AppointTime = $p($h,",",2)
		s objGroup.AppointStatus = "F"
		s objGroup.AppointType = "0"
		s objGroup.AppointUserID = AUserID
		s objGroup.RoleID = ARoleID
		s objGroup.OperationID = AOpID
		
		s spanSecs = (+spanTime)*3600  //将小时换算成秒
		s endDateTime = ..GetEndDateTime(objGroup.AppointDate,objGroup.AppointTime,+spanSecs)
		s objGroup.AppointEndDate = $p(endDateTime,",",1)
		s objGroup.AppointEndTime = $p(endDateTime,",",2)
		
		s sc = objGroup.%Save()
		if ($$$ISERR(sc))
		{
			s flag = "false"
			q
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnAddUserRoleErrorHandler
	TROLLBACK
	q "-100"
}

ClassMethod GetEndDateTime(startDate As %Date, startTime As %Time, timeSpan As %Integer) As %String
{
	s curDate = (startTime+timeSpan)\86400
	if (curDate=0)
	{
		q startDate_","_(startTime+timeSpan)
	}
	else
	{
		s curTime = startTime+timeSpan-(curDate*86400)
		q startDate+curDate_","_curTime
	}
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLFSAuthorization).Apply("FS","1273915^5236876","159","9","134","科研病历","24")
ClassMethod Apply(AEPRAction As %String, AEpisodeString As %String, AUserID As %String, AUserLocID As %String, AUserSSGroupID As %String, AReason As %String, ASpanTime As %String) As %String
{
	s return = "0"
	s:(AEpisodeString = $c(0)) AEpisodeString = ""
	q:(AEpisodeString = "") return
	
	s flag = "true"
	TSTART
	s $zt = "OnApplyErrorHandler"
	
	s return = "-1"
	s objGroup = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%New()
	s objGroup.RequestDate = $p($h,",",1)
	s objGroup.RequestTime = $p($h,",",2)
	s objGroup.RequestUserID = AUserID
	s objGroup.RequestDept = AUserLocID
	s objGroup.RequestSSGroup = AUserSSGroupID
	s objGroup.RequestComment = AReason
	s objGroup.RequestSpan = ASpanTime
	s objGroup.EPRAction = AEPRAction
	s objGroup.AppointStatus = "N"
	s sc = objGroup.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q return
	}
	
	s return = "-2"
	for index=1:1:$l(AEpisodeString,"^")
	{
		s episodeID = $p(AEpisodeString,"^",index)
		s objAuth = ##class(DHCEPRRBAC.INST.FSAuthorization).%New()
		
		s MREpisodeID=""
		s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_episodeID,MREpisodeID))
		
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
		s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID) 
		
		s objAuth.EpisodeID = episodeID
		s objAuth.PatientID = objMRPatient.PatientID
		s objAuth.RegNo = objMRPatient.RegNo
		s objAuth.MedRecordNo = objMREpisode.MedRecordNo
		s objAuth.DetailNum = objGroup.TheFSAuthorization.Count() + 1
		s objAuth.TheFSAuthorizationGroup = objGroup
		
		s scAuth = objAuth.%Save()
		if ($$$ISERR(scAuth))
		{
			s flag = "false"
			q
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnApplyErrorHandler
	TROLLBACK
	q "-100"
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLFSAuthorization).DefaultRole("FS","1273915^5236876","159","9","134")
ClassMethod DefaultRole(AEPRAction As %String, AEpisodeString As %String, AUserID As %String, AUserLocID As %String, AUserSSGroupID As %String) As %String
{
	s return = "0"
	s:(AEpisodeString = $c(0)) AEpisodeString = ""
	q:(AEpisodeString = "") return
	
	s return = "-3", roleID = ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "QYFY")
	{
		s roleDID = ""
		s roleDID = $o(^DHCEPRRBAC.META.RoleMappingI("IdxMain"," DEPTVIEW",roleDID))
		s roleID = ##class(DHCEPRRBAC.Util.Utilization).TrimBlankSpace(roleDID)
	}
	else
	{
		s defaultRoleID = ""
		//s roleID = $o(^DHCEPRRBAC.META.RoleDFI("IdxDefaultRole"," Y",roleID))
		s defaultRoleID = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxSSGroupID"," "_AUserSSGroupID,defaultRoleID))
		if (defaultRoleID '= "")
		{
			s objDef = ##class(DHCEPRRBAC.INST.DefaultRole).%OpenId(defaultRoleID)
			s roleID = objDef.RoleID
			d objDef.%Close()
			s objRole = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(roleID)
			s roleType = objRole.RoleType
			d objRole.%Close()
			if (roleType '= "FS")
			{
				s roleID = $o(^DHCEPRRBAC.META.RoleDFI("IdxDefaultRole"," FS"," Y",roleID))
			}
		}
		else
		{
			s roleID = $o(^DHCEPRRBAC.META.RoleDFI("IdxDefaultRole"," FS"," Y",roleID))
		}
	}
	q:(roleID = "") return
	
	s opID = ""
	s opID = $o(^DHCEPRRBAC.META.OperDFI("IdxDefaultOp"," Y",opID))
	
	s flag = "true"
	TSTART
	s $zt = "OnDefaultRoleErrorHandler"
	
	s return = "-1"
	s objGroup = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%New()
	s objGroup.RequestDate = $p($h,",",1)
	s objGroup.RequestTime = $p($h,",",2)
	s objGroup.RequestUserID = AUserID
	s objGroup.RequestDept = AUserLocID
	s objGroup.RequestSSGroup = AUserSSGroupID
	s objGroup.EPRAction = AEPRAction
	s objGroup.AppointStatus = "D"
	s objGroup.RoleID = roleID
	s objGroup.OperationID = opID
	s sc = objGroup.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q return
	}
	
	s return = "-2"
	for index=1:1:$l(AEpisodeString,"^")
	{
		s episodeID = $p(AEpisodeString,"^",index)
		s objAuth = ##class(DHCEPRRBAC.INST.FSAuthorization).%New()
		
		s MREpisodeID=""
		s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_episodeID,MREpisodeID))
		
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
		s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID) 
		
		s objAuth.EpisodeID = episodeID
		s objAuth.PatientID = objMRPatient.PatientID
		s objAuth.RegNo = objMRPatient.RegNo
		s objAuth.MedRecordNo = objMREpisode.MedRecordNo
		s objAuth.DetailNum = objGroup.TheFSAuthorization.Count() + 1
		s objAuth.TheFSAuthorizationGroup = objGroup
		
		s scAuth = objAuth.%Save()
		if ($$$ISERR(scAuth))
		{
			s flag = "false"
			q
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnDefaultRoleErrorHandler
	TROLLBACK
	q "-100"
}

/// debug: w ##class(DHCEPRRBAC.BL.BLFSAuthorization).OutPatientView("FS","1273915^5236876","159","9","742")
ClassMethod OutPatientView(AEPRAction As %String, AEpisodeString As %String, AUserID As %String, AUserLocID As %String, AUserSSGroupID As %String) As %String
{
	s flag = "1"
	TSTART
	
	s $zt = "OnApplyErrorHandler"
	
	s count = $l(AEpisodeString,"^")
	
	s:(AEpisodeString = $c(0)) AEpisodeString = ""
	if (AEpisodeString '= "")
	{
		s objGroup = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%New()
		s objGroup.RequestDate = $p($h,",",1)
		s objGroup.RequestTime = $p($h,",",2)
		s objGroup.RequestUserID = AUserID
		s objGroup.RequestDept = AUserLocID
		s objGroup.RequestSSGroup = AUserSSGroupID
		
		s objGroup.EPRAction = AEPRAction
		s objGroup.AppointStatus = "O"
		
		s defaultRoleID = ""
		
		s defaultRoleID = $o(^DHCEPRRBAC.INST.OPDRoleI("IdxActive"," Y",defaultRoleID))
		s:(defaultRoleID = $c(0)) defaultRoleID = ""
		
		s objDef = ##class(DHCEPRRBAC.INST.OutPatientDefaultRole).%OpenId(defaultRoleID)
		s roleID = objDef.RoleID
		
		s objGroup.RoleID = roleID
		
		s opID = ""
		s opID = $o(^DHCEPRRBAC.META.OperDFI("IdxDefaultOp"," Y",opID))
		
		s objGroup.OperationID = opID
		
		for index=1:1:count
		{
			s episodeID = $p(AEpisodeString,"^",index)
			s obj = ##class(DHCEPRRBAC.INST.FSAuthorization).%New()
			s obj.EpisodeID = episodeID
			s MREpisodeID=""
			s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_episodeID,MREpisodeID))
			
			s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
			s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID) 
			
			s obj.PatientID = objMRPatient.PatientID
			s obj.RegNo = objMRPatient.RegNo
			s obj.MedRecordNo =objMREpisode.MedRecordNo
			s obj.DetailNum = objGroup.TheFSAuthorization.Count() + 1
			s obj.TheFSAuthorizationGroup = objGroup
			
			s sc = objGroup.%Save()
			if ('$$$ISOK(sc))
			{
				s flag = "-1"
				q
			}
		}
	}
	if ( flag = "1")
	{
		TCOMMIT
	}
	else
	{
		TROLLBACK
	}
	q flag
OnApplyErrorHandler
	TROLLBACK
	q "-1"
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLFSAuthorization).ReApply("29","test","12")
ClassMethod ReApply(AAuthorizationID As %String, AReason As %String, ASpanTime As %String) As %String
{
	s return = "0"
	q:(AAuthorizationID = "") return
	
	s flag = "true"
	TSTART
	s $zt = "OnReApplyErrorHandler"
	
	s return = "-1"
	s objGroupOld = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(AAuthorizationID)
	s objGroup = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%New()
	s objGroup.RequestDate = $p($h,",",1)
	s objGroup.RequestTime = $p($h,",",2)
	s objGroup.RequestUserID = objGroupOld.RequestUserID
	s objGroup.RequestDept = objGroupOld.RequestDept
	s objGroup.RequestSSGroup = objGroupOld.RequestSSGroup
	s objGroup.RequestComment = AReason
	s objGroup.RequestSpan = ASpanTime
	s objGroup.EPRAction = objGroupOld.EPRAction
	s objGroup.AppointStatus = "N"
	s sc = objGroup.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q return
	}
	
	s return = "-2"
	s detailNum = ""
	for {
		s detailNum = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain",AAuthorizationID,detailNum))
		q:(detailNum = "")
		
		s subID = ""
		for {
			s subID = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain",AAuthorizationID,detailNum,subID))
			q:(subID = "")
			
			s subFullID = AAuthorizationID_"||"_subID
			s objOld = ##class(DHCEPRRBAC.INST.FSAuthorization).%OpenId(subFullID)
			s objAuth = ##class(DHCEPRRBAC.INST.FSAuthorization).%New()
			s objAuth.EpisodeID = objOld.EpisodeID
			s objAuth.PatientID = objOld.PatientID
			s objAuth.RegNo = objOld.RegNo
			s objAuth.MedRecordNo = objOld.MedRecordNo
			s objAuth.DetailNum = objGroup.TheFSAuthorization.Count() + 1
			s objAuth.TheFSAuthorizationGroup = objGroup
			
			s sc = objAuth.%Save()
			if ($$$ISERR(sc))
			{
				s flag = "false"
				q
			}
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnReApplyErrorHandler
	TROLLBACK
	q "-100"
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLFSAuthorization","GetApplyListByUserID","2776","D","","")
Query GetApplyListByUserID(AUserID As %String, AApplyStatus As %String, ARequestStartDate As %String, ARequestEndDate As %String) As %Query(ROWSPEC = "AuthorizationID:%String,RequestUserID:%String,RequestUserName:%String,RequestDeptID:%String,RequestDept:%String,RequestSSGroupID:%String,RequestSSGroup:%String,RequestDate:%String,RequestTime:%String,AppointUserID:%String,AppointUserName:%String,AppointDate:%String,AppointTime:%String,AppointEndDate:%String,AppointEndTime:%String,AppointComment:%String,RoleID:%String,RoleCode:%String,RoleDesc:%String,OperationID:%String,OperationCode:%String,OperationDesc:%String,EPRAction:%String,EPRActionDesc:%String,AppointType:%String,AppointStatus:%String,AppointStatusDesc:%String,MedRecordNoS:%String,HasAdvancedSecurity:%String")
{
}

ClassMethod GetApplyListByUserIDExecute(ByRef qHandle As %Binary, AUserID As %String, AApplyStatus As %String, ARequestStartDate As %String, ARequestEndDate As %String) As %Status
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
	
	s expireFlag = "false"
	//查看过期
	if (AApplyStatus = "I")
	{
		s AApplyStatus = "F"
		s expireFlag = "true"
	}
	
	s:(ARequestStartDate = $c(0)) ARequestStartDate = ""
	s:(ARequestEndDate = $c(0)) ARequestEndDate = ""
	//日期为空，退出，避免查询全部浪费资源
	q:((ARequestStartDate = "") && (ARequestEndDate = "")) $$$OK
	
	s:(ARequestEndDate '= "") ARequestEndDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(ARequestEndDate)
	s:(ARequestStartDate '= "") ARequestStartDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(ARequestStartDate)
	if (ARequestEndDate = "")
	{
		s ARequestEndDate = $p($h,",",1)
	}
	
	s requestDate = ARequestEndDate + 1 
	for {
		s requestDate = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestDt"," "_AApplyStatus," "_AUserID,requestDate),-1)
		q:(requestDate = "")
		q:((ARequestStartDate '= "") && (ARequestStartDate > requestDate))
		
		s requestTime = ""
		for {
			s requestTime = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestDt"," "_AApplyStatus," "_AUserID,requestDate,requestTime),-1)
			q:(requestTime = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestDt"," "_AApplyStatus," "_AUserID,requestDate,requestTime,rowID))
				q:(rowID = "")
				
				//已授权并过期
				s ret = ..CheckAppointIsActive(rowID)
				//查看已授权但没过期，则过期continue
				continue:((AApplyStatus = "F") && (expireFlag = "false") && (ret = "0"))
				//查看已授权但过期，则没过期continue
				continue:((AApplyStatus = "F") && (expireFlag = "true") && (ret = "1"))
				
				s obj = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(rowID)
				s RequestUserID = obj.RequestUserID
				s:(RequestUserID = $c(0)) RequestUserID = ""
				s RequestUserName = ""
				if (RequestUserID '= "")
				{
					s RequestUserName = $p($g(^SSU("SSUSR",RequestUserID)),"^",2)
				}
				s RequestDeptID = obj.RequestDept
				s:(RequestDeptID = $c(0)) RequestDeptID = ""
				s RequestDept = ""
				if (RequestDeptID '= "")
				{
					s RequestDept = $p($g(^CTLOC(RequestDeptID)),"^",2)
					s:(RequestDept["-") RequestDept = $p(RequestDept,"-",2)
				}
				s RequestSSGroupID = obj.RequestSSGroup
				s RequestSSGroup = ""
				s:(RequestSSGroupID '= "") RequestSSGroup = $p($g(^SSU("SSGRP",RequestSSGroupID)),"^",1)
				s RequestDate = obj.RequestDate
				s:(RequestDate '= "") RequestDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.RequestDate)
				s RequestTime = obj.RequestTime
				s:(RequestTime '= "") RequestTime = $zt(obj.RequestTime)
				
				s AppointUserID = obj.AppointUserID
				s:(AppointUserID = $c(0)) AppointUserID = ""
				s AppointUserName = ""
				if (AppointUserID '= "") 
				{
					if ($p(AppointUserID,"^",1) = "TEMP")
					{
						s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(AppointUserID,"^",2))
						s AppointUserName = objUser.UserName
						d objUser.%Close()
					}
					else
					{
						s AppointUserName = $p($g(^SSU("SSUSR",AppointUserID)),"^",2)
					}
				}
				s AppointDate = obj.AppointDate
				s:(AppointDate '= "") AppointDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.AppointDate)
				s AppointTime = obj.AppointTime
				s:(AppointTime '= "") AppointTime = $zt(obj.AppointTime)
				s AppointEndDate = obj.AppointEndDate
				s:(AppointEndDate '= "") AppointEndDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.AppointEndDate)
				s AppointEndTime = obj.AppointEndTime
				s:(AppointEndTime '= "") AppointEndTime = $zt(obj.AppointEndTime)
				s AppointComment = obj.AppointComment
				
				s RoleID = obj.RoleID
				s:(RoleID = $c(0)) RoleID = ""
				s RoleDesc = "", RoleCode = ""
				if (RoleID '= "")
				{
					s objRole = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(RoleID)
					s RoleDesc = objRole.RoleDesc
					s RoleCode = objRole.RoleCode
				}
				s EPRAction = obj.EPRAction
				s AppointType = obj.AppointType
				s AppointStatus = obj.AppointStatus
				if ((AApplyStatus = "F") && (ret = "0"))
				{
					s AppointStatus = "I"
				}
				s OperationID = obj.OperationID
				s OperationDesc = "", OperationCode = ""
				if ((OperationID '= "") && (OperationID '= $c(0)))
				{
					s opObj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(OperationID)
					s OperationCode = opObj.OpCode
					s OperationDesc = opObj.OpDesc
				}
				
				s MedRecordNoS = "", MedRecordNo = ""
				for {
					s MedRecordNo = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMainMedRecordNo",rowID,MedRecordNo))
					q:(MedRecordNo = "")
					s MedRecordNoS = MedRecordNoS_""_MedRecordNo
				}
				
				s EPRActionDesc = ##class(DHCEPRRBAC.Util.Utilization).GetEPRActionDesc(EPRAction)
				s AppointStatusDesc = ##class(DHCEPRRBAC.Util.Utilization).GetStatusDesc(AppointStatus)
				s HasAdvancedSecurity = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).CheckASByGroupID(rowID)
				
				if (EnableTranslation = 1)
				{
					s:(RequestUserName'="") RequestUserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",RequestUserName,langid)
					s:(AppointUserName'="") AppointUserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",AppointUserName,langid)
				}
				
				s ^CacheTemp(repid,ind) = $lb(rowID,RequestUserID,RequestUserName,RequestDeptID,RequestDept,RequestSSGroupID,RequestSSGroup,RequestDate,RequestTime,AppointUserID,AppointUserName,AppointDate,AppointTime,AppointEndDate,AppointEndTime,AppointComment,RoleID,RoleCode,RoleDesc,OperationID,OperationCode,OperationDesc,EPRAction,EPRActionDesc,AppointType,AppointStatus,AppointStatusDesc,MedRecordNoS,HasAdvancedSecurity)
				s ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetApplyListByUserIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApplyListByUserIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetApplyListByUserIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApplyListByUserIDExecute ]
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

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLFSAuthorization","GetApplyDefaultByUserID","2776","D","2015-1-1","2015-7-30")
Query GetApplyDefaultByUserID(AUserID As %String, AApplyStatus As %String, ARequestStartDate As %String, ARequestEndDate As %String) As %Query(ROWSPEC = "AuthorizationID:%String,AuthorizationDetailID:%String,EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmWard:%String,PAAdmLoc:%String,PADischgeDate:%String,PADischgeTime:%String,PAAdmDoc:%String,PayMode:%String,LinkedParam:%String,IsAdvancedSecurity:%String")
{
}

ClassMethod GetApplyDefaultByUserIDExecute(ByRef qHandle As %Binary, AUserID As %String, AApplyStatus As %String, ARequestStartDate As %String, ARequestEndDate As %String) As %Status
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
	
	s AApplyStatus = "D"
	
	s:(ARequestStartDate = $c(0)) ARequestStartDate = ""
	s:(ARequestEndDate = $c(0)) ARequestEndDate = ""
	//日期为空，退出，避免查询全部浪费资源
	q:((ARequestStartDate = "") && (ARequestEndDate = "")) $$$OK
	
	s:(ARequestEndDate '= "") ARequestEndDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(ARequestEndDate)
	s:(ARequestStartDate '= "") ARequestStartDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(ARequestStartDate)
	if (ARequestEndDate = "")
	{
		s ARequestEndDate = $p($h,",",1)
	}
	
	s requestDate = ARequestEndDate + 1 
	for {
		s requestDate = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestDt"," "_AApplyStatus," "_AUserID,requestDate),-1)
		q:(requestDate = "")
		q:((ARequestStartDate '= "") && (ARequestStartDate > requestDate))
		
		s requestTime = ""
		for {
			s requestTime = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestDt"," "_AApplyStatus," "_AUserID,requestDate,requestTime),-1)
			q:(requestTime = "")
			
			s AAuthorizationID = ""
			for {
				s AAuthorizationID = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxRequestDt"," "_AApplyStatus," "_AUserID,requestDate,requestTime,AAuthorizationID))
				q:(AAuthorizationID = "")
				
				s detailNum = ""
				for {
					s detailNum = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain", AAuthorizationID, detailNum))
					q:(detailNum = "")
					
					s sub = ""
					for {
						s sub = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain", AAuthorizationID, detailNum, sub))
						q:(sub = "")
						s rowID = AAuthorizationID_"||"_sub
						
						s obj = ##class(DHCEPRRBAC.INST.FSAuthorization).%OpenId(rowID)
						s EpisodeID = obj.EpisodeID
						s PatientID = obj.PatientID
						s MedRecordNo = obj.MedRecordNo
						s RegNo = obj.RegNo
						
						s MREpisodeID=""
						s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_EpisodeID,MREpisodeID))
						
						s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
						s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
						
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
						
						//病区
						s PAAdmWard = objMREpisode.AdmWard
						
						//当前科室
						s PAAdmLoc = objMREpisode.AdmLoc
						if (PAAdmLoc = $c(0)) s PAAdmLoc=""
						
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
						
						s LinkedParam = ##class(DHCEPRRBAC.BL.BLPersonalization).GetLinkInfo(EpisodeID)
						s IsAdvancedSecurity = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).CheckAS("DHC",EpisodeID)
						
						if (EnableTranslation = 1)
						{
							s:(PAAdmLoc'="") PAAdmLoc = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",PAAdmLoc,langid)
							s:(PAAdmWard'="") PAAdmWard = ##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
							s:(PAAdmDoc'="") PAAdmDoc = ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PAAdmDoc,langid)
							s:(PAPMISex'="") PAPMISex = ##class(User.CTSex).GetTranByDesc("CTSEXDesc",PAPMISex,langid)
						}
						
		 				s data = $lb(AAuthorizationID,rowID,EpisodeID,PatientID,MedRecordNo,RegNo,PAStatusType,PAAdmType,PAPMIName,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDate,PAAdmTime,PAAdmWard,PAAdmLoc,PADischgeDate,PADischgeTime,PAAdmDoc,PayMode,LinkedParam,IsAdvancedSecurity)
						s ^CacheTemp(repid,ind)=data
						s ind=ind+1
					}
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetApplyDefaultByUserIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApplyDefaultByUserIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetApplyDefaultByUserIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApplyDefaultByUserIDExecute ]
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

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLFSAuthorization","GetApplyListDetail","5")
Query GetApplyListDetail(AAuthorizationID As %String) As %Query(ROWSPEC = "AuthorizationID:%String,AuthorizationDetailID:%String,EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmWard:%String,PAAdmLoc:%String,PADischgeDate:%String,PADischgeTime:%String,PAAdmDoc:%String,PayMode:%String,LinkedParam:%String,IsAdvancedSecurity:%String")
{
}

ClassMethod GetApplyListDetailExecute(ByRef qHandle As %Binary, AAuthorizationID As %String) As %Status
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
	
	s:(AAuthorizationID = $c(0)) AAuthorizationID = ""
	q:(AAuthorizationID = "") $$$OK
	
	s detailNum = ""
	for {
		s detailNum = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain",AAuthorizationID,detailNum))
		q:(detailNum = "")
		
		s sub = ""
		for {
			s sub = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain",AAuthorizationID,detailNum,sub))
			q:(sub = "")
			s rowID = AAuthorizationID_"||"_sub
			
			s obj = ##class(DHCEPRRBAC.INST.FSAuthorization).%OpenId(rowID)
			s EpisodeID = obj.EpisodeID
			s PatientID = obj.PatientID
			s MedRecordNo = obj.MedRecordNo
			s RegNo = obj.RegNo
			
			s MREpisodeID=""
			s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_EpisodeID,MREpisodeID))
			
			s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
			s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
			
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
			
			//病区
			s PAAdmWard = objMREpisode.AdmWard
			
			//当前科室
			s PAAdmLoc = objMREpisode.AdmLoc
			if (PAAdmLoc = $c(0)) s PAAdmLoc=""
			
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
			
			s LinkedParam = ##class(DHCEPRRBAC.BL.BLPersonalization).GetLinkInfo(EpisodeID)
			s IsAdvancedSecurity = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).CheckAS("DHC",EpisodeID)
			
			if (EnableTranslation = 1)
			{
				s:(PAPMISex'="") PAPMISex = ##class(User.CTSex).GetTranByDesc("CTSEXDesc",PAPMISex,langid)
				s:(PAAdmWard'="") PAAdmWard = ##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
				s:(PAAdmLoc'="") PAAdmLoc = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",PAAdmLoc,langid)
				s:(PAAdmDoc'="") PAAdmDoc = ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PAAdmDoc,langid)
			}
			s data = $lb(AAuthorizationID,rowID,EpisodeID,PatientID,MedRecordNo,RegNo,PAStatusType,PAAdmType,PAPMIName,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDate,PAAdmTime,PAAdmWard,PAAdmLoc,PADischgeDate,PADischgeTime,PAAdmDoc,PayMode,LinkedParam,IsAdvancedSecurity)
			s ^CacheTemp(repid,ind)=data
			s ind=ind+1 
		}
	}
	Quit $$$OK
}

ClassMethod GetApplyListDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApplyListDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetApplyListDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApplyListDetailExecute ]
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

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLFSAuthorization","GetApplyListByStatus","F","","")
Query GetApplyListByStatus(AStatus As %String, AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "AuthorizationID:%String,RequestUserID:%String,RequestUserName:%String,RequestDeptID:%String,RequestDept:%String,RequestSSGroupID:%String,RequestSSGroup:%String,RequestDate:%String,RequestTime:%String,RequestReason:%String,RequestTimeSpan:%String,AppointUserID:%String,AppointUserName:%String,AppointDate:%String,AppointTime:%String,AppointEndDate:%String,AppointEndTime:%String,AppointComment:%String,RoleID:%String,RoleCode:%String,RoleDesc:%String,OperationID:%String,OperationCode:%String,OperationDesc:%String,EPRAction:%String,EPRActionDesc:%String,AppointType:%String,AppointStatus:%String,AppointStatusDesc:%String,HasAdvancedSecurity:%String")
{
}

ClassMethod GetApplyListByStatusExecute(ByRef qHandle As %Binary, AStatus As %String, AStartDate As %String, AEndDate As %String) As %Status
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
	
	s expireFlag = "false"
	//查看过期
	if (AStatus = "I")
	{
		s AStatus = "F"
		s expireFlag = "true"
	}
	
	s:(AStartDate = $c(0)) AStartDate = ""
	s:(AEndDate = $c(0)) AEndDate = ""
	//日期为空，退出，避免查询全部浪费资源
	q:((AStartDate = "") && (AEndDate = "")) $$$OK
	
	s:(AEndDate '= "") AEndDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(AEndDate)
	s:(AStartDate '= "") AStartDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(AStartDate)
	if (AEndDate = "")
	{
		s AEndDate = $p($h,",",1)
	}
	
	s date = AEndDate + 1
	for {
		s date = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxAStatus"," "_AStatus,date),-1)
		q:(date = "")
		q:((AStartDate '= "") && (AStartDate > date))
		
		s time = ""
		for {
			s time = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxAStatus"," "_AStatus,date,time),-1)
			q:(time = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxAStatus"," "_AStatus,date,time,rowID))
				q:(rowID = "")
				
				//已授权并过期
				s ret = ..CheckAppointIsActive(rowID)
				//查看已授权但没过期，则过期continue
				continue:((AStatus = "F") && (expireFlag = "false") && (ret = "0"))
				//查看已授权但过期，则没过期continue
				continue:((AStatus = "F") && (expireFlag = "true") && (ret = "1"))
				
				s obj = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(rowID)
				s RequestUserID = obj.RequestUserID
				s:(RequestUserID = $c(0)) RequestUserID = ""
				s RequestUserName = ""
				if (RequestUserID '= "")
				{
					s RequestUserName = $p($g(^SSU("SSUSR",RequestUserID)),"^",2)
				}
				s RequestDeptID = obj.RequestDept
				s:(RequestDeptID = $c(0)) RequestDeptID = ""
				s RequestDept = ""
				if (RequestDeptID '= "")
				{
					s RequestDept = $p($g(^CTLOC(RequestDeptID)),"^",2)
					s:(RequestDept["-") RequestDept = $p(RequestDept,"-",2)
				}
				s RequestSSGroupID = obj.RequestSSGroup
				s RequestSSGroup = ""
				s:(RequestSSGroupID '= "") RequestSSGroup = $p($g(^SSU("SSGRP",RequestSSGroupID)),"^",1)
				s RequestDate = obj.RequestDate
				s:(RequestDate '= "") RequestDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.RequestDate)
				s RequestTime = obj.RequestTime
				s:(RequestTime '= "") RequestTime = $zt(obj.RequestTime)
				s RequestReason = obj.RequestComment
				s RequestTimeSpan = obj.RequestSpan
				
				s AppointUserID = obj.AppointUserID
				s:(AppointUserID = $c(0)) AppointUserID = ""
				s AppointUserName = ""
				if (AppointUserID '= "")
				{
					if ($p(AppointUserID,"^",1) = "TEMP")
					{
						s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(AppointUserID,"^",2))
						s AppointUserName = objUser.UserName
						d objUser.%Close()
					}
					else
					{
						s AppointUserName = $p($g(^SSU("SSUSR",AppointUserID)),"^",2)
					}
				}
				s AppointDate = obj.AppointDate
				s:(AppointDate '= "") AppointDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.AppointDate)
				s AppointTime = obj.AppointTime
				s:(AppointTime '= "") AppointTime = $zt(obj.AppointTime)
				s AppointEndDate = obj.AppointEndDate
				s:(AppointEndDate '= "") AppointEndDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.AppointEndDate)
				s AppointEndTime = obj.AppointEndTime
				s:(AppointEndTime '= "") AppointEndTime = $zt(obj.AppointEndTime)
				s AppointComment = obj.AppointComment
				
				s RoleID = obj.RoleID
				s:(RoleID = $c(0)) RoleID = ""
				s RoleDesc = "", RoleCode = ""
				if (RoleID '= "")
				{
					s objRole = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(RoleID)
					s RoleDesc = objRole.RoleDesc
					s RoleCode = objRole.RoleCode
				}
				s EPRAction = obj.EPRAction
				s AppointType = obj.AppointType
				s AppointStatus = obj.AppointStatus
				if ((AppointStatus = "F") && (ret = "0"))
				{
					s AppointStatus = "I"
				}
				s OperationID = obj.OperationID
				s OperationDesc = "", OperationCode = ""
				if ((OperationID '= "") && (OperationID '= $c(0)))
				{
					s opObj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(OperationID)
					s OperationCode = opObj.OpCode
					s OperationDesc = opObj.OpDesc
				}
				
				s EPRActionDesc = ##class(DHCEPRRBAC.Util.Utilization).GetEPRActionDesc(EPRAction)
				s AppointStatusDesc = ##class(DHCEPRRBAC.Util.Utilization).GetStatusDesc(AppointStatus)
				s HasAdvancedSecurity = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).CheckASByGroupID(rowID)
				
				if (EnableTranslation = 1)
				{
					s:(RequestUserName'="") RequestUserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",RequestUserName,langid)
					s:(AppointUserName'="") AppointUserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",AppointUserName,langid)
				}
				
				s ^CacheTemp(repid,ind) = $lb(rowID,RequestUserID,RequestUserName,RequestDeptID,RequestDept,RequestSSGroupID,RequestSSGroup,RequestDate,RequestTime,RequestReason,RequestTimeSpan,AppointUserID,AppointUserName,AppointDate,AppointTime,AppointEndDate,AppointEndTime,AppointComment,RoleID,RoleCode,RoleDesc,OperationID,OperationCode,OperationDesc,EPRAction,EPRActionDesc,AppointType,AppointStatus,AppointStatusDesc,HasAdvancedSecurity)
				s ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetApplyListByStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApplyListByStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetApplyListByStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApplyListByStatusExecute ]
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

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLFSAuthorization","GetAuthorizationList","2018-01-01","2018-12-31")
Query GetAuthorizationList(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "AuthorizationID:%String,RequestUserID:%String,RequestUserName:%String,RequestDeptID:%String,RequestDept:%String,RequestSSGroupID:%String,RequestSSGroup:%String,RequestDate:%String,RequestTime:%String,RequestReason:%String,RequestTimeSpan:%String,AppointUserID:%String,AppointUserName:%String,AppointDate:%String,AppointTime:%String,AppointEndDate:%String,AppointEndTime:%String,AppointComment:%String,RoleID:%String,RoleCode:%String,RoleDesc:%String,OperationID:%String,OperationCode:%String,OperationDesc:%String,EPRAction:%String,EPRActionDesc:%String,AppointType:%String,AppointStatus:%String,AppointStatusDesc:%String,HasAdvancedSecurity:%String")
{
}

ClassMethod GetAuthorizationListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
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
	//日期为空，退出，避免查询全部浪费资源
	q:((AStartDate = "") && (AEndDate = "")) $$$OK
	
	s:(AEndDate '= "") AEndDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(AEndDate)
	s:(AStartDate '= "") AStartDate = ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate(AStartDate)
	if (AEndDate = "")
	{
		s AEndDate = $p($h,",",1)
	}
	
	s date = AEndDate + 1 
	for {
		s date = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxAuthorization",date),-1)
		q:(date = "")
		q:((AStartDate '= "") && (AStartDate > date))
		
		s time = ""
		for {
			s time = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxAuthorization",date,time),-1)
			q:(time = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRRBAC.INST.FSAuthGI("IdxAuthorization",date,time,rowID))
				q:(rowID = "")
				
				s obj = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(rowID)
				s RequestUserID = obj.RequestUserID
				s:(RequestUserID = $c(0)) RequestUserID = ""
				s RequestUserName = ""
				if (RequestUserID '= "")
				{
					s RequestUserName = $p($g(^SSU("SSUSR",RequestUserID)),"^",2)
				}
				s RequestDeptID = obj.RequestDept
				s:(RequestDeptID = $c(0)) RequestDeptID = ""
				s RequestDept = ""
				if (RequestDeptID '= "")
				{
					s RequestDept = $p($g(^CTLOC(RequestDeptID)),"^",2)
					s:(RequestDept["-") RequestDept = $p(RequestDept,"-",2)
				}
				s RequestSSGroupID = obj.RequestSSGroup
				s RequestSSGroup = ""
				s:(RequestSSGroupID '= "") RequestSSGroup = $p($g(^SSU("SSGRP",RequestSSGroupID)),"^",1)
				s RequestDate = obj.RequestDate
				s:(RequestDate '= "") RequestDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.RequestDate)
				s RequestTime = obj.RequestTime
				s:(RequestTime '= "") RequestTime = $zt(obj.RequestTime)
				s RequestReason = obj.RequestComment
				s RequestTimeSpan = obj.RequestSpan
				
				s AppointUserID = obj.AppointUserID
				s:(AppointUserID = $c(0)) AppointUserID = ""
				s AppointUserName = ""
				if (AppointUserID '= "") 
				{
					if ($p(AppointUserID,"^",1) = "TEMP")
					{
						s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(AppointUserID,"^",2))
						s AppointUserName = objUser.UserName
						d objUser.%Close()
					}
					else
					{
						s AppointUserName = $p($g(^SSU("SSUSR",AppointUserID)),"^",2)
					}
				}
				s AppointDate = obj.AppointDate
				s:(AppointDate '= "") AppointDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.AppointDate)
				s AppointTime = obj.AppointTime
				s:(AppointTime '= "") AppointTime = $zt(obj.AppointTime)
				s AppointEndDate = obj.AppointEndDate
				s:(AppointEndDate '= "") AppointEndDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(obj.AppointEndDate)
				s AppointEndTime = obj.AppointEndTime
				s:(AppointEndTime '= "") AppointEndTime = $zt(obj.AppointEndTime)
				s AppointComment = obj.AppointComment
				
				s RoleID = obj.RoleID
				s:(RoleID = $c(0)) RoleID = ""
				s RoleDesc = "", RoleCode = ""
				if (RoleID '= "")
				{
					s objRole = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(RoleID)
					s RoleDesc = objRole.RoleDesc
					s RoleCode = objRole.RoleCode
				}
				s EPRAction = obj.EPRAction
				s AppointType = obj.AppointType
				s AppointStatus = obj.AppointStatus
				s OperationID = obj.OperationID
				s OperationDesc = "", OperationCode = ""
				if ((OperationID '= "") && (OperationID '= $c(0)))
				{
					s opObj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(OperationID)
					s OperationCode = opObj.OpCode
					s OperationDesc = opObj.OpDesc
				}
				
				s EPRActionDesc = ##class(DHCEPRRBAC.Util.Utilization).GetEPRActionDesc(EPRAction)
				s AppointStatusDesc = ##class(DHCEPRRBAC.Util.Utilization).GetStatusDesc(AppointStatus)
				s HasAdvancedSecurity = ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).CheckASByGroupID(rowID)
				
				if (EnableTranslation = 1)
				{
					s:(RequestUserName'="") RequestUserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",RequestUserName,langid)
					s:(AppointUserName'="") AppointUserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",AppointUserName,langid)
				}
				
				s ^CacheTemp(repid,ind) = $lb(rowID,RequestUserID,RequestUserName,RequestDeptID,RequestDept,RequestSSGroupID,RequestSSGroup,RequestDate,RequestTime,RequestReason,RequestTimeSpan,AppointUserID,AppointUserName,AppointDate,AppointTime,AppointEndDate,AppointEndTime,AppointComment,RoleID,RoleCode,RoleDesc,OperationID,OperationCode,OperationDesc,EPRAction,EPRActionDesc,AppointType,AppointStatus,AppointStatusDesc,HasAdvancedSecurity)
				s ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetAuthorizationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAuthorizationListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAuthorizationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAuthorizationListExecute ]
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

ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	s appoint = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(AID)
	q:(appoint = "") "0"
	
	///授权日期或者授权时间为空,即没有授权
	q:(appoint.AppointDate = "")||(appoint.AppointTime = "") "0"
	
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	///授权截止日期小于当前日期,授权已过期
	q:(appoint.AppointEndDate<date) "0"
	
	///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
	q:(appoint.AppointEndDate=date)&&(appoint.AppointEndTime<time) "0"
	
	q "1"
}

ClassMethod AddZero(APatientNo As %String) As %String
{
	s patientNo = ""
	s patientNo = $o(^PAPERi("PAPMI_PatNo",patientNo))
	s patientNo = $tr(patientNo, " ")
	s patientNo = $tr(patientNo,$c(10),"")
	s patientNo = $tr(patientNo,$c(13),"")
	s length = $l(patientNo)
	q:(length = $l(APatientNo)) APatientNo
	
	for index=1:1:(length - $l(APatientNo)) {
		s APatientNo = "0"_APatientNo
	}
	q APatientNo
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLFSAuthorization","GetPatientList","^张二^^^^^","2776","9","1")
Query GetPatientList(AParam As %String, AUserID As %String = "", AUserLocID As %String = "", AUserSSGroupID As %String = "") As %Query(ROWSPEC = "PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmWard:%String,PAAdmLoc:%String,PADischgeDate:%String,PADischgeTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String,IsAdvancedSecurity:%String,CheckNoNeedApply:%String")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, AParam As %String, AUserID As %String = "", AUserLocID As %String = "", AUserSSGroupID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s APatientID = $p(AParam,"^",1)
	s APatientName = $p(AParam,"^",2)
	s ALocID = $p(AParam,"^",3)
	s AWard = $p(AParam,"^",4)
	s AAdmNo = $p(AParam,"^",5)
	s ARegNo = $p(AParam,"^",6)
	s AMedRecordNo = $p(AParam,"^",7)
	
	d DealParamter   //处理参数
	
	if (AAdmNo '= ""){
		s PAAdm = AAdmNo
		d OutPutRow
	}
	elseif (APatientID '= ""){
		s PAPMI = APatientID
		d OutPutPAMI
	}
	elseif (ARegNo '= ""){
		s ARegNo = ..AddZero(ARegNo)
		s MRPatientID=""
		s MRPatientID=$o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," "_ARegNo,MRPatientID))
		q:(MRPatientID = "") $$$OK
		s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
		s PAPMI=objMRPatient.PatientID
		d OutPutPAMI
	}
	elseif (APatientName '= ""){
		s PAPMI = ""
		s upperName = $zcvt(APatientName,"U")
		s tmpName = " "_upperName
		while ((tmpName'="")&&(tmpName[upperName))
		{
			s MRPatientID = ""
			for {
				s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName,MRPatientID))
				q:(MRPatientID = "")
				s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
				s PAPMI=objMRPatient.PatientID
				d OutPutPAMI
			}
			s tmpName=$o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName))
		}
	}
	elseif (AMedRecordNo '= ""){
		s MREpisodeID=""
		for {
			s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo"," "_AMedRecordNo,MREpisodeID))
			q:(MREpisodeID = "")
			s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
			s PAAdm=objMREpisode.EpisodeID
			d OutPutRow
		}
	}
	
	Quit $$$OK
	
OutPutPAMI
	//PAPMI 即 PatientID
	
	s MRPatientID=""
	s MRPatientID=$o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," DHC"," "_PAPMI,MRPatientID))
	q:(MRPatientID = "")
	
	s MREpisodeID=""
	for {
		s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MREpisodeID))
		q:(MREpisodeID = "")
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
		s PAAdm=objMREpisode.EpisodeID
		
		d OutPutRow
	}
	q
OutPutRow
	//PAAdm 即 EpisodeID
	//判断是否存在MREpisode记录，不存在则不加入结果集
	s MREpisodeID=""
	s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_PAAdm,MREpisodeID))
	q:(MREpisodeID = "")
	
	s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
	
	s IsAdvancedSecurity = "N"
	//获取封存状态
	s sealStat = ##Class(DHCEPRFS.BI.BIToEMR).GetSealUpStatus(PAAdm)
	s:($P(sealStat,"^",1)="1") IsAdvancedSecurity="Y"
	/**s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxEpisodeID"," "_PAAdm,rowID))
	//已存在
	s:(rowID '= "") IsAdvancedSecurity = "Y"*/
	
	s PatientID = objMRPatient.PatientID
	s PAAdmType = objMREpisode.AdmType
	
	//病人姓名
	s PAPMIName = objMRPatient.Name
	//登记号
	s PAPMINO = objMRPatient.RegNo
	
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
	
	s PAAdmDate = "", PAAdmTime = ""
	s AdmDate = objMREpisode.AdmDate
	s:(AdmDate'="") PAAdmDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(AdmDate)  //入院日期
	s AdmTime = objMREpisode.AdmTime
	s:(AdmTime'="") PAAdmTime = $zt(objMREpisode.AdmTime,1)  //入院时间
	
	//病区
	s PAAdmWard = objMREpisode.AdmWard
	
	//当前科室
	s PAAdmLoc = objMREpisode.AdmLoc
	if (PAAdmLoc = $c(0)) s PAAdmLoc=""
	
	//出院日期时间
	s PADischgeDate = "", PADischgeTime = ""
	s DisDate = objMREpisode.DisDate
	s:(DisDate'="") PADischgeDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(DisDate)
	s DisTime = objMREpisode.DisTime
	s:(DisTime'="") PADischgeTime = $zt(objMREpisode.DisTime,1)
	
	//在院状态
	s PAStatusType = "出院"
	
	//医生 
	s PAAdmDoc = objMREpisode.MainDoctor
	
	//付费方式
	s PayMode = objMREpisode.PayMode 
	
	//判断此次就诊是否满足不需申请直接浏览的权限
	if ((AUserID="")||(AUserID=$c(0)))
	{
		s checkNoNeedApply="1"
	}
	else
	{
		s checkNoNeedApply = ##class(DHCEPRRBAC.BL.BLPrivilege).CheckNoNeedApply(PAAdm,AUserID,AUserLocID,AUserSSGroupID)
	}
	
	s data = $lb(PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDate,PAAdmTime,PAAdmWard,PAAdmLoc,PADischgeDate,PADischgeTime,PAAdmDoc,PayMode,PAAdm,PatientID,IsAdvancedSecurity,checkNoNeedApply)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter
	if AWard = $c(0) s AWard = ""
	if AWard '= ""
	{
		s TempWard = $o(^PAWARD(0,"WARD_LocationDR",AWard,""))
		if TempWard '= "" s AWard = TempWard
	}
	if APatientID = $c(0) s APatientID = ""
	if ARegNo = $c(0) s ARegNo = ""
	if APatientName = $c(0) s APatientName = ""
	if ALocID = $c(0) s ALocID = ""
	if AAdmNo = $c(0) s AAdmNo = ""
	
	if AMedRecordNo = $c(0) s AMedRecordNo = ""
	if (AMedRecordNo '= "")
	{
		s AMedRecordNo = $zcvt(AMedRecordNo,"U")
	}
	
	q
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
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
