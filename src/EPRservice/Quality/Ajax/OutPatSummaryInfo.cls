/// 总结内容
Class EPRservice.Quality.Ajax.OutPatSummaryInfo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s summary = $Get(%request.Data("summary",1),"")
	s Dates=$Get(%request.Data("Dates",1),"")
	
	s:(Dates[" ") Dates=$tr(Dates," ","")
	s date=$zd($h,3)
	s submit=$o(^DHCEPRQ.OutPatSummaryInfoI("IdxSummaryDate"," "_Dates,""))
	if (submit'="") //修改
	{
		w ..UpdateSummaryInfo(summary,date,Dates)
		Quit $$$OK
	}
	
	w ..InsertSummaryInfo(summary,date,Dates) //提交
	Quit $$$OK
}

ClassMethod InsertSummaryInfo(summary As %String, date As %String, Dates As %String) As %String
{
	s result="提交失败"
	q:(summary="")||(Dates="") result
	s OBJSummary=##class(EPRinstance.Quality.OutPatSummaryInfo).%New()
	s OBJSummary.Summary=summary
	s OBJSummary.submitDate=date
	s OBJSummary.SummaryDate=Dates
	s sc=OBJSummary.%Save()
	if ($$$ISERR(sc))
	{
		s Error = $system.OBJ.DisplayError(sc)
		s result = result_"^"_Error
	}
	else
	{
		s StRowId = OBJSummary.%Id()
		s result = "提交成功"
	}
	
	q result
}

/// 修改指定分配日期的总结信息
/// WZL
ClassMethod UpdateSummaryInfo(summary As %String, date As %String, Dates As %String) As %String
{
	s result="修改失败"
	q:(Dates="")||(summary="")||(date="") result
	s dates=" "_Dates
	s rowId=$o(^DHCEPRQ.OutPatSummaryInfoI("IdxSummaryDate",dates,""))
	q:(rowId="") result
	s OBJSummary=##class(EPRinstance.Quality.OutPatSummaryInfo).%OpenId(rowId)
	s OBJSummary.Summary=summary
	s OBJSummary.submitDate=date
	s OBJSummary.SummaryDate=Dates
	s sc=OBJSummary.%Save()
	
	if ($$$ISERR(sc))
	{
		s Error = $system.OBJ.DisplayError(sc)
		s result = result_"^"_Error
	}
	else
	{
		s StRowId = OBJSummary.%Id()
		s result = "修改成功"
	}
	
	q result
}

}
