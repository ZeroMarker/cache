Class EPRservice.Quality.Ajax.SSUserInfo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s Filtter = $Get(%request.Data("Filtter",1),"")
	
	s action= $Get(%request.Data("action",1),"")
	
	s locId=$Get(%request.Data("locId",1),"")
	
	s method=$Get(%request.Data("method",1),"")
	
	s filterUserName=$Get(%request.Data("filterUserName",1),"")
	s filterLocDesc=$Get(%request.Data("filterLocDesc",1),"")
	
	if method'=""
	{
		s result= ..GetDoctorByDFDeptId(filterUserName,filterLocDesc)
		
	}else
	{
		s result= ..GetUserInfo(locId,Filtter)
	}
	//s result= ..GetUserInfo(locId,Filtter)
	
	w result
	Quit $$$OK
}

/// 获取所有用户
/// debug w ##class(EPRservice.Quality.Ajax.SSUserInfo).GetUserInfo()
ClassMethod GetUserInfo(locId, Filtter) As %String
{
	
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.SSUser:GetDoctorByDeptId")
	d ds.Execute(locId,Filtter)
	While (ds.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""UserId"":"""_ds.Data("ID")_""","
		//s json = json_"""SSUSRInitials"":"""_ds.Data("SSUSRInitials")_""","
		s json = json_"""UserName"":"""_ds.Data("Name")_""""
	    s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

/// 获取所有用户、科室信息
/// debug w ##class(EPRservice.Quality.Ajax.SSUserInfo).GetDoctorByDFDeptId()
ClassMethod GetDoctorByDFDeptId(locId, filter) As %String
{
	
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.SSUser:GetDoctorByDFDeptId")
	d ds.Execute(locId,filter)
	While (ds.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""UserId"":"""_ds.Data("ID")_""","
		s json = json_"""CTPCPID"":"""_ds.Data("CTPCPID")_""","
		s json = json_"""Desc"":"""_ds.Data("Desc")_""","
		s json = json_"""UserName"":"""_ds.Data("Name")_""""
	    s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

}
