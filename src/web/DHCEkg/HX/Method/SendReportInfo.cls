/// 发送心电报告
Class web.DHCEkg.HX.Method.SendReportInfo Extends %RegisteredObject
{

/// 方法说明：	心电推送报告信息
/// 创建者：	杨亚莉
/// 创建时间：	2020-11-12
/// 入参：		examId
/// 			流水号
/// 返回值：	
/// w ##class(web.DHCEkg.HX.Method.SendReportInfo).SendRpt("")
ClassMethod SendRpt(params As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.HX.Method.SendReportInfo","SendRpt",$zd($h,3),$zt($p($h,",",2),1),params,"params")
}

}
