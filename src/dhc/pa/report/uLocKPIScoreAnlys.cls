/// Creator: wang ying
/// CreatDate: 2010-10-11
/// Description: 科室指标值分析（指标）
Class dhc.pa.report.uLocKPIScoreAnlys Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2010-10-11
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(5,2)
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
/// CreatDate:2010-10-12
/// Description:获取绩效单元考核主表记录字符串
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDrStr-绩效单元Dr字符串;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录字符串
/// Others:w ##class(dhc.pa.report.uLocSchemScoreAnlys).GetURRowidStr("1||2","201001",1)
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
/// CreatDate:2010-10-12
/// Description:获取绩效单元考核主表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录
/// Others:w ##class(dhc.pa.report.uLocSchemScoreAnlys).GetURRowid("1||2","201001",1)
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
/// CreatDate:2010-10-12
/// Description:寻找树根以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;level-级别深度
/// Output:
/// Return:返回树根以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uLocKPIScoreAnlys).FindRoots("1||15",1,"1&1")
ClassMethod FindRoots(urRowid, level, KPIRowid) As %String
{
	//
	n (urRowid,level,KPIRowid)
	
	s urdRootInfoStr=""
	q:urRowid="" urdRootInfoStr
	
	s stratagemDr=$P(urRowid,"||",1)
	s urChildSub=$P(urRowid,"||",2)
	
	s urdRootChildSub=0
	f  s urdRootChildSub=$o(^DHCCJXPASTRATAGEM(0,"URDParent",stratagemDr,0,urChildSub,urdRootChildSub)) q:urdRootChildSub=""  d
	.s KPIDr=$P(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",urChildSub,urdRootChildSub),"^",2)
	.;//树根KPI表示维度
	.s KPIStr=KPIRowid.Find(KPIDr_"&1",1)
	.;w KPIRowid.GetAt(4)
	.i KPIStr'="" d
	..s KPIDrInfo=KPIDr_"!"_level
	..i urdRootInfoStr="" d
	...s urdRootInfoStr=KPIDrInfo
	..e  d
	...s urdRootInfoStr=urdRootInfoStr_"^"_KPIDrInfo
	
	q urdRootInfoStr
}

/// Creator:wang ying
/// CreatDate:2010-10-12
/// Description:寻找树根下所有子节点以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;level-级别深度;KPIDrInfoStr-子节点信息字符串
/// Output:
/// Return:返回树根下所有子节点以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uLocKPIScoreAnlys).FindChildNodes("1||15",1,"",1)
ClassMethod FindChildNodes(urRowid, rootDr, KPIDrInfoStr, level, KPIRowid) As %String
{
	n (urRowid,rootDr,KPIDrInfoStr,level,KPIRowid)
	
	q:urRowid="" KPIDrInfoStr
	q:rootDr="" KPIDrInfoStr
	i level="" s level=1
	
	s stratagemDr=$P(urRowid,"||",1)
	s urChildSub=$P(urRowid,"||",2)
	
	s level=level+1
	s urdChildSub=0
	f  s urdChildSub=$O(^DHCCJXPASTRATAGEM(0,"URDParent",stratagemDr,-rootDr,urChildSub,urdChildSub)) q:urdChildSub=""  d
	.s KPIDr=$P(^DHCCJXPASTRATAGEM(stratagemDr,"URDetail",urChildSub,urdChildSub),"^",2)
	.s KPIStr=KPIRowid.Find(KPIDr_"&2",1)
	.i KPIStr'="" d
	..s KPIDrInfo=KPIDr_"!"_level
	..i KPIDrInfoStr="" d
	...s KPIDrInfoStr=KPIDrInfo
	..e  d
	...s KPIDrInfoStr=KPIDrInfoStr_"^"_KPIDrInfo
	.i $D(^DHCCJXPASTRATAGEM(0,"URDParent",stratagemDr,KPIDr,urChildSub)) d
	..s KPIDrInfoStr=..FindChildNodes(urRowid,-KPIDr,KPIDrInfoStr,level,KPIRowid)
	
	q KPIDrInfoStr
}

/// Creator:wang ying
/// CreatDate:2010-10-12
/// Description:根据指标ID获取指标名称等信息
/// Table:dhc_pa_data.KPIIndex1
/// Input:KPIDr-指标Dr,level-级别深度
/// Output:
/// Return:返回指标信息
/// Others:w ##class(dhc.pa.report.uLocSchemScoreAnlys).GetKPIInfo(21,2)
ClassMethod GetKPIInfo(KPIDr, level) As %String
{
	n (KPIDr,level)
	
	i level=2 s nullStr="  "
	i level=3 s nullStr="    "
	i level=4 s nullStr="      "
	i level=5 s nullStr="        "
	
	s KPIInfo=""
	q:KPIDr="" KPIInfo
	s KPICode="",KPIName=""
	
	i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	.i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	..s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	..s KPIName=nullStr_KPIName
	..s KPICode=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",1)
	
	s KPIInfo=KPICode_"^"_KPIName
	
	q KPIInfo
}

/// Creator:wang ying
/// CreatDate:2010-10-12
/// Description:根据维度ID获取维度名称等信息
/// Table:dhc_pa_data.DimensType
/// Input:DimenDr-维度Dr
/// Output:
/// Return:返回维度信息
/// Others:w ##class(dhc.pa.report.uLocSchemScoreAnlys).GetDimenInfo(1)
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
	
	s DimenInfo=KPICode_"^"_KPIName
	
	q DimenInfo
}

