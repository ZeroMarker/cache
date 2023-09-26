/// 	指标系统标准接口：指标日志接口
/// 	定义了指标系统中对待记录日志的模块进行日志的设置、获取的方法
Class DHCWL.Interface.MkpiLog Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		JEFF
/// CreatDate:		2014-01-21
/// Description:	查询给定日期范围内指定日志类型的日志。
/// Table:			
/// Input:			fromDate,toDate:yyyy-mm-dd格式的日期数据；
/// 				loginType:日志类型，默认为空取所有日志类型编码,可取的值为{"KpiLogDefinition","KpiLogDataProcess","KpiLogDataQuery","KpiLogTaskErr"}; 	
/// Output:			
/// Return:			ResultSet数据
/// HowToUse:		s rs=##class(DHCWL.Interface.MkpiLog).QueryLogin("2014-03-01","2014-03-06","KpiLogDefinition")
/// 					rs.Next()不为空时，d rs.%Print()查看值
/// Other:			
ClassMethod QueryLogin(fromDate, toDate, loginType = "") As %String
{
	n (fromDate,toDate,loginType)
	q:fromDate="" ""
	q:toDate="" ""
	s rs=##class(%ResultSet).%New("DHCWL.MKPILogin.LoginService:QueryLogRecord")
	d rs.Execute(fromDate,toDate,loginType)
	q rs
}

}
