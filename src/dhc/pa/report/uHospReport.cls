/// Creator: 李明忠
/// CreatDate: 2010-9-19
/// Description: 全院考核报表
Class dhc.pa.report.uHospReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-9-19
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.report.uHospReport).GetJXUnitOfSchem("1||2")
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
/// CreatDate:2010-9-19
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.report.uHospReport).GetCycle(1,1)
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
/// CreatDate:2010-9-19
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
/// CreatDate:2010-9-19
/// Description:获取绩效单元考核主表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录
/// Others:w ##class(dhc.pa.report.uHospReport).GetURRowid("1||2","201001",1)
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
/// CreatDate:2010-9-19
/// Description:寻找树根以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;level-级别深度
/// Output:
/// Return:返回树根以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uHospReport).FindRoots("1||2",1)
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
/// CreatDate:2010-9-19
/// Description:寻找树根下所有子节点以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;level-级别深度;KPIDrInfoStr-子节点信息字符串
/// Output:
/// Return:返回树根下所有子节点以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uHospReport).FindChildNodes("1||2",1,"",1)
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
	.;w KPIDr_"^"_$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2),!
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
/// CreatDate:2010-9-19
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
	s KPICode="",KPIName="",calUnitName="",methodCode="",methodName="",target=""
	
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
	..s calUnitDr=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",8)
	..i calUnitDr'="" d
	...i $D(^DHCCJXPACALUNIT(calUnitDr)) d
	....i $G(^DHCCJXPACALUNIT(calUnitDr))'="" d
	.....s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
	..s target=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",6)
	
	s KPIInfo=KPICode_"^"_KPIName_"^"_calUnitName_"^"_methodName_"^"_target
	
	q KPIInfo
}

/// Creator:李明忠
/// CreatDate:2010-9-19
/// Description:根据维度ID获取维度名称等信息
/// Table:dhc_pa_data.DimensType
/// Input:DimenDr-维度Dr
/// Output:
/// Return:返回维度信息
/// Others:w ##class(dhc.pa.report.uHospReport).GetDimenInfo(1)
ClassMethod GetDimenInfo(DimenDr) As %String
{
	n (DimenDr)
	
	s DimenInfo=""
	q:DimenDr="" DimenInfo
	
	s KPICode="",KPIName="",calUnitName="",methodName="",target=""
	i $D(^DHCCJXPADIMENSTYPE(DimenDr)) d
	.i $G(^DHCCJXPADIMENSTYPE(DimenDr))'="" d
	..s DimenCode="" //$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",1)
	..s KPICode=DimenCode
	..s DimenName=$P(^DHCCJXPADIMENSTYPE(DimenDr),"^",2)
	..s KPIName=DimenName
	
	s DimenInfo=KPICode_"^"_KPIName_"^"_calUnitName_"^"_methodName_"^"_target
	
	q DimenInfo
}

/// Creator:李明忠
/// CreatDate:2010-9-19
/// Description:获取绩效单元考核方案明细记录
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核方案Dr;KPIDr-KPI指标Dr
/// Output:
/// Return:返回绩效单元考核方案明细记录
/// Others:w ##class(dhc.pa.report.uHospReport).GetURDetailInfo("1||15",21)
ClassMethod GetURDetailInfo(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s urDetailInfo=""
	q:urRowid="" urDetailInfo
	q:KPIDr="" urDetailInfo
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_tValue,UnitResultDetail_actValue,UnitResultDetail_score,UnitResultDetail_rate,UnitResultDetail_estDesc,UnitResultDetail_fBDesc from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s tValue = result.Data("UnitResultDetail_tValue") //目标值
		s actValue = result.Data("UnitResultDetail_actValue") //指标值
		s score = result.Data("UnitResultDetail_score") //分数
		s rate = result.Data("UnitResultDetail_rate") //权重
		s estDesc = result.Data("UnitResultDetail_estDesc") //点评描述
		s fBDesc = result.Data("UnitResultDetail_fBDesc") //反馈描述
		s estAndFBDesc=estDesc_"!"_fBDesc //点评和反馈描述
		i estAndFBDesc="!" s estAndFBDesc=""
		s urDetailInfo=tValue_"^"_actValue_"^"_score_"^"_rate_"^"_estAndFBDesc
	}
	
	q urDetailInfo
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
	
	s urDetailInfo=""
	q:urRowid="" urDetailInfo
	q:KPIDr="" urDetailInfo
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_score,UnitResultDetail_rate from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_isTarget=1"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	s whereStr=whereStr_" and UnitResultDetail_parent=0"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s score = result.Data("UnitResultDetail_score") //目标值
		s rate = result.Data("UnitResultDetail_rate") //目标值
		s urDetailInfo=""_"^"_""_"^"_score_"^"_rate_"^"_""
	}
	
	q urDetailInfo
}

