Class web.eprajax.eprepisodelistFS Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s AdmStatus = $Get(%request.Data("AdmStatus",1),"")
	s startDate = $Get(%request.Data("StartDate",1),"")
	s endDate = $Get(%request.Data("EndDate",1),"")
	s medicareNo = $Get(%request.Data("MedicareNo",1),"")
	s ctlocid = $Get(%request.Data("ctlocid",1),"")
	
	s idxStart = $g(%request.Data("start",1),"-1")
	s pageSize = $g(%request.Data("limit",1),"-1")
	s idxLast = idxStart + pageSize - 1	
	//s ^tempyhy("1")=AdmStatus_","_startDate_","_endDate_","_medicareNo_","_idxStart_","_idxLast_","_ctlocid
	s retJSON = ..GetEPREpisodeListJSON(AdmStatus,startDate,endDate,medicareNo,idxStart,idxLast,ctlocid)
	w retJSON
	
	q $$$OK
}

/// Desc:	获取患者列表JSON串;
/// 		AIdxStart为分页开始点;
/// 		AIdxLast为分页结束点;
/// Return:	患者列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(web.eprajax.eprepisodelistFS).GetEPREpisodeListJSON("0","2016-04-12","2016-04-20","",1,20,"245")
ClassMethod GetEPREpisodeListJSON(AdmStatus As %String, AStartDate As %String, AEndDate As %String, AMedicareNo As %String, AIdxStart As %Integer, AIdxLast As %Integer, ctlocid As %String)
{
	s result = ##Class(%ResultSet).%New("EPRservice.BOGetPaAdmDetail:GetPaAdmList")
 	s sc = result.Execute(AStartDate,AEndDate,AdmStatus,AMedicareNo,ctlocid)
 	
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
		 	s json = json_"MedicareNo:'"_$g(result.Data("MedicareNo"))_"',"
		 	s json = json_"PAPMIName:'"_$g(result.Data("PAPMIName"))_"',"
		 	s json = json_"PAPMIDOB:'"_$g(result.Data("PAPMIDOB"))_"',"
		 	s json = json_"PAPMISex:'"_$g(result.Data("PAPMISex"))_"',"
		 	s json = json_"EprDocStatusDesc:'"_$g(result.Data("EprDocStatusDesc"))_"',"
		 	s json = json_"EstimDischDate:'"_$g(result.Data("DisDate"))_"',"
		 	s json = json_"AdmDate:'"_$g(result.Data("AdmDate"))_"',"
		 	s json = json_"PAAdmDepCodeDR:'"_$g(result.Data("PAAdmDepCodeDR"))_"',"
		 	s json = json_"PAAdmDocCodeDR:'"_$g(result.Data("PAAdmDocCodeDR"))_"',"
		 	s json = json_"PAAdmWard:'"_$g(result.Data("PAAdmWard"))_"',"
		 	s json = json_"StatusDesc:'"_$g(result.Data("StatusDesc"))_"',"
		 	s json = json_"mrEpisodeID:'"_$g(result.Data("mrEpisodeID"))_"',"
		 	s json = json_"MRVerItemsIDs:'"_$g(result.Data("MRVerItemsIDs"))_"',"
		 	s json = json_"EprNurStatusDesc:'"_$g(result.Data("EprNurStatusDesc"))_"',"
		 	s json = json_"EprPdfStatusDesc:'"_$g(result.Data("EprPdfStatusDesc"))_"',"
		 	s json = json_"Warddesc:'"_$g(result.Data("Warddesc"))_"'}"
		 	
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
