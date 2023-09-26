/// Creator: 李明忠
/// CreatDate: 2010-9-23
/// Description: 科室考核汇总报表
Class dhc.pa.report.uLocSumReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-9-25
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.report.uLocSumReport).GetCycle(1,1)
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
/// CreatDate:2010-9-25
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.report.uHospReport).GetJXUnitOfSchem("1||2")
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

/// Creator:wang ying
/// CreatDate:2014-3-18
/// Description:查询绩效单元对应的方案
/// Table:dhc_pa_data.UnitSchem
/// Input:groupDr-绩效单元组,cycleDr-年度id
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.report.uLocSumReport).GetSchem("2","1-2-5-6")
ClassMethod GetSchem(cycleDr, groupDr) As %Library.ListOfDataTypes
{
	n (cycleDr,groupDr)
	
	s schemDr=""
	q:groupDr="" schemDr
	q:cycleDr="" schemDr
	s len=$l(groupDr,"-")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitSchem_parRef,UnitSchem_schemDr from dhc_pa_data.UnitSchem,dhc_pa_data.Schem,dhc_pa_data.Stratagem where UnitSchem_schemDr=Schem_rowid  and Stratagem_rowid=Schem_parRef and Schem_active='Y' and Schem_KPIDr is null"
	s whereStr=" and Stratagem_cycleDr='"_cycleDr_"'"
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s parRef = result.Data("UnitSchem_parRef")
		q:parRef=""
		i len=2 s parRef="-"_parRef
		i len>2 s parRef="-"_parRef
		i (groupDr[parRef) d
		.s schemDr = result.Data("UnitSchem_schemDr")

		
	}
	
	q schemDr
}

/// Creator:李明忠
/// CreatDate:2010-9-25
/// Description:获取绩效单元考核主表记录字符串
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDrStr-绩效单元Dr字符串;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录字符串
/// Others:w ##class(dhc.pa.report.uHospReport).GetURRowidStr("1||2","201001",1)
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
/// CreatDate:2010-9-25
/// Description:获取绩效单元考核主表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录
/// Others:w ##class(dhc.pa.report.uLocSumReport).GetURRowid("1||7","201410",1)
ClassMethod GetURRowid(schemDr, newPeriod, jxUnitDr) As %String
{
	n (schemDr,newPeriod,jxUnitDr)
	
	s urRowid=""
	q:schemDr="" urRowid
	q:newPeriod="" urRowid
	q:jxUnitDr="" urRowid
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_rowid,UnitResult_schemDr from dhc_pa_data.UnitResult where UnitResult_childSub>0"
	;s whereStr=" and UnitResult_schemDr='"_schemDr_"'"
	s whereStr=""
	s whereStr=whereStr_" and UnitResult_period='"_newPeriod_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr='"_jxUnitDr_"'"
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s urRowid =""
	While(result.Next()){
		s schem = result.Data("UnitResult_schemDr")
		;w schem,"^"_schemDr,!
		i schem=schemDr d
		.s urRowid = result.Data("UnitResult_rowid")
	}
	
	q urRowid_"-"_jxUnitDr
}

/// Creator:李明忠
/// CreatDate:2010-9-25
/// Description:寻找树根以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;level-级别深度
/// Output:
/// Return:返回树根以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uLocSumReport).FindRoots("1||778",1)
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
/// CreatDate:2010-9-25
/// Description:寻找树根下所有子节点以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;level-级别深度;KPIDrInfoStr-子节点信息字符串
/// Output:
/// Return:返回树根下所有子节点以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uLocSumReport).FindChildNodes("1||778",1,"",1)
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
/// CreatDate:2010-9-25
/// Description:根据指标ID获取指标名称等信息
/// Table:dhc_pa_data.KPIIndex1
/// Input:KPIDr-指标Dr,level-级别深度
/// Output:
/// Return:返回指标信息
/// Others:w ##class(dhc.pa.report.uHospReport).GetKPIInfo(21,2)
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
	
	s KPIInfo=KPICode_"^"_KPIName_"^"_methodName_"^"_level
	
	q KPIInfo
}

