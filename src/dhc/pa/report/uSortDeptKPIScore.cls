/// Creator: wang ying
/// CreatDate: 2010-12-10
/// Description: 科室指标值排名报表
Class dhc.pa.report.uSortDeptKPIScore Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
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
/// CreatDate:2010-12-10
/// Description:根据期间和科室类别生成全院科室考核分的临时global
/// Table:dhc_pa_data.UnitSchem,dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的指标Dr字符串
/// Others:w ##class(dhc.pa.report.uSortDeptKPIScore).GetDeptSocreGlobal(4,"Y",0,14)
ClassMethod GetDeptSocreGlobal(cycleDr, frequency, period, deptType) As %String
{
	
	n (cycleDr,frequency,period,deptType)
   
    k ^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa")
    k ^TEMPDHCCJXPASortAfterDEPTSORCE(0,"dhc","pa","sort")
	
	s newPerid = ##class(dhc.pa.report.uHospKPIScoreAnlys).GetCycle(cycleDr,period)
	
	
	//获取绩效单元设置内容
	;s currStratagem = ..GetCurrStratagemDr()
	s period=""
	s jxunit =0
	i $d(^DHCCJXPAJXUNIT(0,"LocType",deptType)) d
	.f  s jxunit = $o(^DHCCJXPAJXUNIT(0,"LocType",deptType,jxunit)) q:(jxunit="")  d 
	..i $d(^DHCCJXPAJXUNIT(jxunit)) d
	...s jxunitAll = $g(^DHCCJXPAJXUNIT(jxunit))
	...;w jxunitAll,!
	...s unitCode = $p(jxunitAll,"^",2)
	..//获得绩效单元内容
	..s unitResult = 0
    ..s currStratagem=0 
    ..f  s currStratagem=$o(^DHCCJXPASTRATAGEM(currStratagem)) q:currStratagem=""  d
	...i $d(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",currStratagem,jxunit)) d
	....f  s unitResult = $o(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",currStratagem,jxunit,unitResult)) q:unitResult=""  d
    .....i $d(^DHCCJXPASTRATAGEM(currStratagem,"UnitResult",unitResult)) d
	......s unitResultAll = $g(^DHCCJXPASTRATAGEM(currStratagem,"UnitResult",unitResult))
	......s schem = $p(unitResultAll,"^",1)
	......s schemSub = $p(schem,"||",2)
	......s jxperiod = $p(unitResultAll,"^",4)
	......//判断期间在其内执行
	......i (schem'="")&&(jxperiod=newPerid) d
	.......i $d(^DHCCJXPASTRATAGEM(currStratagem,"Schem",schemSub)) d
	........s schemAll = $g(^DHCCJXPASTRATAGEM(currStratagem,"Schem",schemSub))
	........;w schemAll,!
	........s frequencyTMP = $p(schemAll,"^",5)
	........i frequencyTMP = frequency d
	.........//获得总分数
	.........s sorce = $p(unitResultAll,"^",8)
	.........i $d(^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)) d
	..........s ^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)=^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)+sorce
	.........e  d
	..........s ^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)= sorce
}

ClassMethod getDeptSorceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getDeptSorceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa")
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
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uSortDeptKPIScore","getDeptSorce",4,"Y",0,14)
ClassMethod getDeptSorceExecute(ByRef qHandle As %Binary, cycleDr As %String, frequency As %String, period As %String, deptType As %String) As %Status
{
	s start= $zt($p($h,",",2))
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:period="" $$$OK
	q:deptType="" $$$OK
	
	i frequency="M" s Freq="月"
	i frequency="Q" s Freq="季"
	i frequency="H" s Freq="半年"
	i frequency="Y" s Freq="年"
	//生成排序前临时global
	d ..GetDeptSocreGlobal(cycleDr,frequency,period,deptType)
	s count=0
	//生成排序后临时global
	s unit=""
	f  s unit=$o(^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa",unit)) q:unit=""  d
	.s schem=""
	.f  s schem=$o(^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa",unit,schem)) q:schem=""  d
	..s period = ""
	..f  s period=$o(^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa",unit,schem,period)) q:period=""  d
	...s scorce = ^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa",unit,schem,period)
	...s ^TEMPDHCCJXPASortAfterDEPTSORCE(0,"dhc","pa","sort",scorce*(-1),unit,schem,period)=0
	
	//取出排好序的临时global
	s sortSorce=""
	f  s sortSorce=$o(^TEMPDHCCJXPASortAfterDEPTSORCE(0,"dhc","pa","sort",sortSorce)) q:sortSorce=""  d 
	.s sortUnit=""
	.f  s sortUnit=$o(^TEMPDHCCJXPASortAfterDEPTSORCE(0,"dhc","pa","sort",sortSorce,sortUnit)) q:sortUnit=""  d
	..s sortSchem=""
	..f  s sortSchem=$o(^TEMPDHCCJXPASortAfterDEPTSORCE(0,"dhc","pa","sort",sortSorce,sortUnit,sortSchem)) q:sortSchem=""  d
	...s stratagem = $p(sortSchem,"||",1)
	...s schemChild = $p(sortSchem,"||",2)
	...s sortPeriod = "" 
	...f  s sortPeriod=$o(^TEMPDHCCJXPASortAfterDEPTSORCE(0,"dhc","pa","sort",sortSorce,sortUnit,sortSchem,sortPeriod)) q:sortPeriod=""  d
	....i $d(^DHCCJXPAJXUNIT(sortUnit)) d
	.....s unitCode = $p($g(^DHCCJXPAJXUNIT(sortUnit)),"^",2)
	.....s unitName = $p($g(^DHCCJXPAJXUNIT(sortUnit)),"^",3)
	.....i $d(^DHCCJXPASTRATAGEM(stratagem,"Schem",schemChild)) d
	......s schemName = $p($g(^DHCCJXPASTRATAGEM(stratagem,"Schem",schemChild)),"^",2)
	......s periodName = $e(sortPeriod,5,6)_Freq
	......s count = ^TEMPDHCCJXPASortAfterDEPTSORCE(0,"dhc","pa","sort",sortSorce,sortUnit,sortSchem,sortPeriod)
	......d OutputDeptSorce
    
    k ^TEMPDHCCJXPASortByDEPTSORCE(0,"dhc","pa")
    k ^TEMPDHCCJXPASortAfterDEPTSORCE(0,"dhc","pa","sort")
    q $$$OK
OutputDeptSorce
    s Data=$lb(unitCode,unitName,schemName,periodName,$fn(sortSorce,"",2),"折线图",sortSchem,sortUnit)
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
/// CreatDate:2010-9-28
/// Description:查询科室类别
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReport","getDeptType")
Query getDeptType() As %Query(ROWSPEC = "typeRowid:%Integer,typeCode:%String,typeName:%String") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReport","getDeptSorce",1,"M",1,5,2)

Query getDeptSorce(cycleDr As %String, frequency As %String, period As %String, deptType As %String) As %Query(ROWSPEC = "unitCode:%String,unitName:%String,schemName:%String,periodName:%String,sorce:%Float,pargGraph:%String,schemDr:%String,unitDr:%String") [ SqlProc ]
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

Storage Default
{
<StreamLocation>^dhc.pa.report.uSortDeptKPI68AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
