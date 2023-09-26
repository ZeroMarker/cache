/// 常用工具
Class dhc.bonus.comm.Tools Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhaoliguo
/// CreatDate: 2015-12-10
/// Description: 得到月份的最后日期
/// Output：YYYY-MM
/// Return：月份天数
/// Others: w ##class(dhc.bonus.comm.Tools).GetMonthLastDay("2015-12")
ClassMethod GetMonthLastDay(YearMonth)
{
	n (YearMonth)
	s sYear=$p(YearMonth,"-",1)
	s sMonth=$p(YearMonth,"-",2)
	i sMonth<12  d
	.s sMonth=sMonth+1
	.s YM=sYear_"-"_sMonth_"-01"
	e  d
	.s sYear=sYear+1
	.s YM=sYear_"-01-01" 
	
	s sYM=$ZD($ZDH(YM,3)-1,3)
	
	q sYM
}

/// Creator: zhaoliguo
/// CreatDate: 2015-12-10
/// Description: 得到月份的最大天数
/// Output：YYYY-MM
/// Return：月份天数
/// Others: w ##class(dhc.bonus.comm.Tools).GetMonthDays("2015-12")
ClassMethod GetMonthDays(YearMonth)
{
	n (YearMonth)
	s sYear=$p(YearMonth,"-",1)
	s sMonth=$p(YearMonth,"-",2)
	i sMonth<12  d
	.s sMonth=sMonth+1
	.s YM=sYear_"-"_sMonth_"-01"
	e  d
	.s sYear=sYear+1
	.s YM=sYear_"-01-01" 
	
	s sYM=$ZD($ZDH(YM,3)-1,3)
	s sYM=$p(sYM,"-",3)
	q sYM
}

Storage Default
{
<StreamLocation>^dhc.bonus.comm.ToolsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
