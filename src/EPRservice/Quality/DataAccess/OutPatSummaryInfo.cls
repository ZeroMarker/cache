/// /// 质控员总结表数据访问
Class EPRservice.Quality.DataAccess.OutPatSummaryInfo Extends %RegisteredObject
{

/// 获取总结提交日期
/// w ##class(EPRservice.Quality.DataAccess.OutPatSummaryInfo).GetSubmitDateInfo()
ClassMethod GetSubmitDateInfo()
{
	s ret=""
	
	s date=""
	for
	{
		s date=$o(^DHCEPRQ.OutPatSummaryInfoI("IdxSubmitDate",date))
		q:(date="")
		s ret=ret_date_"/"
	}
	
	q $e(ret,1,*-1)
}

/// 获取总结选择的日期段
/// w ##class(EPRservice.Quality.DataAccess.OutPatSummaryInfo).GetSummaryDateInfo()
ClassMethod GetSummaryDateInfo()
{
	s ret=""
	
	s date=""
	for
	{
		s date=$o(^DHCEPRQ.OutPatSummaryInfoI("IdxSummaryDate",date))
		q:(date="")
		s ret=ret_date_"/"
	}
	
	q $e(ret,1,*-1)
}

/// 获取指定书写日期的总结内容
/// w ##class(EPRservice.Quality.DataAccess.OutPatSummaryInfo).GetSummaryInfoByDate(" 2020-08-11")
ClassMethod GetSummaryInfoByDate(date As %String) As %String
{
	s ret=""
	s:(date'[" ") date=" "_date //处理特殊情况
	q:(date="") ret
	
	s rowId=$o(^DHCEPRQ.OutPatSummaryInfoI("IdxSubmitDate",date,""))
	
	q:(rowId="") ret
	
	s OBJSummaryInfo=##class(EPRinstance.Quality.OutPatSummaryInfo).%OpenId(rowId)
	
	s ret=OBJSummaryInfo.Summary
	
	q ret
}

/// 获取指定分配日期的总结内容
/// w ##class(EPRservice.Quality.DataAccess.OutPatSummaryInfo).GetSummaryInfoByDate(" 2020-08-11")
ClassMethod GetInfoBySummaryDate(date As %String) As %String
{
	s ret=""
	
	s:(date'[" ") date=" "_date //处理特殊情况
	q:(date="") ret
	
	s rowId=$o(^DHCEPRQ.OutPatSummaryInfoI("IdxSummaryDate",date,""))
	
	q:(rowId="") ret
	
	s OBJSummaryInfo=##class(EPRinstance.Quality.OutPatSummaryInfo).%OpenId(rowId)
	
	s ret=OBJSummaryInfo.Summary
	
	q ret
}

/// 清总结数据用
/// d ##class(EPRservice.Quality.DataAccess.OutPatSummaryInfo).Killer()
ClassMethod Killer()
{
	k ^DHCEPRQ.OutPatSummaryInfoD
	k ^DHCEPRQ.OutPatSummaryInfoS
	k ^DHCEPRQ.OutPatSummaryInfoI
}

}
