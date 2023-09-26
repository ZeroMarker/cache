Class EPRservice.Quality.Ajax.MedDoctor Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s userId=$Get(%request.Data("userId",1),"")
	
	s userName=$Get(%request.Data("userName",1),"")
	
	s range=$Get(%request.Data("range",1),"")
	
	s stDate=$Get(%request.Data("stDate",1),"")
	
	s edDate=$Get(%request.Data("edDate",1),"")
	
	s filter=$Get(%request.Data("filter",1),"")
	
	s locInfo=$Get(%request.Data("locInfo",1),"")
	
	w ..GetMedDoctorInfo(userId,range,stDate,edDate,filter,locInfo)
	
	Quit $$$OK
}

/// 获取所有质控用户
/// debug w ##class(EPRservice.Quality.Ajax.MedDoctor).GetMedDoctorInfo("","","","")
ClassMethod GetMedDoctorInfo(userId, range, stDate, edDate, filter = "0", locInfo = "") As %String
{
		s json = ""
		///UserId,Range,UserName,StartDate,EndDate
		s result = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.MedDoctor:GetMedDoctorInfo")
	 	s sc = result.Execute(userId,range,stDate,edDate,filter,locInfo)
	 	s count=0
		While (result.Next())
	 	{
		 	s:(count '=0) json =json_","
			s json = json_"{"
		 	s json = json_"""UserId"":"""_$g(result.Data("UserId"))_""","
		 	s json = json_"""UserName"":"""_$g(result.Data("UserName"))_""","
		 	s json = json_"""StartDate"":"""_$g(result.Data("StartDate"))_""","  
		 	s json = json_"""EndDate"":"""_$g(result.Data("EndDate"))_""","
		 	   
		 	s json = json_"""Range"":"""_$g(result.Data("Range"))_""","
		 	//LocDesc
		 	//CTPCPID
		 	s json = json_"""Grade"":"""_$g(result.Data("Grade"))_""","
		 	s json = json_"""LocId"":"""_$g(result.Data("CTPCPID"))_""","
		 	s json = json_"""LocDesc"":"""_$g(result.Data("LocDesc"))_""""
		 	
		 	s json = json_"}"
		 	s json = $tr(json,$c(10),"")
			s json = $tr(json,$c(13),"")
			s count = count + 1		
		}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	
	q json
}

/// debug:w ##class(EPRservice.Quality.Ajax.MedDoctor).GetEffectiveUserByRange($p($h,",",1),"IA")
ClassMethod GetEffectiveUserByRange(date, Range) As %String
{
	s ret=""
	q:(Range="") ret
	
	s:(date="") date=$p($h,",",1)
	
	s result = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.MedDoctor:GetMedDoctorInfo")
 	s sc = result.Execute("",Range,"","")
 	
	While (result.Next())
 	{
	 	//s startDate=$zdh(result.Data("StartDate"),3)
	 	//s endDate=$zdh(result.Data("EndDate"),3)
		//使用ChangeTimeToSys方法做时间格式转换，避免时间格式为22/07/2022时无法成功转换报错
		s startDate=##class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(result.Data("StartDate"))
	 	s endDate=##class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(result.Data("EndDate"))
	 	continue:(date<startDate)||(date>endDate)
	 	s userId=result.Data("UserId")
	 	s:(ret'="") ret=ret_"^"_userId
	 	s:(ret="") ret=userId
	}
	
	q ret
}

/// debug:w ##class(EPRservice.Quality.Ajax.MedDoctor).GetEffectiveUserByRange($p($h,",",1),"IA")
ClassMethod GetEffectiveUserInfoByRange(date, Range) As %String
{
	s ret=""
	q:(Range="") ret
	
	s:(date="") date=$p($h,",",1)
	
	s result = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.MedDoctor:GetMedDoctorInfo")
 	s sc = result.Execute("",Range,"","")
 	
	While (result.Next())
 	{
	 	//s startDate=$zdh(result.Data("StartDate"),3)
	 	//s endDate=$zdh(result.Data("EndDate"),3)
		//使用ChangeTimeToSys方法做时间格式转换，避免时间格式为22/07/2022时无法成功转换报错
		s startDate=##class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(result.Data("StartDate"))
	 	s endDate=##class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(result.Data("EndDate"))
	 	continue:(date<startDate)||(date>endDate)
	 	s userId=result.Data("UserId")
	 	s:(ret'="") ret=ret_"^"_userId_"-"_result.Data("UserName")
	 	s:(ret="") ret=userId_"-"_result.Data("UserName")
	}
	
	q ret
}

}