/// Creator:李明忠
/// CreatDate:2010-9-25
/// Description:根据维度ID获取维度名称等信息
/// Table:dhc_pa_data.DimensType
/// Input:DimenDr-维度Dr
/// Output:
/// Return:返回维度信息
/// Others:w ##class(dhc.pa.report.uLocSumReport).GetDimenInfo(1)
ClassMethod GetDimenInfo(DimenDr) As %String
{
	n (DimenDr)
	
	s DimenInfo=""
	q:DimenDr="" DimenInfo
	
	s KPICode="",KPIName="",methodName=""
	i $D(^DHCCJXPADIMENSTYPE(DimenDr)) d
	.i $G(^DHCCJXPADIMENSTYPE(DimenDr))'="" d
	..s DimenCode=$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",1)
	..s KPICode=DimenCode
	..s DimenName=$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",2)
	..s KPIName=DimenName
	
	s DimenInfo=KPICode_"^"_KPIName_"^"_methodName_"^"_""


	q DimenInfo
}

/// Creator:李明忠
/// CreatDate:2010-9-25
/// Description:获取绩效单元考核方案明细记录分数
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核方案Dr;KPIDr-KPI指标Dr
/// Output:
/// Return:返回绩效单元考核方案明细记录分数
/// Others:w ##class(dhc.pa.report.uLocSumReport).GetURDetailScore("4||3",-5)
ClassMethod GetURDetailScore(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s score=0,tvalue=0,rate=0
	q:urRowid="" score
	q:KPIDr="" score
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_score,UnitResultDetail_Rscore,UnitResultDetail_rate,UnitResultDetail_tValue from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	;i KPIDr>0 s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	i KPIDr>0 s whereStr=whereStr_" and UnitResultDetail_isTarget=2 and UnitResultDetail_KPIDr='"_KPIDr_"'"
	i KPIDr<0 s whereStr=whereStr_" and UnitResultDetail_isTarget=1 and UnitResultDetail_KPIDr='"_-KPIDr_"'"
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s scores = result.Data("UnitResultDetail_score") //分数
		s score = result.Data("UnitResultDetail_Rscore") //分数
		s rate = result.Data("UnitResultDetail_rate") //分数
		s tvalue = result.Data("UnitResultDetail_tValue") //分数
	}
	
	q score_"^"_scores_"^"_rate_"^"_tvalue
}

/// Creator:李明忠
/// CreatDate:2010-9-25
/// Description:处理节点信息字符串
/// Table:
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;NodeInfoStr-节点信息字符串;jxUnitDr-绩效单元Dr
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.report.uHospReport).DealNodeInfo("1||15",1,"1!1^22!2^23!3^24!4^21!2")
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
	.;w urRowid_"^"_KPIDr_"^"_Score,!
	.s NodeAllInfo=KPIInfo_"^"_Score
	.;将数据存入临时Global
	.i KPIDr<0 d
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr,KPIDr))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_($P(Curr,"^",4)+Score)_"^"_$P(Curr,"^",5)_"^"_$P(Curr,"^",6)
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,KPIDr,KPIDr)=NodeAllInfo
	.e  d
	..s code=$P(NodeAllInfo,"^",1)
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code,KPIDr))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_($P(Curr,"^",4)+Score)_"^"_$P(Curr,"^",5)_"^"_$P(Curr,"^",6)
	...s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code,KPIDr)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code,KPIDr)=NodeAllInfo
}

