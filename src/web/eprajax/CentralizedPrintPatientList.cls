Class web.eprajax.CentralizedPrintPatientList Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s admNo = $Get(%request.Data("AdmNo",1),"")
	s patientNo = $Get(%request.Data("PatientNo",1),"")
	s patientName = $Get(%request.Data("PatientName",1),"")
	s patientLocID = $Get(%request.Data("PatientLocID",1),"")
    s patientWardID = $Get(%request.Data("PatientWardID",1),"")
	s startDate = $Get(%request.Data("StartDate",1),"")
	s startTime = $Get(%request.Data("StartTime",1),"")
	s endDate = $Get(%request.Data("EndDate",1),"")
	s endTime = $Get(%request.Data("EndTime",1),"")
	s outStartDate = $Get(%request.Data("OutStartDate",1),"")
	s outStartTime = $Get(%request.Data("OutStartTime",1),"")
	s outEndDate = $Get(%request.Data("OutEndDate",1),"")
	s outEndTime = $Get(%request.Data("OutEndTime",1),"")
	
	s statusType = $Get(%request.Data("StatusType",1),"A")
	s pAAdmType = $Get(%request.Data("PAAdmType",1),"") 
	s gender = $Get(%request.Data("Gender",1),"")
	s age = $Get(%request.Data("Age",1),"")
	s birthday = $Get(%request.Data("Birthday",1),"")
	s marriage = $Get(%request.Data("Marriage",1),"")  
	s nation = $Get(%request.Data("Nation",1),"")
	s mobilePhone = $Get(%request.Data("MobilePhone",1),"")
	s idCardNo = $Get(%request.Data("IdCardNo",1),"")
	s occupation = $Get(%request.Data("Occupation",1),"") 
	s provinceBirth = $Get(%request.Data("ProvinceBirth",1),"")
	s cityBirth = $Get(%request.Data("CityBirth",1),"")  
		
	s idxStart = $g(%request.Data("start",1),"-1")
	s pageSize = $g(%request.Data("limit",1),"-1")
	s idxLast = idxStart + pageSize - 1	
	
	s locID = $g(%session.Data("LOGON.CTLOCID"))
	s userID = $g(%session.Data("LOGON.USERID"))
	
	s param = patientNo_"^"_patientName_"^"_patientLocID_"^"_patientWardID_"^"_startDate_"^"_startTime_"^"_endDate_"^"_endTime_"^"_outStartDate_"^"_outStartTime_"^"_outEndDate_"^"_outEndTime_"^"_admNo
	s filterParam = statusType_"^"_pAAdmType_"^"_gender_"^"_age_"^"_birthday_"^"_marriage_"^"_nation_"^"_mobilePhone_"^"_occupation_"^"_provinceBirth_"^"_cityBirth_"^"_idCardNo
	
	//s ^CacheTemp("param") = param
	//s ^CacheTemp("filterParam") = filterParam
	
	s retJSON = ..GetEPREpisodeListJSON(param, filterParam, idxStart, idxLast)
	w retJSON
	
	q $$$OK
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
/// Debug:	w ##Class(web.eprajax.eprepisodelist).GetEPREpisodeListJSON("","","00000001","","","","on","0","4")
ClassMethod GetEPREpisodeListJSON(AParam As %String, AFilterParam As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	
	s result = ##Class(%ResultSet).%New("EPRservice.BLL.BLPatientList:GetPatientList")
	s sc = result.Execute(AParam,AFilterParam)
	
 	s json = ""
 	s count = 0
 	s isFirstRecord = 1

	While (result.Next())
 	{
	 	s count = count + 1	
	 	
	 	if ( count-1 >= AIdxStart) && (count-1 <= AIdxLast)
		{
			if (isFirstRecord = 0) { s json = json_"," }
			
			s json = json_"{PAStatusType:'"_$g(result.Data("PAStatusType"))_"',"
			s json = json_"PAAdmType:'"_$g(result.Data("PAAdmType"))_"',"
		 	s json = json_"PAPMIName:'"_$g(result.Data("PAPMIName"))_"',"
		 	s json = json_"PAPMINO:'"_$g(result.Data("PAPMINO"))_"',"
		 	s json = json_"PAPMIDOB:'"_$g(result.Data("PAPMIDOB"))_"',"
		 	s json = json_"PAPMIAge:'"_$g(result.Data("PAPMIAge"))_"',"
		 	s json = json_"PAPMISex:'"_$g(result.Data("PAPMISex"))_"',"
		 	s json = json_"PAAdmDateTime:'"_$g(result.Data("PAAdmDateTime"))_"',"
		 	s json = json_"PAAdmWard:'"_$g(result.Data("PAAdmWard"))_"',"
		 	s json = json_"PAAdmRoom:'"_$g(result.Data("PAAdmRoom"))_"',"
		 	s json = json_"PAAdmBed:'"_$g(result.Data("PAAdmBed"))_"',"
		 	s json = json_"PAAdmLoc:'"_$g(result.Data("PAAdmLoc"))_"',"
		 	s json = json_"PADischgeDateTime:'"_$g(result.Data("PADischgeDateTime"))_"',"
		 	s json = json_"PAAdmDoc:'"_$g(result.Data("PAAdmDoc"))_"',"
		 	s json = json_"PayMode:'"_$g(result.Data("PayMode"))_"',"
		 	s json = json_"EpisodeID:'"_$g(result.Data("EpisodeID"))_"',"
		 	s json = json_"PatientID:'"_$g(result.Data("PatientID"))_"'}"
		 	
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
