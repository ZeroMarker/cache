Import SQLUser

/// 创建时间		：2008.04.11
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			: 
/// 主要功能		：套打报告
/// 主要功能		：
/// 最后修改时间	：
/// 最后修改人	：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.PrintTableReport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

/// d ##Class(web.DHCPE.PrintTableReport).GetReportInfor()
ClassMethod GetReportInfor(PAAdmRowid As %String = "")
{
	s Flag=##Class(web.DHCPE.ReportGetInfor).GetPatient(PAAdmRowid)
	Q:("1"'=Flag)
	d ##Class(web.DHCPE.ReportGetInfor).GetGeneralAdvice(PAAdmRowid)
	d ##Class(web.DHCPE.ReportGetInfor).GetSummarize(PAAdmRowid)
	d ##Class(web.DHCPE.ReportGetInfor).GetReportResult(PAAdmRowid)
	Q 1
}

/// d ##Class(web.DHCPE.ReportOutToWeb).OutReportToWeb()
ClassMethod OutDataToReport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "")
{
	s ReportName=$P(Instring,"^",1)
	s PAAdmRowid=$P(Instring,"^",2)
	d ..GetReportInfor(PAAdmRowid)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
}

}