/// Creator:wang ying
/// CreatDate:2010-10-12
/// Description:获取绩效单元考核方案明细记录分数
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核方案Dr;KPIDr-KPI指标Dr
/// Output:
/// Return:返回绩效单元考核方案明细记录分数
/// Others:w ##class(dhc.pa.report.uLocSchemScoreAnlys).GetURDetailInfo("1||15",21)
ClassMethod GetURDetailInfo(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s score=""
	q:urRowid="" score
	q:KPIDr="" score
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_tValue,UnitResultDetail_actValue,UnitResultDetail_score,UnitResultDetail_rate,UnitResultDetail_estDesc,UnitResultDetail_fBDesc from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s score = result.Data("UnitResultDetail_score") //分数
	}
	
	q score
}

/// Creator:wang ying
/// CreatDate:2010-10-12
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
	f k=1:1:Len d
	.s NodeInfo=$P(NodeInfoStr,"^",k)
	.s KPIDr=$P(NodeInfo,"!",1)
	.s level=$P(NodeInfo,"!",2)
	.i k=1 d
	..s KPIInfo=..GetDimenInfo(KPIDr)
	.e  d
	..s KPIInfo=..GetKPIInfo(KPIDr, level)
	.s Score=..GetURDetailInfo(urRowid, KPIDr)
	.s NodeAllInfo=KPIInfo_"^"_Score
	.;将数据存入临时Global
	.i $D(^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod,rootDr,KPIDr)) d
	..s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod,rootDr,KPIDr))
	..s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_($P(Curr,"^",3)+Score)
	..s ^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod,rootDr,KPIDr)=str
	.e  d
	..s ^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod,rootDr,KPIDr)=NodeAllInfo
}

ClassMethod LocKPIScoreAnlysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocKPIScoreAnlysExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LocKPIScoreAnlysExecute(ByRef qHandle As %Binary, cycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, schemDr As %String, jxUnitDr As %String, KPIDr As %String) As %Status
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
	q:KPIDr="" $$$OK
	
	s KPILen=$l(KPIDr,",")
	
	s KPIList=##class(%Library.ListOfDataTypes).%New()
	f i=1:1:KPILen d
	.d KPIList.Insert($p(KPIDr,",",i))
	
	k ^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport")
	
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
	..s urRowidStr=..GetURRowidStr(schemDr,newPeriod,jxUnitDr)
	..q:urRowidStr=""
	..;操作UnitResultDetail表
	..s Length=$L(urRowidStr,"^")
	..f m=1:1:Length d
	...s urRowid=$P(urRowidStr,"^",m)
	...s level=1
	...;获取根节点信息
	...s urdRootInfoStr=..FindRoots(urRowid,level,KPIList)
	...s Len=$L(urdRootInfoStr,"^")
	...f h=1:1:Len d
	....s urdRootInfo=$P(urdRootInfoStr,"^",h)
	....s rootDr=$P(urdRootInfo,"!",1)
	....s KPIDrInfoStr=""
	....s KPIDrInfoStr=..FindChildNodes(urRowid,rootDr,KPIDrInfoStr,level,KPIList)
	....s NodeInfoStr=urdRootInfo_"^"_KPIDrInfoStr
	....d ..DealNodeInfo(urRowid,rootDr,NodeInfoStr,newPeriod)
	//确定期间类型
	i frequency="M" s Freq="月"
	i frequency="Q" s Freq="季"
	i frequency="H" s Freq="半年"
	i frequency="Y" s Freq="年"
	s Graph="折线图"
	//从临时Global中取出数据
	//^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod,rootDr,KPIDr)
	i $D(^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport")) d
	.s newPeriod=0
	.f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod)) q:newPeriod=""  d
	..s periodName=""
	..s newPeriodStr=$E(newPeriod,5)
	..i newPeriodStr=0 d
	...s periodName=$E(newPeriod,6)_Freq
	..e  d
	...s periodName=$E(newPeriod,5,6)_Freq
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod,rootDr)) q:rootDr=""  d
	...s KPIDr=0
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod,rootDr,KPIDr)) q:KPIDr=""  d
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport",newPeriod,rootDr,KPIDr))
	....s KPICode=$P(Curr,"^",1)
	....s KPIName=$P(Curr,"^",2)
	....s score=$P(Curr,"^",3)
	....d OutputRow
	
	k ^TEMPDHCCJXPA("dhc","pa","report","locSchemScoreReport")
	
 	q $$$OK
