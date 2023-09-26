Class DHCEPRFS.web.eprajax.AjaxAuthorizationInfo Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s userID = $Get(%request.Data("UserID",1),"")
	s userLocID = $g(%request.Data("UserLocID",1),"")
	s authInfoID = $g(%request.Data("AuthInfoID",1),"")
	
	s requestAct = $g(%request.Data("RequestAct",1),"")
	s reason = $g(%request.Data("Reason",1),"")
	s clinicFlag = $g(%request.Data("ClinicFlag",1),"")
	s appointStatus = $Get(%request.Data("AppointStatus",1),"")
	s startDate = $g(%request.Data("StartDate",1),"")
	s endDate = $g(%request.Data("EndDate",1),"")
	s medRecordNo = $g(%request.Data("MedRecordNo",1),"")
	s name = $g(%request.Data("Name",1),"")
	s categoryDesc = $g(%request.Data("CategoryDesc",1),"")
	s categoryID = $g(%request.Data("CategoryID",1),"")
	s reasonType = $g(%request.Data("ReasonType",1),"")
	
	if (action = "apply")
	{
		d ..Apply(requestAct,episodeID,userID,userLocID,reason,clinicFlag)
	}
	elseif (action = "recallrecord")
	{
		d ..RecallRecord(episodeID,userID,clinicFlag)
	}
	elseif (action = "approverecall")
	{
		d ..ApproveRecallAppliaction(authInfoID,userID)
	}
	elseif (action = "reject")
	{
		d ..Reject(authInfoID,userID,reason)
	}
	elseif (action = "trakinfo")
	{
		d ..TrakInfo(episodeID)
	}
	elseif (action = "applylist")
	{
		d ..GetApplyListJSON(requestAct,appointStatus,startDate,endDate,medRecordNo,name,userLocID,startRow,endRow)
	}
	elseif (action = "exportapplylist")
	{
		d ..GetApplyListExportJSON(requestAct,appointStatus,startDate,endDate,medRecordNo,name,userLocID)
	}
	elseif (action = "addrecallreason")
	{
		d ..AddRecallReason(userID,categoryDesc,reason)
	}
	elseif (action = "saverecallreason")
	{
		d ..SaveRecallReason(categoryID,reason)
	}
	elseif (action = "removerecallreason")
	{
		d ..RemoveRecallReason(categoryID)
	}
	elseif (action = "loadrecallreason")
	{
		d ..LoadRecallReasonJSON(userID,reasonType)
	}
	Quit $$$OK
}

/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).Apply("REVOKE",601,159,9,"test")
ClassMethod Apply(ARequestAct As %String, AEpisodeID As %String, AUserID As %String, AUserLocID As %String, AReason As %String, AClinicFlag As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAuthorization).Apply(ARequestAct,AEpisodeID,AUserID,AUserLocID,AReason,AClinicFlag)
	w ret
}

/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).RecallRecord(601,159,"1")
ClassMethod RecallRecord(AEpisodeID As %String, AUserID As %String, AClinicFlag As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAuthorization).RecallRecord(AEpisodeID,AUserID,AClinicFlag)
	w ret
}

/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).ApproveAppliaction(8,552)
ClassMethod ApproveRecallAppliaction(AAuthInfoID As %String, AUserID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAuthorization).ApproveRecallAppliaction(AAuthInfoID,AUserID)
	w ret
}

