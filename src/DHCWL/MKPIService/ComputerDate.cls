/// 名称: DHCWL.MKPIService.ComputerDate
/// 描述: 日期计算类
/// 编写者：ban
/// 编写日期:2012-03-30
/// 
Class DHCWL.MKPIService.ComputerDate Extends %RegisteredObject [ Not ProcedureBlock ]
{

//w ##class(DHCWL.MKPIService.ComputerDate).GetLastDayOfMonth("2012-02")

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 获取月份的最后一天
/// Table：       
/// Input：       month:月份,必须为yyyy-mm格式
/// Output：      
/// Return：      该月的最后1天,格式为yyyy-mm-dd
/// Others：      先计算出这个月的下一个月,然后用下月的1号-1天运算当月最后1天
ClassMethod GetLastDayOfMonth(month) As %String
{
	n (month)
	s curYear=$p(month,"-",1)
	s curMon=$p(month,"-",2)
	s lastMon=curMon+1
	;s monAdd=lastMon#12
	//如果月份+1模12等于1,则年+1,月份为1月
	i lastMon=13 s curYear=curYear+1,lastMon=1
	s lastMonFirstDay=$zdh(curYear_"-"_lastMon_"-01",3)
	q $zd(lastMonFirstDay-1,3)
}

//w ##class(DHCWL.MKPIService.ComputerDate).GetLastMonth("2012-02")

/// Creator：      ban
/// CreatDate：    2012-03-31
/// Description:： 获取上个月
/// Table：       
/// Input：       month:月份,必须为yyyy-mm格式
/// Output：      
/// Return：      上个月
/// Others：      
ClassMethod GetLastMonth(month) As %String
{
	n (month)
	s curYear=$p(month,"-",1)
	s curMon=$p(month,"-",2)
	s lastMon=curMon-1
	//如果月份+1模12等于1,则年+1,月份为1月
	i lastMon=0 s year=curYear-1,lastMon=12
	e  s year=curYear
	i lastMon<10 s lastMon=0_lastMon
	q year_"-"_lastMon
}

//w ##class(DHCWL.MKPIService.ComputerDate).GetLastQuarterData("2012-02")

/// Creator：      ban
/// CreatDate：    2012-03-31
/// Description:： 获取上个季度
/// Table：       
/// Input：       month:月份,必须为yyyy-mm格式
/// Output：      
/// Return：      上个季度,格式mm-Q1
/// Others：      
ClassMethod GetLastQuarterData(month) As %String
{
	n (month)
	s curYear=$p(month,"-",1)
	s curMon=+$p(month,"-",2)
	i (curMon=2)||(curMon=3)||(curMon=1) s lastQua=1
	i (curMon=5)||(curMon=6)||(curMon=4) s lastQua=2
	i (curMon=8)||(curMon=9)||(curMon=7) s lastQua=3
	i (curMon=11)||(curMon=12)||(curMon=10) s lastQua=4
	s lastQua=lastQua-1
	i lastQua=0 s year=curYear-1,lastQua=4
	e  s year=curYear
	q year_"-Q"_lastQua
}

//w ##class(DHCWL.MKPIService.ComputerDate).GetMonthDay("2012-01")

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 获取一个月的每一天,拼成字符串,用逗号分隔
/// Table：       
/// Input：       month:需要获取日期的月份
/// Output：      
/// Return：      返回日期字符串
/// Others：      	
ClassMethod GetMonthDay(month) As %String
{
	n (month)
	
	s lastDay=$p(..GetLastDayOfMonth(month),"-",3)
	s startDate=month_"-01"
	s monthDayStr=startDate
	f day=2:1:lastDay d
	.i day<10 s dataDay=0_day
	.e  s dataDay=day
	.s monthDayStr=monthDayStr_","_month_"-"_dataDay
	
	q monthDayStr
}

//w ##class(DHCWL.MKPIService.ComputerDate).GetYesterday("2012-01-01")

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 获取一天的前一天
/// Table：       
/// Input：       day:输入日期
/// Output：      
/// Return：      返回入参的前一天
/// Others：      	
ClassMethod GetYesterday(day) As %String
{
	n (day)
	s day=$zdh(day,3)
	q $zd(day-1,3)
}

//w ##class(DHCWL.MKPIService.ComputerDate).GetMudDay("2010-02-01","2010-02-11")

/// Creator：      lxc
/// CreatDate：    2012-06-27
/// Description:： 获取间隔的每一天，拼成字符串,用逗号分隔
/// Table：       
/// Input：       startDate,endDate:日期,必须为yyyy-mm-dd格式
/// Output：      
/// Return：      返回日期的字符串
/// Others：      
ClassMethod GetMudDay(startDate, endDate) As %String
{
	n (startDate, endDate)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	q:endDate<startDate ""
	s dayStr=""
	f date=startDate:1:endDate d
	.s date1=$zd(date,3)
	.s dayStr=date1_","_dayStr
	q dayStr
}

//w ##class(DHCWL.MKPIService.ComputerDate).GetMudMonth("2010-02","2011-06")

/// Creator：      lxc
/// CreatDate：    2012-06-27
/// Description:： 获取间隔的各个月，拼成字符串,用逗号分隔
/// Table：       
/// Input：       startM,endM:月份,必须为yyyy-mm格式
/// Output：      
/// Return：      返回月份的字符串
/// Others：      
ClassMethod GetMudMonth(startM, endM) As %String
{
	n (startM, endM)
	s starYear=$p(startM,"-",1)
	s starMon=+$p(startM,"-",2)
	s endYear=$p(endM,"-",1)
	s endMon=+$p(endM,"-",2)
	q:endYear<starYear ""
	
	i endYear=starYear  d
	.s monthStr=""
	.q:starMon>endMon
	.f mon=starMon:1:endMon d
	..i mon<10 s mon=0_mon
	..s monthStr=starYear_"-"_mon_","_monthStr
	
	i endYear>starYear  d
	.s stmonthStr="",enmonthStr=""
	.f stmon=starMon:1:12 d
	..i stmon<10 s stmon=0_stmon
	..s stmonthStr=starYear_"-"_stmon_","_stmonthStr
	.f enmon=1:1:endMon d
	..i enmon<10 s enmon=0_enmon
	..s enmonthStr=endYear_"-"_enmon_","_enmonthStr
	.s monthStr=stmonthStr_enmonthStr

	q monthStr
}

//w ##class(DHCWL.MKPIService.ComputerDate).GetMudQd("2010-02-01","2012-02-11")

/// Creator：      lxc
/// CreatDate：    2012-06-27
/// Description:： 获取间隔的每季度，拼成字符串,用逗号分隔
/// Table：       
/// Input：       startDate,endDate:日期,必须为yyyy-mm-dd格式
/// Output：      
/// Return：      返回年的字符串
/// Others：      2008-Q4
ClassMethod GetMudQd(startDate, endDate) As %String
{
	n (startDate, endDate)
	s startDate1=$E(startDate,1,4)
	s endDate1=$e(endDate,1,4)
	q:endDate1<startDate1 ""
	s QdStr=""
	f date=startDate1:1:endDate1 d
	.f jd=1:1:4 d
	..s Qd=date_"-Q"_jd
	..s QdStr=Qd_","_QdStr
	q QdStr
}

//w ##class(DHCWL.MKPIService.ComputerDate).GetMudYear("2010-02-01","2012-02-11")

/// Creator：      lxc
/// CreatDate：    2012-06-27
/// Description:： 获取间隔的每一年，拼成字符串,用逗号分隔
/// Table：       
/// Input：       startDate,endDate:日期,必须为yyyy-mm-dd格式
/// Output：      
/// Return：      返回年的字符串
/// Others：      
ClassMethod GetMudYear(startDate, endDate) As %String
{
	n (startDate, endDate)
	s startDate1=$e(startDate,1,4)
	s endDate1=$e(endDate,1,4)
	q:endDate1<startDate1 ""
	s yearStr=""
	f date=startDate1:1:endDate1 d
	.s yearStr=date_","_yearStr
	q yearStr
}

/// Creator：      wk
/// CreatDate：    2017-01-10
/// Description:： 根据传入的时间获取对应的季度
/// Table：       
/// Input：       startDate,必须为yyyy-mm-dd格式
/// Output：      
/// Return：      返回季的字符串
/// Others：      
ClassMethod GetQuabyDate(startDate) As %String
{
	n (startDate)
	s month=$p(startDate,"-",2)
	s year=$p(startDate,"-",1)
	if ((month="")||(year="")){
		q ""
	}
	s num=0
	if (month<4){
		s num=1
	}elseif(month<7){
		s num=2
	}elseif(month<10){
		s num=3
	}elseif(month<13){
		s num=4	
	}
	q year_"-"_"Q"_num
}

}
