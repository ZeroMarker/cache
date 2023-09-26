/// 名称: 获取就诊列表;
/// 描述: 用于电子病历主页病人列表;
/// 编写者：Zuoxiang Xie
/// 编写日期: 19/07/2011
/// 此类为病历书写和病历浏览共用,修改时请注意.
Class web.eprajax.eprepisodelist Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s patientNo = $Get(%request.Data("PatientNo",1),"")
	//新增病案号  add by lina 2014-11-24
	s medicareNo = $Get(%request.Data("MedicareNo",1),"")
	s MedicalInsuranceNo = $Get(%request.Data("MedicalInsuranceNo",1),"")
	//健康卡号    add by lina 2014-11-26
	s CFCardNo = $Get(%request.Data("CFCardNo",1),"")
	s IDCardNo = $Get(%request.Data("IDCardNo",1),"")
	s patientName = $Get(%request.Data("PatientName",1),"")
	s AdmType = $Get(%request.Data("AdmType",1),"")
	s AdmStatus = $Get(%request.Data("AdmStatus",1),"")
	s startDate = $Get(%request.Data("StartDate",1),"")
	s endDate = $Get(%request.Data("EndDate",1),"")
	s startTime = $Get(%request.Data("StartTime",1),"")
	s endTime = $Get(%request.Data("EndTime",1),"")
	s isArrivedQue = $Get(%request.Data("IsArrivedQue",1),"")
	s expectedLocID = $Get(%request.Data("expectedLocID",1),"")
	
		
	s idxStart = $g(%request.Data("start",1),"-1")
	s pageSize = $g(%request.Data("limit",1),"-1")
	s idxLast = idxStart + pageSize - 1	
	
	s locID = $g(%session.Data("LOGON.CTLOCID"))
	s userID = $g(%session.Data("LOGON.USERID"))
	
	//兼容病区ID
	if (locID'="") {
		s CTLOCType = $p($g(^CTLOC(locID)),"^",13)
		
		if (CTLOCType="W") {
			//如果是病区,则默认转第1个科室ID
			s locID = ##class(EPRservice.HISInterface.PatientInfoAssist).CurDeptLinkLocByDept(locID)
			s locID = $p(locID,"^",3)
		}
	}
		
	
	/*
	s ^CacheTemp("web.eprajax.eprepisodelist","Params", "patientNo") = patientNo
	s ^CacheTemp("web.eprajax.eprepisodelist","Params", "patientName") = patientName
	s ^CacheTemp("web.eprajax.eprepisodelist","Params", "startDate") = startDate
	s ^CacheTemp("web.eprajax.eprepisodelist","Params", "endDate") = endDate
	s ^CacheTemp("web.eprajax.eprepisodelist","Params", "isArrivedQue") = isArrivedQue
	s ^CacheTemp("web.eprajax.eprepisodelist","Params", "idxStart") = idxStart
	s ^CacheTemp("web.eprajax.eprepisodelist","Params", "idxLast") = idxLast
	*/
	
	//modified by lina 2014-11-26
	s retJSON = ..GetEPREpisodeListJSON(locID,userID,patientNo,medicareNo,MedicalInsuranceNo,CFCardNo,IDCardNo,patientName,AdmType,AdmStatus,startDate,endDate,isArrivedQue,idxStart,idxLast,expectedLocID,startTime,endTime)
	w retJSON
	
	q $$$OK
}

