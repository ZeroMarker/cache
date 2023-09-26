Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-08
/// Descript: 		智能决策系统监测查询统计类
Class web.DHCCKBMonQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		取当前月起始日期
/// w ##Class(web.DHCMDTConsPortal).monStartDate()
ClassMethod monStartDate() As %String
{
	s FristDate=$SYSTEM.SQL.YEAR(+$H)_"-"_$SYSTEM.SQL.MONTH(+$H)_"-01"
	s FristDate=$zdh(FristDate,3)
	Q FristDate
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		取当前月结束日期
/// w ##Class(web.DHCMDTConsPortal).monEndDate()
ClassMethod monEndDate() As %String
{
	s EndDate=$SYSTEM.SQL.LASTDAY(+$H)
	Q EndDate
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		取当前月起始日期
/// w ##Class(web.DHCMDTConsPortal).weekStartDate()
ClassMethod weekStartDate() As %String
{
	s FristDate=+$H-$SYSTEM.SQL.DAYOFWEEK(+$H)+1
	Q FristDate
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-07-03
/// Descript:		取当前月结束日期
/// w ##Class(web.DHCMDTConsPortal).weekEndDate()
ClassMethod weekEndDate() As %String
{
	s EndDate=+$H+(7-$SYSTEM.SQL.DAYOFWEEK(+$H))
	Q EndDate
}

}
