Class EMRservice.Ajax.PersonalWaitSign Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	
	s userID = $Get(%request.Data("UserID",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s interface = $Get(%request.Data("AInterface",1),"")
	
	if (action = "GetRecordList")
	{
		w ##Class(EMRservice.Ajax.PersonalWaitSign).GetRecordData(userID,interface,idxStart,idxLast)
	}
	
	Quit $$$OK
}

/// Desc:	获取医生待签列表JSON串;
/// Input:	AUserID为登录用户RowID;
/// 		AInterface病历链接类型，HISUI:hisui版融合界面 空或其他：非融合界面
/// Return:	待签病历列表JSON串,格式为{totalCount:"_count_",data:["_json_"]};
/// Debug:	w ##Class(EMRservice.Ajax.PersonalWaitSign).GetRecordData("10210","HISUI","1","20")
ClassMethod GetRecordData(AUserID As %String, AInterface As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{

 	q:(AUserID = "")||(AIdxStart = "")||(AIdxLast = "") "{""total"":"_count_",""rows"":["_json_"]}"
 	
 	s json = ""
 	s count = 0
 	s result = ##Class(%ResultSet).%New("EMRservice.InterfaceService.WaitSign:GetEMRWaitSign")
	s sc = result.Execute(AUserID,AInterface)
	
	While (result.Next())
 	{
	 	
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	s json = json_"""PapmiNO"":"""_$g(result.Data("PapmiNO"))_""","
		 	s json = json_"""PapmiName"":"""_$g(result.Data("PapmiName"))_""","
		 	s json = json_"""DoucumnetDesc"":"""_$g(result.Data("DoucumnetDesc"))_""","
		 	s json = json_"""InstanceID"":"""_$g(result.Data("InstanceID"))_""","
		 	s json = json_"""SignUserName"":"""_$g(result.Data("SignUserName"))_""","
		 	s json = json_"""EMRStatus"":"""_$g(result.Data("EMRStatus"))_""","
		 	s json = json_"""RecordURL"":"""_result.Data("url")_""","
		 	s json = json_"""documentType"":"""_result.Data("documentType")_""","
		 	s json = json_"""chartItemType"":"""_result.Data("chartItemType")_""","
		 	s json = json_"""templateId"":"""_result.Data("templateId")_""","
		 	s json = json_"""isLeadframe"":"""_result.Data("isLeadframe")_""","
		 	s json = json_"""characteristic"":"""_result.Data("characteristic")_""","
		 	s json = json_"""isMutex"":"""_result.Data("isMutex")_""","
		 	s json = json_"""categoryId"":"""_result.Data("categoryId")_""","
		 	s json = json_"""patientID"":"""_result.Data("patientID")_""","
		 	s json = json_"""DocID"":"""_$g(result.Data("DocID"))_"""}"
		 	s json = json_"," 
		 }
		 s count = count + 1
	}
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

}
