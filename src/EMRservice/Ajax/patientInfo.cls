Class EMRservice.Ajax.patientInfo Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	
	s action = $Get(%request.Data("action",1),"")
	s:(action="") action = $Get(%request.Data("Func",1),"")
	s patientID = $Get(%request.Data("patientID",1),"")
	
	s DateGap = $Get(%request.Data("DateGap",1),"")
	s RadioValue = $Get(%request.Data("RadioValue",1),"")
	//日期框时间 
	if (DateGap["^") {
		s StartDate = $zdh($P(DateGap,"^",1),3)
		s EndDate = $zdh($P(DateGap,"^",2),3)
	} 
	else
	{
		s Systemdatetime = $HOROLOG
		s Systemdateint = $p(Systemdatetime,",",1)
		s Systemtimeint = $p(Systemdatetime,",",2)
		//取最早的出院患者的时间
		s StartDate = Systemdateint-DateGap
		s EndDate = Systemdateint
	}
	
	if (action = "GetPatientInfo") //患者信息
	{
		s patientID = $Get(%request.Data("patientID",1),"")
		s episodeID = $Get(%request.Data("EpisodeID",1),"")
		w ..GetPatientInfoInBrowser(patientID,episodeID)
	}
	elseif (action = "GetPatientList") //检索患者列表
	{
		s page = $g(%request.Data("page",1),"-1")
		s rows = $g(%request.Data("rows",1),"-1")
		s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1	

		s locID = $g(%session.Data("LOGON.CTLOCID"))
		s userID = $g(%session.Data("LOGON.USERID"))
		s PatListType = $Get(%request.Data("PatListType",1),"")
		
		if (PatListType = "InPat")
		{
			s RadioValue = $Get(%request.Data("RadioValue",1),"")
			s WardID = $Get(%request.Data("WardID",1),"all")
			s MedicareNo = $Get(%request.Data("MedicareNo",1),"")
			s PatientName = $Get(%request.Data("PatientName",1),"")
			s Diagnosis = $Get(%request.Data("Diagnosis",1),"")
			s result = ""
			s result = ..GetInPatListJSON(locID,userID,RadioValue,WardID,idxStart,idxLast,MedicareNo,PatientName,Diagnosis)
			while (result.AtEnd = 0)
			{
				w $ZSTRIP(result.Read(32000),"*C")
			}
			
		}
		elseif (PatListType = "OutPat")
		{
			s RadioValue = $Get(%request.Data("RadioValue",1),"")
			s PatientNo = $Get(%request.Data("PatientNo",1),"")
			s MedicareNo = $Get(%request.Data("MedicareNo",1),"")
			s PatientName = $Get(%request.Data("PatientName",1),"")
			s UserCode = $Get(%request.Data("UserCode",1),"")
			w ..GetOutPatListJSON(locID,userID,RadioValue,idxStart,idxLast,StartDate,EndDate,PatientNo,MedicareNo,PatientName,UserCode)
			//w ..GetOutPatListJSON(locID,idxStart,idxLast,"2013-11-04","2013-11-06")
		}
		elseif (PatListType = "TransDept")
		{
			s RadioValue = $Get(%request.Data("RadioValue",1),"")
			w ..GetChangeDeptPatListJSON(locID,userID,RadioValue,idxStart,idxLast,StartDate,EndDate)
			//w ..GetChangeDeptPatListJSON(locID,userID,idxStart,idxLast,"2015-01-20","2015-02-06")
		}
		elseif (PatListType = "OperationPat")
		{
			w ..GetOperationPatListJSON(locID,userID,RadioValue,idxStart,idxLast,StartDate,EndDate)
			//w ..GetOperationPatListJSON(locID,userID,idxStart,idxLast,"2015-02-01","2015-02-10")
		}
		elseif (PatListType = "CriticallyPat")
		{
			w ..GetCriticallyPatListJSON(locID,userID,idxStart,idxLast,"","")
		}
		elseif (PatListType = "OPatient")
		{
			w ..GetOPatient(locID,userID)
		}		
	}
	elseif (action = "GetAdmHistoryLstForOP")
	{
		s patientID = $Get(%request.Data("PatientID",1),"")
		w ..GetAdmHistoryLstForOP(patientID)
	}
	elseif (action = "GetPatientInfoOP") //患者信息
	{
		s episodeID = $Get(%request.Data("EpisodeID",1),"")
		s patientID = $Get(%request.Data("PatientID",1),"")
		
		w ..GetPatientInfo(patientID,episodeID)
	}
	elseif (action = "GetNewEMRRecordOP") //患者信息
	{		
		w ##Class(EMRservice.BL.BLPatientInfo).newEMRRecordOP()
	}
	elseif (action = "GetAdmList")
	{
		d ..GetAdmList() //病历浏览界面患者列表
	}
	elseif (action = "GetUserName")
	{
		s locID = $g(%session.Data("LOGON.CTLOCID"))
		//病历浏览医生下拉框
		s cbxLocID = $g(%request.Data("cbxLocID",1),"")
		s:(cbxLocID '= "") locID = cbxLocID
		s dictCode = $g(%request.Data("DictCode",1),"S07")
		w ..GetUserName(locID,dictCode)
	}
	elseif (action = "GetAdmRecordList")
	{
		d ..GetAdmRecordList()
	}
    elseif (action = "GetEpisodeInfo") //患者就诊信息
    {
        s episodeIDs = $Get(%request.Data("EpisodeIDs",1),"")
        w ..GetEpisodeInfoInBrowser(episodeIDs)
    }

	q $$$OK
}

/// Desc:	获取在院患者列表JSON串;
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		RadioValue为按一下情况查询：
/// 				currentUser： 本人病人
/// 				currentGroup：本组病人
/// 				currentWard： 本病区病人
/// 				currentLoc：  本科病人
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// 			AMedicareNo为病案号;
/// 			APatientName为患者姓名;
/// Return:	在院患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EMRservice.Ajax.patientInfo).GetInPatListJSON("6","359","currentUser","all","1","10","","")
/// Debug:	w ##Class(EMRservice.Ajax.patientInfo).GetInPatListJSON("1","47","currentUser","all","1","10","","")
ClassMethod GetInPatListJSON(ALocID As %String, AUserID As %String, ARadioValue As %String, AWardID As %String, AIdxStart As %Integer, AIdxLast As %Integer, AMedicareNo As %String = "", APatientName As %String = "", ADiagnosis As %String = "") As %GlobalCharacterStream
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	s result = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetInPatList")
	s sc = result.Execute(ALocID,AUserID,ARadioValue,AWardID,AMedicareNo,APatientName,ADiagnosis)
 	s json = ""
 	s count = 0
 	s nowJson = ""
 	s key = $i(^CacheTemp)
	k ^TempEMRPatList(key)
	s BedNO = ""
	s nowJson = ##Class(%GlobalCharacterStream).%New()
 	s ret = ##Class(%GlobalCharacterStream).%New()
	While (result.Next())
 	{
		 s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		 s patientID = $g(result.Data("PatientID"))
		 if (HasPatEncryptLevel = "Y")
		 {
			 s ResultStr = ..GetPatEncryptLevel(patientID)
			 s json = json_"""SecAlias"":"""_$p(ResultStr,"^",1)_""","
			 s json = json_"""EmployeeFunction"":"""_$p(ResultStr,"^",2)_""","
		 }
		 s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		 s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","
		 s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 s json = json_"""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""","
		 s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		 s json = json_"""PAAdmDate"":"""_$g(result.Data("PAAdmDate"))_""","
		 s json = json_"""PAAdmTime"":"""_$g(result.Data("PAAdmTime"))_""","
		 s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 s json = json_"""HeadUniteDoc"":"""_$g(result.Data("HeadUniteDoc"))_""","
		 s json = json_"""ChiefDoc"":"""_$g(result.Data("ChiefDoc"))_""","
		 s json = json_"""PAAdmBedNO"":"""_$g(result.Data("PAAdmBedNO"))_""","
		 s json = json_"""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""","
		 s json = json_"""PAAdmRoom"":"""_$g(result.Data("PAAdmRoom"))_""","
		 s json = json_"""PAAdmReason"":"""_$g(result.Data("PAAdmReason"))_""","
		 s json = json_"""ResidentDays"":"""_$g(result.Data("ResidentDays"))_""","
		 s json = json_"""InTimes"":"""_$g(result.Data("InTimes"))_""","
		 s json = json_"""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""","
		 s json = json_"""Diagnosis"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(result.Data("Diagnosis")))_"""}" 
		 s BedNO = $g(result.Data("PAAdmBedNO"))
		 s:(BedNO = "") BedNO="无"
		 s BedNO = BedNO_"床"
		 s ^TempEMRPatList(key,BedNO,count) = json
		 s json = ""
		 s count = count + 1
	}
	//倒序排序输出
	s OrdBedNO="",j=0,i=1
	for
	{
		s OrdBedNO = $o(^TempEMRPatList(key,OrdBedNO),1)
		q:(OrdBedNO="")
		s order=""
		for {
			s order = $o(^TempEMRPatList(key,OrdBedNO,order))
			q:(order = "")
			if ((AIdxStart <= i)&(i <= AIdxLast))
			{
				s tempJson = ^TempEMRPatList(key,OrdBedNO,order)
				s tempJson = $tr(tempJson,$c(10),"")
				s tempJson = $tr(tempJson,$c(13),"")
				s tempJson = $ZSTRIP(tempJson,"*C")
				if (j'=0)
				{
					d nowJson.Write(",")
				}
				d nowJson.Write(tempJson)
				s j = j + 1
			}
			s i = i + 1
		}
	}
	k ^TempEMRPatList(key)
	
	d ret.Write("{""total"":"_count_",""rows"":[")
	d ret.CopyFrom(nowJson)
	d ret.Write("]}")
	q ret
}

