Class web.eprajax.stat.RecordList Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	q:(episodeID="") $$$OK
	
	s eprDocID = $Get(%request.Data("EPRDocID",1),"")
	if (action = "getsingle")
	{
		w "["
		d ..GetSingleRecordList(episodeID)	
		w "]"
	}
	elseif (action = "getmultiple")
	{
		w "["
		d ..GetMultipleRecordList(episodeID)	
		w "]"
	}
	elseif (action = "getmultipledetail")
	{
		w "["
		d ..GetMultipleRecordDetail(episodeID, eprDocID)	
		w "]"
	}
	
	Quit $$$OK
}

/// Desc:	取患者基本信息
ClassMethod GetPatientInfo(AEpisodeID As %String) As %String
{
	s patientInfo = "", patientID = ""
	//取就诊信息
	if (AEpisodeID '= "")&&(AEpisodeID '= $C(0))
	{
		//取患者指针
		s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
		//出院床位
		s disBed = ##class(EPRservice.HISInterface.PatientInfoAssist).DisBed(AEpisodeID)
		//付费类型
		s payType =  ##class(EPRservice.HISInterface.PatientInfoAssist).PayType(AEpisodeID)
		//入院日期
		s admDateTime = ##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
		s admDate = $P(admDateTime, ",", 1)
		if (admDate '= "") s admDate = $zd(admDate,3)
		
		s patientInfo = "付费类型:"_payType_" 床位:"_disBed_" 入院日期:"_admDate
	}
	
			
	//用patientID取病人信息
	if (patientID '= "")&&(patientID '= $C(0))
	{
		//登记号
		s papmiNo = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientID)
		//姓名
		s name = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(patientID)
		//性别
		s gender = ##class(EPRservice.HISInterface.PatientInfoAssist).Gender(patientID, "")
		s gender = $P(gender, "^", 3)
		
		s patientInfo = "登记号:"_papmiNo_" 姓名:"_name_" 性别:"_gender_" "_patientInfo
	}
		
	//转换特殊字符
	s patientInfo = $tr(patientInfo,$c(10),"")	//<+ added on 2010-12-31 by houj>
	s patientInfo = $tr(patientInfo,$c(13),"")	//<+ added on 2010-12-31 by houj>
	s patientInfo = $tr(patientInfo,"""","")  	//<+ added on 2011-11-18 by xiezx>
	
	q patientInfo
}

/// debug: d ##class(web.eprajax.stat.RecordList).GetSingleRecordList("201868")
ClassMethod GetSingleRecordList(AEpisodeID As %String)
{
	s ^CacheTemp("debug222") = AEpisodeID
	s singleCount = 0
	s rset = ##class(%ResultSet).%New("EPRservice.BLL.Stat.RecordStatus:GetSingleRecordStatus")
 	s sc = rset.Execute(AEpisodeID)
 	while (rset.Next()) {
	 	s singleCount = singleCount + 1
		if (singleCount > 1) w ","
		w "{"
		w "Count:'"_singleCount_"'"
		w ",Name:'"_rset.GetDataByName("Name")_"'"
		w ",Status:'"_rset.GetDataByName("Status")_"'"
		w ",CreateUser:'"_rset.GetDataByName("CreateUser")_"'"
		w ",CreateDateTime:'"_rset.GetDataByName("CreateDate")_" "_rset.GetDataByName("CreateTime")_"'"
		w ",SignInfo:'"_rset.GetDataByName("SignInfo")_"'"	
		w "}"
 	}
}

/// debug: d ##class(web.eprajax.stat.RecordList).GetMultipleRecordList("201868")
ClassMethod GetMultipleRecordList(AEpisodeID As %String)
{
	s multiCount = 0
	s rset = ##class(%ResultSet).%New("EPRservice.BLL.Stat.RecordStatus:GetMultiRecordStatus")
 	s sc = rset.Execute(AEpisodeID)
 	while (rset.Next()) {
	 	s multiCount = multiCount + 1
	 	if (multiCount > 1) w ","
	 	w "{"
	 	w "Count:'"_multiCount_"'"
	 	w ",PrintDocID:'"_rset.GetDataByName("PrintDocID")_"'"
	 	w ",Name:'"_rset.GetDataByName("Name")_"'"
	 	w ",Status:'"_rset.GetDataByName("Status")_"'"
		w "}"
 	}
}

/// debug: d ##class(web.eprajax.stat.RecordList).GetMultipleRecordDetail("201868", "24")
ClassMethod GetMultipleRecordDetail(AEpisodeID As %String, AEPRDocID As %String)
{
	s multiCount = 0
	s rset = ##class(%ResultSet).%New("EPRservice.BLL.Stat.RecordStatus:GetMultiDetailStatus")
 	s sc = rset.Execute(AEpisodeID, AEPRDocID)
 	while (rset.Next()) {
	 	s multiCount = multiCount + 1
	 	if (multiCount > 1) w ","
		
		w "{"
		w "Count:'"_multiCount_"'"
		w ",Name:'"_rset.GetDataByName("Name")_"'"
		w ",Status:'"_rset.GetDataByName("Status")_"'"
		w ",CreateUser:'"_rset.GetDataByName("CreateUser")_"'"
		w ",CreateDateTime:'"_rset.GetDataByName("CreateDate")_" "_rset.GetDataByName("CreateTime")_"'"
		w ",SignInfo:'"_rset.GetDataByName("SignInfo")_"'"	
		w "}"
 	}
}

}