/// Desc:	获取患者列表JSON串;
/// Input:	ALocID为登录科室RowID;
/// 		AUserID为登录用户RowID;
/// 		APatientNo为患者登记号;
/// 		APatientName为患者姓名;
/// 			AdmType为患者就诊类型;
/// 		AStartDate为就诊开始日期;
/// 		AEndDate为就诊截止日期;
/// 		AIsArrivedQue为是否本科患者;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// Return:	患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(web.eprajax.eprepisodelist).GetEPREpisodeListJSON("6","105","","","I","A","","","off","0","4","")
ClassMethod GetEPREpisodeListJSON(ALocID As %String, AUserID As %String, APatientNo As %String, AMedicareNo As %String, AMedicalInsuranceNo As %String, ACFCardNo As %String, AIDCardNo As %String, APatientName As %String, AdmType As %String, AdmStatus As %String, AStartDate As %String, AEndDate As %String, AIsArrivedQue As %String, AIdxStart As %Integer, AIdxLast As %Integer, AexpectedLocID As %String, AStartTime As %String, AEndTime As %String)
{
	//EPRservice.DAL.GetPaAdmDetail是组内自己写的查询，可扩展支持“身份证号查询”、“健康卡号查询”等; add by niucaicai
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.GetPaAdmDetail:GetPaAdmList")
	//LocID(Session获取),UserID(Session获取),IPAddress,AllPatient(全病区病人),PatientNo(病人号码),SurName(病人姓名),StartDate,EndDate,ArrivedQue(本科病人),RegQue
 	s sc = result.Execute(ALocID,AIsArrivedQue,APatientNo,AMedicareNo,AStartDate,AEndDate,APatientName,ACFCardNo,AdmType,AIDCardNo,AexpectedLocID,AdmStatus,AMedicalInsuranceNo,AStartTime,AEndTime)
 	
 	s json = ""
 	s count = 0
 	s isFirstRecord = 1

	While (result.Next())
 	{
	 	s count = count + 1	
	 	
	 	if ( count-1 >= AIdxStart) && (count-1 <= AIdxLast)
		{
			if (isFirstRecord = 0) { s json = json_"," }
			
		 	s json = json_"{PatientID:'"_$g(result.Data("PAPMIDR"))_"',"
		 	s json = json_"EpisodeID:'"_$g(result.Data("PAADMRowID"))_"',"
		 	s json = json_"mradm:'"_$g(result.Data("mradm"))_"',"
		 	s json = json_"PAPMINO:'"_$g(result.Data("PAPMINO"))_"',"
		 	s json = json_"MedicareNo:'"_$g(result.Data("MedicareNo"))_"',"
		 	s json = json_"PAPMIName:'"_$g(result.Data("PAPMIName"))_"',"
		 	s json = json_"PAPMIDOB:'"_$g(result.Data("PAPMIDOB"))_"',"
		 	s json = json_"PAPMISex:'"_$g(result.Data("PAPMISex"))_"',"
		 	s json = json_"PAAdmDate:'"_$g(result.Data("PAAdmDate"))_"',"
		 	s json = json_"PAAdmTime:'"_$g(result.Data("PAAdmTime"))_"',"
		 	s json = json_"PAAdmDepCodeDR:'"_$g(result.Data("PAAdmDepCodeDR"))_"',"
		 	s json = json_"PAAdmDocCodeDR:'"_$g(result.Data("PAAdmDocCodeDR"))_"',"
		 	s json = json_"PAAdmType:'"_$g(result.Data("PAAdmType"))_"',"
		 	s json = json_"PAAdmWard:'"_$g(result.Data("PAAdmWard"))_"',"
		 	s json = json_"PAAdmReason:'"_$g(result.Data("PAADMReason"))_"',"
		 	s json = json_"PAADMBedNO:'"_$g(result.Data("PAADMBedNO"))_"',"
		 	s json = json_"PADischgeDate:'"_$g(result.Data("PADischgeDate"))_"',"
		 	s json = json_"PADischgeTime:'"_$g(result.Data("PADischgeTime"))_"',"
		 	s json = json_"IDCardNO:'"_$g(result.Data("IDCard"))_"',"
		 	s json = json_"CFCardNO:'"_$g(result.Data("CFCardNo"))_"',"
		 	s json = json_"Warddesc:'"_$g(result.Data("Warddesc"))_"',"
		 	s json = json_"Diagnosis:'"_$g(result.Data("Diagnosis"))_"'}"
		 	
		 	s isFirstRecord = 0
		}
	}
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	s ret = "{totalCount:"_count_",data:["_json_"]}"
	q ret
}

ClassMethod GetEPREpisodeListJSON1(ALocID As %String, AUserID As %String, APatientNo As %String, APatientName As %String, AStartDate As %String, AEndDate As %String, AIsArrivedQue As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	//web.DHCDocInPatientList是医生站提供的接口;
	s result = ##Class(%ResultSet).%New("web.DHCDocInPatientList:FindLocDocCurrentAdm")
	//LocID(Session获取),UserID(Session获取),IPAddress,AllPatient(全病区病人),PatientNo(病人号码),SurName(病人姓名),StartDate,EndDate,ArrivedQue(本科病人),RegQue
 	s sc = result.Execute(ALocID,AUserID,"","",APatientNo,APatientName,AStartDate,AEndDate,AIsArrivedQue,"")
 	
 	s json = ""
 	s count = 0
 	s isFirstRecord = 1

	While (result.Next())
 	{
	 	s count = count + 1	
	 	
	 	if ( count-1 >= AIdxStart) && (count-1 <= AIdxLast)
		{
			if (isFirstRecord = 0) { s json = json_"," }
			
		 	s json = json_"{PatientID:'"_$g(result.Data("PatientID"))_"',"
		 	s json = json_"EpisodeID:'"_$g(result.Data("EpisodeID"))_"',"
		 	s json = json_"mradm:'"_$g(result.Data("mradm"))_"',"
		 	s json = json_"PAPMINO:'"_$g(result.Data("PAPMINO"))_"',"
		 	s json = json_"PAPMIName:'"_$g(result.Data("PAPMIName"))_"',"
		 	s json = json_"PAPMIDOB:'"_$g(result.Data("PAPMIDOB"))_"',"
		 	s json = json_"PAPMISex:'"_$g(result.Data("PAPMISex"))_"',"
		 	s json = json_"PAAdmDate:'"_$g(result.Data("PAAdmDate"))_"',"
		 	s json = json_"PAAdmTime:'"_$g(result.Data("PAAdmTime"))_"',"
		 	s json = json_"PAAdmDepCodeDR:'"_$g(result.Data("PAAdmDepCodeDR"))_"',"
		 	s json = json_"PAAdmDocCodeDR:'"_$g(result.Data("PAAdmDocCodeDR"))_"',"
		 	s json = json_"PAAdmType:'"_$g(result.Data("PAAdmType"))_"',"
		 	s json = json_"PAAdmWard:'"_$g(result.Data("PAAdmWard"))_"',"
		 	s json = json_"PAAdmReason:'"_$g(result.Data("PAAdmReason"))_"',"
		 	s json = json_"Diagnosis:'"_$g(result.Data("Diagnosis"))_"'}"
		 	
		 	s isFirstRecord = 0
		}
	}
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	s ret = "{totalCount:"_count_",data:["_json_"]}"
	q ret
}

}
