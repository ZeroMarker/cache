/// Creator: 	huaxiaoying
/// CreateDate: 2017-03-20
/// Descript: 	陪送配送公共类
Class web.DHCDISCommonUtil Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 公共 (页面日期 转为 M中的日期数字)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-20
/// Table: 		 
/// Input:       页面日期  例如：2017-03-03、28/2/2017等
/// Output:  	 M中日期数字 64338
/// Others:	w ##class(web.DHCDISCommonUtil).DateHtmlToLogical("2017-03-03")	
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCDISCommonDate=""
	s DHCDISCommonDate=##class(websys.Conversions).DateHtmlToLogical(date)
	q DHCDISCommonDate
}

/// Description: 公共 (M中的日期数字 转为 demo配置日期)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-20
/// Table: 		 
/// Input:       M中日期数字 64345
/// Output:  	 demo配置的日期格式
/// Others:	w ##class(web.DHCDISCommonUtil).DateLogicalToHtml("64345")	
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCDISCommonDate=""
	s DHCDISCommonDate=##class(websys.Conversions).DateLogicalToHtml(date)
	q DHCDISCommonDate
}

}
