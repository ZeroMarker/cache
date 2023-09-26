/// Creator: 李明忠
/// CreatDate: 2011-09-26
/// Description: 全院挂号员报表
Class dhc.bonus.report.uHospRegisterSFReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2011-09-26
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHospRegisterSFReport","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1)
{
	select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where SchemePeriodID>0 and BonusPeriod='Y00'  order by BonusYear desc
}

ClassMethod GetPeriodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s Freq="",PeriodDr="",PeriodName=""
	
	s FreqLen=4
	f k=1:1:FreqLen d
	.i k=1 d
	..s Freq="M"
	..f m=1:1:12 d
	...s PeriodDr=m
	...i m<10 s PeriodName="0"_m_"月"
	...e  s PeriodName=m_"月"
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr=n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr=l
	...i PeriodDr=1 s PeriodName="上半年"
	...i PeriodDr=2 s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr=1
	..s PeriodName="全年"
	..d OutputRowPeriod
 
 	q $$$OK
OutputRowPeriod
	
 	s Data=$lb(Freq,PeriodDr,PeriodName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetPeriodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2011-09-26
/// Description:期间Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHospRegisterSFReport","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, fre As %String, fromPeriod As %Integer, toPeriod As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK
 	q:fre="" $$$OK
 	q:fromPeriod="" $$$OK
 	q:toPeriod="" $$$OK
 	
 	s periodName=year_"年"_fromPeriod_"月至"_toPeriod_"月"
 
 	//开始日期
 	s startDate = year_"-"_fromPeriod_"-01"
 	s startDate=$zdh(startDate,3)
 	//结束日期
 	s days="01"
 	i toPeriod=12 d
 	.s year=year+1
 	.s toPeriod="01"
 	e  d
 	.s toPeriod=toPeriod+1
 	s endDate=$zdh(year_"-"_toPeriod_"-"_days,3)-1
 	
 	k ^TEMPDHCWL($j,"ghy","JJExport")
 	k ^DHCCBONUSGHYTMP($j,"dhc","ghy","report")
 	
 	d SGGetRegSFYData^SGGetFeeData(startDate,endDate)

 	//处理数据
 	i $D(^TEMPDHCWL($j,"ghy","JJExport")) d
 	.s no=0
 	.f  s no=$O(^TEMPDHCWL($j,"ghy","JJExport",no)) q:no=""  d
 	..s userCode=""
 	..f  s userCode=$O(^TEMPDHCWL($j,"ghy","JJExport",no,userCode)) q:userCode=""  d
 	...s userName=""  
 	...f  s userName=$O(^TEMPDHCWL($j,"ghy","JJExport",no,userCode,userName)) q:userName=""  d
 	....s userInfo=userCode_"^"_userName
 	....s ghyTypeName=""
 	....f  s ghyTypeName=$O(^TEMPDHCWL($j,"ghy","JJExport",no,userCode,userName,ghyTypeName)) q:ghyTypeName=""  d
 	.....i ghyTypeName="普通挂号" s ghyTypeCode="ptgh"
 	.....i ghyTypeName="急诊挂号" s ghyTypeCode="jzgh"
 	.....i ghyTypeName="专家挂号" s ghyTypeCode="zjgh"
 	.....s locName=""
 	.....f  s locName=$O(^TEMPDHCWL($j,"ghy","JJExport",no,userCode,userName,ghyTypeName,locName)) q:locName=""  d
 	......s ghTypeInfo=..getTypeInfo(locName)
 	......s ghyTypeValue=^TEMPDHCWL($j,"ghy","JJExport",no,userCode,userName,ghyTypeName,locName)
 	......i $D(^DHCCBONUSGHYTMP($j,"dhc","ghy","report",ghTypeInfo,userInfo,ghyTypeCode)) d
 	.......s ^DHCCBONUSGHYTMP($j,"dhc","ghy","report",ghTypeInfo,userInfo,ghyTypeCode)=^DHCCBONUSGHYTMP($j,"dhc","ghy","report",ghTypeInfo,userInfo,ghyTypeCode)+ghyTypeValue
 	......e  d
 	.......s ^DHCCBONUSGHYTMP($j,"dhc","ghy","report",ghTypeInfo,userInfo,ghyTypeCode)=ghyTypeValue
 	
 	//向报表输出数据
 	i $D(^DHCCBONUSGHYTMP($j,"dhc","ghy","report")) d
 	.s ghTypeInfo=""
 	.f  s ghTypeInfo=$O(^DHCCBONUSGHYTMP($j,"dhc","ghy","report",ghTypeInfo)) q:ghTypeInfo=""  d
 	..s typeDr=$P(ghTypeInfo,"^",1)
 	..s typeName=$P(ghTypeInfo,"^",2)
 	..s userInfo=""
 	..f  s userInfo=$O(^DHCCBONUSGHYTMP($j,"dhc","ghy","report",ghTypeInfo,userInfo)) q:userInfo=""  d
 	...s userCode=$P(userInfo,"^",1)
 	...s userName=$P(userInfo,"^",2)
 	...s ghyTypeCode=""
 	...f  s ghyTypeCode=$O(^DHCCBONUSGHYTMP($j,"dhc","ghy","report",ghTypeInfo,userInfo,ghyTypeCode)) q:ghyTypeCode=""  d
 	....s ghyTypeValue=^DHCCBONUSGHYTMP($j,"dhc","ghy","report",ghTypeInfo,userInfo,ghyTypeCode)
 	....i ghyTypeCode="ptgh" d
 	.....s ghyTypeName="普通挂号"
 	.....s ghyTypeCode=2
 	....i ghyTypeCode="jzgh" d
 	.....s ghyTypeName="急诊挂号"
 	.....s ghyTypeCode=1
 	....i ghyTypeCode="zjgh" d
 	.....s ghyTypeName="专家挂号"
 	.....s ghyTypeCode=3
 	....d OutputReport
 	
 	k ^TEMPDHCWL($j,"ghy","JJExport")
 	k ^DHCCBONUSGHYTMP($j,"dhc","ghy","report")
 	
 	q $$$OK
 	
OutputReport
	
 	s Data=$lb(periodName,typeDr,typeName,userCode,userName,ghyTypeCode,ghyTypeName,ghyTypeValue)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2011-09-26
/// Description:获取全院科室挂号收入报表
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHospRegisterSFReport","GetReport","2011","M",1,1)
Query GetReport(year As %String, fre As %String, fromPeriod As %String, toPeriod As %String) As %Query(ROWSPEC = "periodName:%String,typeDr:%Integer,typeName:%String,userCode:%String,userName:%String,ghyTypeCode:%String,ghyTypeName:%String,ghyTypeValue:%Float")
{
}

ClassMethod GetItemList(ReportId) As %Library.ListOfDataTypes
{
	n (ReportId)
	
	s itemList=##class(%Library.ListOfDataTypes).%New()
	q:ReportId="" itemList
	
	i $D(^dhcbsReportCellI("ReportItem",ReportId)) d
	.s itemDr=0
	.f  s itemDr=$O(^dhcbsReportCellI("ReportItem",ReportId,itemDr)) q:itemDr=""  d
	..d itemList.Insert(itemDr)
	
	q itemList
}

ClassMethod getOrder(ReportId, itemDr) As %Library.ListOfDataTypes
{
	n (ReportId,itemDr)
	
	s orders=0
	
	i $D(^dhcbsReportCellI("ReportItem",ReportId,itemDr)) d
	.s rowid=0
	.f  s rowid=$O(^dhcbsReportCellI("ReportItem",ReportId,itemDr,rowid)) q:rowid=""  d
	..s orders=$List(^dhcbsReportCellD(rowid),4)
	
	q orders
}

ClassMethod getAllDept() As %Library.ListOfDataTypes
{
	
	s deptList=##class(%Library.ListOfDataTypes).%New()
	
	s sqlStr="select BonusUnitID from dhc_bonus_data.BonusUnit where %ID>0 and superiorUnitID>0"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("BonusUnitID")
		d deptList.Insert(rowid)
	}
	
	q deptList
}