/// Desc:	获取出院患者列表JSON串;
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		RadioValue为按一下情况查询：
/// 				currentUser： 本人病人
/// 				currentLoc：  本科室病人
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// 			AStartDate开始日期
/// 			AEndDate结束日期
/// Return:	出院患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EMRservice.Ajax.patientInfo).GetOutPatListJSON("6","105","currentUser","1","10","2013-11-01","2013-11-30","","","","")
ClassMethod GetOutPatListJSON(ALocID As %String, AUserID As %String, ARadioValue As %String, AIdxStart As %Integer, AIdxLast As %Integer, AStartDate As %String, AEndDate As %String, APatientNo As %String = "", AMedicareNo As %String = "", APatientName As %String = "", AUserCode As %String = "")
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	//s ^tempncc("0") = ALocID_"^"_AIdxStart_"^"_AIdxLast_"^"_AStartDate_"^"_AEndDate
	if (AStartDate = "")||(AEndDate = "")
	{
		s Systemdatetime = $HOROLOG
		s Systemdateint = $p(Systemdatetime,",",1)
		s Systemtimeint = $p(Systemdatetime,",",2)
		s StartDate = Systemdateint-6
		s EndDate = Systemdateint
	}
	else
	{
		s StartDate = AStartDate
		s EndDate= AEndDate
	}
	
	s result = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetOutPatList")
	s sc = result.Execute(ALocID,AUserID,ARadioValue,StartDate,EndDate,APatientNo,AMedicareNo,APatientName,AUserCode)
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		 	
		 	s patientID = $g(result.Data("PatientID"))
		 	if (HasPatEncryptLevel = "Y")
		 	{
			 	s ResultStr = ..GetPatEncryptLevel(patientID)
			 	s json = json_"""SecAlias"":"""_$p(ResultStr,"^",1)_""","
				s json = json_"""EmployeeFunction"":"""_$p(ResultStr,"^",2)_""","
		 	}
		 	s IsRecordCompleted = $g(result.Data("IsRecordCompleted"))
		 	s:(IsRecordCompleted = "1") IsRecordCompleted = "是"
		 	s:(IsRecordCompleted = "0") IsRecordCompleted = "否"
		 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		 	s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""","
			s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		 	s json = json_"""PAAdmDischgeDate"":"""_$g(result.Data("PAAdmDischgeDate"))_""","
		 	s json = json_"""PAAdmDischgeTime"":"""_$g(result.Data("PAAdmDischgeTime"))_""","
		 	s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 	s json = json_"""PAAdmBedNO"":"""_$g(result.Data("PAAdmBedNO"))_""","
		 	s json = json_"""HomepageURL"":"""_$g(result.Data("HomepageURL"))_""","
		 	s json = json_"""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""","
		 	s json = json_"""DisDiagnosDesc"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(result.Data("DisDiagnosDesc")))_""","
		 	s json = json_"""OutDays"":"""_$g(result.Data("OutDays"))_""","
		 	s json = json_"""InTimes"":"""_$g(result.Data("InTimes"))_""","
		 	s json = json_"""IsRecordCompleted"":"""_IsRecordCompleted_"""}"
		 	s json = json_"," 
		 }
		 s count = count + 1
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

/// Desc:	获取在院转科患者列表JSON串;
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// 		AStartDate开始日期
/// 		AEndDate结束日期
/// Return:	在院转科患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EMRservice.Ajax.patientInfo).GetChangeDeptPatListJSON("6","105","1","10","2015-01-20","2015-02-06")
ClassMethod GetChangeDeptPatListJSON(ALocID As %String, AUserID As %String, ARadioValue As %String, AIdxStart As %Integer, AIdxLast As %Integer, AStartDate As %String, AEndDate As %String)
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	if (AStartDate = "")||(AEndDate = "")
	{
		s Systemdatetime = $HOROLOG
		s Systemdateint = $p(Systemdatetime,",",1)
		s Systemtimeint = $p(Systemdatetime,",",2)
		s StartDate = Systemdateint
		s EndDate = Systemdateint
	}
	else
	{
		s StartDate = AStartDate
		s EndDate= AEndDate
	}
	
	s result = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetChangeDeptPatList")
	s sc = result.Execute(ALocID,AUserID,ARadioValue,StartDate,EndDate)
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		 	
		 	s patientID = $g(result.Data("PatientID"))
		 	if (HasPatEncryptLevel = "Y")
		 	{
			 	s ResultStr = ..GetPatEncryptLevel(patientID)
			 	s json = json_"""SecAlias"":"""_$p(ResultStr,"^",1)_""","
				s json = json_"""EmployeeFunction"":"""_$p(ResultStr,"^",2)_""","
		 	}
		 	
		 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		 	s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""","
			s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		 	s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 	s json = json_"""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""","
		 	s json = json_"""PAAdmBedNO"":"""_$g(result.Data("PAAdmBedNO"))_""","
		 	s json = json_"""TransStartDate"":"""_$g(result.Data("TransStartDate"))_""","
		 	s json = json_"""TransStartTime"":"""_$g(result.Data("TransStartTime"))_""","
		 	s json = json_"""TransURL"":"""_$g(result.Data("TransURL"))_""","
		 	s json = json_"""TransBedNO"":"""_$g(result.Data("TransBedNO"))_"""}"
		 	s json = json_"," 
		 }
		 s count = count + 1
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

/// Desc:	获取本人当天手术患者列表JSON串;
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// 		AStartDate开始日期
/// 		AEndDate结束日期
/// Return:	本人当天手术患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EMRservice.Ajax.patientInfo).GetOperationPatListJSON("6","105","1","10","2015-02-01","2015-02-10")
ClassMethod GetOperationPatListJSON(ALocID As %String, AUserID As %String, ARadioValue As %String, AIdxStart As %Integer, AIdxLast As %Integer, AStartDate As %String, AEndDate As %String)
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	//s ^tempncc("0") = ALocID_"^"_AUserID_"^"_AIdxStart_"^"_AIdxLast_"^"_AStartDate_"^"_AEndDate
	if (AStartDate = "")||(AEndDate = "")
	{
		s Systemdatetime = $HOROLOG
		s Systemdateint = $p(Systemdatetime,",",1)
		s Systemtimeint = $p(Systemdatetime,",",2)
		s StartDate = Systemdateint
		s EndDate = Systemdateint
	}
	else
	{
		s StartDate = AStartDate
		s EndDate = AEndDate
	}
	
	s result = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetOperationPatList")
	s sc = result.Execute(ALocID,AUserID,ARadioValue,StartDate,EndDate)
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		 	
		 	s patientID = $g(result.Data("PatientID"))
		 	if (HasPatEncryptLevel = "Y")
		 	{
			 	s ResultStr = ..GetPatEncryptLevel(patientID)
			 	s json = json_"""SecAlias"":"""_$p(ResultStr,"^",1)_""","
				s json = json_"""EmployeeFunction"":"""_$p(ResultStr,"^",2)_""","
		 	}
		 	
		 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		 	s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""","
			s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		 	s json = json_"""PAAdmBedNO"":"""_$g(result.Data("PAAdmBedNO"))_""","
		 	s json = json_"""opdes"":"""_$g(result.Data("opdes"))_""","
		 	s json = json_"""OPCategory"":"""_$g(result.Data("OPCategory"))_""","
		 	s json = json_"""opdatestr"":"""_$g(result.Data("opdatestr"))_""","
		 	s json = json_"""PreOPConferURL"":"""_$g(result.Data("PreOPConferURL"))_""","
		 	s json = json_"""OPRecordURL"":"""_$g(result.Data("OPRecordURL"))_""","
		 	s json = json_"""AfterOPFirstURL"":"""_$g(result.Data("AfterOPFirstURL"))_"""}"
		 	s json = json_"," 
		 }
		 s count = count + 1
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

/// Desc:	获取本病区在院危重患者列表JSON串;
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// 		AStartDate开始日期
/// 		AEndDate结束日期
/// Return:	本病区在院危重患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EMRservice.Ajax.patientInfo).GetCriticallyPatListJSON("6","105","1","10","2015-02-01","2015-02-10")
ClassMethod GetCriticallyPatListJSON(ALocID As %String, AUserID As %String, AIdxStart As %Integer, AIdxLast As %Integer, AStartDate As %String, AEndDate As %String)
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	if (AStartDate = "")||(AEndDate = "")
	{
		s StartDate = ""
		s EndDate = ""
	}
	else
	{
		s StartDate = AStartDate
		s EndDate = AEndDate
	}
	
	s result = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetCriticallyPatList")
	s sc = result.Execute(ALocID,AUserID,StartDate,EndDate)
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		 	
		 	s patientID = $g(result.Data("PatientID"))
		 	if (HasPatEncryptLevel = "Y")
		 	{
			 	s ResultStr = ..GetPatEncryptLevel(patientID)
			 	s json = json_"""SecAlias"":"""_$p(ResultStr,"^",1)_""","
				s json = json_"""EmployeeFunction"":"""_$p(ResultStr,"^",2)_""","
		 	}
		 	
		 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		 	s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""","
			s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		 	s json = json_"""PAAdmBedNO"":"""_$g(result.Data("PAAdmBedNO"))_""","
		 	s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 	s json = json_"""HeadUniteDoc"":"""_$g(result.Data("HeadUniteDoc"))_""","
		 	s json = json_"""ChiefDoc"":"""_$g(result.Data("ChiefDoc"))_""","
		 	s json = json_"""CareClass"":"""_$g(result.Data("CareClass"))_""","
		 	s json = json_"""Vitalsigns"":"""_$g(result.Data("Vitalsigns"))_""","
		 	s json = json_"""Diagnosis"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(result.Data("Diagnosis")))_"""}"
		 	s json = json_"," 
		 }
		 s count = count + 1
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

