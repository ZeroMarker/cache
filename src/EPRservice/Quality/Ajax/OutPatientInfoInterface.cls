Class EPRservice.Quality.Ajax.OutPatientInfoInterface Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s AdmStatus = $Get(%request.Data("AdmStatus",1),"")
	s StartDate = $Get(%request.Data("StartDate",1),"")
	s EndDate = $Get(%request.Data("EndDate",1),"")
	s selectPro = $Get(%request.Data("selectPro",1),"")
	s LocIds=$Get(%request.Data("LocIds",1),"")
	s extractNums = $Get(%request.Data("extractNums",1),"")
	//FinishedFlag
	s FinishedFlag = $Get(%request.Data("FinishedFlag",1),"")
	s HOSPID=$Get(%request.Data("HospitalID",1),"")
	s:(HOSPID="") HOSPID = $Get(%session.Data("LOGON.HOSPID"))
	
	d ..GetEPREpisodeListJSON(AdmStatus,StartDate,EndDate,LocIds,selectPro,extractNums,HOSPID)
	
	
	Quit $$$OK
}

/// Desc:	获取患者列表JSON串;
/// input		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// 		AdmStatus患者在出院状态
/// 		AStartDate就诊开始时间
/// 		AEndDate就诊结束时间
/// 		AselectPro抽查比例
/// Return:	患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EPRservice.Quality.Ajax.OutPatientInfoInterface).GetEPREpisodeListJSON("A","2019-02-01","2019-02-02","0.1","")
ClassMethod GetEPREpisodeListJSON(AdmStatus As %String, AStartDate As %String, AEndDate As %String, LocIds As %Text, AselectPro As %String, extractNums As %String, HOSPID = "")
{
	
	s json = ""
	// 存放时间和抽查级别的临时global（永远不要相信用户的输入!不能删）
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.GetOutPatientList:GetOutPatientList")
 	s sc = result.Execute(AStartDate,AEndDate,AdmStatus,LocIds,AselectPro,extractNums,HOSPID)
 	
 	s jsons=##Class(%GlobalCharacterStream).%New()
 	
 	s count = 0
		
	While (result.Next())
 	{
	 	
	 	s MainDiagnos = $g(result.Data("MainDiagnos"))
	 	
	 	s MainDiagnos = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(MainDiagnos)
	 	
	 	s json={}
	 	s json.EpisodeID=$g(result.Data("PAADMRowID"))
	 	
	 	s json.PAPMIName=$g(result.Data("PAPMIName"))
	 	
	 	s json.PAPMISex=$g(result.Data("PAPMISex"))
	 	
	 	s json.MainDiagnos=MainDiagnos
	 	
	 	s json.PAAdmDepCodeDR=$g(result.Data("PAAdmDepCodeDR"))
	 	
	 	s json.PAAdmWard=$g(result.Data("PAAdmWard"))
	 	
	 	s json.Age=$g(result.Data("Age"))
	 	
	 	s json.length=$g(result.Data("length"))
	 	
	 	s json.number=$g(result.Data("LocNumber"))
	 	
	 	s json.extractPro=$g(result.Data("extractPro"))
	 	
	 	s json.LocName=$g(result.Data("LocName"))

		d:(count'=0) jsons.Write(",")
			
		d jsons.Write(json.%ToJSON())
		
		s count = count+1	
	}
	
	d jsons.Rewind()
	
	w "{""total"":"_count_",""rows"":["
	
	while(jsons.AtEnd=0)
	{
		w jsons.Read()
	}
		
	w "]}"
}

}
