/// <H3>综合检测系统接口</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建日期：2012-08-07</H4>
Class DHCMed.CCService.IntegratedControl.Interface Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// <H3>通过关键字获取监控结果列表</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>:就诊号，Paadm</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>KeywordCode</B>：关键字代码，可以参见DHCMed.CC.KeyWord类的代码</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回结果集</P>
/// <P>内容类型：DHCMed.CC.CtlResult类的实例</P>	
/// <H4>实例</H4>
/// s a=##class(DHCMed.CCService.IntegratedControl.Interface).GetCtlResultListByKeyword(4,2,"Anti")
ClassMethod GetCtlResultListByKeyword(EpisodeID As %String, SubjectID As %Integer, KeywordCode As %String) As %ListOfObjects
{
	 Quit ##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultListByKeyword(EpisodeID,SubjectID,KeywordCode)
}

/// <H3>功能:按关键字汇总监控结果</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>:就诊号，Paadm</LI>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>KeywordCode</B>：关键字代码,DHCMed.CC.KeyWord的Code字段</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回结果字符串</P>
/// <P>格式：</P>
/// {数量}^{得分}
/// <H4>实例</H4>
/// w ##class(DHCMed.CCService.IntegratedControl.Interface).GetCtlResultSubTotalKeyWord(4,2,"Anti")
ClassMethod GetCtlResultSubTotalKeyWord(EpisodeID As %String, SubjectID As %String, KeywordCode As %String) As %String
{
	 Quit ##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultSubTotalKeyWord(EpisodeID,SubjectID,KeywordCode)
}

/// <H3>通过触发日期、关键字获取监控结果列表</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>KeywordCode</B>：关键字代码，可以参见DHCMed.CC.KeyWord类的代码</LI>
/// <LI><B>FromDate</B>：触发开始日期，Cache日期格式</LI>
/// <LI><B>ToDate</B>：触发结束日期，Cache日期格式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回结果集</P>
/// <P>内容类型：DHCMed.CC.CtlResult类的实例</P>
/// <H4>实例</H4>
/// Set a=##class(DHCMed.CCService.IntegratedControl.Interface).GetCtlResultListByKeywordActDate(2,"Anti",$zdh("2012-07-01",3),$zdh("2012-07-31",3))
ClassMethod GetCtlResultByKeywordActDate(SubjectID As %String, KeywordCode As %String, FromDate As %Date, ToDate As %Date) As %ListOfObjects
{
	Quit ##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultByKeywordActDate(SubjectID,KeywordCode,FromDate,ToDate)
}

/// <H3>通过触发日期、关键字获取监控汇总</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>SubjectID</B>：监控主题ID</LI>
/// <LI><B>KeywordCode</B>：关键字代码，可以参见DHCMed.CC.KeyWord类的代码</LI>
/// <LI><B>FromDate</B>：触发开始日期，Cache日期格式</LI>
/// <LI><B>ToDate</B>：触发结束日期，Cache日期格式</LI>
/// </OL>
/// <H4>返回值:</H4>
/// <P>如果程序运行成功，返回字符串</P>
/// <P>格式：{数量}^{分数}</P>
/// w ##class(DHCMed.CCService.IntegratedControl.Interface).GetCtlResultSummaryByKeywordActDate(2,"Anti",$zdh("2012-07-01",3),$zdh("2012-07-31",3))
ClassMethod GetCtlSummaryByKeywordActDate(SubjectID As %String, KeywordCode As %String, FromDate As %Date, ToDate As %Date) As %String
{
	Quit ##class(DHCMed.CCService.Feedback.ResultService).GetCtlSummaryByKeywordActDate(SubjectID,KeywordCode,FromDate,ToDate)
}

/// <H4>参数:</H4>
/// <OL>
/// <LI><B>FromDate</B>监控开始日期，支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// <LI><B>ToDate</B>监控结束日期，支持日期格式：（1）Cache的日期格式，（2）YYYY-MM-DD格式 （3）DD/MM/YYYY</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功，返回字符串  OK
/// <H4>备注</H4>
/// 如果类库产生了运行异常，系统会将错误日志存储在类<B>DHCMed.CC.ErrorLog</B>中，管理员应该经常检查此实体类的内容。
/// <H4>实例</H4>
/// w ##class(DHCMed.CCService.IntegratedControl.Interface).InpatientAutoWork($zdh("2012-08-19",3),$zdh("2012-08-19",3))
ClassMethod InpatientAutoWork(FromDate As %String, ToDate As %String)
{
	Set $ZT="ErrorHander"
	Quit ##class(DHCMed.CCService.AutoProcess.AutoWorkService).InpatientAutoWork(FromDate,ToDate)
ErrorHander
	Q 1
}

/// s b=##class(DHCMed.CCService.IntegratedControl.Interface).Test()
ClassMethod Test()
{
	Set a=##class(%ListOfObjects).%New()
	do a.%Close()
	
	For i=1:1:50000
	{
		Set objResult=##class(DHCMed.CC.CtlResult).%OpenId(307)
		Do objResult.%Close()
		w a.Insert(objResult)
	}
	Quit a
}

}
