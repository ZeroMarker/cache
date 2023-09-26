/// Creator: 李明忠
/// CreatDate: 2010-9-26
/// Description: 全院指标考核分分析报表
Class dhc.pa.report.uHospKPIScoreAnlys Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-9-26
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

/// Creator:李明忠
/// CreatDate:2010-9-26
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).GetJXUnitOfSchem("1||2")
ClassMethod GetJXUnitOfSchem(schemDr) As %String
{
	n (schemDr)
	
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
		.s jxUnitDr = parRef
		.i jxUnitDrStr="" d
		..s jxUnitDrStr=jxUnitDr
		.e  d
		..s jxUnitDrStr=jxUnitDrStr_"^"_jxUnitDr
	}
	
	q jxUnitDrStr
}

/// Creator:李明忠
/// CreatDate:2010-9-26
/// Description:寻找树根以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;level-级别深度
/// Output:
/// Return:返回树根以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).FindRoots("1||15",1)
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

/// Creator:李明忠
/// CreatDate:2010-9-26
/// Description:寻找树根下所有子节点以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;level-级别深度;KPIDrInfoStr-子节点信息字符串
/// Output:
/// Return:返回树根下所有子节点以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).FindChildNodes("1||15",1,"",1)
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

/// Creator:李明忠
/// CreatDate:2010-9-26
/// Description:获取绩效单元考核主表记录字符串
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDrStr-绩效单元Dr字符串;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录字符串
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).GetURRowidStr("1||2","201001",1)
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

/// Creator:李明忠
/// CreatDate:2010-9-26
/// Description:获取绩效单元考核主表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).GetURRowid("1||2","201001",1)
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

/// Creator:李明忠
/// CreatDate:2010-9-26
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
	s KPICode="",KPIName=""
	
	i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	.i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	..s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	..s KPIName=nullStr_KPIName
	..s KPICode=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",1)
	
	s KPIInfo=KPICode_"^"_KPIName
	
	q KPIInfo
}

/// Creator:李明忠
/// CreatDate:2010-9-26
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
	..s DimenCode="" //$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",1)
	..s KPICode=DimenCode
	..s DimenName=$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",2)
	..s KPIName=DimenName
	
	s DimenInfo=KPICode_"^"_KPIName
	
	q DimenInfo
}

/// Creator:李明忠
/// CreatDate:2010-9-26
/// Description:获取绩效单元考核方案明细记录分数
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核方案Dr;KPIDr-KPI指标Dr
/// Output:
/// Return:返回绩效单元考核方案明细记录分数
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).GetURDetailInfo("1||15",21)
ClassMethod GetURDetailInfo(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s score=""
	q:urRowid="" score
	q:KPIDr="" score
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_tValue,UnitResultDetail_actValue,UnitResultDetail_score,UnitResultDetail_rate,UnitResultDetail_estDesc,UnitResultDetail_fBDesc, UnitResultDetail_Rscore from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0 and  UnitResultDetail_isTarget=2"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	s sqlStr=sqlStr_whereStr
	;s ^chuchu=sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s score = result.Data("UnitResultDetail_score") //分数
		s Rscore = result.Data("UnitResultDetail_Rscore") //最终考核分
		
	}
	
	q score_"^"_Rscore
}

/// Creator:李明忠
/// CreatDate:2010-11-19
/// Description:获取维度记录
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核方案Dr;KPIDr-KPI指标Dr
/// Output:
/// Return:返回维度记录
/// Others:w ##class(dhc.pa.report.uHospReport).GetURDetailInfo2("1||15",21)
ClassMethod GetDimensInfo(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s score=0
	q:urRowid="" score
	q:KPIDr="" score
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_score from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_isTarget=1"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	s whereStr=whereStr_" and UnitResultDetail_parent=0"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s score = result.Data("UnitResultDetail_score") //目标值
	}
	
	q score
}

/// Creator:李明忠
/// CreatDate:2010-9-26
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
	..s KPIInfo=..GetDimenInfo(KPIDr)
	..s KPIDr=-KPIDr
	.e  d
	..s KPIInfo=..GetKPIInfo(KPIDr, level)
	.i KPIDr>0 s Score=..GetURDetailInfo(urRowid, KPIDr)
	.e  s Score=..GetDimensInfo(urRowid, -KPIDr)
	.s NodeAllInfo=KPIInfo_"^"_Score
	.;将数据存入临时Global
	.i KPIDr<0 d
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_($P(Curr,"^",3)+Score)
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)=NodeAllInfo
	.e  d
	..s code=$P(NodeAllInfo,"^",1)
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,code)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,code))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_($P(Curr,"^",3)+Score)
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,code)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,code)=NodeAllInfo
}

