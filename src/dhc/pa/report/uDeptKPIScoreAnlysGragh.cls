/// Creator: wang ying
/// CreatDate: 2010-11-18
/// Description: 科室指标值信息
Class dhc.pa.report.uDeptKPIScoreAnlysGragh Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2010-11-18
/// Description:通过指标code找指标信息
/// Table:dhc_pa_udata.DHCPAINDEX1
/// Others:w ##class(dhc.pa.report.uDeptKPIScoreAnlysGragh).getKPIDr("1001000000")
ClassMethod getKPIDr(KPICode) As %String
{
	n (KPICode)
	
	q:KPICode="" "NoKPICode"
	s KPIDr = 0
	s count = 0
	i $d(^DHCCJXPAKPIINDEX1(0,"Code",KPICode)) d
	.f  s KPIDr=$o(^DHCCJXPAKPIINDEX1(0,"Code",KPICode,KPIDr)) q:KPIDr=""  d
	..i $d(^DHCCJXPAKPIINDEX1(KPIDr)) d
	...s KPI = KPIDr
	...s KPIName = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
	...s count=count+1
	;q:count'=1 "ERRKPI"
	q KPI_"^"_KPIName
}

/// Creator:wang ying
/// CreatDate:2010-11-18
/// Description:根据维度code获取维度名称等信息
/// Table:dhc_pa_data.DimensType
/// Input:DimenDr-维度Dr
/// Output:
/// Return:返回维度信息
/// Others:w ##class(dhc.pa.report.uDeptKPIScoreAnlysGragh).GetDimenInfo("101")
ClassMethod GetDimenInfo(DimenCode) As %String
{
	n (DimenCode)
	
	s DimenInfo=""
	q:DimenCode="" DimenInfo
	
	s KPICode="",KPIName="",DimDr=0
	i $d(^DHCCJXPADIMENSTYPE(0,"Code",DimenCode)) d
	.s DimDr = $o(^DHCCJXPADIMENSTYPE(0,"Code",DimenCode,DimDr))
	.i $D(^DHCCJXPADIMENSTYPE(DimDr)) d
	..i $G(^DHCCJXPADIMENSTYPE(DimDr))'="" d
	...s KPICode=DimenCode
	...s DimenName=$P(^DHCCJXPADIMENSTYPE(DimDr),"^",2)
	...s KPIName=DimenName
	
	s DimenInfo=DimDr_"^"_KPIName
	
	q DimenInfo
}

/// Creator:wang ying 
/// CreatDate:2010-11-18
/// Description:获取绩效单元考核主表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录
/// Others:w ##class(dhc.pa.report.uDeptKPIScoreAnlysGragh).GetURRowid("1||1","200901",7)
ClassMethod GetURRowid(schemDr, newPeriod, jxUnitDr) As %String
{
	n (schemDr,newPeriod,jxUnitDr)
	
	s urRowid="",total=""
	q:schemDr="" urRowid
	q:newPeriod="" urRowid
	q:jxUnitDr="" urRowid
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_rowid,UnitResult_totalScore from dhc_pa_data.UnitResult where UnitResult_childSub>0"
	s whereStr=" and UnitResult_schemDr='"_schemDr_"'"
	s whereStr=whereStr_" and UnitResult_period='"_newPeriod_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr='"_jxUnitDr_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s urRowid = result.Data("UnitResult_rowid")
	}
	
	q urRowid
}

