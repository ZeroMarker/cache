/// Creator: 李明忠
/// CreatDate: 2010-9-9
/// Description: 上期关注指标分析报表
Class dhc.pa.report.uPerAttKPIAnlys Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetJXUnitOfSchem("1||2")
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
		.i jxUnitDrStr="" s jxUnitDrStr=jxUnitDr
		.e  s jxUnitDrStr=jxUnitDrStr_"^"_jxUnitDr
	}
	
	q jxUnitDrStr
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:查询绩效单元信息
/// Table:dhc_pa_data.JXUnit
/// Input:jxUnitDr-绩效单元Dr
/// Output:
/// Return:返回绩效单元信息
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetJXUnitName(1)
ClassMethod GetJXUnitName(jxUnitDr) As %String
{
	n (jxUnitDr)
	
	s jxUnitName=""
	q:jxUnitDr="" jxUnitName
	
	i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
	.i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
	..s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
	
	q jxUnitName
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:查询绩效考核方案下的指标Dr字符串
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的指标Dr字符串
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetKPIOfSchem("1||2")
ClassMethod GetKPIOfSchem(schemDr) As %String
{
	n (schemDr)
	
	s KPIDrStr=""
	q:schemDr="" KPIDrStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y'and EXISTS (SELECT SchemDetail_KPIDr FROM dhc_pa_data.SchemDetail where dhc_pa_data.KPIIndex1.KPIIndex1_rowid =dhc_pa_data.SchemDetail.SchemDetail_KPIDr and SchemDetail_parRef='"_schemDr_"')"
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		i rowid'="" d
		.s KPIDr=rowid
		.i KPIDrStr="" s KPIDrStr=KPIDr
		.e  s KPIDrStr=KPIDrStr_"^"_KPIDr
	}
	
	q KPIDrStr
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetCycle(1,1)
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
	
	i period<10 s period="0"_period
	s newPeriod=cycleCode_period
	
	q newPeriod
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:根据指标ID获取指标名称等信息
/// Table:dhc_pa_data.KPIIndex1
/// Input:KPIDr-指标Dr
/// Output:
/// Return:返回指标信息
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetKPIInfo(21)
ClassMethod GetKPIInfo(KPIDr) As %String
{
	n (KPIDr)
	
	s KPIName="",calUnitName=""
	
	i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	.i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
	..s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
	..s calUnitDr=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",8)
	..i calUnitDr'="" d
	...i $D(^DHCCJXPACALUNIT(calUnitDr)) d
	....i $G(^DHCCJXPACALUNIT(calUnitDr))'="" d
	.....s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
	
	s KPIInfo=KPIName_"^"_calUnitName
	
	q KPIInfo
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:查询条件下的绩效单元考核表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-绩效方案Dr;jxUnitDr-绩效单位;newPeriod-考核期间(如:201001)
/// Output:
/// Return:返回绩效单元考核表记录
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetURRcord(1,"201001","1||2")
ClassMethod GetURRcord(jxUnitDr, newPeriod, schemDr) As %String
{
	n (jxUnitDr,newPeriod,schemDr)
	
	//绩效单元考核表记录Dr
	s URDr=""
	
	q:jxUnitDr="" URDr
	q:newPeriod="" URDr
	q:schemDr="" URDr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_rowid from dhc_pa_data.UnitResult where UnitResult_childSub>0 and UnitResult_appSysDr=2"
	s whereStr=" and UnitResult_schemDr='"_schemDr_"'"
	s whereStr=whereStr_" and UnitResult_jxUnitDr='"_jxUnitDr_"'"
	s whereStr=whereStr_" and UnitResult_period='"_newPeriod_"'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s URDr = result.Data("UnitResult_rowid")
	}
	
	q URDr
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:根据指标ID、绩效单元获取上期分数
/// Table:dhc_pa_data.UnitResultDetail
/// Input:jxUnitDr-绩效单元Dr,KPIDr-指标Dr,newPeriod-组合期间,schemDr-绩效方案Dr
/// Output:
/// Return:返回上期分数
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetPerScoreInfo(1,21,"201001","1||2")
ClassMethod GetPerScoreInfo(jxUnitDr, KPIDr, newPeriod, schemDr) As %String
{
	n (jxUnitDr,KPIDr,newPeriod,schemDr)
	
	s perScoreInfo="^^"
	
	q:KPIDr="" perScoreInfo
	q:jxUnitDr="" perScoreInfo
	q:newPeriod="" perScoreInfo
	q:schemDr="" perScoreInfo
	
	//确定上期区间
	s perPeriod="",periodSubStr2="",periodSubStr1=""
	
	i $E(newPeriod,5,6)="00" s perPeriod=($E(newPeriod,1,4)-1)_$E(newPeriod,5,6)
	e  d
	.s periodSubStr1=$E(newPeriod,5)
	.i periodSubStr1'="0" d
	..i ($E(newPeriod,5,6)-1)<10 s perPeriod=$E(newPeriod,1,4)_"0"_($E(newPeriod,5,6)-1)
	..e  s perPeriod=$E(newPeriod,1,4)_($E(newPeriod,5,6)-1)
	.e  d
	..s periodSubStr2=$E(newPeriod,6)
	..i periodSubStr2>1 s perPeriod=$E(newPeriod,1,5)_($E(newPeriod,6)-1)
	..e  s perPeriod=($E(newPeriod,1,4)-1)_"12"
	
	//返回上期分数信息
	q ..GetCurrScoreInfo(jxUnitDr,KPIDr,perPeriod,schemDr)
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:根据指标ID、绩效单元获取本期分数
/// Table:dhc_pa_data.UnitResultDetail
/// Input:jxUnitDr-绩效单元Dr,KPIDr-指标Dr,newPeriod-组合期间,schemDr-绩效方案Dr
/// Output:
/// Return:返回本期分数
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetCurrScoreInfo(1,21,"201001","1||2")
ClassMethod GetCurrScoreInfo(jxUnitDr, KPIDr, newPeriod, schemDr) As %String
{
	n (jxUnitDr,KPIDr,newPeriod,schemDr)
	
	s currScore="",flagName="",estDesc=""
	s currScoreInfo=currScore_"^"_flagName_"^"_estDesc
	
	q:KPIDr="" currScoreInfo
	q:jxUnitDr="" currScoreInfo
	q:newPeriod="" currScoreInfo
	q:schemDr="" currScoreInfo

	//获取绩效单元考核主表ID
	s urRowid=..GetURRcord(jxUnitDr,newPeriod,schemDr)
	q:urRowid="" currScoreInfo
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_score,UnitResultDetail_flag,UnitResultDetail_estDesc from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0 and UnitResultDetail_isTarget=2"
	s whereStr=" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	s whereStr=whereStr_" and UnitResultDetail_parRef='"_urRowid_"'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		//分数
		s score = result.Data("UnitResultDetail_score")
		//关注度
		s flag = result.Data("UnitResultDetail_flag")
		i flag=0 s flagName="一般"
		i flag=1 s flagName="重点"
		//考核点评
		s estDesc = result.Data("UnitResultDetail_estDesc")
		
		s currScoreInfo=score_"^"_flagName_"^"_estDesc
	}
	
	q currScoreInfo
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:查询给定条件下的报表数据
/// Table:
/// Input:cycleDr-战略年度Dr,frequency-报告频率,period-期间,schemDr-绩效方案Dr
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.report.uPerAttKPIAnlys).GetReportData(1,"M",1,"1||2")
/// /d ##class(%ResultSet).RunQuery("dhc.pa.report.uPerAttKPIAnlys","GetReport",1,"M",1,"1||2")
ClassMethod GetReportData(cycleDr, frequency, period, schemDr) As %String
{
	n (cycleDr,frequency,period,schemDr)
	
	k ^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData")
	
	q:cycleDr="" "NoCycle"
	q:frequency="" "NoFreq"
	q:period="" "NoPeriod"
	q:schemDr="" "NoSchem"
	
	//获取组合区间(年+期间)
	s newPeriod=..GetCycle(cycleDr,period)
	q:newPeriod="" "NoPeriod"
	q:newPeriod="UnCycle" "NoPeriod"
	q:newPeriod="UnPeriod" "NoPeriod"
	q:newPeriod="UnCycleCode" "NoPeriod"
	
	//整体思路:将报表数据暂时写入临时Global中
	//1.通过方案查询执行该方案的绩效单元(末端绩效单元)
	s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	q:jxUnitDrStr="" "NoUnit"
	s Len=$L(jxUnitDrStr,"^")
	
	//2.通过方案查询该方案下的指标明细(末端指标)
	s KPIDrStr=..GetKPIOfSchem(schemDr)
	q:KPIDrStr="" "NoKPI"
	s Length=$L(KPIDrStr,"^")
	
	//3.准备报表数据
	//3.1循环绩效单元
	f k=1:1:Len d 
	.s jxUnitDr=$P(jxUnitDrStr,"^",k)
	.i jxUnitDr'="" d
	..;//3.2循环指标
	..f j=1:1:Length d
	...s KPIDr=$P(KPIDrStr,"^",j)
	...i KPIDr'="" d
	....;获取KPI相关数据
	....s KPIInfo=..GetKPIInfo(KPIDr)
	....;指标名称
	....s KPIName=$P(KPIInfo,"^",1) 
	....;计量单元
	....s calUnitName=$P(KPIInfo,"^",2)
	....;上期信息
	....s perScoreInfo=..GetPerScoreInfo(jxUnitDr,KPIDr,newPeriod,schemDr)
	....s perScore=$P(perScoreInfo,"^",1)
	....s perFlagName=$P(perScoreInfo,"^",2)
	....s perEstDesc=$P(perScoreInfo,"^",3)
	....;本期信息
	....s currScoreInfo=..GetCurrScoreInfo(jxUnitDr,KPIDr,newPeriod,schemDr)
	....s currScore=$P(currScoreInfo,"^",1)
	....s currFlagName=$P(currScoreInfo,"^",2)
	....s currEstDesc=$P(currScoreInfo,"^",3)
	....;上期与本期差额
	....s diffScore=currScore-perScore
	....i $D(^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr,frequency,newPeriod,schemDr)) d
	.....s ReCord=^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr,frequency,newPeriod,schemDr)
	.....s ^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr,frequency,newPeriod,schemDr)=(perScore+$P(ReCord,"^",1))_"^"_perFlagName_"^"_perEstDesc_"^"_(currScore+$P(ReCord,"^",4))_"^"_currFlagName_"^"_currEstDesc_"^"_(diffScore+$P(ReCord,"^",7))_"^"_KPIName_"^"_calUnitName
	....e  d
	.....s ^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr,frequency,newPeriod,schemDr)=perScore_"^"_perFlagName_"^"_perEstDesc_"^"_currScore_"^"_currFlagName_"^"_currEstDesc_"^"_diffScore_"^"_KPIName_"^"_calUnitName
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
  	q:frequency="" $$$OK
  	q:period="" $$$OK
  	q:schemDr="" $$$OK
	/*
	d ..GetReportData(cycleDr,frequency,period,schemDr)
	
	s jxUnitName="",KPIName="",calUnitName="",perScore=0,currScore=0,diffScore=0,perFlagName="",perEstDesc="",currFlagName="",currEstDesc=""
	i $D(^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData")) d
	.s jxUnitDr=0
	.f  s jxUnitDr=$O(^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr)) q:jxUnitDr=""  d
	..s jxUnitName=..GetJXUnitName(jxUnitDr)
	..s KPIDr=0
	..f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr)) q:KPIDr=""  d
	...i $D(^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr,frequency)) d
	....s newPeriod=""
	....f  s newPeriod=$O(^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr,frequency,newPeriod)) q:newPeriod=""  d
	.....i $D(^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr,frequency,newPeriod,schemDr)) d
	......s Curr=^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData",jxUnitDr,KPIDr,frequency,newPeriod,schemDr)
	......i Curr'="" d
	.......s KPIName=$P(Curr,"^",8)
	.......s calUnitName=$P(Curr,"^",9)
	.......s perScore=5 //$P(Curr,"^",1)
	.......s currScore=75 //$P(Curr,"^",4)
	.......s diffScore=35 //$P(Curr,"^",7)
	.......s perFlagName=$P(Curr,"^",2)
	.......s perEstDesc=$P(Curr,"^",3)
	.......s currFlagName=$P(Curr,"^",5)
	.......s currEstDesc=$P(Curr,"^",6)
	.......d OutputRow 
 
 	k ^TEMPDHCCJXPA("dhc","pa","report","peratt","reportData")
 	*/
 	/*测试数据*/
 	s jxUnitName="",KPIName="",calUnitName="",perScore=0,currScore=0,diffScore=0,perFlagName="",perEstDesc="",currFlagName="",currEstDesc=""
 	s m=3
 	f k=1:1:m d
 	.i k=1 d
 	..s jxUnitName="单元一"
 	..s KPIName="指标1"
 	..s calUnitName="个"
 	..s perScore=5
 	..s currScore=1
 	..s diffScore=4
 	..s perFlagName=""
 	..s perEstDesc=""
 	..s currFlagName=""
 	..s currEstDesc=""
 	..d OutputRow
 	.i k=2 d
 	..s jxUnitName="单元二"
 	..s KPIName="指标4"
 	..s calUnitName="米"
 	..s perScore=5
 	..s currScore=2
 	..s diffScore=3
 	..s perFlagName=""
 	..s perEstDesc=""
 	..s currFlagName=""
 	..s currEstDesc=""
 	..d OutputRow
 	.i k=3 d
 	..s jxUnitName="单元三"
 	..s KPIName="指标5"
 	..s calUnitName="米"
 	..s perScore=5
 	..s currScore=3
 	..s diffScore=2
 	..s perFlagName=""
 	..s perEstDesc=""
 	..s currFlagName=""
 	..s currEstDesc=""
 	..d OutputRow
 
 	q $$$OK
OutputRow
	
 	s Data=$lb(jxUnitName,KPIName,calUnitName,$fn(perScore,"",2),$fn(currScore,"",2),$fn(diffScore,"",2),perFlagName,perEstDesc,currFlagName,currEstDesc)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportExecute ]
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

ClassMethod GetReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate:2010-9-9
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uPerAttKPIAnlys","GetReport")
Query GetReport(cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String) As %Query(ROWSPEC = "jxUnitName:%String,KPIName:%String,calUnitName:%String,perScore:%Float,currScore:%Float,diffScore:%Float,perFlagName:%String,perEstDesc:%String,currFlagName:%String,currEstDesc:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uPerAttKPIAnlysS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
