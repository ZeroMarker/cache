Class dhc.pa.report.uYantaiTemp Extends %Persistent
{

/*
/// Creator: wyy
/// CreatDate: 2013-3-23
/// Description: 科室考核汇总报表
Class dhc.pa.report.uYantaiReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Input:cycleDr-考核周期Dr;period-期间
/// w ##class(dhc.pa.report.uYantaiReport).GetCycle(1,1)
ClassMethod GetCycle(cycleDr, period) As %String
{
	n (cycleDr,period)
	
	q:cycleDr="" "UnCycle" //不计算
	q:period="" "UnPeriod" //不计算
	s newPeriod=""
	
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'=""  d
	..s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "UnCycleCode" //不计算
	
	i period<10 d
	.s period="0"_period
	s newPeriod=cycleCode_period
	
	q newPeriod
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// w ##class(dhc.pa.report.uHospReport).GetJXUnitOfSchem("1||2")
ClassMethod GetJXUnitOfSchem(jxUnitDrList, schemDr) As %Library.ListOfDataTypes
{
	n (jxUnitDrList,schemDr)
	
	s jxUnitDrStr=""
	q:schemDr="" jxUnitDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitSchem_parRef from dhc_pa_data.UnitSchem where UnitSchem_childSub>0"
	s whereStr=" and UnitSchem_schemDr='"_schemDr_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s parRef = result.Data("UnitSchem_parRef")
		i parRef'="" d
		.d jxUnitDrList.Insert(parRef)
	}
	
	q jxUnitDrList
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:获取绩效单元考核主表记录字符串
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDrStr-绩效单元Dr字符串;newPeriod-新的考核周期
/// Return:返回绩效单元考核主表记录字符串
/// w ##class(dhc.pa.report.uHospReport).GetURRowidStr("1||2","201001",1)
ClassMethod GetURRowidStr(schemDr, newPeriod, jxUnitDrStr) As %String
{
	n (schemDr,newPeriod,jxUnitDrStr)
	
	s urRowidStr=""
	q:schemDr="" urRowidStr
	q:newPeriod="" urRowidStr
	q:jxUnitDrStr="" urRowidStr
	
	s Length=$L(jxUnitDrStr,"^")
	f k=1:1:Length d
	.s jxUnitDr=$P(jxUnitDrStr,"^",k)
	.i jxUnitDr'="" d
	..s urRowid=..GetURRowid(schemDr,newPeriod,jxUnitDr)
	..i urRowid'="" d
	...i urRowidStr="" d
	....s urRowidStr=urRowid
	...e  d
	....s urRowidStr=urRowidStr_"^"_urRowid
	
	q urRowidStr
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:获取绩效单元考核主表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Return:返回绩效单元考核主表记录
/// w ##class(dhc.pa.report.uHospReport).GetURRowid("1||2","201001",1)
ClassMethod GetURRowid(schemDr, newPeriod, jxUnitDr) As %String
{
	n (schemDr,newPeriod,jxUnitDr)
	
	s urRowid=""
	q:schemDr="" urRowid
	q:newPeriod="" urRowid
	q:jxUnitDr="" urRowid
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_rowid from dhc_pa_data.UnitResult where UnitResult_childSub>0"
	s whereStr=" and UnitResult_schemDr='"_schemDr_"'"
	s whereStr=whereStr_" and UnitResult_period='"_newPeriod_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr='"_jxUnitDr_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s urRowid = result.Data("UnitResult_rowid")
	}
	
	q urRowid_"-"_jxUnitDr
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:寻找树根以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;level-级别深度
/// Return:返回树根以及节点深度信息记录
/// w ##class(dhc.pa.report.uHospReport).FindRoots("1||15",1)
ClassMethod FindRoots(urRowid, level) As %String
{
	n (urRowid,level)
	
	s urdRootInfoStr=""
	q:urRowid="" urdRootInfoStr
	
	s stratagemDr=$P(urRowid,"||",1)
	s urChildSub=$P(urRowid,"||",2)
	
	s urdRootChildSub=0
	f  s urdRootChildSub=$O(^DHCCJXPASTRATAGEM(0,"URDParent",stratagemDr,0,urChildSub,urdRootChildSub)) q:urdRootChildSub=""  d
	.s KPIDr=$P(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",urChildSub,urdRootChildSub),"^",2)
	.;//树根KPI表示维度
	.s KPIDrInfo=KPIDr_"!"_level
	.i urdRootInfoStr="" d
	..s urdRootInfoStr=KPIDrInfo
	.e  d
	..s urdRootInfoStr=urdRootInfoStr_"^"_KPIDrInfo
	
	q urdRootInfoStr
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:寻找树根下所有子节点以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;level-级别深度;KPIDrInfoStr-子节点信息字符串
/// Return:返回树根下所有子节点以及节点深度信息记录
/// w ##class(dhc.pa.report.uHospReport).FindChildNodes("1||15",1,"",1)
ClassMethod FindChildNodes(urRowid, rootDr, KPIDrInfoStr, level) As %String
{
	n (urRowid,rootDr,KPIDrInfoStr,level)
	
	q:urRowid="" KPIDrInfoStr
	q:rootDr="" KPIDrInfoStr
	i level="" s level=1
	
	s stratagemDr=$P(urRowid,"||",1)
	s urChildSub=$P(urRowid,"||",2)
	
	s level=level+1
	s urdChildSub=0
	f  s urdChildSub=$O(^DHCCJXPASTRATAGEM(0,"URDParent",stratagemDr,-rootDr,urChildSub,urdChildSub)) q:urdChildSub=""  d
	.s KPIDr=$P(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",urChildSub,urdChildSub),"^",2)
	.s KPIDrInfo=KPIDr_"!"_level
	.i KPIDrInfoStr="" d
	..s KPIDrInfoStr=KPIDrInfo
	.e  d
	..s KPIDrInfoStr=KPIDrInfoStr_"^"_KPIDrInfo
	.i $D(^DHCCJXPASTRATAGEM(0,"URDParent",stratagemDr,KPIDr,urChildSub)) d
	..s KPIDrInfoStr=..FindChildNodes(urRowid,-KPIDr,KPIDrInfoStr,level)
	
	q KPIDrInfoStr
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:根据指标ID获取指标名称等信息
/// Table:dhc_pa_data.KPIIndex1
/// Input:KPIDr-指标Dr,level-级别深度
/// Return:返回指标信息
/// w ##class(dhc.pa.report.uHospReport).GetKPIInfo(21,2)
ClassMethod GetKPIInfo(KPIDr, level) As %String
{
	n (KPIDr,level)
	
	i level=2 s nullStr="  "
	i level=3 s nullStr="    "
	i level=4 s nullStr="      "
	i level=5 s nullStr="        "
	
	s KPIInfo=""
	q:KPIDr="" KPIInfo
	s KPICode="",KPIName="",methodCode="",methodName=""
	
	i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	.i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	..s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	..s KPIName=nullStr_KPIName
	..s KPICode=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",1)
	..s methodCode=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",13)
	..i methodCode="I" s methodName="区间法"
	..i methodCode="C" s methodName="比较法"
	..i methodCode="D" s methodName="扣分法"
	..i methodCode="A" s methodName="加分法"
	..i methodCode="M" s methodName="目标参照法"
	
	s KPIInfo=KPICode_"^"_KPIName_"^"_methodName
	
	q KPIInfo
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:根据维度ID获取维度名称等信息
/// Table:dhc_pa_data.DimensType
/// Input:DimenDr-维度Dr
/// Return:返回维度信息
/// w ##class(dhc.pa.report.uHospReport).GetDimenInfo(1)
ClassMethod GetDimenInfo(DimenDr) As %String
{
	n (DimenDr)
	
	s DimenInfo=""
	q:DimenDr="" DimenInfo
	
	s KPICode="",KPIName="",methodName=""
	i $D(^DHCCJXPADIMENSTYPE(DimenDr)) d
	.i $G(^DHCCJXPADIMENSTYPE(DimenDr))'="" d
	..s DimenCode="" //$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",1)
	..s KPICode=DimenCode
	..s DimenName=$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",2)
	..s KPIName=DimenName
	
	s DimenInfo=KPICode_"^"_KPIName_"^"_methodName
	
	q DimenInfo
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:获取绩效单元考核方案明细记录分数
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核方案Dr;KPIDr-KPI指标Dr
/// Return:返回绩效单元考核方案明细记录分数
/// w ##class(dhc.pa.report.uHospReport).GetURDetailScore("1||15",21)
ClassMethod GetURDetailScore(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s score=""
	q:urRowid="" score
	q:KPIDr="" score
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_score,UnitResultDetail_rate from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	i KPIDr>0 s whereStr=whereStr_" and UnitResultDetail_isTarget=2 and UnitResultDetail_KPIDr='"_KPIDr_"'"
	i KPIDr<0 s whereStr=whereStr_" and UnitResultDetail_isTarget=1 and UnitResultDetail_KPIDr='"_-KPIDr_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s score = result.Data("UnitResultDetail_score")
		s rate = result.Data("UnitResultDetail_rate")
	}
	
	q score_"^"_rate
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:处理节点信息字符串
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;NodeInfoStr-节点信息字符串;jxUnitDr-绩效单元Dr
/// w ##class(dhc.pa.report.uHospReport).DealNodeInfo("1||15",1,"1!1^22!2^23!3^24!4^21!2")
ClassMethod DealNodeInfo(urRowid, rootDr, NodeInfoStr, jxUnitDr) As %String
{
	n (urRowid,rootDr,NodeInfoStr,jxUnitDr)
	
	q:urRowid=""
	q:rootDr=""
	q:NodeInfoStr=""
	q:jxUnitDr=""
	
	s Len=$L(NodeInfoStr,"^")
	s KPIInfo=""
	f k=1:1:Len d
	.s NodeInfo=$P(NodeInfoStr,"^",k)
	.s KPIDr=$P(NodeInfo,"!",1)
	.s level=$P(NodeInfo,"!",2)
	.i k=1 d
	..s KPIInfo=..GetDimenInfo(KPIDr)
	..s KPIDr=-KPIDr
	.e  d
	..s KPIInfo=..GetKPIInfo(KPIDr, level)
	.s Score=..GetURDetailScore(urRowid, KPIDr)
	.s NodeAllInfo=KPIInfo_"^"_Score
	.;将数据存入临时Global
	.i KPIDr<0 d
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_($P(Curr,"^",4)+Score)_"^"_$P(Curr,"^",5)
	...s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr)=NodeAllInfo
	.e  d
	..s code=$P(NodeAllInfo,"^",1)
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_($P(Curr,"^",4)+Score)_"^"_$P(Curr,"^",5)
	...s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code)=NodeAllInfo
}

ClassMethod GetLocSumReportExecute(ByRef qHandle As %Binary, cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String, groupDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:period="" $$$OK
	q:schemDr="" $$$OK
	q:groupDr="" $$$OK
	
	k ^TEMPDHCCJXPA("dhc","pa","report","locSumReport")
	
	//首先判断分组是否是科室分组
	s locGroup=""
	i $D(^DHCCJXPAJXGROUP(groupDr)) d
	.i $G(^DHCCJXPAJXGROUP(groupDr))'="" d
	..;取分组类别
	..s gType=$P(^DHCCJXPAJXGROUP(groupDr),"^",5)
	..i gType=2 d //科室分组,否则为指标分组
	...s locGroup=$P(^DHCCJXPAJXGROUP(groupDr),"^",3)
	q:locGroup="" $$$OK
	s Len=$L(locGroup,"-")
	
	//获取新考核期间
	s newPeriod=..GetCycle(cycleDr,period)
	q:newPeriod="" $$$OK
	
	//定义一个绩效单元集合List
	s jxUnitDrList=##class(%Library.ListOfDataTypes).%New() 
	s jxUnitDrList=..GetJXUnitOfSchem(jxUnitDrList,schemDr)
	
	//帅选新的绩效单元
	s newLocGroup=""
	f k=1:1:Len d
	.s locDr=$P(locGroup,"-",k)
	.s retStr=jxUnitDrList.Find(locDr,1)
	.i retStr'="" d
	..i newLocGroup="" s newLocGroup=locDr
	..e  s newLocGroup=newLocGroup_"^"_locDr
	q:newLocGroup="" $$$OK
	
	s urRowidStr=..GetURRowidStr(schemDr, newPeriod, newLocGroup)
	q:urRowidStr="" $$$OK
	
	s Length=$L(urRowidStr,"^")
	f k=1:1:Length d
	.s urRowidInfo=$P(urRowidStr,"^",k)
	.s jxUnitDr=$P(urRowidInfo,"-",2)
	.i jxUnitDr'="" d
	..s urRowid=$P(urRowidInfo,"-",1)
	..i urRowid'="" d
	...s level=1
	...;获取根节点信息
	...s urdRootInfoStr=..FindRoots(urRowid,level)
	...s Len2=$L(urdRootInfoStr,"^")
	...f m=1:1:Len2 d
	....s urdRootInfo=$P(urdRootInfoStr,"^",m)
	....s rootDr=$P(urdRootInfo,"!",1)
	....s KPIDrInfoStr=""
	....s KPIDrInfoStr=..FindChildNodes(urRowid,rootDr,KPIDrInfoStr,level)
	....s NodeInfoStr=urdRootInfo_"^"_KPIDrInfoStr
	....d ..DealNodeInfo(urRowid,rootDr,NodeInfoStr,jxUnitDr)
	s totalScore=0
	
	//从临时Global中处理数据
	i $D(^TEMPDHCCJXPA("dhc","pa","report","locSumReport")) d
	.s newPeriod=0
	.f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod)) q:newPeriod=""  d
	..s rootDr=0,count=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,KPIDr)) q:KPIDr=""  d
	....s count=count+1
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,KPIDr))
	....s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,KPIDr)=Curr_"^"_count

	i $D(^TEMPDHCCJXPA("dhc","pa","report","locSumReport")) d
	.s jxUnitDr=0
	.f  s jxUnitDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr)) q:jxUnitDr=""  d
	..s jxUnitName=""
	..i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	...i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	....s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr)) q:KPIDr=""  d
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr))
	....i Curr'="" d
	.....s KPICode=$P(Curr,"^",1)
	.....s KPIName=$P(Curr,"^",2)
	.....s methodName=$P(Curr,"^",3)
	.....;s kdr=$P(Curr,"^",4)
	.....s kdr=..GetkpiNameOfCode(KPICode)
	.....s score=$P(Curr,"^",4)
	.....s rate=$P(Curr,"^",5)
	.....s count=$P(Curr,"^",6)
	.....i KPIDr<0 d
	......s totalScore=totalScore+score
	.....d OutputRow
	
	k ^TEMPDHCCJXPA("dhc","pa","report","locSumReport")
 	q $$$OK
 	
OutputRow
	
 	s Data=$lb(KPIDr,0,KPIName,methodName,jxUnitName,score,rate,count,totalScore,kdr)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetLocSumReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocSumReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}Else{				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocSumReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocSumReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:查询科室汇总报表数据记录
/// d ##class(%ResultSet).RunQuery("dhc.pa.report.uYantaiReport","GetLocSumReport",3,"M",1,"4||1",17)
Query GetLocSumReport(cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String, groupDr As %String) As %Query(ROWSPEC = "Graph:%String,KPIDr:%Float,KPICode:%String,KPIName:%String,methodName:%String,jxUnitName:%String,score:%Float,rate:%Float,count:%Integer,totalScore:%Float,kdr:%String") [ SqlProc ]
{
}

/// w ##class(dhc.pa.report.uYantaiReport).GetkpiNameOfCode("1001000000")
ClassMethod GetkpiNameOfCode(code) As %Library.ListOfDataTypes
{
	n (code)
	
	s rowid=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIIndex1_rowid from dhc_pa_data.KPIIndex1 where %ID>0"
	s whereStr=" and KPIIndex1_code='"_code_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
	}
	
	q rowid
}

}


*/
Storage Default
{
<Data name="uYantaiTempDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.report.uYantaiTempD</DataLocation>
<DefaultData>uYantaiTempDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.report.uYantaiTempD</IdLocation>
<IndexLocation>^dhc.pa.report.uYantaiTempI</IndexLocation>
<StreamLocation>^dhc.pa.report.uYantaiTempS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
