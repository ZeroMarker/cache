Class DHCEPRFS.web.eprajax.AjaxReview Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s actionCode = $Get(%request.Data("ActionCode",1),"")
	
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s userID = $Get(%request.Data("UserID",1),"") 
	
	s type = $Get(%request.Data("Type",1),"")
	s medRecordNo = $Get(%request.Data("MedRecordNo",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	s name = $Get(%request.Data("Name",1),"")
	s startDate = $g(%request.Data("StartDate",1),"")
	s endDate = $g(%request.Data("EndDate",1),"")
	s filterLocID = $Get(%request.Data("FilterLocID",1),"")
	s filterMUID = $Get(%request.Data("FilterMUID",1),"")
	
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	
	s back2Nur = $Get(%request.Data("Back2Nur",1),"")
	s back2Doc = $Get(%request.Data("Back2Doc",1),"")
	s reason = $Get(%request.Data("Reason",1),"")
	s category = $Get(%request.Data("Category",1),"")
	
	s docCommit = $Get(%request.Data("DocCommit",1),"")
	s nurCommit = $Get(%request.Data("NurCommit",1),"")
	s pdfCreated = $Get(%request.Data("PDFCreated",1),"")
	
	s mrRemarks = $Get(%request.Data("mrremarks",1),"")

	s submitDocID = $Get(%request.Data("SubmitDocID",1),"")
	s submitNurID = $Get(%request.Data("SubmitNurID",1),"")
	
	if (action = "episodelist")
	{
		d ..GetEpisodeListJSON(type,startDate,endDate,medRecordNo,regNo,name,filterLocID,startRow,endRow,docCommit,nurCommit,pdfCreated)
	}
	elseif (action = "deptepisodelist")
	{
		d ..GetDeptEpisodeListJSON(type,startDate,endDate,medRecordNo,regNo,name,filterLocID,startRow,endRow,docCommit,nurCommit,pdfCreated)
	}
	elseif (action = "oeepisodelist")
	{
		d ..GetOEEpisodeListJSON(type,startDate,endDate,medRecordNo,regNo,filterLocID,startRow,endRow,"query")
	}
	elseif (action = "exportoeepisodelist")
	{
		d ..GetOEEpisodeListJSON(type,startDate,endDate,medRecordNo,regNo,filterLocID,startRow,endRow,"export")
	}
	elseif (action = "reviewpass")
	{
		d ..SaveReviewedStatus(episodeID,userID,actionCode)
	}
	elseif (action = "qcback")
	{
		d ..QCBack(episodeID,userID,back2Nur,back2Doc,reason,actionCode,submitDocID,submitNurID)
	}
	elseif (action = "trakinfo")
	{
		d ..TrakInfo(episodeID)
	}
	elseif (action = "loadreasoncategory")
	{
		d ..LoadReasonCategoryJSON(userID)
	}
	elseif (action = "addreasoncategory")
	{
		d ..AddReasonCategory(userID,category,reason)
	}
	elseif (action = "removereasoncategory")
	{
		d ..RemoveReasonCategory(category)
	}
	elseif (action = "savereasoncategory")
	{
		d ..SaveReasonCategory(category,reason)
	}
	elseif (action = "getepisodeinfo")
	{
		d ..GetEpisodeInfo(episodeID)
	}
	elseif (action = "statusquery")
	{
		d ..GetStatusJSON(type,startDate,endDate,medRecordNo,regNo,userID,filterLocID,filterMUID,startRow,endRow)
	}
	elseif (action = "getmedunit")
	{
		d ..GetMedUnitListJSON(filterLocID)
	}
	elseif (action = "mrremarks")
	{
		d ..UpdateMRRemarks(mrRemarks,episodeID,userID)
	}
	elseif (action = "lastmrremarks")
	{
		d ..GetLastMRRemarks(episodeID)
	}
	
	Quit $$$OK
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).GetEpisodeInfo("585")
ClassMethod GetEpisodeInfo(AEpisodeID As %String)
{
	s ret = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientInfoByAdm(AEpisodeID)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).SaveReasonCategory("1","222")
ClassMethod SaveReasonCategory(ACategoryID As %String, AReason As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLReview).SaveReasonCategory(ACategoryID,AReason)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).RemoveReasonCategory("1")
ClassMethod RemoveReasonCategory(ACategoryID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLReview).RemoveReasonCategory(ACategoryID)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).LoadReasonCategory("1")
ClassMethod AddReasonCategory(AUserID As %String, ACategory As %String, AReason As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLReview).AddReasonCategory(AUserID,ACategory,AReason)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).LoadReasonCategoryJSON("159")
ClassMethod LoadReasonCategoryJSON(AUserID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLReview:LoadReasonCategory")
	s sc = result.Execute(AUserID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
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
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).TrakInfo("18","","1","0")
ClassMethod TrakInfo(AEpisodeID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLReview).TrakInfo(AEpisodeID)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).QCBack("18","","1","0")
ClassMethod QCBack(AEpisodeID As %String, AUserID As %String, ABack2Nur As %String, ABack2Doc As %String, AReason As %String, AActionCode As %String, ASubmitDocID As %String, ASubmitNurID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLPrivilege).CheckQCBackPrivilege(AEpisodeID,AUserID,ABack2Nur,ABack2Doc,AReason,AActionCode)
	if (ret="1")
	{
		if (ABack2Nur="1")  //退回给护士
		{
			d ##class(websys.DHCMessageInterface).Send("科室审核退回","5000",AUserID,AEpisodeID,"",ASubmitDocID)
		}
		if (ABack2Doc="1") //退回给医生
		{
			d ##class(websys.DHCMessageInterface).Send("科室审核退回","5000",AUserID,AEpisodeID,"",ASubmitNurID)
		}
	}
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).SaveReviewedStatus("10","")
ClassMethod SaveReviewedStatus(AEpisodeID As %String, AUserID As %String, AActionCode As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLPrivilege).CheckReviewPassPrivilege(AEpisodeID,AUserID,AActionCode)
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if ((hospitalFlag = "WLDYRM")&&(AActionCode = "1"))
	{
		d ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishFPTOP(AEpisodeID)
	}
	elseif ((hospitalFlag = "SZBAFYYY")&&(AActionCode = "1"))
	{
		d ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishTop(AEpisodeID)
	}
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).UpdateMRRemarks("test","601","159")
ClassMethod UpdateMRRemarks(AMRRemarks As %String, AEpisodeID As %String, AUserID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLReview).UpdateMRRemarks(AMRRemarks,AEpisodeID,AUserID)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).GetLastMRRemarks("601")
ClassMethod GetLastMRRemarks(AEpisodeID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLReview).GetLastMRRemarks(AEpisodeID)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).GetEpisodeListJSON("MR||U","2017-3-1","2017-6-30","","","","","0","20","","","")
ClassMethod GetEpisodeListJSON(AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AName As %String, AFilterLocID As %String, AIdxStart As %Integer, AIdxLast As %Integer, ADocCommit As %String, ANurCommit As %String, APDFCreated As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLReview:GetEpisodeList")
	s sc = result.Execute(AType, AStartDate, AEndDate, AMedRecordNo, ARegNo, AName, AFilterLocID, ADocCommit, ANurCommit, APDFCreated)
	
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
			w ..TrimEnter("""SuperURL"":""SuperURL"",")
			w ..TrimEnter("""EPRURL"":""EPRURL"",")
			w ..TrimEnter("""CheckRetURL"":""CheckRetURL"",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ..TrimEnter("""AdmDateTime"":"""_$g(result.Data("AdmDateTime"))_""",")
			w ..TrimEnter("""DisDateTime"":"""_$g(result.Data("DisDateTime"))_""",")
			w ..TrimEnter("""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""",")
			w ..TrimEnter("""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""",")
			w ..TrimEnter("""Warddesc"":"""_$g(result.Data("Warddesc"))_""",")
			w ..TrimEnter("""EprDocStatus"":"""_$g(result.Data("EprDocStatus"))_""",")
			w ..TrimEnter("""EprDocStatusDesc"":"""_$g(result.Data("EprDocStatusDesc"))_""",")
			w ..TrimEnter("""EprNurStatus"":"""_$g(result.Data("EprNurStatus"))_""",")
			w ..TrimEnter("""EprNurStatusDesc"":"""_$g(result.Data("EprNurStatusDesc"))_""",")
			w ..TrimEnter("""EprPdfStatus"":"""_$g(result.Data("EprPdfStatus"))_""",")
			w ..TrimEnter("""EprPdfStatusDesc"":"""_$g(result.Data("EprPdfStatusDesc"))_""",")
			w ..TrimEnter("""ReviewStatus"":"""_$g(result.Data("ReviewStatus"))_""",")
			w ..TrimEnter("""QCDeptStatus"":"""_$g(result.Data("QCDeptStatus"))_""",")
			w ..TrimEnter("""DeptStatus"":"""_$g(result.Data("DeptStatus"))_""",")
			w ..TrimEnter("""CheckStatus"":"""_$g(result.Data("CheckStatus"))_""",")
			w ..TrimEnter("""CheckRule"":"""_$g(result.Data("CheckRule"))_""",")
			w ..TrimEnter("""CheckDateTime"":"""_$g(result.Data("CheckDateTime"))_""",")
			w ..TrimEnter("""CheckUser"":"""_$g(result.Data("CheckUser"))_""",")
			w ..TrimEnter("""BackMessage"":"""_$g(result.Data("BackMessage"))_""",")
			w ..TrimEnter("""Remarks"":"""_$g(result.Data("Remarks"))_""",")
			w ..TrimEnter("""SubmitMessage"":"""_$g(result.Data("SubmitMessage"))_""",")
			w ..TrimEnter("""ScanStatus"":"""_$g(result.Data("ScanStatus"))_""",")
			w ..TrimEnter("""CodeStatus"":"""_$g(result.Data("CodeStatus"))_""",")
			w ..TrimEnter("""MRRemarks"":"""_$g(result.Data("MRRemarks"))_""",")
			w ..TrimEnter("""BackCount"":"""_$g(result.Data("BackCount"))_""",")
			w ..TrimEnter("""QCDeptBackCount"":"""_$g(result.Data("QCDeptBackCount"))_""",")
			w ..TrimEnter("""DeptBackCount"":"""_$g(result.Data("DeptBackCount"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).GetDeptEpisodeListJSON("U","2017-4-1","2017-6-30","","","","9","0","20","","","")
ClassMethod GetDeptEpisodeListJSON(AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AName As %String, AFilterLocID As %String, AIdxStart As %Integer, AIdxLast As %Integer, ADocCommit As %String, ANurCommit As %String, APDFCreated As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLReview:GetDeptEpisodeList")
	s sc = result.Execute(AType, AStartDate, AEndDate, AMedRecordNo, ARegNo, AName, AFilterLocID, ADocCommit, ANurCommit, APDFCreated)
	
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
			w ..TrimEnter("""SuperURL"":""SuperURL"",")
			w ..TrimEnter("""EPRURL"":""EPRURL"",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ..TrimEnter("""AdmDate"":"""_$g(result.Data("AdmDate"))_""",")
			w ..TrimEnter("""AdmTime"":"""_$g(result.Data("AdmTime"))_""",")
			w ..TrimEnter("""DisDate"":"""_$g(result.Data("DisDate"))_""",")
			w ..TrimEnter("""DisTime"":"""_$g(result.Data("DisTime"))_""",")
			w ..TrimEnter("""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""",")
			w ..TrimEnter("""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""",")
			w ..TrimEnter("""Warddesc"":"""_$g(result.Data("Warddesc"))_""",")
			w ..TrimEnter("""EprDocStatus"":"""_$g(result.Data("EprDocStatus"))_""",")
			w ..TrimEnter("""EprDocStatusDesc"":"""_$g(result.Data("EprDocStatusDesc"))_""",")
			w ..TrimEnter("""EprNurStatus"":"""_$g(result.Data("EprNurStatus"))_""",")
			w ..TrimEnter("""EprNurStatusDesc"":"""_$g(result.Data("EprNurStatusDesc"))_""",")
			w ..TrimEnter("""EprPdfStatus"":"""_$g(result.Data("EprPdfStatus"))_""",")
			w ..TrimEnter("""EprPdfStatusDesc"":"""_$g(result.Data("EprPdfStatusDesc"))_""",")
			w ..TrimEnter("""QCSignStatus"":"""_$g(result.Data("QCSignStatus"))_""",")
			w ..TrimEnter("""QCSignStatusDesc"":"""_$g(result.Data("QCSignStatusDesc"))_""",")
			w ..TrimEnter("""ReviewStatus"":"""_$g(result.Data("ReviewStatus"))_""",")
			w ..TrimEnter("""QCDeptStatus"":"""_$g(result.Data("QCDeptStatus"))_""",")
			w ..TrimEnter("""DeptStatus"":"""_$g(result.Data("DeptStatus"))_""",")
			w ..TrimEnter("""Remarks"":"""_$g(result.Data("Remarks"))_""",")
			w ..TrimEnter("""SubmitMessage"":"""_$g(result.Data("SubmitMessage"))_""",")
			w ..TrimEnter("""SubmitCount"":"""_$g(result.Data("SubmitCount"))_""",")
			w ..TrimEnter("""BackMessage"":"""_$g(result.Data("BackMessage"))_""",")
			w ..TrimEnter("""SubmitDocID"":"""_$g(result.Data("SubmitDocID"))_""",")
			w ..TrimEnter("""SubmitNurID"":"""_$g(result.Data("SubmitNurID"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).GetStatusJSON("U","2017-3-1","2017-6-30","","","159","9","9||3","0","20")
ClassMethod GetStatusJSON(AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AUserID As %String, AFilterLocID As %String, ACTMUID As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLReview:GetStatus")
	s sc = result.Execute(AType, AStartDate, AEndDate, AMedRecordNo, ARegNo, AUserID, AFilterLocID, ACTMUID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ( count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""DisDateTime"":"""_$g(result.Data("DisDateTime"))_""",")
			w ..TrimEnter("""CTMedUnitDesc"":"""_$g(result.Data("CTMedUnitDesc"))_""",")
			w ..TrimEnter("""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""",")
			w ..TrimEnter("""Warddesc"":"""_$g(result.Data("Warddesc"))_""",")
			w ..TrimEnter("""EprDocStatus"":"""_$g(result.Data("EprDocStatus"))_""",")
			w ..TrimEnter("""EprDocStatusDesc"":"""_$g(result.Data("EprDocStatusDesc"))_""",")
			w ..TrimEnter("""EprNurStatus"":"""_$g(result.Data("EprNurStatus"))_""",")
			w ..TrimEnter("""EprNurStatusDesc"":"""_$g(result.Data("EprNurStatusDesc"))_""",")
			w ..TrimEnter("""EprPdfStatus"":"""_$g(result.Data("EprPdfStatus"))_""",")
			w ..TrimEnter("""EprPdfStatusDesc"":"""_$g(result.Data("EprPdfStatusDesc"))_""",")
			w ..TrimEnter("""ReviewStatus"":"""_$g(result.Data("ReviewStatus"))_""",")
			w ..TrimEnter("""QCDeptStatus"":"""_$g(result.Data("QCDeptStatus"))_""",")
			w ..TrimEnter("""DeptStatus"":"""_$g(result.Data("DeptStatus"))_""",")
			w ..TrimEnter("""Message"":"""_$g(result.Data("Message"))_""",")
			w ..TrimEnter("""Remarks"":"""_$g(result.Data("Remarks"))_""",")
			w ..TrimEnter("""SubmitMessage"":"""_$g(result.Data("SubmitMessage"))_""",")
			w ..TrimEnter("""BackMessage"":"""_$g(result.Data("BackMessage"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).GetMedUnitListJSON("9")
ClassMethod GetMedUnitListJSON(AFilterLocID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetMedUnitByCTLocID")
	s sc = result.Execute(AFilterLocID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""TMURowid"":"""_$g(result.Data("TMURowid"))_""",")
		w ..TrimEnter("""TCTMUCode"":"""_$g(result.Data("TCTMUCode"))_""",")
		w ..TrimEnter("""TCTMUDesc"":"""_$g(result.Data("TCTMUDesc"))_""",")
		w ..TrimEnter("""TCTMUActiveFlag"":"""_$g(result.Data("TCTMUActiveFlag"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxReview).GetOEEpisodeListJSON("U","2017-8-1","2017-8-20","","","","0","20")
ClassMethod GetOEEpisodeListJSON(AType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AFilterLocID As %String, AIdxStart As %Integer, AIdxLast As %Integer, AFlagExec As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLReview:GetOEEpisodeList")
	s sc = result.Execute(AType, AStartDate, AEndDate, AMedRecordNo, ARegNo, AFilterLocID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		continue:(AFlagExec '= "export")&&((count < AIdxStart)||(count > AIdxLast))
		//if (count >= AIdxStart) && (count <= AIdxLast)
		//{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ..TrimEnter("""SuperURL"":""SuperURL"",")
			w ..TrimEnter("""EPRURL"":""EPRURL"",")
			w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ..TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_""",")
			w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ..TrimEnter("""AdmDateTime"":"""_$g(result.Data("AdmDateTime"))_""",")
			w ..TrimEnter("""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""",")
			w ..TrimEnter("""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""",")
			w ..TrimEnter("""EprDocStatus"":"""_$g(result.Data("EprDocStatus"))_""",")
			w ..TrimEnter("""EprDocStatusDesc"":"""_$g(result.Data("EprDocStatusDesc"))_""",")
			w ..TrimEnter("""EprPdfStatus"":"""_$g(result.Data("EprPdfStatus"))_""",")
			w ..TrimEnter("""EprPdfStatusDesc"":"""_$g(result.Data("EprPdfStatusDesc"))_""",")
			w ..TrimEnter("""ReviewStatus"":"""_$g(result.Data("ReviewStatus"))_"""")
			w "}"
			s first = 0
		//}
	}
	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

}