/// d ##class(%ResultSet).RunQuery("dhc.pa.report.uLocSumReport","GetLocSumReport",6,"Q",2,"1||1",1)
ClassMethod GetLocSumReportExecute(ByRef qHandle As %Binary, cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String, groupDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	;s ^TMPLY(1)=cycleDr_"^"_frequency_"^"_period_"^"_schemDr_"^"_groupDr
	
	q:cycleDr="" $$$OK
	q:frequency="" $$$OK
	q:period="" $$$OK
	;q:schemDr="" $$$OK
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
	...s locGroupName=$P(^DHCCJXPAJXGROUP(groupDr),"^",2)
	q:locGroup="" $$$OK
	s Len=$L(locGroup,"-")
	
	//根据分组绩效单元获取方案
	i schemDr="" s schemDr=..GetSchem(cycleDr,locGroup)
	q:schemDr="" $$$OK

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
	...s code=""
	...f  s code=$o(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,code)) q:code=""  d
	....s KPIDr=""
	....f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,code,KPIDr)) q:KPIDr=""  d
	.....s count=count+1
	.....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,code,KPIDr))
	.....s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,code,KPIDr)=Curr_"^"_count


	//从临时Global中取出数据
	//^TEMPDHCCJXPA("dhc","pa","report","locSumReport",urRowid,rootDr,KPIDr)
	i $D(^TEMPDHCCJXPA("dhc","pa","report","locSumReport")) d
	.s jxUnitDr=0
	.f  s jxUnitDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr)) q:jxUnitDr=""  d
	..;s totalScore=0
	..s jxUnitName=""
	..i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	...i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	....s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr)) q:rootDr=""  d
	...s code=""
	...f  s code=$o(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code)) q:code=""  d
	....s KPIDr=""
	....f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code,KPIDr)) q:KPIDr=""  d
	.....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code,KPIDr))
	.....i Curr'="" d
	......s Graph="图形"
	......s KPICode=$P(Curr,"^",1)
	......s KPIName=$P(Curr,"^",2)
	......s methodName=$P(Curr,"^",3)
	......s kdr=..GetkpiNameOfCode(KPICode)
	......s level=$P(Curr,"^",4)
	......s score=$P(Curr,"^",5)
	......s scores=$P(Curr,"^",6)
	......s rate=$P(Curr,"^",7)
	......s tvalue=$P(Curr,"^",8)
	......s count=$P(Curr,"^",9)
	......i KPIDr<0 d
	.......;s totalScore=0
	.......;w "score:"_score,!
	.......s totalScore=totalScore+score
	.......s schemLowDr=##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId3(KPIDr,jxUnitDr,schemDr,frequency)
	.......s KPI=$p(KPICode,"-",2)
	.......i KPI'="" d
	........s info=..GetDimenInfo(KPI)
	........s KPICode=$P(info,"^",1)
	.......;s schemLowDr=##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId2(KPIDr,jxUnitDr,schemDr)
	........s schemLowDr=##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId3(KPIDr,jxUnitDr,schemDr,frequency)
	.......;w "totalScore:"_totalScore,!
	......i kdr'=""  s schemLowDr=##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId3(KPIDr,jxUnitDr,schemDr,frequency)	
	......d OutputRow
	
	k ^TEMPDHCCJXPA("dhc","pa","report","locSumReport")
 	q $$$OK
OutputRow
	
 	//s Data=$lb(Graph,KPIDr,KPICode,KPIName,methodName,jxUnitName,$fn(score,"",2),rate,count)
 	s Data=$lb(Graph,KPIDr,KPICode,KPIName,methodName,jxUnitDr,jxUnitName,$fn(score,"",2),$fn(scores,"",2),rate,tvalue,count,totalScore,kdr,schemLowDr,locGroupName,level)
 	;s totalScore=0
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
 	}
 	Else      {				
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

/// Creator:李明忠
/// CreatDate:2010-9-25
/// Description:查询科室汇总报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uLocSumReport","GetLocSumReport",6,"Q",2,"1||27","36")
Query GetLocSumReport(cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String, groupDr As %String) As %Query(ROWSPEC = "Graph:%String,KPIDr:%Float,KPICode:%String,KPIName:%String,methodName:%String,jxUnitDr:%Integer,jxUnitName:%String,score:%Float,scores:%Float,rate:%Float,tvalue:%Float,count:%Integer,totalScore:%Float,kdr:%String,schemLowDr:%String,locGroupName:%String,level:%Integer") [ SqlProc ]
{
}

/// Others:w ##class(dhc.pa.report.uLocSumReport).GetkpiNameOfCode("1001000000")
ClassMethod GetkpiNameOfCode(code) As %Library.ListOfDataTypes
{
	n (code)
	
	s rowid=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIIndex1_rowid,KPIIndex1_code from dhc_pa_data.KPIIndex1 where %ID>0"
	;s whereStr=" and KPIIndex1_code='"_code_"'"
	;s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s KpiCode  = result.Data("KPIIndex1_code")
		i KpiCode=code d
		.s rowid = result.Data("KPIIndex1_rowid")
		
	}
	
	q rowid
}

Query GetLocSumReportTG(cycleDr As %String, frequency As %String, period As %String, schemDr As %String, groupDr As %String, userCode As %String) As %Query(ROWSPEC = "KPIDr:%String,KPICode:%String,KPIName:%String,jxUnitDrStr:%String,jxUnitName:%String,count:%Integer,score:%Float,rate:%Float,schemLowDr:%String,level:%Integer") [ SqlProc ]
{
}