ClassMethod GetHospKPIScoreReportExecute(ByRef qHandle As %Binary, cycleDr As %Integer, frequency As %String, startPeriod As %Integer, endPeriod As %Integer, schemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:startPeriod="" $$$OK
	q:endPeriod="" $$$OK
	q:schemDr="" $$$OK
	
	k ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport")
	k ^TEMPKPIScore("KPIScore")
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
	//获取方案下的绩效单元
	s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	q:jxUnitDrStr="" $$$OK
	//遍历集合List
	s Count=newPeriodList.Count()
	f j=1:1:Count d
	.s newPeriod=newPeriodList.GetAt(j)
	.i newPeriod'="" d
	..s urRowidStr=..GetURRowidStr(schemDr, newPeriod, jxUnitDrStr)
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
	....;d ..DealNodeInfo(urRowid,rootDr,NodeInfoStr,newPeriod)
	....d ..DealNodeInfoNew(urRowid,rootDr,NodeInfoStr,newPeriod)
	//确定期间类型
	i frequency="M" s Freq="月"
	i frequency="Q" s Freq="季"
	i frequency="H" s Freq="半年"
	i frequency="Y" s Freq="年"
	s Graph="柱形图"
	//从临时Global中处理数据
	i $D(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport")) d
	.s newPeriod=0
	.f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod)) q:newPeriod=""  d
	..s rootDr=0,count=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)) q:KPIDr=""  d
	....s count=count+1
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr))
	....s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)=Curr_"^"_count
	
	//从临时Global中取出数据
	//^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)
	i $D(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport")) d
	.s newPeriod=0
	.f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod)) q:newPeriod=""  d
	..s periodName=""
	..s newPeriodStr=$E(newPeriod,5)
	..i newPeriodStr=0 d
	...s periodName="0"_$E(newPeriod,6)_Freq
	..e  d
	...s periodName=$E(newPeriod,5,6)_Freq
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)) q:KPIDr=""  d
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr))
	....s KPICode=$P(Curr,"^",1)
	....s KPIName=$P(Curr,"^",2)
	....s score=$g(^TEMPKPIScore("KPIScore",newPeriod,KPIDr)) ;$fn($P(Curr,"^",3)/100,"",2)
	....s Rscore=$g(^TEMPKPIRscore("KPIRscore",newPeriod,KPIDr)) ;$fn($P(Curr,"^",4)/100,"",2)
	....;s ^sdhjhghkk = rootDr_"  KPIDr->"_KPIDr_"  Curr->"_Curr_"   score->"_score
	....;s score=$fn($P(Curr,"^",3),"",2)  //20140224 edit
	....s count=$P(Curr,"^",5)
	....d OutputRow
	k ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport")
	
	;k ^TEMPKPIScore("KPIScore")
	
 	q $$$OK
OutputRow
	
 	s Data=$lb(Graph,KPIDr,KPICode,KPIName,periodName,score,Rscore,count)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetHospKPIScoreReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospKPIScoreReportExecute ]
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

ClassMethod GetHospKPIScoreReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospKPIScoreReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2010-9-26
/// Description:全院指标考核分分析
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uHospKPIScoreAnlys","GetHospKPIScoreReport",3,"Q",1,2,"1||1")
Query GetHospKPIScoreReport(cycleDr As %Integer, frequency As %String, startPeriod As %Integer, endPeriod As %Integer, schemDr As %String) As %Query(ROWSPEC = "Graph:%String,KPIDr:%Integer,KPICode:%String,KPIName:%String,periodName:%String,score:%Float,Rscore:%Float,count:%Integer") [ SqlProc ]
{
}

/// Creator:初雅莉
/// CreatDate:2016-8-15
/// Description:全院指标考核分分析
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uHospKPIScoreAnlys","GetHospKPIScoreReportNew",3,"Q",1,2,"1||1")
Query GetHospKPIScoreReportNew(cycleDr As %Integer, frequency As %String, startPeriod As %Integer, endPeriod As %Integer, schemDr As %String) As %Query(ROWSPEC = "Graph:%String,KPIDr:%Integer,KPICode:%String,KPIName:%String,periodName:%String,score:%Float,Rscore:%Float,count:%Integer") [ SqlProc ]
{
}

