Class EPRservice.Quality.Ajax.AiAnalysis Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s StartDate = $Get(%request.Data("StartDate",1),"")
	s EndDate = $Get(%request.Data("EndDate",1),"")
	s Action = $Get(%request.Data("Action",1),"")
	s Input = $Get(%request.Data("Input",1),"")
	if (Action="CorrectRate")
	{
		w ..GetAiCorrectRateJSON(StartDate,EndDate)	
	}elseif (Action="AcceptRate")
	{
		s ^tem("AcceptRate")=..GetAiAcceptRateJSON(StartDate,EndDate)
		w ..GetAiAcceptRateJSON(StartDate,EndDate)
		
	}elseif (Action="CorrectRateView")
	{
		w ..GetAiCorrectRateViewJSON(StartDate,EndDate)
	}
	elseif (Action="AcceptRateView")
	{
		w ..GetAiAcceptRateViewJSON(StartDate,EndDate)
	}elseif (Action="AiErrDetail")||(Action="AiCorrectDetail")||(Action="ManualDetail")
	{
		w ..GetDetailJSON(StartDate,EndDate,Action)
	}elseif (Action="GetTag")
	{
		w ..GetTagJSON()	
	}elseif (Action="SaveTag")
	{
		s ^tem("SaveTag")=Input
		w ##class(EPRservice.Quality.DataAccess.BOQualityAiResult).SaveAiTag(Input)	
	}
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			内涵质控采纳反馈率 表json
/// Input:			AStartDate	评价开始时间
/// 				AEndDate	评价结束时间
/// Output          json
/// Debug: ##class(EPRservice.Quality.Ajax.AiAnalysis).GetAiCorrectRateJSON("2021-06-22","2021-06-28")
ClassMethod GetAiCorrectRateJSON(AStartDate As %String, AEndDate As %String) As %String
{
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiResult:GetCorrectRateData")
 	s sc = result.Execute(AStartDate,AEndDate)

 	s json = ""
 	s count = 0
	While (result.Next())
 	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""startDate"":"""_$g(result.Data("startDate"))_""","
	 	s json = json_"""endDate"":"""_$g(result.Data("endDate"))_""","
	 	s json = json_"""ErrCount"":"""_$g(result.Data("ErrCount"))_""","
	 	s json = json_"""CorrectCount"":"""_$g(result.Data("CorrectCount"))_""","
	 	s json = json_"""Count"":"""_$g(result.Data("Count"))_""","
	 	s json = json_"""CorrectRate"":"""_$j($g(result.Data("CorrectRate"))*100,2,2)_"%"_""""
	 	s json = json_"}"
	 	s json = $tr(json,$c(10),"")
		s json = $tr(json,$c(13),"")
		s count = count + 1		
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			内涵质控采纳反馈率 图json
/// Input:			AStartDate	评价开始时间
/// 				AEndDate	评价结束时间
/// Output          json
/// Debug:##class(EPRservice.Quality.Ajax.AiAnalysis).GetAiCorrectRateViewJSON("2021-06-22","2021-06-28")
ClassMethod GetAiCorrectRateViewJSON(AStartDate As %String, AEndDate As %String) As %String
{
	s json = ""
	s count = 0
	s result = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiResult:GetCorrectRateData")
	s sc = result.Execute(AStartDate,AEndDate)
	While (result.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	//s json = json_"""Date"":"""_$g(result.Data("startDate"))_"~"_$g(result.Data("endDate"))_""","
	 	s json = json_"""Date"":"""_$p($g(result.Data("startDate")),"-",2,*)_"~"_$p($g(result.Data("endDate")),"-",2,*)_""","
	 	s json = json_"""CorrectRate"":"""_$j($g(result.Data("CorrectRate"))*100,2,2)_""""
	 	s json = json_"}"
	    s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			内涵质控人工使用率 表json
/// Input:			AStartDate	评价开始时间
/// 				AEndDate	评价结束时间
/// Output          json
/// Debug:##class(EPRservice.Quality.Ajax.AiAnalysis).GetAiAcceptRateJSON("2021-06-01","2021-07-01")
ClassMethod GetAiAcceptRateJSON(AStartDate As %String, AEndDate As %String) As %String
{
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiResult:GetAcceptRateData")
 	s sc = result.Execute(AStartDate,AEndDate)

 	s json = ""
 	s count = 0
	While (result.Next())
 	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""startDate"":"""_$g(result.Data("startDate"))_""","
	 	s json = json_"""endDate"":"""_$g(result.Data("endDate"))_""","
	 	s json = json_"""AiCount"":"""_$g(result.Data("AiCount"))_""","
	 	s json = json_"""ManualCount"":"""_$g(result.Data("ManualCount"))_""","
	 	s json = json_"""Count"":"""_$g(result.Data("Count"))_""","
	 	s json = json_"""EpiCount"":"""_$g(result.Data("EpiCount"))_""","
	 	s json = json_"""AcceptRate"":"""_$j($g(result.Data("AcceptRate"))*100,2,2)_"%"_""""
	 	s json = json_"}"
	 	s json = $tr(json,$c(10),"")
		s json = $tr(json,$c(13),"")
		s count = count + 1		
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			内涵质控人工使用率 图json
/// Input:			AStartDate	评价开始时间
/// 				AEndDate	评价结束时间
/// Output          json
/// Debug: ##class(EPRservice.Quality.Ajax.AiAnalysis).GetAiAcceptRateViewJSON("2021-07-01","2021-10-01")
ClassMethod GetAiAcceptRateViewJSON(AStartDate As %String, AEndDate As %String) As %String
{
	s json = ""
	s count = 0
	s result = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiResult:GetAcceptRateData")
	s sc = result.Execute(AStartDate,AEndDate)
	While (result.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""Date"":"""_$p($g(result.Data("startDate")),"-",2,*)_"~"_$p($g(result.Data("endDate")),"-",2,*)_""","
	 	s json = json_"""AcceptRate"":"""_$j($g(result.Data("AcceptRate"))*100,2,2)_""""
	 	s json = json_"}"
	    s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			明细json
/// Input:			AStartDate	评价开始时间
/// 				AEndDate	评价结束时间
/// 				Action		类型 AiErrDetail：内涵错误反馈 AiCorrectDetail：内涵正确保存 ManualDetail：手工评价
/// Output          json
/// Debug: ##class(EPRservice.Quality.Ajax.AiAnalysis).GetDetailJSON("2021-06-18","2021-06-24","AiErrDetail")
ClassMethod GetDetailJSON(AStartDate As %String, AEndDate As %String, Action As %String) As %String
{
	s json = ""
	s count = 0
	if (Action="AiErrDetail") {
		s result = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiResult:GetAiErrDetail")
		s sc = result.Execute(AStartDate,AEndDate)
	}elseif (Action="AiCorrectDetail") {
		s result = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiResult:GetAiCorrectDetail")
		s sc = result.Execute(AStartDate,AEndDate,"N")
	}elseif (Action="ManualDetail") {
		s result = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityAiResult:GetAiCorrectDetail")
		s sc = result.Execute(AStartDate,AEndDate,"A")
	}
	While (result.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
	 	s json = json_"""Name"":"""_$g(result.Data("Name"))_""","
	 	s json = json_"""RegNo"":"""_$g(result.Data("RegNo"))_""","
	 	s json = json_"""LocDesc"":"""_$g(result.Data("LocDesc"))_""","
	 	s json = json_"""DoctorDesc"":"""_$g(result.Data("DoctorDesc"))_""","
	 	s json = json_"""EntryTitle"":"""_$g(result.Data("EntryTitle"))_""","
	 	s json = json_"""ErrorText"":"""_$g(result.Data("ErrorText"))_""","	//AiErrDetail
	 	s json = json_"""ResumeText"":"""_$g(result.Data("ResumeText"))_"""," //AiCorrectDetail
	 	s json = json_"""SignUserDesc"":"""_$g(result.Data("SignUserDesc"))_""","
	 	s json = json_"""ExamineDate"":"""_$g(result.Data("ExamineDate"))_""","
	 	s json = json_"""Tag"":"""_$g(result.Data("Tag"))_""","
	 	s json = json_"""TagDesc"":"""_$g(result.Data("TagDesc"))_""","
	 	
	 	s json = json_"""Remarks"":"""_$g(result.Data("Remarks"))_""""
	 	s json = json_"}"
	    s count = count + 1
	}
	
	s json = "["_json_"]"
	q json
}

/// Creator:	    qy
/// Create Date:	2020
/// Desc:			标记类型json
/// Input:			
/// Output          json
/// Debug:##class(EPRservice.Quality.Ajax.AiAnalysis).GetTagJSON()
ClassMethod GetTagJSON() As %String
{
	s AiErrTag=##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("AiErrTag")
	s TagObj={}.%FromJSON(AiErrTag)
	s json = ""
	s count = 0
	set iter = TagObj.%GetIterator()
	while iter.%GetNext(.key , .value ) {
		s:(count '=0) json =json_","
		s json = json_"{"
	 	s json = json_"""Tag"":"""_key_""","
		s value = ##class(EMRservice.HISInterface.Translation).Get("dhc.emr.quality.AiAnalysisData.csp",value)
	 	s json = json_"""TagDesc"":"""_value_""""
	 	s json = json_"}"
	    s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

}
