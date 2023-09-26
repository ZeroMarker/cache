Class web.eprajax.lockpatiet Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s type = $Get(%request.Data("Type",1),"")
	s locID = $Get(%request.Data("LocId",1),"")
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"")
	s UserID=$Get(%request.Data("UserID",1),"")
	s AllLock=$Get(%request.Data("AllLock",1),"")
	s RowId=$Get(%request.Data("RowId",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s IsUnLockUserID = $Get(%request.Data("IsUnLockUserID",1),"")
	s ^tempyhy("action")=action_","_UserID_","_EpisodeID_","_AllLock
	if (action = "GetCTLocID")
	{
 		w ..GetCTLocID(type)
 		
	}elseif (action = "GetUserID")
	{
		w ..GetUserID(locID)
	}
	elseif (action = "SetData")
	{
		
		s stDate=$zd($h,3)
		w ##Class(EPRservice.Quality.BOLockPatient).SetData(UserID,EpisodeID,stDate,AllLock,IsUnLockUserID)
	}
	elseif (action = "GetDataList")
	{
		w ##class(EPRservice.Quality.BOLockPatient).GetDataList()
	}
	elseif (action = "DeletData")
	{
		w ##class(EPRservice.Quality.BOLockPatient).DeletData(RowId)
	}
	Quit $$$OK
}

/// Desc:获取科室ID、科室Name
/// w ##Class(web.eprajax.usercopypastepower).GetCTLocID("E")
ClassMethod GetCTLocID(AType As %String)
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.Location:GetLocationList")
	d ds.Execute(AType,"","")
	While (ds.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""ID"":"""_ds.Data("ID")_""","
		s json = json_"""Name"":"""_ds.Data("Name")_""""
	    s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

/// Desc:依据科室ID获取用户ID、用户Name
ClassMethod GetUserID(ALocID As %String)
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.SSUser:GetUserDataList")
	d ds.Execute("",ALocID)
	While (ds.Next())
	{
		if (ds.Data("UserID")'=""){
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""UserID"":"""_ds.Data("UserID")_""","
			s json = json_"""UserDesc"":"""_ds.Data("UserDesc")_""""
	    	s json = json_"}"
			s count = count + 1
		}
	}
	s json = "["_json_"]"
	q json
}

}