ClassMethod GetHospKPIScoreReportNewExecute(ByRef qHandle As %Binary, cycleDr As %Integer, frequency As %String, startPeriod As %Integer, endPeriod As %Integer, schemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:startPeriod="" $$$OK
	q:endPeriod="" $$$OK
	q:schemDr="" $$$OK
	
	k ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport")
	k ^TEMPKPIRscore("KPIRscore")
	k ^TEMPKPIScore("KPIScore")
	
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
		//获取方案下的绩效单元
	s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	q:jxUnitDrStr="" $$$OK
	
	//遍历集合List
	s Count=newPeriodList.Count()
	f j=1:1:Count d
	.s newPeriod=newPeriodList.GetAt(j)
	.i newPeriod'="" d
	..s urRowidStr=..GetURRowidStr(schemDr, newPeriod, jxUnitDrStr)
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
	....d ..DealNodeInfoNew(urRowid,rootDr,NodeInfoStr,newPeriod) //2015-8-15
	//确定期间类型
	i frequency="M" s Freq="月"
	i frequency="Q" s Freq="季"
	i frequency="H" s Freq="半年"
	i frequency="Y" s Freq="年"
	s Graph="柱形图"
	//从临时Global中处理数据
	i $D(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport")) d
	.s newPeriod=0
	.f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod)) q:newPeriod=""  d
	..s rootDr=0,count=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)) q:KPIDr=""  d
	....s count=count+1
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr))
	....s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)=Curr_"^"_count
	
	//从临时Global中取出数据
	//^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)
	i $D(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport")) d
	.s newPeriod=0
	.f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod)) q:newPeriod=""  d
	..s periodName=""
	..s newPeriodStr=$E(newPeriod,5)
	..i newPeriodStr=0 d
	...s periodName="0"_$E(newPeriod,6)_Freq
	..e  d
	...s periodName=$E(newPeriod,5,6)_Freq
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)) q:KPIDr=""  d
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr))
	....s KPICode=$P(Curr,"^",1)
	....s KPIName=$P(Curr,"^",2)
	....s score=$g(^TEMPKPIScore("KPIScore",newPeriod,KPIDr)) //2015-8-15 ;$fn($P(Curr,"^",3)/100,"",2) 
	....s Rscore=$g(^TEMPKPIRscore("KPIRscore",newPeriod,KPIDr))  //2015-8-15;$fn($P(Curr,"^",4)/100,"",2)//2015-8-15
	....;s ^sdhjhghkk = rootDr_"  KPIDr->"_KPIDr_"  Curr->"_Curr_"   score->"_score
	....;s score=$fn($P(Curr,"^",3),"",2)  //20140224 edit
	....s count=$P(Curr,"^",5)
	....d OutputRow2
	k ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport")
	k ^TEMPKPIRscore("KPIRscore")
	k ^TEMPKPIScore("KPIScore")
	
 	q $$$OK
OutputRow2
	
 	s Data=$lb(Graph,KPIDr,KPICode,KPIName,periodName,score,Rscore,count)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetHospKPIScoreReportNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospKPIScoreReportNewExecute ]
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

ClassMethod GetHospKPIScoreReportNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospKPIScoreReportNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:初雅莉
/// CreatDate:2016-8-15
/// Description:处理节点信息字符串
/// Table:
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;NodeInfoStr-节点信息字符串;newPeriod-新的考核期间
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.report.uHospKPIScoreAnlys).DealNodeInfo("1||15",1,"1!1^22!2^23!3^24!4^21!2","201001")
ClassMethod DealNodeInfoNew(urRowid, rootDr, NodeInfoStr, newPeriod) As %String
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
	..s KPIInfo=..GetDimenInfo(KPIDr)
	..s KPIDr=-KPIDr
	.e  d
	..s KPIInfo=..GetKPIInfo(KPIDr, level)
	.i KPIDr>0 s Score=..GetURDetailInfo(urRowid, KPIDr)
	.e  s Score=..GetDimensInfo(urRowid, -KPIDr)
	.; score_"^"_Rscore
	
	.s NodeAllInfo=KPIInfo_"^"_Score
	.;将数据存入临时Global
	.i KPIDr<0 d
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_($P(Curr,"^",3)+Score)
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,KPIDr)=NodeAllInfo
	..s ^TEMPKPIScore("KPIScore",newPeriod,KPIDr)=$p(Score,"^",1)+$g(^TEMPKPIScore("KPIScore",newPeriod,KPIDr))  //2015-8-15
	..s ^TEMPKPIRscore("KPIRscore",newPeriod,KPIDr)=$p(Score,"^",2)+$g(^TEMPKPIRscore("KPIRscore",newPeriod,KPIDr)) //2015-8-15
	.e  d
	..s code=$P(NodeAllInfo,"^",1)
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,code)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,code))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_($P(Curr,"^",3)+Score)
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,code)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospKPIScoreReport",newPeriod,rootDr,code)=NodeAllInfo
	..s ^TEMPKPIScore("KPIScore",newPeriod,code)=$p(Score,"^",1)+$g(^TEMPKPIScore("KPIScore",newPeriod,code)) //2015-8-15
	..s ^TEMPKPIRscore("KPIRscore",newPeriod,code)=$p(Score,"^",2)+$g(^TEMPKPIRscore("KPIRscore",newPeriod,code)) //2015-8-15
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uHospKPIScor6F6S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
