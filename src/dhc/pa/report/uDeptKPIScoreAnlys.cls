/// Creator: wang ying
/// CreatDate: 2010-11-8
/// Description: 科室指标值分析报表
Class dhc.pa.report.uDeptKPIScoreAnlys Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).GetCycle(1,1)
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

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:获取绩效单元考核主表记录字符串
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDrStr-绩效单元Dr字符串;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录字符串
/// Others:w ##class(dhc.pa.report.uDeptKPIScoreAnlys).GetURRowidStr("1||1","201001",1)
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

/// Creator:wang ying 
/// CreatDate:2010-11-8
/// Description:获取绩效单元考核主表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).GetURRowid("1||1","200901",7)
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
	
	q urRowid
}

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:寻找树根以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;level-级别深度
/// Output:
/// Return:返回树根以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uDeptKPIScoreAnlys).FindRoots("1||2",1)
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

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:寻找树根下所有子节点以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;level-级别深度;KPIDrInfoStr-子节点信息字符串
/// Output:
/// Return:返回树根下所有子节点以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uDeptKPIScoreAnlys).FindChildNodes("1||2",1,"",1)
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

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:根据指标ID获取指标名称等信息
/// Table:dhc_pa_data.KPIIndex1
/// Input:KPIDr-指标Dr,level-级别深度
/// Output:
/// Return:返回指标信息
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).GetKPIInfo(21,2)
ClassMethod GetKPIInfo(KPIDr, level) As %String
{
	n (KPIDr,level)
	
	i level=2 s nullStr="  "
	i level=3 s nullStr="    "
	i level=4 s nullStr="      "
	i level=5 s nullStr="        "
	
	s KPIInfo=""
	q:KPIDr="" KPIInfo
	s KPICode="",KPIName="",calUnitName=""
	
	i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	.i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	..s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	..s KPIName=nullStr_KPIName
	..s KPICode=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",1)
	..s calUnitDr = $P(^DHCCJXPAKPIINDEX1(KPIDr),"^",8)
	..i calUnitDr'="" d
    ...i $D(^DHCCJXPACALUNIT(calUnitDr)) d
	....i $G(^DHCCJXPACALUNIT(calUnitDr)) d
	.....s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
	i calUnitName="" d
	.s calUnitNam="无"
	s KPIInfo=KPICode_"^"_KPIName_"^"_calUnitName
	
	q KPIInfo
}

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:根据维度ID获取维度名称等信息
/// Table:dhc_pa_data.DimensType
/// Input:DimenDr-维度Dr
/// Output:
/// Return:返回维度信息
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).GetDimenInfo(1)
ClassMethod GetDimenInfo(DimenDr) As %String
{
	n (DimenDr)
	
	s DimenInfo=""
	q:DimenDr="" DimenInfo
	
	s KPICode="",KPIName=""
	i $D(^DHCCJXPADIMENSTYPE(DimenDr)) d
	.i $G(^DHCCJXPADIMENSTYPE(DimenDr))'="" d
	..s DimenCode=$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",1)
	..s KPICode=DimenCode
	..s DimenName=$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",2)
	..s KPIName=DimenName
	
	s DimenInfo=KPICode_"^"_KPIName_"^"
	
	q DimenInfo
}

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:获取绩效单元考核方案明细记录分数
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核方案Dr;KPIDr-KPI指标Dr
/// Output:
/// Return:返回绩效单元考核方案明细记录分数
/// Others:w ##class(dhc.pa.report.uDeptKPIScoreAnlys).GetURDetailInfo("1||2",1,1)
ClassMethod GetURDetailInfo(urRowid, KPIDr, par) As %String
{
	n (urRowid,KPIDr,par)
	
	s score=""
	q:urRowid="" score
	q:KPIDr="" score
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_tValue,UnitResultDetail_actValue,UnitResultDetail_score,UnitResultDetail_rate,UnitResultDetail_estDesc,UnitResultDetail_fBDesc from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	i par=0 d
	.s whereStr=whereStr_" and UnitResultDetail_parent=0"
	e  d
	.s whereStr=whereStr_" and UnitResultDetail_parent!=0"
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s score = result.Data("UnitResultDetail_actValue") //指标实际值
	}
	
	q score
}

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:处理节点信息字符串
/// Table:
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;NodeInfoStr-节点信息字符串;newPeriod-新的考核期间
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).DealNodeInfo("1||15",1,"1!1^22!2^23!3^24!4^21!2","201001")
ClassMethod DealNodeInfo(urRowid, rootDr, NodeInfoStr, newPeriod) As %String
{
	n (urRowid,rootDr,NodeInfoStr,newPeriod)
	
	q:urRowid=""
	q:rootDr=""
	q:NodeInfoStr=""
	
	s Len=$L(NodeInfoStr,"^")
	s KPIInfo=""
	
	f k=1:1:Len d
	.s NodeInfo=$P(NodeInfoStr,"^",k)
	.s KPIDr=$P(NodeInfo,"!",1)
	.s level=$P(NodeInfo,"!",2)
	.i k=1 d
	..s KPIInfo=..GetDimenInfo(KPIDr)_"^1"
	..s Score=..GetURDetailInfo(urRowid, KPIDr,0)
	..;w KPIInfo,"Score="_Score,!
	..s KPIDr=-KPIDr
	.e  d
	..s KPIInfo=..GetKPIInfo(KPIDr, level)_"^2"
	..;w urRowid, KPIDr,!
	..s Score=..GetURDetailInfo(urRowid, KPIDr,1)
	.s NodeAllInfo=KPIInfo_"^"_Score
	.;w NodeAllInfo,!
	.;将数据存入临时Global
	.i KPIDr<0 d
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_$P(Curr,"^",4)_"^"_($P(Curr,"^",5)+Score)
	...s ^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr)=NodeAllInfo
	.e  d
	..s code=$P(NodeAllInfo,"^",1)
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,code)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,code))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_"^"_$P(Curr,"^",4)_($P(Curr,"^",5)+Score)
	...s ^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,code)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,code)=NodeAllInfo
}