/// Desc:	获取患者列表JSON串;
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		APatientNo为患者登记号;
/// 		APatientName为患者姓名;
/// 		AStartDate为就诊开始日期;
/// 		AEndDate为就诊截止日期;
/// 		AIsArrivedQue为是否本科患者;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// Return:	患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EMRservice.Ajax.PatientInfo).GetEPREpisodeListJSON("","","0000000025","","","","on","1","10")
ClassMethod GetEPREpisodeListJSON(ALocID As %String, AUserID As %String, APatientNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String, AIsArrivedQue As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	s result = ##Class(%ResultSet).%New("web.DHCDocInPatientList:FindLocDocCurrentAdm")
	//LocID(Session获取),UserID(Session获取),IPAddress,AllPatient(全病区病人),PatientNo(病人号码),SurName(病人姓名),StartDate,EndDate,ArrivedQue(本科病人),RegQue
 	s sc = result.Execute(ALocID,AUserID,"","",APatientNo,APatientName,AStartDate,AEndDate,AIsArrivedQue,"")
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		 	
		 	s patientID = $g(result.Data("PatientID"))
		 	if (HasPatEncryptLevel = "Y")
		 	{
			 	s ResultStr = ..GetPatEncryptLevel(patientID)
			 	s json = json_"""SecAlias"":"""_$p(ResultStr,"^",1)_""","
				s json = json_"""EmployeeFunction"":"""_$p(ResultStr,"^",2)_""","
		 	}
		 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		 	s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""PAAdmDate"":"""_$g(result.Data("PAAdmDate"))_""","
		 	s json = json_"""PAAdmTime"":"""_$g(result.Data("PAAdmTime"))_""","
		 	s json = json_"""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""","
		 	s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 	s json = json_"""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""","
		 	s json = json_"""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""","
		 	s json = json_"""PAAdmReason"":"""_$g(result.Data("PAAdmReason"))_""","
		 	s json = json_"""Diagnosis"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(result.Data("Diagnosis")))_"""}"
		 	s json = json_"," 
		 }
		 s count = count + 1
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

