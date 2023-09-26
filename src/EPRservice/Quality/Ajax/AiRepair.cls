Class EPRservice.Quality.Ajax.AiRepair Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s CTLocID = $g(%request.Data("CTLocID",1),"")
	s StartDate = $Get(%request.Data("StartDate",1),"")
	s EndDate = $Get(%request.Data("EndDate",1),"")
	s Type = $Get(%request.Data("Type",1),"")
	s Action = $Get(%request.Data("Action",1),"")
	s AdmType= $Get(%request.Data("AdmType",1),"")
	s MedicareNo= $Get(%request.Data("MedicareNo",1),"")
	s HospitalID=$g(%session.Data("LOGON.HOSPID"))
	//s ^tem("Ajax.AiRepair")=CTLocID_","_StartDate_","_EndDate_","_Type
	if (Action="View")
	{
		w ..GetAiRepairRankJSON()
	}else{
		w ..GetAiRepairListJSON(CTLocID,StartDate,EndDate,Type,AdmType,MedicareNo,HospitalID)
	}
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			获取内涵明细json
/// Input:			ALocID	科室
/// 				AStartDate	入院开始时间
/// 				AEndDate	入院结束时间
/// 				AType		是否修复（E 未修复 R 修复）
/// Output          json
/// Debug: ##class(EPRservice.Quality.Ajax.AiRepair).GetAiRepairListJSON()
ClassMethod GetAiRepairListJSON(ALocID As %String, AStartDate As %String, AEndDate As %String, AType As %String, AdmType As %String, MedicareNo As %String, AHospitalID As %String) As %String
{
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiLog:GetAiLogList")
 	s sc = result.Execute(AdmType,AStartDate,AEndDate,ALocID,AType,MedicareNo,AHospitalID)

 	s json = ""
 	s count = 0
	While (result.Next())
 	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""PAADMRowID"":"""_$g(result.Data("PAADMRowID"))_""","
	 	s json = json_"""Name"":"""_$g(result.Data("Name"))_""","
		s json = json_"""MRNo"":"""_$g(result.Data("MRNo"))_""","
	 	s json = json_"""LocDesc"":"""_$g(result.Data("LocDesc"))_""","
	 	s json = json_"""DoctorDesc"":"""_$g(result.Data("DoctorDesc"))_""","
	 	s json = json_"""EntryDR"":"""_$g(result.Data("EntryDR"))_""","
	 	s json = json_"""Title"":"""_$g(result.Data("Title"))_""","
	 	s StatusDesc=""
	 	s Status=$g(result.Data("Status"))
	 	s:(Status="R") StatusDesc="已修复"
	 	s json = json_"""StatusDesc"":"""_StatusDesc_""","
	 	s json = json_"""Trigger"":"""_$g(result.Data("Trigger"))_""","
	 	s json = json_"""Repair"":"""_$g(result.Data("Repair"))_""""
	 	s json = json_"}"
	 	s json = $tr(json,$c(10),"")
		s json = $tr(json,$c(13),"")
		s count = count + 1		
	}
	//s json=json_","
	//s json=json_"{"EpisodeID":"394","PatientID":"225","MedRecordNo":"100005","RegNo":"0000000052","PAPMIName":"tyu01","PAPMIDOB":"2018-03-11","PAPMISex":"女", "AdmDateTime":"2019-02-18 09:37:21","DisDateTime":"2019-02-20 11:43:50","PAAdmDepCodeDR":"泌尿外科门诊","PAAdmDocCodeDR":"医生01","PAADMReason":"全自费","Warddesc":"呼吸内科护理单元","EprDocStatus":"0","EprDocStatusDesc":"否","EprNurStatus":"0","EprNurStatusDesc":"否","EprPdfStatus":"0","EprPdfStatusDesc":"否","ReviewS  tatus":"否","CheckStatus":"否","CheckRule":"无","CheckDateTime":"无","CheckUser":"无"}"
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			获取科室内涵触犯倒序json
/// Input:			
/// Output          json
/// Debug: ##class(EPRservice.Quality.Ajax.AiRepair).GetAiRepairRankJSON()
ClassMethod GetAiRepairRankJSON() As %String
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiLog:GetAiResultRank")
	d ds.Execute(10)
	While (ds.Next())
	{
		s LocID=ds.Data("LocID")
		s LocDesc=ds.Data("LocDesc")
		s Err=ds.Data("Err")
		s Rep=ds.Data("Rep")
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""LocID"":"""_LocID_""","
		s json = json_"""LocDesc"":"""_LocDesc_""","
		s json = json_"""Err"":"""_Err_""","
		s json = json_"""Rep"":"""_Rep_""""
	    s json = json_"}"
	    s count = count + 1
	    
	}
	s json = "["_json_"]"
	q json
}

}
