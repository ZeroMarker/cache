/// Creator:wang ying
/// CreatDate:2010-10-08
/// Description:根据期间和科室类别查询全院科室考核分
Class dhc.pa.report.uDeptReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2010-11-16
/// Description: 获取当前战略Dr
/// Table：dhc_pa_data.Stratagem
/// Input：
/// Output：
/// Return：当前战略DR
/// Others：w ##class(dhc.pa.report.uDeptReport).GetCurrStratagemDr()
ClassMethod GetCurrStratagemDr() As %String
{
	//获取当前战略
	s stratagemDr = 0 //定义并初始化战略Dr
	s count=0 //定义并初始化当前战略记录数量
	s currStratagemDr = 0 //定义并初始化当前战略Dr
	f  s stratagemDr=$O(^DHCCJXPASTRATAGEM(stratagemDr)) q:stratagemDr=""  d
	.i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	..i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	...s currStratagemFlag = $P(^DHCCJXPASTRATAGEM(stratagemDr),"^",14)
	...i currStratagemFlag="Y" d
	....s currStratagemDr = stratagemDr
	....s count=count+1

	q:count=0 "" //表示没有当前战略记录
	q:count>1 "" //表示有多条当前战略记录
	
	q currStratagemDr
}

/// Creator:wang ying
/// CreatDate:2010-10-8
/// Description:根据期间和科室类别生成全院科室考核分的临时global
/// Table:dhc_pa_data.UnitSchem,dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的指标Dr字符串
/// Others:w ##class(dhc.pa.report.uDeptReport).GetDeptSocreGlobal(1,"M",1,6,2)
ClassMethod GetDeptSocreGlobal(cycleDr, frequency, startPeriod, endPeriod, deptType) As %String
{
	
	n (cycleDr,frequency,startPeriod,endPeriod,deptType)
	s newPeriodList=##class(%Library.ListOfDataTypes).%New()
	i startPeriod=endPeriod d
	.d newPeriodList.Insert(##class(dhc.pa.report.uHospKPIScoreAnlys).GetCycle(cycleDr,startPeriod))
	i startPeriod<endPeriod d
	.s diff=endPeriod-startPeriod+1
	.f k=1:1:diff d
	..s period=startPeriod+k-1
	..d newPeriodList.Insert(##class(dhc.pa.report.uHospKPIScoreAnlys).GetCycle(cycleDr,period))
	//^DHCCJXPAJXUNIT,deptType
	//获取绩效单元设置内容
	s currStratagem = ..GetCurrStratagemDr()
	s period=""
	s jxunit =0
	i $d(^DHCCJXPAJXUNIT(0,"LocType",deptType)) d
	.f  s jxunit = $o(^DHCCJXPAJXUNIT(0,"LocType",deptType,jxunit)) q:(jxunit="")||(currStratagem="")  d 
	..i $d(^DHCCJXPAJXUNIT(jxunit)) d
	...s jxunitAll = $g(^DHCCJXPAJXUNIT(jxunit))
	...;w jxunitAll,!
	...s unitCode = $p(jxunitAll,"^",2)
	..//获得绩效单元内容
	..s unitResult = 0
	..i $d(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",currStratagem,jxunit)) d
	...f  s unitResult = $o(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",currStratagem,jxunit,unitResult)) q:unitResult=""  d
    ....i $d(^DHCCJXPASTRATAGEM(currStratagem,"UnitResult",unitResult)) d
	.....s unitResultAll = $g(^DHCCJXPASTRATAGEM(currStratagem,"UnitResult",unitResult))
	.....;w unitResultAll,!
	.....s schem = $p(unitResultAll,"^",1)
	.....s schemSub = $p(schem,"||",2)
	.....s jxperiod = $p(unitResultAll,"^",4)
	.....s str = newPeriodList.Find(jxperiod,1)
	.....;w schem," "_str,!
	.....//判断期间在其内执行
	.....i (schem'="")&&(str'="") d
	......i $d(^DHCCJXPASTRATAGEM(currStratagem,"Schem",schemSub)) d
	.......s schemAll = $g(^DHCCJXPASTRATAGEM(currStratagem,"Schem",schemSub))
	.......;w schemAll,!
	.......s frequencyTMP = $p(schemAll,"^",5)
	.......i frequencyTMP = frequency d
	........//获得总分数
	........s sorce = $p(unitResultAll,"^",8)
	........i $d(^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)) d
	.........s ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)=^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)+sorce
	........e  d
	.........s ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)= sorce
}

ClassMethod getDeptSorceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getDeptSorceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getDeptTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getDeptTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wang ying
/// CreatDate:2010-10-08
/// Description:根据期间和科室类别查询全院科室考核分
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReport","getDeptSorce","1","Q","2","3","1")
ClassMethod getDeptSorceExecute(ByRef qHandle As %Binary, cycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, deptType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:startPeriod="" $$$OK
	q:endPeriod="" $$$OK
	q:startPeriod>endPeriod $$$OK
	
	i frequency="M" s Freq="月"
	i frequency="Q" s Freq="季"
	i frequency="H" s Freq="半年"
	i frequency="Y" s Freq="年"
	
	d ..GetDeptSocreGlobal(cycleDr,frequency,startPeriod,endPeriod,deptType)
	s unit=""
	f  s unit=$o(^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unit)) q:unit=""  d
	.;w "funitCode="_unitCode,!
	.s schem=""
	.f  s schem=$o(^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unit,schem)) q:schem=""  d
	..s stratagem = $p(schem,"||",1)
	..s schemChild = $p(schem,"||",2)
	..s period = ""
	..f  s period=$o(^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unit,schem,period)) q:period=""  d
	...i $d(^DHCCJXPAJXUNIT(unit)) d
	....s unitCode = $p($g(^DHCCJXPAJXUNIT(unit)),"^",2)
	....s unitName = $p($g(^DHCCJXPAJXUNIT(unit)),"^",3)
	....i $d(^DHCCJXPASTRATAGEM(stratagem,"Schem",schemChild)) d
	.....s schemName = $p($g(^DHCCJXPASTRATAGEM(stratagem,"Schem",schemChild)),"^",2)
	
	.....s level = $p($g(^DHCCJXPASTRATAGEM(stratagem,"Schem",schemChild)),"^",9)
	.....i level=2 s schemName="   "_schemName  //20140224  add  二级方案加空格
	
	.....s periodName = $e(period,5,6)_Freq
	.....s scorce = ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unit,schem,period)
	.....d OutputDeptSorce
    
    k ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa")
    q $$$OK