/// CreatDate:2014-2-16
/// Desc:	取病人基本信息,
/// 		若EpisodeID信息不为空，取病人信息+就诊信息，
/// 		若EpisodeID为空，取病人信息
/// Table:
/// Input:	patientID As %String, episodeID As %String
/// Output:
/// Return:	格式为Json的病人基本信息字符串
/// Others:	病历浏览页面上病人基本信息加载
/// debug: w ##Class(EMRservice.Ajax.patientInfo).GetPatientInfoInBrowser(48,76)
ClassMethod GetPatientInfoInBrowser(patientID As %String, episodeID As %String) As %String
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	s patientInfo = ""
	
	s papmiNo = ""		//登记号
	s name = ""			//姓名
	s age = ""			//年龄
	s gender = ""		//性别
	s disBed = ""		//出院床位
	s payType = ""		//付费类型
	s admDate = ""		//入院日期
	s mainDiagnos = ""	//主要诊断
	s ipRecordNo = "" 	//病案号
	s inTimes = "" 		//入院次数
	s doctor = "" 	        //经治医生
	//取就诊信息
	if (episodeID '= "")&&(episodeID '= $C(0))
	{
		//取患者指针
		s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
		
		//年龄
		s birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientID)
		s HISFormatBirthDay=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",birthday)
		s admDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID, "")
		s admDate = $P(admDate, ",", 1)
		s age = ##class(web.DHCBillInterface).GetPapmiAge(patientID,episodeID,"","")
		
		//出院床位
		s disBed = ##class(EMRservice.HISInterface.PatientInfoAssist).DisBed(episodeID)
		
		//付费类型
		s payType =  ##class(EMRservice.HISInterface.PatientInfoAssist).PayType(episodeID)
		
		//入院日期
		s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
		s admDate = $P(admDateTime, ",", 1)
		if (admDate '= "") s admDate = $zd(admDate,3)
		s HISFormatAdmDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",admDate)
		//主要诊断
		s mainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
		if (mainDiagnos = "")
        {
	        s mainDiagnos = ..getOPdiagnosis(episodeID)
	    }
		if (mainDiagnos '= "")
		{	
			s mainDiagnos = $P(mainDiagnos,"^",3)
			s mainDiagnos = $tr(mainDiagnos,"'","\'")
		}
		
		s hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName(episodeID)
		s ipRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(episodeID, hospital)
		
		s mCurrRow = $g(^PAADM(episodeID))
		s PAADMDocCode=$p($g(mCurrRow),"^",9)
	
		if (PAADMDocCode '= "")
		{
			s doctor = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
		}
		else
		{
			s doctor = "无"
		}
	}
	
	s dept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID,hospital)
	s dept = $p(dept,"^",3)		
	//用patientID取病人信息
	if (patientID '= "")&&(patientID '= $C(0))
	{
		//登记号
		s papmiNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
		
		//姓名
		s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientID)
		
		//性别
		s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientID, "")
		s gender = $P(gender, "^", 3)
		s inTimes= ##class(EMRservice.HISInterface.PatientInfoAssist).InTimes(episodeID)
		

		if (HasPatEncryptLevel = "Y")
		{
			//病人密级和病人级别
			//SecAlias_"^"_EmployeeFunction_"^"_SecCode_"^"_SecDesc
			//密级特殊字符^病人级别^密级代码^密级描述 或 空
			s PatEncryptLevelStr = ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patientID)
			s SecAlias = $P(PatEncryptLevelStr, "^",1)
			s EmployeeFunction = $P(PatEncryptLevelStr, "^",2)
			s SecCode = $P(PatEncryptLevelStr, "^",3)
			s SecDesc = $P(PatEncryptLevelStr, "^",4)
		
			//s SecAlias = "1"
			//s EmployeeFunction = "2"
			//s SecCode = "3"
			//s SecDesc = "4"
		}
		else
		{
			s SecAlias = ""
			s EmployeeFunction = ""
			s SecCode = ""
			s SecDesc = ""
		}
	}
		
	s patientInfo = "papmiNo:'"_papmiNo_"',name:'"_name_"',gender:'"_gender_"',disBed:'"_disBed_"',age:'"_age_"',mainDiagnos:'"_mainDiagnos_"',payType:'"_payType_"',admDate:'"_HISFormatAdmDate_"',ipRecordNo:'"_$g(ipRecordNo)_"',birthday:'"_HISFormatBirthDay_"',dept:'"_dept_"',SecAlias:'"_SecAlias_"',EmployeeFunction:'"_EmployeeFunction_"',SecCode:'"_SecCode_"',SecDesc:'"_SecDesc_"',doctor:'"_doctor_"',inTimes:'"_inTimes_"'"
	//转换特殊字符
	s patientInfo = $ZSTRIP(patientInfo,"*C")
	
	q "[{"_patientInfo_"}]"
}

/// 根据patientID获取病人级别等信息
ClassMethod GetPatEncryptLevel(patientID As %String)
{
	//病人密级和病人级别
	//SecAlias_"^"_EmployeeFunction_"^"_SecCode_"^"_SecDesc
	//密级特殊字符^病人级别^密级代码^密级描述 或 空
	
	s PatEncryptLevelStr = ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patientID)
	s SecAlias = $P(PatEncryptLevelStr, "^",1)
	s EmployeeFunction = $P(PatEncryptLevelStr, "^",2)
	s SecCode = $P(PatEncryptLevelStr, "^",3)
	s SecDesc = $P(PatEncryptLevelStr, "^",4)

	//s SecAlias = "1"
	//s EmployeeFunction = "2"
	//s SecCode = "3"
	//s SecDesc = "4"
	
	q SecAlias_"^"_EmployeeFunction_"^"_SecCode_"^"_SecDesc
}

