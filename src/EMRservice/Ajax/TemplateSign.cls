Class EMRservice.Ajax.TemplateSign Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s:(action="") action = $Get(%request.Data("Func",1),"")
	s patientID = $Get(%request.Data("patientID",1),"")
	
	s RadioValue = $Get(%request.Data("RadioValue",1),"")
	
	if (action = "GetPatientList") //检索患者列表
	{
		s page = $g(%request.Data("page",1),"-1")
		s rows = $g(%request.Data("rows",1),"-1")
		s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1	

		s locID = $g(%session.Data("LOGON.CTLOCID"))
		s userID = $g(%session.Data("LOGON.USERID"))
		s ssgroupID = %session.Get("LOGON.GROUPID")

		s PatListType = $Get(%request.Data("PatListType",1),"")
		s SignAction = $Get(%request.Data("SignAction",1),"")
		
		if (PatListType = "InPat")
		{
			s RadioValue = $Get(%request.Data("RadioValue",1),"")
			s WardID = $Get(%request.Data("WardID",1),"all")
			s MedicareNo = $Get(%request.Data("MedicareNo",1),"")
			s PatientName = $Get(%request.Data("PatientName",1),"")
			s result = ""
			s result = ..GetInPatListJSON(SignAction,ssgroupID,locID,userID,RadioValue,WardID,idxStart,idxLast,MedicareNo,PatientName)
			while (result.AtEnd = 0)
			{
				w $ZSTRIP(result.Read(32000),"*C")
			}
			
		}
		elseif (PatListType = "OutPat")
		{
			s DateGap = $Get(%request.Data("DateGap",1),"")
			s StartDate = $Get(%request.Data("OutStartDate",1),"")
			s EndDate = $Get(%request.Data("OutEndDate",1),"")
			if ((StartDate '= "")&&(EndDate '= ""))
			{
				s StartDate = $zdh(StartDate,3)
				s EndDate=$zdh(EndDate,3)
			}
			else
			{
				s Systemdatetime = $HOROLOG
				s Systemdateint = $p(Systemdatetime,",",1)
				s Systemtimeint = $p(Systemdatetime,",",2)
				s StartDate = Systemdateint-DateGap
				s EndDate = Systemdateint
			}
			
			s RadioValue = $Get(%request.Data("RadioValue",1),"")
			s PatientNo = $Get(%request.Data("PatientNo",1),"")
			s MedicareNo = $Get(%request.Data("MedicareNo",1),"")
			s PatientName = $Get(%request.Data("PatientName",1),"")
			Set ssuser=##class(User.SSUser).%OpenId(userID)
  			s UserCode = ""
			w ..GetOutPatListJSON(SignAction,ssgroupID,locID,userID,RadioValue,idxStart,idxLast,StartDate,EndDate,PatientNo,MedicareNo,PatientName,UserCode)
		}
		elseif (PatListType = "PapmiNo")
		{
			s papmiNo = $Get(%request.Data("PapmiNo",1),"")
			s RadioValue = $Get(%request.Data("RadioValue",1),"")
			w ..GetPapmiNoJSON(papmiNo,locID,ssgroupID,SignAction,RadioValue,userID)
		}
	}
	elseif (action = "GetRecord")
	{
		s InstanceIDs = $Get(%request.Data("InstanceIDs",1),"")
		s Interface =$Get(%request.Data("Interface",1),"")
		w ##Class(EMRservice.BL.BLTemplateSign).GetRecordData(InstanceIDs,Interface)
	}
	
	Quit $$$OK
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
/// Debug:	w ##Class(EMRservice.Ajax.TemplateSign).GetInPatListJSON("Check","29","6","359","currentUser","all","1","20","","")
ClassMethod GetInPatListJSON(ASignAction As %String, ASSgroupId As %String, ALocID As %String, AUserID As %String, ARadioValue As %String, AWardID As %String, AIdxStart As %Integer, AIdxLast As %Integer, AMedicareNo As %String = "", APatientName As %String = "") As %GlobalCharacterStream
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	s result = ##Class(%ResultSet).%New("EMRservice.DAL.GetPaAdmDetail:GetInPatList")
	s sc = result.Execute(ALocID,AUserID,ARadioValue,AWardID,AMedicareNo,APatientName)
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
		 s waitsignInfo = ##Class(EMRservice.BL.BLTemplateSign).GetWaitSignInstance(ALocID,ASSgroupId,$g(result.Data("EpisodeID")),ASignAction,AUserID)
		 continue:($p(waitsignInfo,"#",1)=0)
		 s waitsign = $p(waitsignInfo,"#",1)
		 s instanceIDs = $p(waitsignInfo,"#",2)
		 s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		 s patientID = $g(result.Data("PatientID"))
		 if (HasPatEncryptLevel = "Y")
		 {
			 s ResultStr = ##Class(EMRservice.Ajax.patientInfo).GetPatEncryptLevel(patientID)
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
		 s json = json_"""waitsign"":"""_waitsign_""","
		 s json = json_"""WaitSignInstance"":"""_instanceIDs_""","
		 s json = json_"""Diagnosis"":"""_$g(result.Data("Diagnosis"))_"""}" 
		 s BedNO = $g(result.Data("PAAdmBedNO"))
		 s:(BedNO = "") BedNO="无"
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
ClassMethod GetOutPatListJSON(ASignAction As %String, ASSgroupId As %String, ALocID As %String, AUserID As %String, ARadioValue As %String, AIdxStart As %Integer, AIdxLast As %Integer, AStartDate As %String, AEndDate As %String, APatientNo As %String = "", AMedicareNo As %String = "", APatientName As %String = "", AUserCode As %String = "")
{
	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
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
	 	s waitsignInfo = ##Class(EMRservice.BL.BLTemplateSign).GetWaitSignInstance(ALocID,ASSgroupId,$g(result.Data("EpisodeID")),ASignAction,AUserID)
		continue:($p(waitsignInfo,"#",1)=0)
		s waitsign = $p(waitsignInfo,"#",1)
		s instanceIDs = $p(waitsignInfo,"#",2)
	 	
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""PatientID"":"""_$g(result.Data("PatientID"))_""","
		 	
		 	s patientID = $g(result.Data("PatientID"))
		 	if (HasPatEncryptLevel = "Y")
		 	{
			 	s ResultStr = ##Class(EMRservice.Ajax.patientInfo).GetPatEncryptLevel(patientID)
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
		 	s json = json_"""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""","
		 	s json = json_"""PAAdmDate"":"""_$g(result.Data("PAAdmDate"))_""","
		 	s json = json_"""PAAdmTime"":"""_$g(result.Data("PAAdmTime"))_""","
		 	s json = json_"""waitsign"":"""_waitsign_""","
			s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
		 	s json = json_"""PAAdmDischgeDate"":"""_$g(result.Data("PAAdmDischgeDate"))_""","
		 	s json = json_"""PAAdmDischgeTime"":"""_$g(result.Data("PAAdmDischgeTime"))_""","
		 	s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 	s json = json_"""PAAdmBedNO"":"""_$g(result.Data("PAAdmBedNO"))_""","
		 	s json = json_"""HomepageURL"":"""_$g(result.Data("HomepageURL"))_""","
		 	s json = json_"""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""","
		 	s json = json_"""OutDays"":"""_$g(result.Data("OutDays"))_""","
		 	s json = json_"""InTimes"":"""_$g(result.Data("InTimes"))_""","
		 	s json = json_"""WaitSignInstance"":"""_instanceIDs_""","
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

/// Desc:	获取某登记号列表JSON串;
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
/// Debug:	w ##Class(EMRservice.Ajax.TemplateSign).GetPapmiNoJSON("0000000001","6","29","Check","currentUser")
ClassMethod GetPapmiNoJSON(APapmiNo As %String, ALocID As %String, ASSgroupId As %String, ASignAction As %String, ARadioValue As %String, AUserID As %String) As %String
{
 	s count = 0
 	s json = ""
 	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
 	q:(APapmiNo = "")||(ALocID = "")||(ASSgroupId = "")||(ASignAction = "")||(ARadioValue = "")||(AUserID = "") ret
 	
 	s HasPatEncryptLevel = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("HasPatEncryptLevel")
	s patientInfo = ""
	
	s name = ""			//姓名
	s age = ""			//年龄
	s gender = ""		//性别
	s disBed = ""		//出院床位
	s payType = ""		//付费类型
	s admDate = ""		//入院日期
	s mainDiagnos = ""	//主要诊断
	s ipRecordNo = "" 	//病案号
	
	s patientID = $o(^PAPERi("PAPMI_PatNo",APapmiNo,""))
	q:(patientID = "") ret
	s episodeIDs = ##class(EMRservice.Ajax.TemplateSign).getspisodeid(patientID,ALocID)   //add 2019-03-28 当前科室住院就诊记录
	q:(episodeIDs = "") ret
	
	s length = $l(episodeIDs,"^")
	for I=1:1:length
	{
		s episodeID = $p(episodeIDs,"^",I)
		
		s waitsignInfo = ##Class(EMRservice.BL.BLTemplateSign).GetWaitSignInstance(ALocID,ASSgroupId,episodeID,ASignAction,AUserID)
		continue:($p(waitsignInfo,"#",1)=0)
	
		//年龄
		s age = ##class(web.DHCBillInterface).GetPapmiAge(patientID,episodeID)
		
		//出院床位
		s disBed = ##class(EMRservice.HISInterface.PatientInfoAssist).DisBed(episodeID)
		
		//付费类型
		s payType =  ##class(EMRservice.HISInterface.PatientInfoAssist).PayType(episodeID)
		
		//入院日期
		s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeID)
		s admDate = $P(admDateTime, ",", 1)
		if (admDate '= "") s admDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",admDate)
		s admTime = $P(admDateTime, ",", 2)
		if (admTime '= "") s admTime = $zt(admTime,1)
		
		//出院日期
		s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
		s PAAdmDischgeDate = $P(disDateTime, ",", 1)
		if (PAAdmDischgeDate '= "") s PAAdmDischgeDate = $zd(PAAdmDischgeDate,3)
		s PAAdmDischgeTime = $P(disDateTime, ",", 2)
		if (PAAdmDischgeTime '= "") s PAAdmDischgeTime = $zt(PAAdmDischgeTime,1)
		
		s hospital = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
		s ipRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(episodeID, hospital)
		
		s dept = ##class(EMRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID,hospital)
		s dept = $p(dept,"^",3)	
			
		//姓名
		s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientID)
		
		//性别
		s gender = ##class(EMRservice.HISInterface.PatientInfoAssist).Gender(patientID, "")
		s gender = $P(gender, "^", 3)
		
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
		}
		else
		{
			s SecAlias = ""
			s EmployeeFunction = ""
			s SecCode = ""
			s SecDesc = ""
		}
	 	
		 s waitsign = $p(waitsignInfo,"#",1)
		 s instanceIDs = $p(waitsignInfo,"#",2)
		 s:(count > 0) json = json_","
		 s json = json_"{""PatientID"":"""_patientID_""","
		 if (HasPatEncryptLevel = "Y")
		 {
			 s ResultStr = ##Class(EMRservice.Ajax.patientInfo).GetPatEncryptLevel(patientID)
			 s json = json_"""SecAlias"":"""_$p(ResultStr,"^",1)_""","
			 s json = json_"""EmployeeFunction"":"""_$p(ResultStr,"^",2)_""","
		 }
		 s json = json_"""EpisodeID"":"""_episodeID_""","
		 s json = json_"""PAPMINO"":"""_APapmiNo_""","
		 s json = json_"""PAPMIName"":"""_name_""","
		 s json = json_"""PAPMISex"":"""_gender_""","
		 s json = json_"""PAPMIAge"":"""_age_""","
		 s json = json_"""PAAdmDate"":"""_admDate_""","
		 s json = json_"""PAAdmTime"":"""_admTime_""","
		 s json = json_"""PAAdmBedNO"":"""_disBed_""","
		 s json = json_"""PAAdmWard"":"""_dept_""","
		 s json = json_"""PAAdmDischgeDate"":"""_PAAdmDischgeDate_""","
		 s json = json_"""PAAdmDischgeTime"":"""_PAAdmDischgeTime_""","
		 s json = json_"""waitsign"":"""_waitsign_""","
		 s json = json_"""WaitSignInstance"":"""_instanceIDs_"""}" 
		 s json = $ZSTRIP(json,"*C")
		 s count = count + 1
	}
	 s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	 q ret
}

/// 根据papmid取病人当前科室住院就诊号，以^分隔
/// w ##class(EMRservice.Ajax.TemplateSign).getspisodeid(2305,155)
ClassMethod getspisodeid(patientID As %String, ALocID As %String) As %String
{
	s result = ""
	q:(patientID = "")||(ALocID = "") result
	s episodeID = ""
	for
	{
		s episodeID = $o(^PAPERdr(patientID,"ADM","I",episodeID))
		q:(episodeID = "")
		s depcode=$p(^PAADM(episodeID),"^",4)
		if (depcode = ALocID)
		{
			s:(result '= "") result = result_"^"
			s result = result_episodeID
		}
	}
	q result
}

}