ClassMethod getReportGraghClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getReportGraghExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wang ying
/// CreatDate:2010-11-18
/// Description:科室指标值信息Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptKPIScoreAnlysGragh","getReportGragh",3,"M",1,1,"1||14",26,"004",2)
ClassMethod getReportGraghExecute(ByRef qHandle As %Binary, cycleDr As %String, fre As %String, start As %String, end As %String, schemDr As %String, jxUnitDr As %String, KPICode As %String, flag As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	;n (cycleDr,fre,start,end,schemDr,jxUnitDr,KPICode,flag)
	//cycleDr,fre,start,end,schemDr,jxUnitDr,KPICode
	q:cycleDr="" $$$OK
	q:fre="" $$$OK
	q:start="" $$$OK
	q:end="" $$$OK
	q:schemDr="" $$$OK
	q:jxUnitDr="" $$$OK
	q:KPICode="" $$$OK
	q:flag="" $$$OK
	
	//确定期间类型
	i fre="M" s Freq="月"
	i fre="Q" s Freq="季"
	i fre="H" s Freq="半年"
	i fre="Y" s Freq="年"
	
	//获得指标或维度信息 ^DHCCJXPADIMENSTYPE(0,"Code",{DimensType_code},{DimensType_rowid})
	i flag=1 d
	.s KPIInfo = ..GetDimenInfo(KPICode)
	e  s KPIInfo = ..getKPIDr(KPICode)
	q:start>end $$$OK
	//准备新的考核期间(1-->201001变换)
	s newPeriodList=##class(%Library.ListOfDataTypes).%New()
	i start=end d
	.d newPeriodList.Insert(##class(dhc.pa.report.uHospKPIScoreAnlys).GetCycle(cycleDr,start))
	i start<end d
	.s diff=end-start+1
	.f k=1:1:diff d
	..s period=start+k-1
	..d newPeriodList.Insert(##class(dhc.pa.report.uHospKPIScoreAnlys).GetCycle(cycleDr,period))
	s Count=newPeriodList.Count()
	f j=1:1:Count d
	.s newPeriod=newPeriodList.GetAt(j)
	.i newPeriod'="" d
	..s urRowidStr=..GetURRowid(schemDr, newPeriod, jxUnitDr)
	..q:urRowidStr=""
	..;w urRowidStr,!
	..;操作UnitResultDetail表
	..s unitResutDetail = 0
	..f  s unitResutDetail=$o(^DHCCJXPASTRATAGEM($p(urRowidStr,"||",1),"URDetail",$p(urRowidStr,"||",2),unitResutDetail)) q:unitResutDetail=""  d
	...s KPIDr = $p(^DHCCJXPASTRATAGEM($p(urRowidStr,"||",1),"URDetail",$p(urRowidStr,"||",2),unitResutDetail),"^",2)
	...s parent = $p(^DHCCJXPASTRATAGEM($p(urRowidStr,"||",1),"URDetail",$p(urRowidStr,"||",2),unitResutDetail),"^",25)
	...i flag'=1 d
	....i KPIDr=$p(KPIInfo,"^",1)&&(parent'=0) d
	.....s KPIName=$p(KPIInfo,"^",2)
	.....s sorce = $p(^DHCCJXPASTRATAGEM($p(urRowidStr,"||",1),"URDetail",$p(urRowidStr,"||",2),unitResutDetail),"^",11)
	.....s sorce = $fn(sorce,"",2)
	.....s periodName=$E(newPeriod,5,6)_Freq
	.....d OutputRow
	...e  d
	....i KPIDr=$p(KPIInfo,"^",1)&&(parent=0) d
	.....s KPIName=$p(KPIInfo,"^",2)
	.....s sorce = $p(^DHCCJXPASTRATAGEM($p(urRowidStr,"||",1),"URDetail",$p(urRowidStr,"||",2),unitResutDetail),"^",11)
	.....s sorce = $fn(sorce,"",2)
	.....s periodName=$E(newPeriod,5,6)_Freq
	.....d OutputRow
	....;w KPICode,KPIName,periodName,$fn(sorce,"",2),!
	q $$$OK

OutputRow	
 	s Data=$lb(KPICode,KPIName,periodName,sorce)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getReportGraghFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getReportGraghExecute ]
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

Query getReportGragh(cycleDr As %String, fre As %String, start As %String, end As %String, schemDr As %String, jxUnitDr As %String, KPICode As %String, flag As %String) As %Query(ROWSPEC = "KPICode:%String,KPIName:%String,periodName:%String,sorce:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uDeptKPIScor8D2S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