/// Creator: wang ying
/// CreatDate: 2013-2-26
/// Description: 科室汇总图表
/// schemDr二级方案,kdr(传的是点击指标的id)
/// d ##class(%ResultSet).RunQuery("dhc.pa.report.uLocSumReport","GetLocSumReportTG",3,"Q",1,"1||11",1,"demo")
ClassMethod GetLocSumReportTGExecute(ByRef qHandle As %Binary, cycleDr As %String, frequency As %String, period As %String, schemDr As %String, groupDr As %String, userCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1 
	;s ^chuPa=cycleDr_"^"_frequency_"^"_ period_"^"_ schemDr _"^"_groupDr _"^"_userCode
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
	...s locGroupName=$P(^DHCCJXPAJXGROUP(groupDr),"^",2)
	q:locGroup="" $$$OK
	s Len=$L(locGroup,"-")
	
	//根据分组绩效单元获取方案
	i schemDr="" s schemDr=..GetSchem(cycleDr,locGroup)
	q:schemDr="" $$$OK

	//获取新考核期间
	s newPeriod=..GetCycle(cycleDr,period)
	q:newPeriod="" $$$OK
	
	//定义一个绩效单元集合List
	s jxUnitDrList=##class(%Library.ListOfDataTypes).%New() 
	s jxUnitDrList=..GetJXUnitOfSchem(jxUnitDrList,schemDr)

	//筛选新的绩效单元
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
	...s code=""
	...f  s code=$o(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,code)) q:code=""  d
	....s KPIDr=""
	....f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,code,KPIDr)) q:KPIDr=""  d
	.....s count=count+1
	.....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,code,KPIDr))
	.....s ^TEMPDHCCJXPA("dhc","pa","report","locSumReport",newPeriod,rootDr,code,KPIDr)=Curr_"^"_count


	//从临时Global中取出数据
	//^TEMPDHCCJXPA("dhc","pa","report","locSumReport",urRowid,rootDr,KPIDr)
	i $D(^TEMPDHCCJXPA("dhc","pa","report","locSumReport")) d
	.s jxUnitDr=0
	.f  s jxUnitDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr)) q:jxUnitDr=""  d
	..;s totalScore=0
	..s jxUnitName=""
	..i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	...i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	....s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr)) q:rootDr=""  d
	...s code=""
	...f  s code=$o(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code)) q:code=""  d
	....s KPIDr=""
	....f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code,KPIDr)) q:KPIDr=""  d
	.....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locSumReport",jxUnitDr,rootDr,code,KPIDr))
	.....i Curr'="" d
	......s Graph="图形"
	......s KPICode=$P(Curr,"^",1)
	......s KPIName=$P(Curr,"^",2)
	......s methodName=$P(Curr,"^",3)
	......s kdr=..GetkpiNameOfCode(KPICode)
	......s level=$P(Curr,"^",4)
	......s score=$P(Curr,"^",5)
	......s rate=$P(Curr,"^",6)
	......s tvalue=$P(Curr,"^",7)
	......s count=$P(Curr,"^",8)
	......i KPIDr<0 d
	.......;s totalScore=0
	.......;w "score:"_score,!
	.......s totalScore=totalScore+score
	.......s schemLowDr=##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId3(KPIDr,jxUnitDr,schemDr,frequency)
	.......s KPI=$p(KPICode,"-",2)
	.......i KPI'="" d
	........s info=..GetDimenInfo(KPI)
	........s KPICode=$P(info,"^",1)
	.......;s schemLowDr=##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId2(KPIDr,jxUnitDr,schemDr)
	........s schemLowDr=##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId3(KPIDr,jxUnitDr,schemDr,frequency)
	.......;w "totalScore:"_totalScore,!
	......i kdr'=""  s schemLowDr=##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId3(KPIDr,jxUnitDr,schemDr,frequency)	
	......d OutputRowTG
	
	k ^TEMPDHCCJXPA("dhc","pa","report","locSumReport")
	k ^TEMPDHCCJXPA("dhc","pa","report","locReport")
	k ^TEMPDHCCJXPA("dhc","pa","report","locReportTotal")
	q $$$OK

OutputRowTG
    ///KPIDr:%String,KPICode:%String,KPIName:%String,JXUnitDr:%String,JXUnitName:%String,score:%Integer
 	s Data=$lb(KPIDr,KPICode,KPIName,jxUnitDrStr,jxUnitName,count,$fn(score,"",2),rate,schemLowDr,level)
 	
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetLocSumReportTGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocSumReportTGExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLocSumReportTGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocSumReportTGExecute ]
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

Storage Default
{
<StreamLocation>^dhc.pa.report.uLocSumReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
