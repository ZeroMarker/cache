Class EPRservice.Quality.Ajax.disPatientList Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s Type = $Get(%request.Data("Type",1),"")
	s YType = $Get(%request.Data("YType",1),"")
	s StartDate = $Get(%request.Data("StartDate",1),"")
	s EndDate = $Get(%request.Data("EndDate",1),"")
	s MedRecordNo = $Get(%request.Data("MedRecordNo",1),"")
	s RegNo = $Get(%request.Data("RegNo",1),"")
	s Name = $Get(%request.Data("Name",1),"")
	s CTLocID = $g(%request.Data("CTLocID",1),"")
	s DocCommit = $g(%request.Data("DocCommit",1),"")
	s NurCommit = $g(%request.Data("NurCommit",1),"")
	s PDFCreated = $g(%request.Data("PDFCreated",1),"")
	s SpecialAdm = $Get(%request.Data("SpecialAdm",1),"")
	s HospitalID=$g(%session.Data("LOGON.HOSPID"))
	s doctorID=$g(%request.Data("doctorID",1),"")
	s RcFlag=$g(%request.Data("RcFlag",1),"")
	s AEpisodeID = $Get(%request.Data("AEpisodeID",1),"")
	//s ^tem("DepDisList")=$lb(Type,YType,StartDate,EndDate,MedRecordNo,RegNo,Name,CTLocID,DocCommit,NurCommit,PDFCreated,SpecialAdm,HospitalID,doctorID,RcFlag,AEpisodeID)
	w ..GetAdmProcedureListJSON(Type,YType,StartDate,EndDate,MedRecordNo,RegNo,Name,CTLocID,DocCommit,NurCommit,PDFCreated,SpecialAdm,HospitalID,doctorID,RcFlag,AEpisodeID)
	 
	q $$$OK
}

/// Desc:	获取患者列表JSON串;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// Return:	患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EPRservice.Quality.Ajax.disPatientList).GetAdmProcedureListJSON("","2020-12-01","2020-12-24","","0000000347","","","","","")
ClassMethod GetAdmProcedureListJSON(AType As %String, AYType As %String, AStartDate As %String, AEndDate As %String, AMedRecordNo As %String, ARegNo As %String, AName As %String, ACTLocID As %String, ADocCommit As %String, ANurCommit As %String, APDFCreated As %String, SpecialAdm As %String, AHospitalID As %String, doctorID As %String, RcFlag As %String, AEpisodeID As %String) As %String
{
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.GetDisPatientDetail:GetDisProcedureList")
 	s sc = result.Execute(AType,AYType,AStartDate,AEndDate,AMedRecordNo,ARegNo,AName,ACTLocID,ADocCommit,ANurCommit,APDFCreated,SpecialAdm,AHospitalID,doctorID,RcFlag,AEpisodeID)

 //EpisodeID,PatientID,MedRecordNo,RegNo,PAPMIName,PAPMIDOB,PAPMISex,AdmDateTime,DisDateTime,PAAdmDepCodeDR,PAAdmDocCodeDR,PAADMReason,Warddesc,
 //EprDocStatus,EprDocStatusDesc,EprNurStatus,EprNurStatusDesc,EprPdfStatus,EprPdfStatusDesc,ReviewStatus,CheckStatus,CheckRule,CheckDateTime,CheckUser
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
	 	s json = json_"""PatientID"":"""_$g(result.Data("PatientID"))_""","
	 	s json = json_"""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""","
	 	s json = json_"""RegNo"":"""_$g(result.Data("RegNo"))_""","
	 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
	 	s json = json_"""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""","
	 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
	 	s json = json_"""AdmDateTime"":"""_$g(result.Data("AdmDateTime"))_""","
	 	s json = json_"""DisDateTime"":"""_$g(result.Data("DisDateTime"))_""","
	 	s json = json_"""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""","
	 	s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
	 	s json = json_"""PAADMReason"":"""_$g(result.Data("PAADMReason"))_""","
	 	s json = json_"""Warddesc"":"""_$g(result.Data("Warddesc"))_""","
	 	s json = json_"""EprDocStatus"":"""_$g(result.Data("EprDocStatus"))_""","
	 	s json = json_"""EprDocStatusDesc"":"""_$g(result.Data("EprDocStatusDesc"))_""","
	 	s json = json_"""EprNurStatus"":"""_$g(result.Data("EprNurStatus"))_""","
	 	s json = json_"""EprNurStatusDesc"":"""_$g(result.Data("EprNurStatusDesc"))_""","
	 	s json = json_"""EprPdfStatus"":"""_$g(result.Data("EprPdfStatus"))_""","
	 	s json = json_"""EprPdfStatusDesc"":"""_$g(result.Data("EprPdfStatusDesc"))_""","
	 	s json = json_"""ReviewStatus"":"""_$g(result.Data("ReviewStatus"))_""","
	 	s json = json_"""CheckStatus"":"""_$g(result.Data("CheckStatus"))_""","
	 	s json = json_"""CheckRule"":"""_$g(result.Data("CheckRule"))_""","
	 	s json = json_"""CheckDateTime"":"""_$g(result.Data("CheckDateTime"))_""","
		s json = json_"""disReviewStatus"":"""_$g(result.Data("disReviewStatus"))_""","
		s json = json_"""Age"":"""_$g(result.Data("Age"))_""","
	 	s json = json_"""ProblemFlag"":"""_$g(result.Data("ProblemFlag"))_""","
	 	s json = json_"""Illness"":"""_$g(result.Data("Illness"))_""","
		s json = json_"""score"":"""_$g(result.Data("score"))_""","
	 	s json = json_"""TransLocFlag"":"""_$g(result.Data("TransLocFlag"))_""","
	 	s json = json_"""ResidentDays"":"""_$g(result.Data("ResidentDays"))_""","
	 	s json = json_"""QualityFlag"":"""_$g(result.Data("QualityFlag"))_""","
	 	s json = json_"""MainDiagnos"":"""_$g(result.Data("MainDiagnos"))_""","
		s json = json_"""RCInfo"":"""_$g(result.Data("RCInfo"))_""","
	 	s json = json_"""BedNo"":"""_$g(result.Data("BedNo"))_""""
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

}