/// w ##Class(EMRservice.Ajax.patientInfo).GetPatientInfo()
ClassMethod GetPatientInfo(patientID As %String, episodeID As %String) As %String
{
	s patientInfo = ""
	s papmiNo = ""		//登记号
	s name = ""			//姓名
	s age = ""			//年龄
	s gender = ""		//性别
	s disBed = ""		//出院床位
	s payType = ""		//付费类型
	s admDate = ""		//入院日期
	s mainDiagnos = ""	//主要诊断
	s ipRecordNo = "" 	//病案号
	
	//取就诊信息
	if (episodeID '= "")&&(episodeID '= $C(0))
	{
		//取患者指针
		s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
		
		//年龄
		s birthday = ##class(EMRservice.HISInterface.PatientInfoAssist).Birthday(patientID)
		s HISFormatBirthDay=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",birthday)
		s admDate = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID, "")
		s admDate = $P(admDate, ",", 1)
		//s age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(episodeID,birthday,admDate,4)
		//s age = ##class(EMRservice.HISInterface.PatientInfoAssist).Age(episodeID,birthday,admDate,4)
		//调用年龄统一接口 [Age]
   		s age=##class(EMRservice.HISInterface.PatientInfoAssist).Age(patientID,episodeID,"","")
		
		
		//出院床位
		s disBed = ##class(EMRservice.HISInterface.PatientInfoAssist).DisBed(episodeID)
		
		//付费类型
		s payType =  ##class(EMRservice.HISInterface.PatientInfoAssist).PayType(episodeID)
		
		//入院日期
		s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
		s admDate = $P(admDateTime, ",", 1)
		if (admDate '= "") s admDate = $zd(admDate,3)
		s HISFormatAdmDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",admDate)
		//主要诊断
		s mainDiagnos = ##class(EMRservice.HISInterface.PatientInfoAssist).DiagnosInfo(episodeID)
		if (mainDiagnos '= "")
		{	
			s mainDiagnos = $P(mainDiagnos,"^",3)
			s mainDiagnos = $tr(mainDiagnos,"'","\'")
		}
		
		s hospital = ##class(EMRservice.HISInterface.PatientInfoAssist).HospitalName()
		s ipRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(episodeID, hospital)
	}
	
	s dept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID,hospital)
	s dept = $p(dept,"^",3)		
	//用patientID取病人信息
	if (patientID '= "")&&(patientID '= $C(0))
	{
		//登记号
		s papmiNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
		
		//姓名
		s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientID)
		
		//性别
		s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientID, "")
		s gender = $P(gender, "^", 3)
	}
		
	s patientInfo = """papmiNo"":"""_papmiNo_""",""name"":"""_name_""",""gender"":"""_gender_""",""disBed"":"""_disBed_""",""age"":"""_age_""",""mainDiagnos"":"""_mainDiagnos_""",""payType"":"""_payType_""",""admDate"":"""_HISFormatAdmDate_""",""ipRecordNo"":"""_$g(ipRecordNo)_""",""birthday"":"""_HISFormatBirthDay_""",""dept"":"""_dept_""""
	//转换特殊字符
	s patientInfo = $ZSTRIP(patientInfo,"*C")
	q "{"_patientInfo_"}"
}

/// Desc: 为门诊病历中的就诊历史获取信息，返回JSON
/// W ##Class(EMRservice.Ajax.patientInfo).GetAdmHistoryLstForOP("5438262")
ClassMethod GetAdmHistoryLstForOP(argPatientID As %String) As %String
{
	s count=0
	s result=""
 
 	s admType = ""
 	for {
	 	q:(count=20)
 		s admType = $O(^PAPERdr(argPatientID,"ADM",admType))
 		q:(admType="")

 		s admID = ""
 		for {
	 		q:(count=20)
	 		s admID = $O(^PAPERdr(argPatientID,"ADM",admType,admID),-1)
	 		q:(admID="")
	 		s admDate = $P($G(^PAADM(admID)),"^",6)
	 		s admTime = $P($G(^PAADM(admID)),"^",7)
	 		s curDept = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(admID)
	 		s curDept = $P(curDept,"^",3)
	 		s diagnosis = ##class(EPRservice.HISInterface.PatientInfoAssist).DiagnosInfo(admID)
	 		s diagnosis = $P(diagnosis,"^",3)
	 		s doc=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(admID,"")
	 		s doc = $P($G(doc),"^",3)	 		
	 		//w admID_" "_admType_" "_admDate_" "_admTime_" "_curDept_" "_diagnosis,!
	 		s item = "{""EpisodeID"":"""_admID_""","
	 		s item = item_"""PAPMINO"":"""","
	 		s item = item_"""PAAdmType"":"""_admType_""","
	 		s item = item_"""PAAdmDate"":"""_$zd(admDate,3)_"""," 
	 		s item = item_"""PAAdmTime"":"""_$zt(admTime,1)_""","
	 		s item = item_"""PAAdmDep"":"""_curDept_""","
			s item = item_"""Diagnosis"":"""_diagnosis_""","
			s item = item_"""Doc"":"""_doc_"""}"
            //w item,!
            if (result="") { s result= item }
            else { s result = result_","_item }
            s count=count+1
 		}
 	}
 	
 	q "{""total"":"_count_",""rows"":["_result_"]}"
}

ClassMethod getOPdiagnosis(argAdmId As %String) As %String
{
	q:(argAdmId="") ""
	
	s retDiagnos = ""
	s diagnosID = ""
	
	//门诊诊断
	s disDiagTypeID = $O(^MRC("DTYP",0,"Code","OP",""))  
	if (disDiagTypeID '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, disDiagTypeID)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	q retDiagnos
}

/// Desc:	取指定类型的诊断ID
ClassMethod GetTypedDiagnosID(argEpisodeID As %String, argMRCDiagnosTypeID As %String) As %String
{
	q:(argMRCDiagnosTypeID = "") ""
	
	s ret = ""
	
	s mrAdmDR = $p($g(^PAADM(argEpisodeID)),"^",61)
	q:(mrAdmDR = "") ""
	
	s mrcDiagnosTypeIDString = "^"_argMRCDiagnosTypeID_"^"
	
	s mrDiaChildsub = "0"
	for {
		s mrDiaChildsub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub))
		q:(mrDiaChildsub="")
		
		s typeChildSub = 0
		for {
			s typeChildSub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub))
			q:(typeChildSub = "")
			
			s mrcDiagTypID = $p($g(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub)),"^",1)
			continue:(mrcDiagTypID = "")
			
			//判断是否为待选诊断类型
			continue:('$f(mrcDiagnosTypeIDString, "^"_mrcDiagTypID_"^"))
			
			s mrDiagnosID = mrAdmDR_"||"_mrDiaChildsub
			if ret = ""
			{	s ret = mrDiagnosID}
			else
			{	s ret = ret_"^"_mrDiagnosID}	
		}
	}
	q ret
}

/// 	Desc:	取诊断信息
/// 	Input:	argMRDiagnosID : MR_Adm.MRADM_RowId||MR_Diagnos.MRDIA_Childsub
/// 	Return：RowId^诊断代码^诊断描述(诊断备注)
ClassMethod GetDiagnosWithNote(argMRDiagnosID) As %String
{
	s mrAdmID = $P(argMRDiagnosID, "||", 1)
	s mrDiaChildSub = $P(argMRDiagnosID, "||", 2)
	q:(mrAdmID = "")||(mrDiaChildSub = "") ""
	
	s icdid = $p($g(^MR(mrAdmID,"DIA",mrDiaChildSub)),"^",1)
	q:(icdid = "") ""
	
	s icdCode = $p($g(^MRC("ID",icdid)),"^",4)
	s icdDesc = $p($g(^MRC("ID",icdid)),"^",2)
	
	s diagNote=$g(^MR(mrAdmID,"DIA",mrDiaChildSub,"DES",1))
	if (diagNote '= "") 
	{	s icdDesc = icdDesc_"("_diagNote_")"}	
	
	q icdid_"^"_icdCode_"^"_icdDesc
}

/// Desc:       患者列表增加搜索界面
/// Creator:    candy
/// CreateDate: 2015-10-29
ClassMethod GetAdmList()
{
	s patientNo = $Get(%request.Data("PatientNo",1),"")
	s medicareNo = $Get(%request.Data("MedicareNo",1),"")
	s medicalInsuranceNo = $Get(%request.Data("MedicalInsuranceNo",1),"")
	s cfCardNo = $Get(%request.Data("CFCardNo",1),"")
	s idCardNo = $Get(%request.Data("IDCardNo",1),"")
	s patientName = $Get(%request.Data("PatientName",1),"")
	s admType = $Get(%request.Data("AdmType",1),"")
	s admStatus = $Get(%request.Data("AdmStatus",1),"")
	s startDate = $Get(%request.Data("StartDate",1),"")
	s endDate = $Get(%request.Data("EndDate",1),"")
	s outStartDate = $Get(%request.Data("OutStartDate",1),"")
	s outEndDate = $Get(%request.Data("OutEndDate",1),"")
	s isArrivedQue = $Get(%request.Data("IsArrivedQue",1),"")
	s expectedLocId = $Get(%request.Data("ExpectedLocID",1),"")
	s expectedUserId = $Get(%request.Data("ExpectedUserID",1),"")
	s MRN = $Get(%request.Data("MRN",1),"")
	s queryItem = $Get(%request.Data("QueryItem",1),"")
    s wardId = $Get(%request.Data("WardId",1),"")
    s Illness = $Get(%request.Data("Illness",1),"")
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	
	s locID = $g(%session.Data("LOGON.CTLOCID"))
	s userID = $g(%session.Data("LOGON.USERID"))
	//兼容病区ID
	if (locID'="") {
		s CTLOCType = $p($g(^CTLOC(locID)),"^",13)
		
		if (CTLOCType="W") {
			//如果是病区,则默认转第1个科室ID
			s locID = ##class(EMRservice.HISInterface.PatientInfoAssist).CurDeptLinkLocByDept(locID)
			s locID = $p(locID,"^",3)
		}
	}
	d ..GetAdmListJSON(locID,isArrivedQue,patientNo,medicareNo,startDate,endDate,patientName,cfCardNo,admType,idCardNo,expectedLocId,admStatus,medicalInsuranceNo,idxStart,idxLast,outStartDate,outEndDate,expectedUserId,MRN,queryItem,wardId,Illness)
}

/// Desc:	获取患者列表JSON串;
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		APatientNo为患者登记号;
/// 		APatientName为患者姓名;
/// 		AdmType为患者就诊类型;
/// 		AStartDate为就诊开始日期;
/// 		AEndDate为就诊截止日期;
/// 		AIsArrivedQue为是否本科患者;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
///         ADiagnosis为诊断内容;
/// Return:	患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	d ##Class(EMRservice.Ajax.patientInfo).GetAdmListJSON("95","off","","","2020-01-08","2020-01-10","","","","","95","all","","1","10","","","10209","","")
/// Debug:	d ##Class(EMRservice.Ajax.patientInfo).GetAdmListJSON("95","off","","","","","","","","","95","A","",1,10,"","","","","",3)
ClassMethod GetAdmListJSON(ALocID As %String, AIsArrivedQue As %String, APatientNo As %String, AMedicareNo As %String, AStartDate As %String, AEndDate As %String, APatientName As %String, ACFCardNo As %String, AdmType As %String, AIDCardNo As %String, AexpectedLocID As %String, AdmStatus As %String, AMedicalInsuranceNo As %String, AIdxStart As %Integer, AIdxLast As %Integer, AOutStartDate As %String, AOutEndDate As %String, AexpectedUserID As %String, AMRN As %String, ADiagnosis As %String, AWardId As %String = "", Illness As %String = "")
{
	s repid = $I(^CacheTemp)
	//s ^Temp("duan","GetAdmListJSON")=ALocID_","_AIsArrivedQue_","_APatientNo_","_AMedicareNo_","_AStartDate_","_AEndDate_","_APatientName_","_ACFCardNo_","_AdmType_","_AIDCardNo_","_AexpectedLocID_","_AdmStatus_","_AMedicalInsuranceNo_","_AIdxStart_","_AIdxLast_","_AOutStartDate_","_AOutEndDate _","_ AexpectedUserID _","_ AMRN _","_ ADiagnosis_","_AWardId
	s result = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetPaAdmList")
	s param = ALocID_","_AIsArrivedQue_","_APatientNo_","_AMedicareNo_","_AStartDate_","_AEndDate_","_APatientName_","_ACFCardNo_","_AdmType_","_AIDCardNo_","_AexpectedLocID_","_AdmStatus_","_AMedicalInsuranceNo_","_AOutStartDate_","_AOutEndDate_","_AWardId_","_AexpectedUserID_","_AMRN_","_ADiagnosis_",,"_Illness

 	s sc = result.Execute(param)
 	s openSortByPAADMBedNO=##class(EMRservice.SystemParameter).openSortByPAADMBedNO()
 	s json = ""
 	s count = 0
 	s isFirstRecord = 1

	While (result.Next())
 	{
	 	if (openSortByPAADMBedNO="Y")
	 	{
		 	//按床号排序
	 		d ..bedSort(repid,result)
	 		
		}else{
	 		if ((AIdxStart-1)<= count) && (AIdxLast > count )
			{
				if (isFirstRecord = 0) { s json = json_"," }
		 		s json = json_"{""PatientID"":"""_$g(result.Data("PAPMIDR"))_""","
		 		s json = json_"""EpisodeID"":"""_$g(result.Data("PAADMRowID"))_""","
		 		s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		 		s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","
		 		s json = json_"""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""","
		 		s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 		s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		 		s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 		s json = json_"""PAAdmDate"":"""_$g(result.Data("PAAdmDate"))_""","
		 		s json = json_"""PAAdmTime"":"""_$g(result.Data("PAAdmTime"))_""","
		 		s json = json_"""PAAdmAdmDate"":"""_$g(result.Data("PAAdmAdmDate"))_""","
		 		s json = json_"""PAAdmAdmTime"":"""_$g(result.Data("PAAdmAdmTime"))_""","
		 		s json = json_"""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""","
		 		s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 		s json = json_"""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""","
		 		s json = json_"""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""","
		 		s json = json_"""PAAdmReason"":"""_$g(result.Data("PAADMReason"))_""","
		 		s json = json_"""PAADMBedNO"":"""_$g(result.Data("PAADMBedNO"))_""","
		 		s json = json_"""PADischgeDate"":"""_$g(result.Data("PADischgeDate"))_""","
		 		s json = json_"""PADischgeTime"":"""_$g(result.Data("PADischgeTime"))_""","
		 		s json = json_"""IDCardNO"":"""_$g(result.Data("IDCard"))_""","
		 		s json = json_"""CFCardNO"":"""_$g(result.Data("CFCardNo"))_""","
		 		s json = json_"""Warddesc"":"""_$g(result.Data("Warddesc"))_""","
		 		s json = json_"""Diagnosis"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape($g(result.Data("Diagnosis")))_""","
		 		s json = json_"""PatIllness"":"""_$g(result.Data("PatIllness"))_"""}"
		 		s isFirstRecord = 0
			}
			s count = count + 1	
		}
	}
	if (openSortByPAADMBedNO="Y")
 	{
	 	s PAADMBedNOSort=""
	 		for
	 		{
		 		s PAADMBedNOSort=$O(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort))
		 		q:PAADMBedNOSort=""
		 		s PAADMBedNO =""
		 		for
		 		{
			 		s PAADMBedNO=$O(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO))
			 		q:PAADMBedNO=""
			 		s EpisodeID=""
			 		for{
				 		s EpisodeID = $O(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID))
				 		q:EpisodeID=""
				 		if ((AIdxStart-1)<= count) && (AIdxLast > count )
						{
				 			if (isFirstRecord = 0) { s json = json_"," }
				 			s PAPMIDR = $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",1)
		 					s json = json_"{""PatientID"":"""_PAPMIDR_""","
		 					s json = json_"""EpisodeID"":"""_EpisodeID_""","
		 					s mradm = $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",3)
		 					s json = json_"""mradm"":"""_mradm_""","
		 					s json = json_"""PAADMBedNO"":"""_PAADMBedNO_""","
		 					s MedicareNo= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",5)
		 					s json = json_"""MedicareNo"":"""_MedicareNo_""","
		 					s PAPMIName= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",6)
		 					s json = json_"""PAPMIName"":"""_PAPMIName_""","
		 					s PAPMIDOB= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",7)
		 					s json = json_"""PAPMIDOB"":"""_PAPMIDOB_""","
		 					s PAPMISex= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",8)
		 					s json = json_"""PAPMISex"":"""_PAPMISex_""","
		 					s PAAdmDate= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",9)
		 					s PAAdmTime= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",10)
		 					s json = json_"""PAAdmDate"":"""_PAAdmDate_""","
		 					s json = json_"""PAAdmTime"":"""_PAAdmTime_""","
		 					s PAAdmAdmDate= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",11)
		 					s PAAdmAdmTime= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",12)
		 					s json = json_"""PAAdmAdmDate"":"""_PAAdmAdmDate_""","
		 					s json = json_"""PAAdmAdmTime"":"""_PAAdmAdmTime_""","
		 					s PAAdmDepCodeDR= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",13)
		 					s PAAdmDocCodeDR= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",14)
		 					s json = json_"""PAAdmDepCodeDR"":"""_PAAdmDepCodeDR_""","
		 					s json = json_"""PAAdmDocCodeDR"":"""_PAAdmDocCodeDR_""","
		 					s PAAdmType= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",15)
		 					s json = json_"""PAAdmType"":"""_PAAdmType_""","
		 					s PAAdmWard= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",16)
		 					s json = json_"""PAAdmWard"":"""_PAAdmWard_""","
		 					s PAADMReason= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",17)
		 					s json = json_"""PAAdmReason"":"""_PAADMReason_""","
		 					s PAPMINO= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",4)
		 					s json = json_"""PAPMINO"":"""_PAPMINO_""","
		 					s PADischgeDate= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",19)
		 					s PADischgeTime= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",20)
		 					s json = json_"""PADischgeDate"":"""_PADischgeDate_""","
		 					s json = json_"""PADischgeTime"":"""_PADischgeTime_""","
		 					s IDCard= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",21)
		 					s CFCardNo= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",22)
		 					s json = json_"""IDCardNO"":"""_IDCard_""","
		 					s json = json_"""CFCardNO"":"""_CFCardNo_""","	
		 					s Warddesc = $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",23)
		 					s json = json_"""Warddesc"":"""_Warddesc_""","
		 					s Diagnosis= $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",24)
		 					s json = json_"""Diagnosis"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(Diagnosis)_""","
		 					s PatIllness = $p($G(^CacheTemp("PAADMBedNO",repid,PAADMBedNOSort,PAADMBedNO,EpisodeID)),"^",25)
		 					s json = json_"""PatIllness"":"""_PatIllness_"""}"
		 					
		 					s isFirstRecord = 0
		    			}
		    			s count = count+1 
				 	}
			 	}
		 	}
	 } 
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	k ^CacheTemp("PAADMBedNO",repid)
	w ret
}

/// desc 病历浏览患者列表 根据床号重新排序
/// create duan
/// input ARepid 唯一标识 result 患者信息stream
/// output 无
ClassMethod bedSort(ARepid As %String, result As %Stream)
{
	q:result=""
	s PAADMBedNO = $g(result.Data("PAADMBedNO"))
	s EpisodeID = $g(result.Data("PAADMRowID"))
	s PAADMBedNOFlag = +PAADMBedNO
	if (PAADMBedNOFlag){
		s PAADMBedNOSort = PAADMBedNOFlag
	}else{
		s PAADMBedNOSort = PAADMBedNO
	}
	s ^CacheTemp("PAADMBedNO",ARepid,PAADMBedNOSort,PAADMBedNO,EpisodeID)=$g(result.Data("PAPMIDR"))_"^"_$g(result.Data("PAADMRowID"))_"^"_$g(result.Data("mradm"))_"^"_$g(result.Data("PAPMINO"))_"^"_$g(result.Data("MedicareNo"))_"^"_$g(result.Data("PAPMIName"))_"^"_$g(result.Data("PAPMIDOB"))_"^"_$g(result.Data("PAPMISex"))_"^"_$g(result.Data("PAAdmDate"))_"^"_$g(result.Data("PAAdmTime"))_"^"_$g(result.Data("PAAdmAdmDate"))_"^"_$g(result.Data("PAAdmAdmTime"))_"^"_$g(result.Data("PAAdmDepCodeDR"))_"^"_$g(result.Data("PAAdmDocCodeDR"))_"^"_$g(result.Data("PAAdmType"))_"^"_$g(result.Data("PAAdmWard"))_"^"_$g(result.Data("PAADMReason"))_"^"_$g(result.Data("PAADMBedNO"))_"^"_$g(result.Data("PADischgeDate"))_"^"_$g(result.Data("PADischgeTime"))_"^"_$g(result.Data("IDCard"))_"^"_$g(result.Data("CFCardNo"))_"^"_$g(result.Data("Warddesc"))_"^"_$g(result.Data("Diagnosis"))_"^"_$g(result.Data("PatIllness"))
}

/// w ##Class(EMRservice.Ajax.patientInfo).GetOPatient(5,3111)
/// 门诊页面使用的门诊患者列表
ClassMethod GetOPatient(LocID, UserID) As %String
{
	
	s IPAddress=""  //$$upper^SSUTIL4(%request.GetCgiEnv("REMOTE_ADDR"))
	s AllPatient="on",PatientNo="",SurName="",ArrivedQue="",AIdxStart="",AIdxLast=""
    s StartDate=$P($h,",") // today
    s EndDate=$P($h,",")
    s RegQue=""
    s Consultation="AllPatient"
	s result = ##Class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
 	s sc = result.Execute(LocID,UserID,IPAddress,AllPatient,PatientNo,SurName,StartDate,EndDate,ArrivedQue,RegQue,Consultation)
 	
 	s json = ""
 	s count = 0

	While (result.Next())
 	{
	 	s:(json'="") json = json_","
	 	
		s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","	  
		s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		s json = json_"""PAAdmReason"":"""_$g(result.Data("PAAdmReason"))_"""}"
		s isFirstRecord = 0
	 
		s count = count + 1	
	}
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