/// w ##class(dhc.bonus.report.uHospRegisterSFReport).getTypeInfo("MZSFC-门诊收费处")
ClassMethod getTypeInfo(LocName) As %Library.ListOfDataTypes
{
	n (LocName)
	
	s typeDr=6,typeName="其他",typeInfo=typeDr_"^"_typeName
	
	//对科室归类
	i LocName="MZSFC-门诊收费处" s typeDr=1,typeName="本部收费处"
	i LocName="ZYSFC-住院收费处" s typeDr=1,typeName="本部收费处"
	
	i LocName="SQMZSFC-市区门诊收费处" s typeDr=2,typeName="分院收费处"
	
	i LocName="TJZX-体检中心" s typeDr=3,typeName="保健科"
	i LocName="MZJYK-门诊简易科" s typeDr=3,typeName="保健科"
	
	i LocName="JZKZLS-急诊科治疗室" s typeDr=5,typeName="护士站"
	i LocName="MZNK-门诊内科" s typeDr=5,typeName="护士站"
	i LocName="MZFK-门诊妇科" s typeDr=5,typeName="护士站"
	i LocName="MZEK-门诊儿科" s typeDr=5,typeName="护士站"
	i LocName="XNYQBQ-心内一区病区" s typeDr=5,typeName="护士站"
	
	i LocName="CTMRS-CT\MR室" s typeDr=6,typeName="其他"
	i LocName="BMYF-便民药房" s typeDr=6,typeName="其他"
	
	s typeInfo=typeDr_"^"_typeName
	
	q typeInfo
}

/// w ##class(dhc.bonus.report.uHospRegisterSFReport).Test()
ClassMethod Test() As %Library.ListOfDataTypes
{
	s year="2009"
	s month="01"
	s days="31"
	
	
	
	s date = year_"-"_month_"-"_days
	
	w date,!
	
	w $zdh(date,3)
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uHospRegiste869S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