OutputDeptSorce
    s Data=$lb(unitCode,unitName,schemName,periodName,$fn(scorce,"",2),"折线图",schem)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod periodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = periodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getDeptSorceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getDeptSorceExecute ]
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

ClassMethod getDeptTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//^DHCCJXPAJXLOCTYPE
	s dept =0
    f  s dept = $o(^DHCCJXPAJXLOCTYPE(dept)) q:dept=""  d
    .s deptAll=$g(^DHCCJXPAJXLOCTYPE(dept))
    .s deptCode = $p(deptAll,"^",1)
    .s deptName = $p(deptAll,"^",2)
    .d OutputDeptType
    
	Quit $$$OK
OutputDeptType
    s Data=$lb(dept,deptCode,deptName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod periodExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s frequency="",period=""
	s stargem =0
    s stargem = $o(^DHCCJXPASTRATAGEM(stargem)) q:stargem=""  d
	.s currStargem=$p($g(^DHCCJXPASTRATAGEM(stargem)),"^",14)
	.i currStargem="Y" d
	..s schem = 0
	..f  s schem=$o(^DHCCJXPASTRATAGEM(stargem,"Schem",schem)) q:schem=""  d
	...s frequency = $p($g(^DHCCJXPASTRATAGEM(stargem,"Schem",schem)),"^",5)
	...s unitResult = 0
	...f  s unitResult=$o(^DHCCJXPASTRATAGEM(stargem,"UnitResult",unitResult))  q:unitResult=""  d
	....s period = $p($g(^DHCCJXPASTRATAGEM(stargem,"UnitResult",unitResult)),"^",4)
	....d OutputPeriod

	Quit $$$OK
OutputPeriod
    s Data=$lb(frequency,period)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getDeptTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getDeptTypeExecute ]
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

ClassMethod getReportDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getReportDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod periodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = periodExecute ]
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

/// Creator:wang ying
/// CreatDate:2010-10-08
/// Description:根据期间和科室类别查询全院科室考核分
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReport","getReportDataExecute","1","M",1,5,1)
ClassMethod getReportDataExecute(ByRef qHandle As %Binary, cycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, deptType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:startPeriod="" $$$OK
	q:endPeriod="" $$$OK
	q:startPeriod>endPeriod $$$OK
	
	i frequency="M" s Freq="月"
	i frequency="Q" s Freq="季"
	i frequency="H" s Freq="半年"
	i frequency="Y" s Freq="年"
	
	d ..GetDeptSocreGlobal(cycleDr,frequency,startPeriod,endPeriod,deptType)
	s unitCode=""
	s unit=""
	f  s unitCode=$o(^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unitCode)) q:unitCode=""  d
	.s period=""
	.f  s period=$o(^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unitCode,period)) q:period=""  d
	..i $d(^DHCCJXPAJXUNIT(0,"Code",unitCode)) d
	...s unit = ^DHCCJXPAJXUNIT(0,"Code",unitCode,unit)
	...i unit'="" d
	....s unitName = $p($g(^DHCCJXPAJXUNIT(unit)),"^",2)
	....s periodName = $e(period,5,6)_Freq
	....;w unitCode,"dsf"_periodName,!
	....s scorce = ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unitCode,period)
	....s Graph="折线图"
	....d OutputReport
    
    k ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unitCode,period)
    
OutputReport
    s Data=$lb(unitCode,unitName,periodName,$fn(scorce,"",2),Graph)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator:wang ying
/// CreatDate:2010-9-28
/// Description:查询科室类别
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReport","getDeptType")
Query getDeptType() As %Query(ROWSPEC = "typeRowid:%Integer,typeCode:%String,typeName:%String") [ SqlProc ]
{
}

ClassMethod getReportDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getReportDataExecute ]
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

//d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReport","getDeptSorce",1,"M",1,5,2)

Query getDeptSorce(cycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, deptType As %String) As %Query(ROWSPEC = "unitCode:%String,unitName:%String,schemName:%String,periodName:%String,sorce:%Float,pargGraph:%String,schemDr:%String") [ SqlProc ]
{
}

/// Creator:wang ying
/// CreatDate:2010-9-25
/// Description:查询期间类型和考核期间
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReport","period")
Query period() As %Query(ROWSPEC = "frequency:%String,period:%String") [ SqlProc ]
{
}

/// Creator:wang ying
/// CreatDate:2010-9-28
/// Description:查询全院科室考核分分析
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReport","getReportData")
Query getReportData(cycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, deptType As %String) As %Query(ROWSPEC = "unitCode:%String,unitName:%String,periodName:%String,sorce:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uDeptReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