/// Desc:依据科室ID获取用户Code、用户Name
/// w ##Class(EMRservice.Ajax.patientInfo).GetUserName(6)
ClassMethod GetUserName(ALocID As %String, ADictCode As %String = "S07")
{
	
	if ADictCode="S10"
	{
		s ALocID = $p($g(^PAWARD(ALocID)),"^",5)
	}
	//增加“全部”选项，支持查询所有主管医生的患者
	s json = "{"
	s json = json_"""UserID"":"""","
	s json = json_"""UserCode"":"""","
	s json = json_"""UserDesc"":"""_"全部医师"_""""
	s json = json_"}"
	s count = 0
	//s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetUserDataList")
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetUserDataList")
	d ds.Execute("",ALocID)
	While (ds.Next())
	{
		if (ds.Data("UserID")'=""){
			//s:(count '=0) json =json_","
			s json =json_","
			s json = json_"{"
			s json = json_"""UserID"":"""_ds.Data("UserID")_""","
			s json = json_"""UserCode"":"""_ds.Data("UserCode")_""","
			s json = json_"""UserDesc"":"""_ds.Data("UserDesc")_""""
	    	s json = json_"}"
			s count = count + 1
		}
	}
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// d ##Class(EMRservice.Ajax.patientInfo).GetAdmRecordList()
ClassMethod GetAdmRecordList()
{
	s docId = $Get(%request.Data("DocID",1),"")
	s glossaryCode = $Get(%request.Data("GlossaryCode",1),"")
	s signStatus = $Get(%request.Data("SignStatus",1),"")
	s patientNo = $Get(%request.Data("PatientNo",1),"")
	s medicareNo = $Get(%request.Data("MedicareNo",1),"")
	s medicalInsuranceNo = $Get(%request.Data("MedicalInsuranceNo",1),"")
	s cfCardNo = $Get(%request.Data("CFCardNo",1),"")
	s idCardNo = $Get(%request.Data("IDCardNo",1),"")
	s patientName = $Get(%request.Data("PatientName",1),"")
	s admType = $Get(%request.Data("AdmType",1),"")
	s admStatus = $Get(%request.Data("AdmStatus",1),"")
	s startDate = $Get(%request.Data("StartDate",1),"")
	s endDate = $Get(%request.Data("EndDate",1),"")
	s outStartDate = $Get(%request.Data("OutStartDate",1),"")
	s outEndDate = $Get(%request.Data("OutEndDate",1),"")
	s isArrivedQue =  $Get(%request.Data("IsArrivedQue",1),"")
	s expectedLocId = $Get(%request.Data("ExpectedLocID",1),"")
	s wardId = $Get(%request.Data("WardID",1),"")
	s locID = $Get(%request.Data("LocID",1),"")
	s userID = $Get(%request.Data("UserID",1),"")	
	s nurUserID = $Get(%request.Data("NurUserID",1),"")
	s:wardId'="" wardId = $o(^PAWARD(0,"WARD_LocationDR",wardId,""))
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	//s ^tempCandy = docId_","_glossaryCode_","_locID_","_isArrivedQue_","_patientNo_","_medicareNo_","_startDate_","_endDate_","_patientName_","_cfCardNo_","_admType_","_idCardNo_","_expectedLocId_","_admStatus_","_medicalInsuranceNo_","_outStartDate_","_outEndDate_","_wardId_","_userID
	s result = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetPaAdmList")
	s param = locID_","_isArrivedQue_","_patientNo_","_medicareNo_","_startDate_","_endDate_","_patientName_","_cfCardNo_","_admType_","_idCardNo_","_expectedLocId_","_admStatus_","_medicalInsuranceNo_","_outStartDate_","_outEndDate_","_wardId_","_userID_",,,"_nurUserID_","
 	s sc = result.Execute(param)
	//s sc = result.Execute("146","off","","","","","","","I","","146","A","","","","","")
 	s json = ""
 	s count = 0
 	s isFirstRecord = 1

	While (result.Next())
 	{
		s episodeId = $g(result.Data("PAADMRowID"))
		s record = ##Class(EMRservice.BL.BLRecordQuery).GetRecordSignStatus(episodeId,docId,glossaryCode)
	 	continue:(record = "")
	 	s tmpSignStatus = $p(record,"^",6)
	 	continue:((signStatus = "unsign")&&(tmpSignStatus = 1))
	 	continue:((signStatus = "sign")&&(tmpSignStatus = 0))			
	 	if ((idxStart-1)<= count) && (idxLast > count )
		{
			if (isFirstRecord = 0) { s json = json_"," }
		 	s json = json_"{""PatientID"":"""_$g(result.Data("PAPMIDR"))_""","
		 	s json = json_"""EpisodeID"":"""_episodeId_""","
		 	s json = json_"""mradm"":"""_$g(result.Data("mradm"))_""","
		 	s json = json_"""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""","
		 	s json = json_"""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""PAPMIDOB"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$g(result.Data("PAPMIDOB")))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""PAAdmDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$g(result.Data("PAAdmDate")))_""","
		 	s json = json_"""PAAdmTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$g(result.Data("PAAdmTime")))_""","
		 	s json = json_"""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""","
		 	s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 	s json = json_"""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""","
		 	s json = json_"""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""","
		 	s json = json_"""PAAdmReason"":"""_$g(result.Data("PAADMReason"))_""","
		 	s json = json_"""PAADMBedNO"":"""_$g(result.Data("PAADMBedNO"))_""","
		 	s json = json_"""PADischgeDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$g(result.Data("PADischgeDate")))_""","
		 	s json = json_"""PADischgeTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$g(result.Data("PADischgeTime")))_""","
		 	s json = json_"""IDCardNO"":"""_$g(result.Data("IDCard"))_""","
		 	s json = json_"""CFCardNO"":"""_$g(result.Data("CFCardNo"))_""","
		 	s json = json_"""Warddesc"":"""_$g(result.Data("Warddesc"))_""","
		 	s json = json_"""Diagnosis"":"""_$g(result.Data("Diagnosis"))_""","
		 	s json = json_"""InstanceID"":"""_$p(record,"^",1)_""","
		 	s json = json_"""Title"":"""_$p(record,"^",2)_""","		 	
		 	s json = json_"""chartItemType"":"""_$p(record,"^",3)_""","
		 	s json = json_"""pluginType"":"""_$p(record,"^",4)_""","
		 	s json = json_"""templateID"":"""_$p(record,"^",5)_""""
		 	s json = json_"}"
		 	s isFirstRecord = 0
		}
		s count = count + 1	
	}
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	w ret
}

/// Desc:       根据就诊号获取就诊信息
/// Creator:    Lina
/// CreateDate: 2020-2-24
/// Input:      AEpisodeIDs 就诊号，多个以","分隔
/// Debug  w ##Class(EMRservice.Ajax.patientInfo).GetEpisodeInfoInBrowser("24,43,646")
ClassMethod GetEpisodeInfoInBrowser(AEpisodeIDs As %String) As %String
{
    s episodeInfo = ""
    q:(AEpisodeIDs = "") episodeInfo
    //根据入参就诊号获取就诊次数
    s episodeNum = $l(AEpisodeIDs,",")
    //根据入参就诊号获取第一次就诊日期
    s fistAdmDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime($p(AEpisodeIDs,",",1))
    s fistAdmDate = $P(fistAdmDateTime, ",", 1)
    if (fistAdmDate '= "") {
        s fistAdmDate = $zd(fistAdmDate,3)
        s HISFormatFistAdmDate = ##Class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",fistAdmDate)
    }
    //根据入参就诊号获取最后一次就诊日期
    s lastAdmDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime($p(AEpisodeIDs,",",episodeNum))
    s lastAdmDate = $P(lastAdmDateTime, ",", 1)
    if (lastAdmDate '= "") {
        s lastAdmDate = $zd(lastAdmDate,3)
        s HISFormatLastAdmDate = ##Class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",lastAdmDate)
    }
    s episodeInfo = "{""fistAdmDate"":"""_HISFormatFistAdmDate_""""
    s episodeInfo = episodeInfo_",""lastAdmDate"":"""_HISFormatLastAdmDate_""""
    s episodeInfo = episodeInfo_",""episodeNum"":"""_episodeNum_""""
    s episodeInfo = episodeInfo_"}"
    //转换特殊字符
    s episodeInfo = $ZSTRIP(episodeInfo,"*C")
    
    q "["_episodeInfo_"]"
}

}