/// Creator:李明忠
/// CreatDate:2010-11-19
/// Description:获取总分
/// Table:dhc_pa_data.UnitResult
/// Input:urRowid-绩效单元考核方案Dr
/// Output:
/// Return:返回总分
/// Others:w ##class(dhc.pa.report.uHospReport).GetTotalScore("1||15",21)
ClassMethod GetTotalScore(urRowid) As %String
{
	n (urRowid)
	
	s totalScore=0
	q:urRowid="" totalScore
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_totalScore from dhc_pa_data.UnitResult where UnitResult_childSub>0"
	s whereStr=" and UnitResult_rowid='"_urRowid_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s totalScore = result.Data("UnitResult_totalScore") //总分值
	}
	
	q totalScore
}

/// Creator:李明忠
/// CreatDate:2010-9-19
/// Description:处理节点信息字符串
/// Table:
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;NodeInfoStr-节点信息字符串
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.report.uHospReport).DealNodeInfo("1||2",4,"4!1^20!2^38!3^21!2^40!3^43!3")
ClassMethod DealNodeInfo(urRowid, rootDr, NodeInfoStr) As %String
{
	n (urRowid,rootDr,NodeInfoStr)
	
	;w urRowid_"%"_rootDr_"%"_NodeInfoStr,!
	
	q:urRowid=""
	q:rootDr=""
	q:NodeInfoStr=""
	
	s Len=$L(NodeInfoStr,"^")
	s KPIInfo=""
	
	s totalScore=0
	f k=1:1:Len d
	.s NodeInfo=$P(NodeInfoStr,"^",k)
	.s KPIDr=$P(NodeInfo,"!",1)
	.s level=$P(NodeInfo,"!",2)
	.i k=1 d
	..s KPIInfo=..GetDimenInfo(KPIDr)
	..s KPIDr=-KPIDr
	.e  d
	..s KPIInfo=..GetKPIInfo(KPIDr, level)
	.s Info=""
	.i KPIDr>0 s Info=..GetURDetailInfo(urRowid, KPIDr)
	.e  s Info=..GetDimensInfo(urRowid,-KPIDr)
	.s NodeAllInfo=KPIInfo_"^"_Info
	.;w KPIDr_"^"_NodeAllInfo,!
	.;将数据存入临时Global
	.i KPIDr<0 d
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,KPIDr))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_$P(Curr,"^",4)_"^"_$P(Curr,"^",5)_"^"_($P(Curr,"^",6)+$P(Info,"^",1))_"^"_($P(Curr,"^",7)+$P(Info,"^",2))_"^"_($P(Curr,"^",8)+$P(Info,"^",3))_"^"_$P(Curr,"^",9)_"^"_$P(Curr,"^",10)
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,KPIDr)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,KPIDr)=NodeAllInfo
	.e  d
	..s code=$P(NodeAllInfo,"^",1)
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,code)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,code))
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_$P(Curr,"^",4)_"^"_$P(Curr,"^",5)_"^"_($P(Curr,"^",6)+$P(Info,"^",1))_"^"_($P(Curr,"^",7)+$P(Info,"^",2))_"^"_($P(Curr,"^",8)+$P(Info,"^",3))_"^"_$P(Curr,"^",9)_"^"_$P(Curr,"^",10)
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,code)=str
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,code)=NodeAllInfo
}