/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).Reject(7,552,"拒绝申请测试")
ClassMethod Reject(AAuthInfoID As %String, AUserID As %String, AReason As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAuthorization).Reject(AAuthInfoID,AUserID,AReason)
	w ret
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).TrakInfo("612")
ClassMethod TrakInfo(AEpisodeID As %String)
{
	s ret =	##class(DHCEPRFS.BL.BLAuthorization).TrakInfo(AEpisodeID)
	w ret
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).GetApplyListJSON("N","2018-6-1","2018-6-20","","","9",1,20)
ClassMethod GetApplyListJSON(ARequestAct As %String, AStatus As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, AName As %String, AUserLocID As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLAuthorization:GetApplyList")
	s sc = result.Execute(ARequestAct,AStatus, AStartDate, AEndDate, AMedRecordNo, AName, AUserLocID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
	 	s count = count + 1
		if (count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""AuthorizationID"":"""_$g(result.Data("AuthorizationID"))_""",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ..TrimEnter("""RequestUserName"":"""_$g(result.Data("RequestUserName"))_""",")
			w ..TrimEnter("""RequestDept"":"""_$g(result.Data("RequestDept"))_""",")
			w ..TrimEnter("""RequestDate"":"""_$g(result.Data("RequestDate"))_""",")
			w ..TrimEnter("""RequestTime"":"""_$g(result.Data("RequestTime"))_""",")
			w ..TrimEnter("""RequestComment"":"""_$g(result.Data("RequestComment"))_""",")
			w ..TrimEnter("""RequestType"":"""_$g(result.Data("RequestType"))_""",")
			w ..TrimEnter("""RequestTypeDesc"":"""_$g(result.Data("RequestTypeDesc"))_""",")
			w ..TrimEnter("""AppointStatus"":"""_$g(result.Data("AppointStatus"))_""",")
			w ..TrimEnter("""AppointStatusDesc"":"""_$g(result.Data("AppointStatusDesc"))_""",")
			w ..TrimEnter("""AppointUserName"":"""_$g(result.Data("AppointUserName"))_""",")
			w ..TrimEnter("""AppointDate"":"""_$g(result.Data("AppointDate"))_""",")
			w ..TrimEnter("""AppointTime"":"""_$g(result.Data("AppointTime"))_""",")
			w ..TrimEnter("""AppointComment"":"""_$g(result.Data("AppointComment"))_""",")
			w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
			w ..TrimEnter("""Name"":"""_$g(result.Data("Name"))_""",")
			w ..TrimEnter("""DisDate"":"""_$g(result.Data("DisDate"))_""",")
			w ..TrimEnter("""DisTime"":"""_$g(result.Data("DisTime"))_""",")
			w ..TrimEnter("""PAAdmDepDesc"":"""_$g(result.Data("PAAdmDepDesc"))_""",")
			w ..TrimEnter("""PrintStatus"":"""_$g(result.Data("PrintStatus"))_""",")
			w ..TrimEnter("""PrintStatusDesc"":"""_$g(result.Data("PrintStatusDesc"))_""",")
			w ..TrimEnter("""MRCurrentStep"":"""_$g(result.Data("MRCurrentStep"))_""",")
			w ..TrimEnter("""MRCurrentStepDesc"":"""_$g(result.Data("MRCurrentStepDesc"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).GetApplyListExportJSON("N","2018-6-1","2018-6-20","","","9")
ClassMethod GetApplyListExportJSON(ARequestAct As %String, AStatus As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, AName As %String, AUserLocID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLAuthorization:GetApplyList")
	s sc = result.Execute(ARequestAct,AStatus, AStartDate, AEndDate, AMedRecordNo, AName, AUserLocID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
	 	s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""AuthorizationID"":"""_$g(result.Data("AuthorizationID"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
		w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
		w ..TrimEnter("""RequestUserName"":"""_$g(result.Data("RequestUserName"))_""",")
		w ..TrimEnter("""RequestDept"":"""_$g(result.Data("RequestDept"))_""",")
		w ..TrimEnter("""RequestDate"":"""_$g(result.Data("RequestDate"))_""",")
		w ..TrimEnter("""RequestTime"":"""_$g(result.Data("RequestTime"))_""",")
		w ..TrimEnter("""RequestComment"":"""_$g(result.Data("RequestComment"))_""",")
		w ..TrimEnter("""RequestType"":"""_$g(result.Data("RequestType"))_""",")
		w ..TrimEnter("""RequestTypeDesc"":"""_$g(result.Data("RequestTypeDesc"))_""",")
		w ..TrimEnter("""AppointStatus"":"""_$g(result.Data("AppointStatus"))_""",")
		w ..TrimEnter("""AppointStatusDesc"":"""_$g(result.Data("AppointStatusDesc"))_""",")
		w ..TrimEnter("""AppointUserName"":"""_$g(result.Data("AppointUserName"))_""",")
		w ..TrimEnter("""AppointDate"":"""_$g(result.Data("AppointDate"))_""",")
		w ..TrimEnter("""AppointTime"":"""_$g(result.Data("AppointTime"))_""",")
		w ..TrimEnter("""AppointComment"":"""_$g(result.Data("AppointComment"))_""",")
		w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
		w ..TrimEnter("""Name"":"""_$g(result.Data("Name"))_""",")
		w ..TrimEnter("""DisDate"":"""_$g(result.Data("DisDate"))_""",")
		w ..TrimEnter("""DisTime"":"""_$g(result.Data("DisTime"))_""",")
		w ..TrimEnter("""PAAdmDepDesc"":"""_$g(result.Data("PAAdmDepDesc"))_""",")
		w ..TrimEnter("""PrintStatus"":"""_$g(result.Data("PrintStatus"))_""",")
		w ..TrimEnter("""PrintStatusDesc"":"""_$g(result.Data("PrintStatusDesc"))_""",")
		w ..TrimEnter("""MRCurrentStep"":"""_$g(result.Data("MRCurrentStep"))_""",")
		w ..TrimEnter("""MRCurrentStepDesc"":"""_$g(result.Data("MRCurrentStepDesc"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).AddRecallReason("159","recallreason1","test")
ClassMethod AddRecallReason(AUserID As %String, ACategoryDesc As %String, AReason As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAuthorization).AddRecallReason(AUserID,ACategoryDesc,AReason)
	w ret
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).SaveRecallReason("1","modify")
ClassMethod SaveRecallReason(ACategoryID As %String, AReason As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAuthorization).SaveRecallReason(ACategoryID,AReason)
	w ret
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).RemoveRecallReason("1")
ClassMethod RemoveRecallReason(ACategoryID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLAuthorization).RemoveRecallReason(ACategoryID)
	w ret
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxAuthorizationInfo).LoadRecallReasonJSON("159")
ClassMethod LoadRecallReasonJSON(AUserID As %String, AReasonType As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLAuthorization:LoadRecallReason")
	s sc = result.Execute(AUserID)
	
	s count = 0
	s first = 1
	if (AReasonType="grid") {
		w "{""rows"":"
	}
	w "["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""CategoryID"":"""_$g(result.Data("CategoryID"))_""",")
		w ..TrimEnter("""CategoryCode"":"""_$g(result.Data("CategoryCode"))_""",")
		w ..TrimEnter("""CategoryDesc"":"""_$g(result.Data("CategoryDesc"))_""",")
		w ..TrimEnter("""Reason"":"""_$g(result.Data("Reason"))_"""")
		w "}"
		s first = 0
	}
	w "]"
	if (AReasonType="grid") {
		w ",""total"":"_count_"}"
	}
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

}