OutputRow
	
 	s Data=$lb(Graph,KPICode,KPIName,periodName,$fn(score,"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod LocKPIScoreAnlysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocKPIScoreAnlysExecute ]
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

//d ##class(%ResultSet).RunQuery("dhc.pa.report.uLocKPIScoreAnlys","LocKPIScoreAnlys",1,"M",1,5,"1||2",1,"24&2,23&2,21&2,1&1")

Query LocKPIScoreAnlys(cycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, schemDr As %String, jxUnitDr As %String, KPIDr As %String) As %Query(ROWSPEC = "Graph:%String,KPICode:%String,KPIName:%String,periodName:%String,score:%Float") [ SqlProc ]
{
}

ClassMethod GetKPIByJXUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKPIByJXUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKPIByJXUnitExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	s count=0
	s stratagem=0
	s StragtagemDr=""
	f  s stratagem=$o(^DHCCJXPASTRATAGEM(stratagem)) q:stratagem=""  d
	.s currStratagem=$p($g(^DHCCJXPASTRATAGEM(stratagem)),"^",14)
	.i currStratagem="Y"  d
	..s StragtagemDr=stratagem
	..s count=count+1
	q:count>1 
	
	s JXUnitDr=0
	f {
	s JXUnitDr=$o(^DHCCJXPAJXUNIT(JXUnitDr)) 
	q:JXUnitDr="" 
	s UnitResultDr=0
	i $d(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",StragtagemDr,JXUnitDr)) d
	.s UnitResultDr=$o(^DHCCJXPASTRATAGEM(0,"UnitResultJXUnit",StragtagemDr,JXUnitDr,UnitResultDr))
	.i UnitResultDr'="" d
	..s UnitResultDetailDr=0
	..f  s UnitResultDetailDr=$o(^DHCCJXPASTRATAGEM(StragtagemDr,"URDetail",UnitResultDr,UnitResultDetailDr)) q:UnitResultDetailDr=""  d
	...s UnitResultDetailAll=$g(^DHCCJXPASTRATAGEM(StragtagemDr,"URDetail",UnitResultDr,UnitResultDetailDr))
	...s isTarget=$p(UnitResultDetailAll,"^",4)
	...s KPIDr = $p(UnitResultDetailAll,"^",2)
	...i (isTarget=2)&&(KPIDr'="") d
	....i $d(^DHCCJXPAKPIINDEX1(KPIDr))  d
	.....s KPIName=$p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
	...i (isTarget=1)&&(KPIDr'="") d
	....i $d(^DHCCJXPADIMENSTYPE(KPIDr))  d
	.....s KPIName=$p($g(^DHCCJXPADIMENSTYPE(KPIDr)),"^",2)
	...d OutputKPI
	
	}
 	q $$$OK
OutputKPI
	
 	s Data=$lb(JXUnitDr,KPIDr_"&"_isTarget,KPIName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetKPIByJXUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKPIByJXUnitExecute ]
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

/// d ##class(%ResultSet).RunQuery("dhc.pa.report.uLocKPIScoreAnlys","GetKPIByJXUnit")
Query GetKPIByJXUnit() As %Query(ROWSPEC = "JXUnitDr:%String,KPIDr:%String,KPIName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uLocKPIScore67AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
