Class web.eprajax.dental.ToothRecord Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s patientID = $Get(%request.Data("PatientID",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s dataFlag = $Get(%request.Data("DataFlag",1),"")
	s toothPositionCode = $Get(%request.Data("ToothPositionCode",1),"")
	s currentAdmFlag = $Get(%request.Data("CurrentAdmFlag",1),"")
	
	if (dataFlag = "") {s dataFlag="21"}
	s json = ..GetToothRecord(patientID,episodeID,dataFlag,toothPositionCode,currentAdmFlag)
	w json
	
	q $$$OK
}

/// Debug:	w ##class(web.eprajax.dental.ToothRecord).GetToothRecord("13","15","1","13")
ClassMethod GetToothRecord(APatientID, AEpisodeID, ADataFlag, AToothPositionCode, ACurrentAdmFlag) As %String
{
	//s ^CacheTempDHCEPRDebug("web.eprajax.dental.ToothRecord","input")= APatientID_","_AEpisodeID_","_ADataFlag_","_AToothPositionCode
	//q "{""total"":0,""rows"":[]}"
	
	s count = "0",json=""
	q:(APatientID="")||(AEpisodeID="") "{""total"":"""_count_""",""rows"":["_json_"]}"
	
	s rs = ##Class(%ResultSet).%New("EPRservice.BLL.Dental.BLToothRecord:GetToothRecord")
	s sc = rs.Execute(APatientID, AEpisodeID, ADataFlag, AToothPositionCode,ACurrentAdmFlag)	
	While (rs.Next()){
		s count = count + 1
		if (count > 1) s json =json_","
		s json = json_"{"
		s json = json_"""EpisodeID"":"""_rs.Data("EpisodeID")_""","	
		s json = json_"""AdmDate"":"""_rs.Data("AdmDate")_""","
		s json = json_"""ToothPositionCode"":"""_rs.Data("ToothPositionCode")_"""," 
		s json = json_"""RecordContent"":"""_rs.Data("RecordContent")_"""," 
		s json = json_"""UpdateDate"":"""_rs.Data("UpdateDate")_""""
		s json = json_"}"
	}	
	d rs.Close()
	
	s json = "{""total"":"""_count_""",""rows"":["_json_"]}"
	
	/*
	s json = $tr(json,$c(13),"&keyenter")
	s json = $tr(json,$c(0),"&nbsp")
	s json = $tr(json,$c(10),"&keyenter")
	*/
	//s json = ##Class(EPRservice.Util.StringHelper).Replace(json,$c(0),"&nbsp")
	s json = ##Class(EPRservice.Util.StringHelper).Replace(json,$c(10),"&keyenter")
	s json = ##Class(EPRservice.Util.StringHelper).Replace(json,$c(13),"&keyenter")
	
	q json
}

}
