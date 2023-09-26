Class dhc.pa.report.uDeptReportGragh Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2010-11-23
/// Description:根据期间和科室类别生成全院科室考核分的临时global
/// Table:dhc_pa_data.UnitSchem,dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的指标Dr字符串
/// Others:w ##class(dhc.pa.report.uDeptReportGragh).GetDeptSocreGlobal(1,"M",1,6,2,"007")
ClassMethod GetDeptSocreGlobal(cycleDr, frequency, startPeriod, endPeriod, deptType, unit, schemDr) As %String
{
	
	n (cycleDr,frequency,startPeriod,endPeriod,deptType,unit,schemDr)
	
	k ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa")
	
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
	s currStratagem = ##class(dhc.pa.report.uDeptReport).GetCurrStratagemDr()
	s period=""
	s unitCode=""
	s jxunit =0
	i $d(^DHCCJXPAJXUNIT(0,"LocType",deptType)) d
	.f  s jxunit = $o(^DHCCJXPAJXUNIT(0,"LocType",deptType,jxunit)) q:(jxunit="")||(currStratagem="")  d 
	..i $d(^DHCCJXPAJXUNIT(jxunit)) d
	...s jxunitAll = $g(^DHCCJXPAJXUNIT(jxunit))
	...;w jxunitAll,!
	...s unitCode = $p(jxunitAll,"^",2)
	..i unitCode=unit d
	...//获得绩效单元内容
	...s unitResult = 0
	...i $d(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",currStratagem,jxunit)) d
	....f  s unitResult = $o(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",currStratagem,jxunit,unitResult)) q:unitResult=""  d
    .....i $d(^DHCCJXPASTRATAGEM(currStratagem,"UnitResult",unitResult)) d
	......s unitResultAll = $g(^DHCCJXPASTRATAGEM(currStratagem,"UnitResult",unitResult))
	......;w unitResultAll,!
	......s schem = $p(unitResultAll,"^",1)
	......i schem = schemDr d
	.......s schemSub = $p(schem,"||",2)
	.......s jxperiod = $p(unitResultAll,"^",4)
	.......s str = newPeriodList.Find(jxperiod,1)
	.......;w schem," "_str,!
	.......//判断期间在其内执行
	.......i (schem'="")&&(str'="") d
	........i $d(^DHCCJXPASTRATAGEM(currStratagem,"Schem",schemSub)) d
	.........s schemAll = $g(^DHCCJXPASTRATAGEM(currStratagem,"Schem",schemSub))
	.........;w schemAll,!
	.........s frequencyTMP = $p(schemAll,"^",5)
	.........i frequencyTMP = frequency d
	..........//获得总分数
	..........s sorce = $p(unitResultAll,"^",8)
	..........i $d(^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)) d
	...........s ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)=^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)+sorce
	..........e  d
	...........s ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",jxunit,schem,jxperiod)= sorce
}

ClassMethod getDeptSoreGraghDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getDeptSoreGraghDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wang ying
/// CreatDate:2010-11-23
/// Description:全院科室指标分分析
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptReportGragh","getDeptSoreGraghData",1,"M",1,3,2,"007","1||1")
ClassMethod getDeptSoreGraghDataExecute(ByRef qHandle As %Binary, cycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, deptType As %String, unitCode As %String, schemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:unitCode="" $$$OK
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:startPeriod="" $$$OK
	q:endPeriod="" $$$OK
	q:startPeriod>endPeriod $$$OK
	
	i frequency="M" s Freq="月"
	i frequency="Q" s Freq="季"
	i frequency="H" s Freq="半年"
	i frequency="Y" s Freq="年"
	
	d ..GetDeptSocreGlobal(cycleDr,frequency,startPeriod,endPeriod,deptType,unitCode,schemDr)
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
	.....s periodName = $e(period,5,6)_Freq
	.....s scorce = ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa",unit,schem,period)
	.....;w "scorce="_scorce,!
	.....d OutputDeptSorce
    
    k ^TEMPDHCCJXPADEPTSORCE(0,"dhc","pa")
    q $$$OK
OutputDeptSorce
    s Data=$lb(unitCode,unitName,schemName,periodName,scorce)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getDeptSoreGraghDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getDeptSoreGraghDataExecute ]
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

Query getDeptSoreGraghData(cycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, deptType As %String, unitCode As %String, schemDr As %String) As %Query(ROWSPEC = "unitCode:%String,unitName:%String,schemName:%String,periodName:%String,sorce:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uDeptReportG667S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
