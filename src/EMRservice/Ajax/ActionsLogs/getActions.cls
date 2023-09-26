Class EMRservice.Ajax.ActionsLogs.getActions Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("action",1),"")
	if (action = "getType")
	{
		w ..getActionsTypes()
	}
	elseif (action = "getActions")
	{
		s ModelTypeCode = $Get(%request.Data("ModelTypeCode",1),"")
		s ModelDesc = $Get(%request.Data("ModelDesc",1),"")
	
		s page = $g(%request.Data("page",1),"-1")
		s rows = $g(%request.Data("rows",1),"-1")
		s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1	
	
		w ..getActions(ModelTypeCode,ModelDesc,idxStart,idxLast)
	}
	
	Quit $$$OK
}

/// d ##Class(EMRservice.Ajax.ActionsLogs.getActionsTypes).getActionsTypes()
ClassMethod getActionsTypes()
{
	s result = ##Class(web.DHCEventModel).GetTypeJson()
	q result
}

/// w ##Class(EMRservice.Ajax.ActionsLogs.getActions).getActions("1","10")
ClassMethod getActions(AModelTypeCode As %String, AModelDesc As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("web.DHCEventModel:Find")
	s sc = result.Execute("",AModelDesc,AModelTypeCode,"")
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
	 	if (result.Data("ModelFiledSet") = "EMR")
	 	{
		 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
			{
			 	s json = json_"{""ModelRowId"":"""_$g(result.Data("ModelRowId"))_""","
			 	s json = json_"""ModelActive"":"""_$g(result.Data("ModelActive"))_""","
			 	s json = json_"""ModelCode"":"""_$g(result.Data("ModelCode"))_""","
			 	s json = json_"""ModelDesc"":"""_$g(result.Data("ModelDesc"))_""","
			 	s json = json_"""ModelFiledSet"":"""_$g(result.Data("ModelFiledSet"))_""","
			 	s json = json_"""ModelNote"":"""_$g(result.Data("ModelNote"))_""","
			 	s json = json_"""ModelType"":"""_$g(result.Data("ModelType"))_"""}"
			 	s json = json_"," 
		 	}
			s count = count + 1
	 	}
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

}
