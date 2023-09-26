Class EPRservice.Quality.Ajax.patientInfoList Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s AdmStatus = $Get(%request.Data("AdmStatus",1),"")
	s startDate = $Get(%request.Data("StartDate",1),"")
	s endDate = $Get(%request.Data("EndDate",1),"")
	s medicareNo = $Get(%request.Data("MedicareNo",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	s patName = $Get(%request.Data("PatName",1),"")
	s LocID = $Get(%request.Data("ALocID",1),"")
	s SpecialAdm = $Get(%request.Data("SpecialAdm",1),"")
	s Reclaim = $Get(%request.Data("Reclaim",1),"")
	s ischecked = $Get(%request.Data("ischecked",1),"")
	s Diagnos= $g(%request.Data("Diagnos",1),"")
	s HospitalID=$g(%request.Data("HospitalID",1),"")
	s:(HospitalID="") HospitalID=$g(%session.Data("LOGON.HOSPID"))
	
	s idxStart = $g(%request.Data("start",1),"-1")
	s pageSize = $g(%request.Data("limit",1),"-1")
	s idxLast = idxStart + pageSize - 1	
	//s result = ..GetEPREpisodeListJSON(AdmStatus,startDate,endDate,medicareNo,LocID,SpecialAdm,HospitalID,idxStart,idxLast)
	/*while (result.AtEnd = 0)
	{
		w $ZSTRIP(result.Read(32000),"*C",,$c(1)_$c(2))
	}*/
	w ..GetEPREpisodeListJSON(AdmStatus,startDate,endDate,medicareNo,LocID,SpecialAdm,HospitalID,idxStart,idxLast,Diagnos,ischecked,regNo,patName,Reclaim)
	q $$$OK
}

/// Desc:	获取患者列表JSON串;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// Return:	患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EPRservice.Quality.Ajax.patientInfoList).GetEPREpisodeListJSON("D","2022-06-01","2022-06-13","","","","2","-1",-3,"","")
ClassMethod GetEPREpisodeListJSON(AdmStatus As %String, AStartDate As %String, AEndDate As %String, AMedicareNo As %String, ALocID As %String, SpecialAdm As %String, HospitalID As %String, AIdxStart As %String, AIdxLast As %String, Diagnos As %String, ischecked As %String, ARegNo As %String, APatName As %String, Reclaim As %String = "")
{
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.GetPaAdmDetail:GetPaAdmList")
 	s sc = result.Execute(AStartDate,AEndDate,AdmStatus,AMedicareNo,ALocID,SpecialAdm,HospitalID,Diagnos,"",ischecked,ARegNo,APatName,Reclaim)
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""EpisodeID"":"""_$g(result.Data("PAADMRowID"))_""","
	 	s json = json_"""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""","
	 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
	 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""ManualFlag"":"""_$g(result.Data("ManualFlag"))_""","
		 	s json = json_"""DisManualFlag"":"""_$g(result.Data("DisManualFlag"))_""","
			s json = json_"""CreateDisUser"":"""_$g(result.Data("CreateDisUser"))_""","
		 	s json = json_"""MessageFlag"":"""_$g(result.Data("MessageFlag"))_""","
		 	s json = json_"""MainDiagnos"":"""_$g(result.Data("MainDiagnos"))_""","
		 	s json = json_"""ProblemFlag"":"""_$g(result.Data("ProblemFlag"))_""","
		 	s json = json_"""DisDate"":"""_$g(result.Data("DisDate"))_""","
		 	s json = json_"""PAAdmDepCodeDR"":"""_$g(result.Data("PAAdmDepCodeDR"))_""","
		 	s json = json_"""PAAdmDocCodeDR"":"""_$g(result.Data("PAAdmDocCodeDR"))_""","
		 	s json = json_"""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""","
		 	s json = json_"""StatusDesc"":"""_$g(result.Data("StatusDesc"))_""","
		 	s json = json_"""AdmDateTime"":"""_$g(result.Data("AdmDateTime"))_""","
		 	s json = json_"""BedNo"":"""_$g(result.Data("BedNo"))_""","
		 	s json = json_"""CreateAdmUser"":"""_$g(result.Data("CreateAdmUser"))_""","
		 	s json = json_"""Illness"":"""_$g(result.Data("Illness"))_""","
		 	s json = json_"""AdmRecordStatus"":"""_$g(result.Data("AdmRecordStatus"))_""","
		 	s json = json_"""QualityFlag"":"""_$g(result.Data("QualityFlag"))_""","
			s json = json_"""QualityDT"":"""_$g(result.Data("QualityDT"))_""","
		 	s json = json_"""DeathDate"":"""_$g(result.Data("DeathDate"))_""","
		 	s json = json_"""InPathWayStatus"":"""_$g(result.Data("InPathWayStatus"))_""","
		 	s json = json_"""Attending"":"""_$g(result.Data("Attending"))_""","
		 	s json = json_"""Chief"":"""_$g(result.Data("Chief"))_""","
		 	s json = json_"""OutManualFlag"":"""_$g(result.Data("OutManualFlag"))_""","
		 	s json = json_"""CreateOutUser"":"""_$g(result.Data("CreateOutUser"))_""","
		 	s json = json_"""KSManualFlag"":"""_$g(result.Data("KSManualFlag"))_""","
		 	s json = json_"""BSManualFlag"":"""_$g(result.Data("BSManualFlag"))_""","
		 	s json = json_"""KSUser"":"""_$g(result.Data("KSUser"))_""","
		 	s json = json_"""BSUser"":"""_$g(result.Data("BSUser"))_""","
		 	s json = json_"""TransLocFlag"":"""_$g(result.Data("TransLocFlag"))_""","
			s json = json_"""RegNo"":"""_$g(result.Data("RegNo"))_""","
		 	s json = json_"""ResidentDays"":"""_$g(result.Data("ResidentDays"))_""","
		 	
	 	s json = json_"""Age"":"""_$g(result.Data("Age"))_""""
	 	s json = json_"}"
	 	s json = $tr(json,$c(10),"")
		s json = $tr(json,$c(13),"")
		s json = $tr(json,$c(92),"")
		s count = count + 1		
	}
	
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
}

}