ClassMethod GetLocSchemScoreReportExecute(ByRef qHandle As %Binary, cycleDr As %Integer, frequency As %String, startPeriod As %Integer, endPeriod As %Integer, schemDr As %String, jxUnitDr As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:startPeriod="" $$$OK
	q:endPeriod="" $$$OK
	q:schemDr="" $$$OK
	q:jxUnitDr="" $$$OK
	
	k ^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport")
	
	q:startPeriod>endPeriod $$$OK
	//准备新的考核期间(1-->201001变换)
	s newPeriodList=##class(%Library.ListOfDataTypes).%New()
	i startPeriod=endPeriod d
	.d newPeriodList.Insert(..GetCycle(cycleDr,startPeriod))
	i startPeriod<endPeriod d
	.s diff=endPeriod-startPeriod+1
	.f k=1:1:diff d
	..s period=startPeriod+k-1
	..d newPeriodList.Insert(..GetCycle(cycleDr,period))
	
	//遍历集合List
	s Count=newPeriodList.Count()
	f j=1:1:Count d
	.s newPeriod=newPeriodList.GetAt(j)
	.i newPeriod'="" d
	..s urRowidStr=..GetURRowidStr(schemDr, newPeriod, jxUnitDr)
	..q:urRowidStr=""
	..;操作UnitResultDetail表
	..s Length=$L(urRowidStr,"^")
	..f m=1:1:Length d
	...s urRowid=$P(urRowidStr,"^",m)
	...s level=1
	...;获取根节点信息
	...s urdRootInfoStr=..FindRoots(urRowid,level)
	...s Len=$L(urdRootInfoStr,"^")
	...f h=1:1:Len d
	....s urdRootInfo=$P(urdRootInfoStr,"^",h)
	....s rootDr=$P(urdRootInfo,"!",1)
	....s KPIDrInfoStr=""
	....s KPIDrInfoStr=..FindChildNodes(urRowid,rootDr,KPIDrInfoStr,level)
	....s NodeInfoStr=urdRootInfo_"^"_KPIDrInfoStr
	....d ..DealNodeInfo(urRowid,rootDr,NodeInfoStr,newPeriod)
	//从临时Global中处理数据
	i $D(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport")) d
	.s newPeriod=0
	.f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod)) q:newPeriod=""  d
	..s rootDr=0,count=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr)) q:KPIDr=""  d
	....s count=count+1
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr))
	....s ^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr)=Curr_"^"_count

	s target=""
	//确定期间类型
	i frequency="M" s Freq="月"
	i frequency="Q" s Freq="季"
	i frequency="H" s Freq="半年"
	i frequency="Y" s Freq="年"
	s Graph="柱形图"
	//从临时Global中取出数据
	//^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr)
	i $D(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport")) d
	.s newPeriod=0
	.f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod)) q:newPeriod=""  d
	..s periodName=""
	..s newPeriodStr=$E(newPeriod,5)
	..i newPeriodStr=0 d
	...s periodName="0"_$E(newPeriod,6)_Freq
	..e  d
	...s periodName=$E(newPeriod,5,6)_Freq
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr)) q:KPIDr=""  d
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport",newPeriod,rootDr,KPIDr))
	....s KPICode=$P(Curr,"^",1)
	....i $p(KPICode,"$",2)'="" d
	.....s target=1
	....s KPIName=$P(Curr,"^",2)
	....s calUnitName=$P(Curr,"^",3)
	....s target=$P(Curr,"^",4)
	....s score=$P(Curr,"^",5)
	....s count=$P(Curr,"^",6)
	....d OutputRow
	
	k ^TEMPDHCCJXPA("dhc","pa","report","deptKPIScoreReport")
	
 	q $$$OK
OutputRow
	
 	s Data=$lb(Graph,KPICode,KPIName,calUnitName,periodName,$fn(score,"",2),count,target)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetLocSchemScoreReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocSchemScoreReportExecute ]
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

ClassMethod GetLocSchemScoreReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocSchemScoreReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wang ying
/// CreatDate:2010-11-8
/// Description:全院指标值分析
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptKPIScoreAnlys","GetLocSchemScoreReport",1,"M",1,3,"1||1",7)
Query GetLocSchemScoreReport(cycleDr As %Integer, frequency As %String, startPeriod As %Integer, endPeriod As %Integer, schemDr As %String, jxUnitDr As %Integer) As %Query(ROWSPEC = "Graph:%String,KPICode:%String,KPIName:%String,calUnitName:%String,periodName:%String,score:%Float,count:%Integer,target:%Integer") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uDeptKPIScor6E9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