ClassMethod GetHospReportExecute(ByRef qHandle As %Binary, cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
  	q:frequency="" $$$OK
  	q:period="" $$$OK
  	q:schemDr="" $$$OK
  	
  	k ^TEMPDHCCJXPA("dhc","pa","report","hospReport")
  	
  	//获取新的考核周期
  	s newPeriod=..GetCycle(cycleDr, period)
  	q:newPeriod="" $$$OK
	q:newPeriod="UnCycle" $$$OK
	q:newPeriod="UnPeriod" $$$OK
	q:newPeriod="UnCycleCode" $$$OK
	//获取该方案下的所有绩效单元
	s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	q:jxUnitDrStr="" $$$OK
	//根据条件获取所有绩效单元考核主表记录字符串
	s urRowidStr=..GetURRowidStr(schemDr,newPeriod,jxUnitDrStr)
	q:urRowidStr="" $$$OK
	//操作UnitResultDetail表
	s Length=$L(urRowidStr,"^")
	f k=1:1:Length d
	.s urRowid=$P(urRowidStr,"^",k)
	.s level=1
	.;获取根节点信息
	.s urdRootInfoStr=..FindRoots(urRowid,level)
	.;w urdRootInfoStr,!
	.s Len=$L(urdRootInfoStr,"^")
	.f m=1:1:Len d
	..s urdRootInfo=$P(urdRootInfoStr,"^",m)
	..s rootDr=$P(urdRootInfo,"!",1)
	..s KPIDrInfoStr=""
	..;w urRowid_"^"_rootDr_"^"_KPIDrInfoStr_"^"_level,!
	..s KPIDrInfoStr=..FindChildNodes(urRowid,rootDr,KPIDrInfoStr,level)
	..s NodeInfoStr=urdRootInfo_"^"_KPIDrInfoStr
	..;w urRowid_"%"_rootDr_"%"_NodeInfoStr,!
	..d ..DealNodeInfo(urRowid,rootDr,NodeInfoStr)
	
	
	//从临时Global中取出数据
	//^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,KPIDr)
	s totalScore=0
	i $D(^TEMPDHCCJXPA("dhc","pa","report","hospReport")) d
	.s urRowid=0
	.f  s urRowid=$O(^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid)) q:urRowid=""  d
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr)) q:rootDr=""  d
	...s KPIDr=""
	...f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,KPIDr)) q:KPIDr=""  d
	....;w KPIDr,!
	....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","hospReport",urRowid,rootDr,KPIDr))
	....i Curr'="" d
	.....s Graph="柱形图"
	.....s KPICode=$P(Curr,"^",1)
	.....s KPIName=$P(Curr,"^",2)
	.....s calUnitName=$P(Curr,"^",3)
	.....s tValue=$P(Curr,"^",6)
	.....s actValue=$P(Curr,"^",7)
	.....s score=$P(Curr,"^",8)
	.....s methodName=$P(Curr,"^",4)
	.....s target=$P(Curr,"^",5)
	.....s estAndFBDesc=$P(Curr,"^",10)
	.....s rate=$P(Curr,"^",9)
	.....i KPIDr<0 d
	......s totalScore=totalScore+((score*rate)/100)
	.....;w Graph_"^"_KPICode_"^"_KPIName_"^"_calUnitName_"^"_tValue_"^"_actValue_"^"_score_"^"_methodName_"^"_target_"^"_estAndFBDesc_"^"_rate,!
	.....d OutputRow
	
	s ^TEMPDHCCJXPA("dhc","pa","report","hospReportTotal")="^^^^^^^"_totalScore_"^^"
	
	s Graph="",KPICode="",KPIName="   考核总分",calUnitName="",tValue="",actValue="",methodName="",target="",estAndFBDesc="",rate=""
	s score=$fn($P(^TEMPDHCCJXPA("dhc","pa","report","hospReportTotal"),"^",8),"",2)
	d OutputRow

	k ^TEMPDHCCJXPA("dhc","pa","report","hospReport")
	k ^TEMPDHCCJXPA("dhc","pa","report","hospReportTotal")

 	q $$$OK
OutputRow
	
 	s Data=$lb(Graph,KPICode,KPIName,calUnitName,$fn(tValue,"",2),$fn(actValue,"",2),$fn(score,"",2),methodName,target,estAndFBDesc,$fn(rate,"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetHospReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospReportExecute ]
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

ClassMethod GetHospReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2010-9-19
/// Description:查询全院报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uHospReport","GetHospReport",1,"M",1,"1||1")
Query GetHospReport(cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String) As %Query(ROWSPEC = "Graph:%String,KPICode:%String,KPIName:%String,calUnitName:%String,tValue:%Float,actValue:%Float,score:%Float,methodName:%String,target:%String,estAndFBDesc:%String,rate:%Float")
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uHospReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
