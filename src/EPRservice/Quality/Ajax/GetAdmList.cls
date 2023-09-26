/// 患者数据抽查
Class EPRservice.Quality.Ajax.GetAdmList Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s AdmType= $Get(%request.Data("AdmType",1),"")
	s AdmStatus = $Get(%request.Data("AdmStatus",1),"")
	s StartDate = $Get(%request.Data("StartDate",1),"")
	s EndDate = $Get(%request.Data("EndDate",1),"")
	s selectPro = $Get(%request.Data("selectPro",1),"")
	s extractNums = $Get(%request.Data("extractNums",1),"")
	s LocId = $Get(%request.Data("LocId",1),"")
	s HospitalID = $Get(%request.Data("HospitalID",1),"")
	s:(HospitalID="") HospitalID = $Get(%session.Data("LOGON.HOSPID"))
	
	s SpecialAdm = $Get(%request.Data("specialAdm",1),"")
	
	d ..GetAdmListJSON(StartDate,EndDate,AdmType,selectPro,LocId,extractNums,AdmStatus,SpecialAdm,HospitalID)
	
	Quit $$$OK
}

/// W ##class(EPRservice.Quality.Ajax.GetAdmList).GetAdmListJSON("2019-02-01","2019-03-01","I","1","","","1","",1,20)
ClassMethod GetAdmListJSON(StartDate, EndDate, AdmType, selectPro, locId, extractNums, AdmStatus, SpecialAdm = "", HOSPID = "", startRow = "", endRow = "") As %String
{
	s data = ""
	// 存放时间和抽查级别的临时global（永远不要相信用户的输入!不能删）
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.GetAdmList:GetAdmList")
	 	s sc = result.Execute(StartDate,EndDate,AdmType,selectPro,locId,extractNums,AdmStatus,SpecialAdm,HOSPID)
	 	
	 	
	 	s count = 0
	 	s jsons=##Class(%GlobalCharacterStream).%New()
	 	
		While (result.Next())
	 	{
			s json={}
				
			s json.EpisodeID=$g(result.Data("PAADMRowID"))
			s json.PAPMIName=$g(result.Data("PAPMIName"))
			s json.PAPMISex=$g(result.Data("PAPMISex"))
			s json.MainDiagnos=$g(result.Data("MainDiagnos"))
			s json.PAADMDocCode=$g(result.Data("PAADMDocCode"))
			s json.PAAdmWard=$g(result.Data("PAAdmWard"))
			s json.AdmDateTime=$g(result.Data("AdmDateTime"))
			s json.AdmRecordStatus=$g(result.Data("AdmRecordStatus"))
			s json.DeathDate=$g(result.Data("DeathDate"))
			s json.Age=$g(result.Data("Age"))
			s json.LocNums=$g(result.Data("length"))
			s json.RegNo=$g(result.Data("RegNo"))
			s json.MedicareNumber=$g(result.Data("MedicareNumber"))
			s json.CheckType=$g(result.Data("CheckType"))
			s json.AssignedFlag=$g(result.Data("AssignedFlag"))
			s json.nums=$g(result.Data("nums"))
			s json.ResidentDays=$g(result.Data("ResidentDays"))
			s json.LocName=$g(result.Data("LocName"))
			s json.DischDate=$g(result.Data("DischDate"))
			s json.SpecialInfo=$g(result.Data("SpecialInfo"))
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
