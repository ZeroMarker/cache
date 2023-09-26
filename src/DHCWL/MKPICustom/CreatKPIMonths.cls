/// 名称: DHCWL.MKPICustom.CreatKPIMonths
/// 描述: 客户化定制生成区间代码
/// 编写者：ban
/// 编写日期:2012-03-30
/// 
Class DHCWL.MKPICustom.CreatKPIMonths Extends %RegisteredObject
{

/// d ##class(DHCWL.MKPICustom.CreatKPIMonths).CreateMonths("2010")
ClassMethod CreateMonths(date = "2008", rebildFlag = 0)
{
	;s sd=$o(^DHCWL.MKPI.MonthsD(""),-1)
	d ##class(DHCWL.MKPICustom.CreatKPIMonths).InsDayData(date,rebildFlag)
	d ##class(DHCWL.MKPICustom.CreatKPIMonths).InsMonthData(date,rebildFlag)
	d ##class(DHCWL.MKPICustom.CreatKPIMonths).InsQuarterData(date,rebildFlag)
	d ##class(DHCWL.MKPICustom.CreatKPIMonths).InsYearData(date,rebildFlag)
	;s ed=$o(^DHCWL.MKPI.MonthsD(""),-1)
	;d ##class(DHCWL.MKPIService.DateUtil).SetMonthContractScope(sd_"-"_ed,rebildFlag) 不在生成@0130903
}

//d ##class(DHCWL.MKPICustom.CreatKPIMonths).InsDayData(2008)

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 自动生成一年的日区间
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       year:需要生成数据的年份
/// Output：      
/// Return：      成功返回1,否则返回0
/// Others：      	
ClassMethod InsDayData(year, rebildFlag = 0) As %Status
{
	s firstDay=$zdh((year_"-01-01"),3)
	s lastDay=$zdh((year_"-12-31"),3)
	s section=$o(^DHCWL.MKPI.SectionI("SecCode","D",""))
	q:section="" 0
	f day=firstDay:1:lastDay d
	.s code=$zd(day,8)
	.s monId=+##class(DHCWL.MKPIService.ConfigService).GetMonthByCode(code)
	.i ((rebildFlag=1)&&(monId'=0)) d
	..&sql(delete from DHCWL_MKPI.DHCWLKPIMonths where ID=:monId)
	..;w monId,!
	..s monId=0
	.q:monId'=0
	.s name=$zd(day,3)
	.s dataYear=$p(name,"-",1)
	.s dataMonth=$p(name,"-",2)
	.s dataDay=$p(name,"-",3)
	.s desc=dataYear_"年"_dataMonth_"月"_dataDay_"日"
	.s startDate=name
	.s endDate=name
	.s user=""
	.s remark=""
	.s calFlag="Y"
	.s monthDr=""
	.s sc=##class(DHCWL.MKPIService.ConfigService).InsertMonth(code,name,desc,startDate,endDate,user,remark,calFlag,section,monthDr)
	q 1
}

//d ##class(DHCWL.MKPICustom.CreatKPIMonths).InsMonthData(2012)

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 自动生成一年的月区间
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       year:需要生成数据的年份
/// Output：      
/// Return：      成功返回1,否则返回0
/// Others：      	
ClassMethod InsMonthData(year, rebildFlag = 0) As %Status
{
	s section=$o(^DHCWL.MKPI.SectionI("SecCode","M",""))
	q:section="" 0
	f month=1:1:12 d
	.i month<10 s dataMon=0_month
	.e  s dataMon=month
	.s code=year_dataMon
	.;i month>9 b	//3
	.s monId=+##class(DHCWL.MKPIService.ConfigService).GetMonthByCode(code)
	.i ((rebildFlag=1)&&(monId'=0)) d
	..&sql(delete from DHCWL_MKPI.DHCWLKPIMonths where ID=:monId)
	..;w monId,!
	..s monId=0
	.q:monId'=0
	.s name=year_"-"_dataMon
	.s desc=year_"年"_dataMon_"月"
	.s startDate=name_"-"_"01"
	.s endDate=##class(DHCWL.MKPIService.ComputerDate).GetLastDayOfMonth(name)
	.s user=""
	.s remark=""
	.s calFlag="Y"
	.//获取当月的每一天
	.s nameStr=##class(DHCWL.MKPIService.ComputerDate).GetMonthDay(name)
	.s idStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(nameStr)
	.;i month>9 b	//2
	.q:idStr=""
	.s monthDr=idStr
	.;i month>9 b	//1
	.s sc=##class(DHCWL.MKPIService.ConfigService).InsertMonth(code,name,desc,startDate,endDate,user,remark,calFlag,section,monthDr)
	
	q 1
}

//d ##class(DHCWL.MKPICustom.CreatKPIMonths).InsQuarterData(2012)

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 自动生成一年的季区间
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       year:需要生成数据的年份
/// Output：      
/// Return：      成功返回1,否则返回0
/// Others：      	
ClassMethod InsQuarterData(year, rebildFlag = 1) As %Status
{

	s section=$o(^DHCWL.MKPI.SectionI("SecCode","Q",""))
	q:section="" 0
	f qua=1:1:4 d
	.s code=year_"Q"_qua
	.s monId=+##class(DHCWL.MKPIService.ConfigService).GetMonthByCode(code)
	.i ((rebildFlag=1)&&(monId'=0)) d
	..&sql(delete from DHCWL_MKPI.DHCWLKPIMonths where ID=:monId)
	..;w monId,!
	..s monId=0
	.q:monId'=0
	.s name=year_"-Q"_qua
	.s desc=year_"年"_qua_"季度"
	.s mon1=(qua-1)*3+1
	.s mon2=(qua-1)*3+2
	.s mon3=(qua-1)*3+3
	.i mon1<10 s mon1=0_mon1
	.i mon2<10 s mon2=0_mon2
	.i mon3<10 s mon3=0_mon3
	.s mon1=year_"-"_mon1
	.s mon2=year_"-"_mon2
	.s mon3=year_"-"_mon3
	.s startDate=mon1_"-"_"01"
	.s endDate=##class(DHCWL.MKPIService.ComputerDate).GetLastDayOfMonth(mon3)
	.s user=""
	.s remark=""
	.s calFlag="Y"
	.s nameStr=mon1_","_mon2_","_mon3
	.s idStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(nameStr)
	.;i qua=4 b	//2
	.q:idStr=""
	.s monthDr=idStr
	.;i qua=4 b	//1
	.s sc=##class(DHCWL.MKPIService.ConfigService).InsertMonth(code,name,desc,startDate,endDate,user,remark,calFlag,section,monthDr)
	
	q 1
}

//d ##class(DHCWL.MKPICustom.CreatKPIMonths).InsYearData(2012)

/// Creator：      ban
/// CreatDate：    2012-03-30
/// Description:： 自动生成一年的年区间
/// Table：       DHCWL_MKPI.DHCWLKPIMonths
/// Input：       year:需要生成数据的年份
/// Output：      
/// Return：      成功返回1,否则返回0
/// Others：      	
ClassMethod InsYearData(year, rebildFlag = 1) As %Status
{

	s section=$o(^DHCWL.MKPI.SectionI("SecCode","Y",""))
	q:section="" 0
	s code=year_"Y"
	s monId=+##class(DHCWL.MKPIService.ConfigService).GetMonthByCode(code)
	i ((rebildFlag=1)&&(monId'=0)) d
	.&sql(delete from DHCWL_MKPI.DHCWLKPIMonths where ID=:monId)
	.;w monId,!
	.s monId=0
	q:monId'=0
	s name=year_"-Y"
	s desc=year_"年度"
	s startDate=year_"-"_"01"_"-01"
	s endDate=year_"-"_"12"_"-31"
	s user=""
	s remark=""
	s calFlag="Y"
	s nameStr=year_"-Q1,"_year_"-Q2,"_year_"-Q3,"_year_"-Q4"
	s idStr=##class(DHCWL.MKPIService.ConfigService).GetMonthStrByName(nameStr)
	q:idStr="" 0
	s monthDr=idStr
	s sc=##class(DHCWL.MKPIService.ConfigService).InsertMonth(code,name,desc,startDate,endDate,user,remark,calFlag,section,monthDr)
	q 1
}

}
