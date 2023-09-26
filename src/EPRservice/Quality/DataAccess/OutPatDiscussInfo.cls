/// 质控科主任讨论信息访问
Class EPRservice.Quality.DataAccess.OutPatDiscussInfo Extends %RegisteredObject
{

/// 添加讨论数据
ClassMethod InsertDiscussInfo(idea As %String, DiscussDates As %String, date As %String) As %String
{
	s result="提交失败"
	q:(idea="") result
	
	s OBJDiscuss=##class(EPRinstance.Quality.OutPatDiscussInfo).%New()
	s OBJDiscuss.Idea=idea
	s OBJDiscuss.DiscussDates=DiscussDates
	s OBJDiscuss.submitDate=date
	s sc=OBJDiscuss.%Save()
	if ($$$ISERR(sc))
	{
		s Error = $system.OBJ.DisplayError(sc)
		s result = result_"^"_Error
	}
	else
	{
		s StRowId = OBJDiscuss.%Id()
		s result = "提交成功"
	}
	
	q result
}

/// 获取讨论历史数据
/// ^DHCEPRQ.OutPatDiscussInfoI("IdxDiscussDates")
/// w ##class(EPRservice.Quality.DataAccess.OutPatDiscussInfo).GetDiscussInfo(" 2019-02-12至2019-02-12")
ClassMethod GetDiscussInfo(DiscussDates As %String) As %String
{
	s result=""
	s:(DiscussDates'[" ") DiscussDates=" "_DiscussDates //通过索引里、特殊情况处理
	q:(DiscussDates="") result
	s rowId=""
	for{
		s rowId=$o(^DHCEPRQ.OutPatDiscussInfoI("IdxDiscussDates",DiscussDates,rowId))
		q:(rowId="")
		s OBJDiscussInfo=##class(EPRinstance.Quality.OutPatDiscussInfo).%OpenId(rowId)
		s DiscussInfo=OBJDiscussInfo.Idea
		s SubmitDate=OBJDiscussInfo.submitDate
		s result= result_DiscussInfo_"/"_SubmitDate_"^"
	}
	
	q $e(result,1,*-1)
}

/// 获取讨论日期段数据
/// ^DHCEPRQ.OutPatDiscussInfoI("IdxDiscussDates")
/// w ##class(EPRservice.Quality.DataAccess.OutPatDiscussInfo).GetDiscussDatesInfo()
ClassMethod GetDiscussDatesInfo() As %String
{
	s result=""
	
	s DiscussDates=""
	for
	{
		s DiscussDates=$o(^DHCEPRQ.OutPatDiscussInfoI("IdxDiscussDates",DiscussDates))
		q:(DiscussDates="")
		
		s result= result_DiscussDates_"/"
	}
	
	q $e(result,1,*-1)
}

/// 修改讨论历史数据
/// ^DHCEPRQ.OutPatDiscussInfoI("IdxDiscussDates")
/// w ##class(EPRservice.Quality.DataAccess.OutPatDiscussInfo).UpDateDiscussInfo()
ClassMethod UpDateDiscussInfo(Idea As %String, DiscussDates As %String, date As %String) As %String
{
	s result="修改失败"
	q:(DiscussDates="")||(Idea="")||(date="") result
	s:(DiscussDates'[" ") DiscussDates=" "_DiscussDates //通过索引里、特殊情况处理
	
	s rowId=$o(^DHCEPRQ.OutPatDiscussInfoI("IdxDiscussDates",DiscussDates,""))
	q:(rowId="") result
	s OBJDiscussInfo=##class(EPRinstance.Quality.OutPatDiscussInfo).%OpenId(rowId)
	q:(OBJDiscussInfo="") result
	s OBJDiscussInfo.Idea=Idea
	s OBJDiscussInfo.submitDate=date
	s sc=OBJDiscussInfo.%Save()
	
	if ($$$ISERR(sc))
	{
		s Error = $system.OBJ.DisplayError(sc)
		s result = result_"^"_Error
	}
	else
	{
		s StRowId = OBJDiscussInfo.%Id()
		s result = "修改成功"
	}
	
	q result
}

}
