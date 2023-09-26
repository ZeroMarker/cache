Class DHCEPRFS.BL.BLAuthorization Extends %RegisteredObject
{

/// Desc: 提交申请
/// Debug: w ##class(DHCEPRFS.BL.BLAuthorization).Apply("REVOKE","601","159","9","test")
ClassMethod Apply(ARequestAct As %String, AEpisodeID As %String, AUserID As %String, AUserLocID As %String, AReason As %String, AClinicFlag As %String = "") As %String
{
	s objAuth = ##class(DHCEPRFS.INST.AuthorizationInfo).%New()
	s objAuth.AppointStatus = "N"
	s objAuth.EpisodeID = AEpisodeID
	s objAuth.MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	s objAuth.RequestDate = $p($h,",",1)
	s objAuth.RequestTime = $p($h,",",2)
	s objAuth.RequestUserID = AUserID
	s objAuth.RequestDept = AUserLocID
	s objAuth.RequestComment = AReason
	s objAuth.RequestAct = ARequestAct
	s requestType = $s(AClinicFlag="1":"DOCTOR",AClinicFlag="0":"NURSE",1:"")
	s objAuth.RequestType = requestType
	s sc = objAuth.%Save()
	d objAuth.%Close()
	if ($$$ISERR(sc))
	{	
		q "0"
	}
	else
	{
		q "1"
	}
}

/// Desc: 更新审批通过信息
/// Debug: w ##class(DHCEPRFS.BL.BLAuthorization).Approve(2,552)
ClassMethod Approve(AAuthInfoID As %String, AUserID As %String) As %String
{
	s objAuth = ##class(DHCEPRFS.INST.AuthorizationInfo).%OpenId(AAuthInfoID)
	s objAuth.AppointDate = $p($h,",",1)
	s objAuth.AppointTime = $p($h,",",2)
	s objAuth.AppointStatus = "F"
	s objAuth.AppointUserID = AUserID
	s sc = objAuth.%Save()
	d objAuth.%Close()
	if ($$$ISERR(sc))
	{
		q "0"
	}
	else
	{
		q "1"
	}
}

/// Desc: 更新拒绝申请信息
/// Debug: w ##class(DHCEPRFS.BL.BLAuthorization).Reject(7,552,"拒绝申请测试")
ClassMethod Reject(AAuthInfoID As %String, AUserID As %String, AReason As %String) As %String
{
	s objAuth = ##class(DHCEPRFS.INST.AuthorizationInfo).%OpenId(AAuthInfoID)
	s objAuth.AppointDate = $p($h,",",1)
	s objAuth.AppointTime = $p($h,",",2)
	s objAuth.AppointStatus = "R"
	s objAuth.AppointUserID = AUserID
	s objAuth.AppointComment = AReason
	s sc = objAuth.%Save()
	d objAuth.%Close()
	if ($$$ISERR(sc))
	{
		q "0"
	}
	else
	{
		q "1"
	}
}

/// Desc: 撤销提交审批通过
/// Debug: w ##class(DHCEPRFS.BL.BLAuthorization).ApproveAppliaction(8,552)
ClassMethod ApproveRecallAppliaction(AAuthInfoID As %String, AUserID As %String) As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnApproveAppliactionErrorHandler"
	
	s obj = ##class(DHCEPRFS.INST.AuthorizationInfo).%OpenId(AAuthInfoID)
	s episodeID = obj.EpisodeID
	s requestType = obj.RequestType
	d obj.%Close()
	s ret = ""
	if (requestType = "DOCTOR")
	{
		s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(episodeID,"0","1","",AUserID,"","6")
	}
	elseif (requestType = "NURSE")
	{
		s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(episodeID,"1","0","",AUserID,"","6")
	}
	if (ret '= "1")
	{
		s flag = "false"
	}
	else
	{
		s approveRet = ..Approve(AAuthInfoID,AUserID)
		if (approveRet = "0")
		{
			s flag = "false"
		}
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"	
	}
  	else
  	{
	  	TROLLBACK
	  	q "0"
  	}	
OnApproveAppliactionErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 病历召回
/// Debug: w ##class(DHCEPRFS.BL.BLAuthorization).RecallRecord("8","552","1")
ClassMethod RecallRecord(AEpisodeID As %String, AUserID As %String, AClinicFlag As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s eprStatus = ##class(DHCEPRFS.BL.BLAdmMRStatus).GetAdmMRStatusDHC(AEpisodeID)
	s eprDocStatus = $p(eprStatus,"^",2)
	s eprNurStatus = $p(eprStatus,"^",1)
	if (AClinicFlag = "1")
	{
		if (eprDocStatus = "0")
		{
			s ret = "-3^医生提交未完成，不能进行召回操作"
		}
		elseif (eprNurStatus = "1")
		{
			s ret = "2"
		}
		else
		{
			s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,"0","1","",AUserID,"","5")
		}
	}
	elseif (AClinicFlag = "0")
	{
		if (eprNurStatus = "0")
		{
			s ret = "-3^护士提交未完成，不能进行召回操作"
		}
		elseif (eprDocStatus = "1")
		{
			s ret = "2"
		}
		else
		{
			s ret = ##class(DHCEPRFS.BL.BLAdmMRStatus).CancelMRStatusFlagDHC(AEpisodeID,"1","0","",AUserID,"","5")
		}
	}
	q ret
}

/// Desc: 查询申请列表
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAuthorization","GetApplyList","REVOKE","N","2018-6-1","2018-6-20","","","9")
Query GetApplyList(ARequestAct As %String, AStatus As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, AName As %String, AUserLocID As %String) As %Query(ROWSPEC = "AuthorizationID:%String,EpisodeID:%String,MedRecordNo:%String,RequestUserName:%String,RequestDept:%String,RequestDate:%String,RequestTime:%String,RequestComment:%String,RequestType:%String,RequestTypeDesc:%String,AppointStatus:%String,AppointStatusDesc:%String,AppointUserName:%String,AppointDate:%String,AppointTime:%String,AppointComment:%String,RegNo:%String,Name:%String,DisDate:%String,DisTime:%String,PAAdmDepDesc:%String,PrintStatus:%String,PrintStatusDesc:%String,MRCurrentStep:%String,MRCurrentStepDesc:%String")
{
}

ClassMethod GetApplyListExecute(ByRef qHandle As %Binary, ARequestAct As %String, AStatus As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, AName As %String, AUserLocID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	Set langid=20  //登录语言
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set EnableTranslation=0  //翻译功能启用标识
	If (##class(%Dictionary.CompiledMethod).%ExistsId("User.Abstract||GetTranByDesc"))
	{
		Set EnableTranslation=1
	}
	
	s startDate="",endDate=""
	s:(AStartDate '= "") startDate = ##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate(AStartDate)
	s:(AEndDate '= "") endDate = ##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate(AEndDate)
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	//s:(ARegNo = $c(0)) ARegNo = ""
	s:(AName = $c(0)) AName = ""
	s locRet = ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).CheckCTLocType(AUserLocID)
	
	if (AMedRecordNo '= "")
	{
		s AMedRecordNo = $zcvt(AMedRecordNo,"U")
		s admDepID = ""
		f {
			s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo"," I"," "_AMedRecordNo,admDepID))
			q:(admDepID = "")
			s patRowID = ""
			f {
				s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxMedRecordNo"," I"," "_AMedRecordNo,admDepID,patRowID))
				q:(patRowID = "")
				s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
				s episodeID = objPat.EpisodeID
				d objPat.%Close()
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.AuthorizationI("IdxEpisodeID"," "_episodeID,rowID))
					q:(rowID = "")
					d GetApplyInfo
				}
			}
		}
	}
	elseif (AName '= "")
	{
		s AName = $zcvt(AName,"U")
		s admDepID = ""
		f {
			s admDepID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxName"," I"," "_AName,admDepID))
			q:(admDepID = "")
			s patRowID = ""
			f {
				s patRowID = $o(^DHCEPRFS.INST.CheckedPatListI("IdxName"," I"," "_AName,admDepID,patRowID))
				q:(patRowID = "")
				s objPat = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(patRowID)
				s episodeID = objPat.EpisodeID
				d objPat.%Close()
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.AuthorizationI("IdxEpisodeID"," "_episodeID,rowID))
					q:(rowID = "")
					d GetApplyInfo
				}
			}
		}
	}
	elseif ((startDate '= "") && (endDate '= ""))
	{
		s date = startDate - 1
		f {
			s date = $o(^DHCEPRFS.INST.AuthorizationI("IdxRequestActStatus"," "_ARequestAct," "_AStatus,date))
			q:((date = "")||(date > endDate))
			s time = ""
			f {
				s time = $o(^DHCEPRFS.INST.AuthorizationI("IdxRequestActStatus"," "_ARequestAct," "_AStatus,date,time))
				q:(time = "")
				s rowID = ""
				f {
					s rowID = $o(^DHCEPRFS.INST.AuthorizationI("IdxRequestActStatus"," "_ARequestAct," "_AStatus,date,time,rowID))
					q:(rowID = "")
					d GetApplyInfo
				}
			}
		}
	}
	
	q $$$OK
GetApplyInfo
	s obj = ##class(DHCEPRFS.INST.AuthorizationInfo).%OpenId(rowID)
	s episodeID = obj.EpisodeID
	s mrEpisodeID = obj.MREpisodeID
	//过滤申请日期
	s requestDate = obj.RequestDate
	if ((startDate'="")&&(endDate'=""))
	{
		q:((requestDate < startDate)||(requestDate > endDate))
	}
	//过滤申请类型
	s requestType = obj.RequestType
	//q:((locRet = "1")&&(requestType '= "DOCTOR"))
	//q:((locRet = "0")&&(requestType '= "NURSE"))
	s requestTypeDesc = $s(requestType="DOCTOR":"医生召回",requestType="NURSE":"护士召回",1:"")
	//申请信息
	s requestUserID = obj.RequestUserID
	s:(requestUserID = $c(0)) requestUserID = ""
	s requestUserName = ""
	if (requestUserID '= "")
	{
		s requestUserName = $p($g(^SSU("SSUSR",requestUserID)),"^",2)
	}
	s requestDeptID = obj.RequestDept
	s:(requestDeptID = $c(0)) requestDeptID = ""
	s requestDept = ""
	if (requestDeptID '= "")
	{
		s requestDept = $p($g(^CTLOC(requestDeptID)),"^",2)
	}
	s:(requestDate '= "") requestDate = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(requestDate)
	s requestTime = obj.RequestTime
	s:(requestTime '= "") requestTime = $zt(requestTime)
	s requestComment = ..EncodeText(obj.RequestComment)
	//审批信息
	s appointStatus = obj.AppointStatus
	s appointStatusDesc = $s(appointStatus="N":"未批准",appointStatus="F":"已批准",appointStatus="R":"已拒绝",1:"")
	s appointUserID = obj.AppointUserID
	s:(appointUserID = $c(0)) appointUserID = ""
	s appointUserName = ""
	if (appointUserID '= "")
	{
		s appointUserName = $p($g(^SSU("SSUSR",appointUserID)),"^",2)
	}
	s appointDate = obj.AppointDate
	s:(appointDate '= "") appointDate = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(appointDate)
	s appointTime = obj.AppointTime
	s:(appointTime '= "") appointTime = $zt(appointTime)
	s appointComment = ..EncodeText(obj.AppointComment)
	d obj.%Close()
	//就诊信息
	s patientID = $p(^PAADM(episodeID),"^",1)
	s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",episodeID)
	s regNo = $p($g(^PAPER(patientID,"PAT",1)),"^",1)
	s name = $p($g(^PAPER(patientID,"ALL")),"^",1)
	s disDate = "", disTime = ""
	s paDisDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(episodeID)
	s paDisDate = $p(paDisDateTime,",",1)
	s:(paDisDate '= "") disDate = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(paDisDate)
	s paDisTime = $p(paDisDateTime,",",2)
	s:(paDisTime '= "") disTime = $zt(paDisTime)
	s paAdmDepID = $p($g(^PAADM(episodeID)),"^",4)
	s paAdmDepDesc = ""
	if (paAdmDepID '= "")
	{
		s paAdmDepDesc = $p($g(^CTLOC(paAdmDepID)),"^",2)
		if ($l(paAdmDepDesc,"-")>1)
		{
			s paAdmDepDesc =$p(paAdmDepDesc,"-",2)
		}
	}
	s printStatus = ##class(DHCEPRFS.BL.BLMRLog).IsPrinted(mrEpisodeID)
	s printStatusDesc = ""
	s:(printStatus = "1") printStatusDesc = "是"
	s:(printStatus = "0") printStatusDesc = "否"
	
	if (EnableTranslation = 1)
	{
		s:(requestUserName'="") requestUserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",requestUserName,langid)
		s:(requestDept'="") requestDept = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",requestDept,langid)
		s:(appointUserName'="") appointUserName = ##class(User.SSUser).GetTranByDesc("SSUSRName",appointUserName,langid)
		s:(paAdmDepDesc'="") paAdmDepDesc = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",paAdmDepDesc,langid)
	}
	
	s ^CacheTemp(repid,ind) = $lb(rowID,episodeID,medRecordNo,requestUserName,requestDept,requestDate,requestTime,requestComment,requestType,requestTypeDesc,appointStatus,appointStatusDesc,appointUserName,appointDate,appointTime,appointComment,regNo,name,disDate,disTime,paAdmDepDesc,printStatus,printStatusDesc,mrCurrentStep,mrCurrentStepDesc)
	s ind = ind + 1
	q
}

ClassMethod GetApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApplyListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApplyListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 处理用户输入的特殊字符
/// Debug: w ##class(DHCEPRFS.BL.BLReview).EncodeText("""test""")
ClassMethod EncodeText(AText As %String) As %String
{
	s ret = $replace(AText,$c(92),"\\") //反斜线
	s ret = $replace(ret,$c(34),"\""") //双引号
	//s ret = ##class(DHCEPRFS.Util.StringHelper).Replace(AText,$c(92),"\\")
	//s ret = ##class(DHCEPRFS.Util.StringHelper).Replace(ret,$c(34),"\""")
	q ret
}

/// Desc: 提交、撤销提交及打印信息
/// Debug: w ##class(DHCEPRFS.BL.BLAuthorization).TrakInfo(436)
ClassMethod TrakInfo(AEpisodeID As %String) As %String
{
	s ret = ""
	s admMRStatusID = $o(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_AEpisodeID,""))
	s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID", " DHC", " "_AEpisodeID, ""))
	q:(admMRStatusID = "")&&(mrEpisodeID="") ret
	
	s repid = $I(^CacheTemp)
	//提交、撤销提交信息
	s action = ""
	f {
		s action = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID,action))
		q:(action = "")
		continue:(action '= " COMPLETE")&&(action '= " REVOKE")
		s logID = ""
		f {
			s logID = $o(^DHCEPRFS.INST.AdmMRStatusLogI("IdxStatusAct"," "_admMRStatusID,action,logID))
			q:(logID = "")
			
			s objLog = ##class(DHCEPRFS.INST.AdmMRStatusLog).%OpenId(logID)
			s changeDate = objLog.ChangeDate
			s changeTime = objLog.ChangeTime
			s actUserID = objLog.ChangeUserID
			s actType = objLog.Type
			s actAct = objLog.ChangeAct
			s actMessage = objLog.Message
			d objLog.%Close()
			
			s actUserName = "",actDate = "",actTime = ""
			s:(actUserID '= "") actUserName = $p($g(^SSU("SSUSR",actUserID)),"^",2)
			s:(changeDate '= "") actDate = $zd(changeDate,3)
			s:(changeTime '= "") actTime = $zt(changeTime,1)
			
			s oneRet = actDate_"^"_actTime_"^"_actUserName
			if (actAct = "COMPLETE")
			{
				if (actType = "DOCTOR")
				{
					s:(actMessage '= "") actMessage = ##class(DHCEPRFS.BL.BLReview).FormatRemarks(actMessage)
					s ^CacheTemp(repid,"DHCEPRFSAuth",AEpisodeID,changeDate,changeTime) = oneRet_"^black^医生提交^"_actMessage
				}
				else
				{
					s ^CacheTemp(repid,"DHCEPRFSAuth",AEpisodeID,changeDate,changeTime) = oneRet_"^black^护士提交^"_actMessage
				}
			}
			elseif (actAct = "REVOKE")
			{
				if (actType = "DOCTOR")
				{
					s ^CacheTemp(repid,"DHCEPRFSAuth",AEpisodeID,changeDate,changeTime) = oneRet_"^red^撤销医生提交^"_actMessage
				}
				else
				{
					s ^CacheTemp(repid,"DHCEPRFSAuth",AEpisodeID,changeDate,changeTime) = oneRet_"^red^撤销护士提交^"_actMessage
				}
			}
		}
	}
	//打印信息
	s mrLogID = ""
	f {
		s mrLogID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeID"," "_mrEpisodeID ," PRINT",mrLogID))
		q:(mrLogID = "")
		s detailID = ""
		f {
			s detailID = $o(^DHCEPRFS.INST.MRLogDetailI("IdxMREpisodeID"," "_mrEpisodeID," PRINT",mrLogID,detailID))
			q:(detailID = "")
			s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_detailID)
			s changeDate = objMRLogDetail.ActDate
			s changeTime = objMRLogDetail.ActTime
			s actUserID = objMRLogDetail.ActUserID
			d objMRLogDetail.%Close()
			
			s actUserName = "",actDate = "",actTime = ""
			s:(actUserID '= "") actUserName = $p($g(^SSU("SSUSR",actUserID)),"^",2)
			s:(changeDate '= "") actDate = $zd(changeDate,3)
			s:(changeTime '= "") actTime = $zt(changeTime,1)
			
			s ^CacheTemp(repid,"DHCEPRFSAuth",AEpisodeID,changeDate,changeTime) = actDate_"^"_actTime_"^"_actUserName_"^green^病案打印^"
		}
	}
	//b
	s date = ""
	f {
		s date = $o(^CacheTemp(repid,"DHCEPRFSAuth",AEpisodeID,date))
		q:(date = "")
		s time = ""
		f {
			s time = $o(^CacheTemp(repid,"DHCEPRFSAuth",AEpisodeID,date,time))
			q:(time = "")
			s info = $g(^CacheTemp(repid,"DHCEPRFSAuth",AEpisodeID,date,time))
			if (ret = "")
			{
				s ret = info
			}
			else
			{
				s ret = ret_"|"_info
			}
		}
	}
	k ^CacheTemp(repid)
	q ret
}

/// Debug: w ##class(DHCEPRFS.BL.BLAuthorization).AddRecallReason("159","recallreason1","test")
ClassMethod AddRecallReason(AUserID As %String, ACategoryDesc As %String, AReason As %String) As %String
{
	s nowDate = $p($h,",",1)
	s nowTime = $p($h,",",2)
	s CategoryCode = AUserID_"_"_nowDate_"_"_nowTime
	
	s obj = ##class(DHCEPRFS.INST.RecallReasonCategory).%New()
	s obj.Available = "Y"
	s obj.CategoryCode = CategoryCode
	s obj.CategoryDesc = ACategoryDesc
	s obj.CreateDate = nowDate
	s obj.CreateTime = nowTime
	s obj.Reason = AReason
	s obj.UserID = AUserID
	s sc = obj.%Save()
	d obj.%Close()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Debug: w ##Class(DHCEPRFS.BL.BLAuthorization).SaveRecallReason("1","testmodify")
ClassMethod SaveRecallReason(ACategoryID As %String, AReason As %String) As %String
{
	q:(ACategoryID = "") "-1"
	
	s obj = ##class(DHCEPRFS.INST.RecallReasonCategory).%OpenId(ACategoryID)
	s obj.Reason = AReason
	s sc = obj.%Save()
	d obj.%Close()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Debug: w ##class(DHCEPRFS.BL.BLAuthorization).RemoveRecallReason("1")
ClassMethod RemoveRecallReason(ACategoryID As %String)
{
	q:(ACategoryID = "") "-1"
	
	s obj = ##class(DHCEPRFS.INST.RecallReasonCategory).%OpenId(ACategoryID)
	s obj.Available = "N"
	s sc = obj.%Save()
	d obj.%Close()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAuthorization","LoadRecallReason","159")
Query LoadRecallReason(AUserID As %String) As %Query(ROWSPEC = "CategoryID:%String,CategoryCode:%String,CategoryDesc:%String,Reason:%String")
{
}

ClassMethod LoadRecallReasonExecute(ByRef qHandle As %Binary, AUserID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	s date = ""
	for {
		s date = $o(^DHCEPRFS.INST.RecallReasonCatI("IdxMain"," Y"," "_AUserID,date))
		q:(date = "")
		
		s time = ""
		for {
			s time = $o(^DHCEPRFS.INST.RecallReasonCatI("IdxMain"," Y"," "_AUserID,date,time))
			q:(time = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRFS.INST.RecallReasonCatI("IdxMain"," Y"," "_AUserID,date,time,rowID))
				q:(rowID = "")
				
				s obj = ##class(DHCEPRFS.INST.RecallReasonCategory).%OpenId(rowID)
				s categoryCode = obj.CategoryCode
				s categoryDesc = obj.CategoryDesc
				s reason = obj.Reason
				d obj.%Close()
				
				set ^CacheTemp(repid,ind) = $LB(rowID,categoryCode,categoryDesc,reason)
				set ind = ind + 1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod LoadRecallReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadRecallReasonExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LoadRecallReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadRecallReasonExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
