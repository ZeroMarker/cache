Class dhc.pa.report.uUnitKpiReport Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:查询绩效考核方案下的绩效单元
/// Table:dhc_pa_data.UnitSchem
/// Input:schemDr-绩效方案Dr
/// Output:
/// Return:返回绩效考核方案下的绩效单元Dr字符串
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).GetJXUnitOfSchem("1||2")
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

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).GetCycle(4,1)
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
	
	s newCycle=cycleCode-1
	i period<10 d
	.s period="0"_period
	s newPeriod=cycleCode_period
	s perPeriod=newCycle_period
	
	q newPeriod_"^"_perPeriod
}

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:获取绩效单元考核主表记录字符串
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDrStr-绩效单元Dr字符串;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录字符串
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).GetURRowidStr("1||5","201601",25)
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

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:获取绩效单元考核主表记录
/// Table:dhc_pa_data.UnitResult
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核主表记录
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).GetURRowid("1||2","201001",1)
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

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:寻找树根以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;level-级别深度
/// Output:
/// Return:返回树根以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).FindRoots("1||4303",1)
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

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:寻找树根下所有子节点以及节点深度
/// Table:dhc_pa_data.UnitResultDetail
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;level-级别深度;KPIDrInfoStr-子节点信息字符串
/// Output:
/// Return:返回树根下所有子节点以及节点深度信息记录
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).FindChildNodes("1||4303",2,"",1)
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

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:根据指标ID获取指标名称等信息
/// Table:dhc_pa_data.KPIIndex1
/// Input:KPIDr-指标Dr,level-级别深度
/// Output:
/// Return:返回指标信息
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).GetKPIInfo(2,2)
ClassMethod GetKPIInfo(KPIDr, level) As %String
{
	n (KPIDr,level)
	
	i level=2 s nullStr="  "
	i level=3 s nullStr="    "
	i level=4 s nullStr="      "
	i level=5 s nullStr="        "
	
	
	s KPIInfo=""
	q:KPIDr="" KPIInfo															//20120206 快捷键
	s KPICode="",KPIName="",calUnitName="",methodCode="",methodName="",target="", shortcut=""
	
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
	..;s target=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",7)
	
	..;s shortcut=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",3)  //20120206 快捷键
	..s parentKPI=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",21)   //20160511 cyl 父亲指标
	s KPIInfo=KPICode_"^"_KPIName_"^"_calUnitName_"^"_methodName_"^"_target_"^"_level_"^"_parentKPI
	
	q KPIInfo
}

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:根据维度ID获取维度名称等信息
/// Table:dhc_pa_data.DimensType
/// Input:DimenDr-维度Dr
/// Output:
/// Return:返回维度信息
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).GetDimenInfo(1)
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
	
	s DimenInfo=KPICode_"^"_KPIName_"^"_calUnitName_"^"_methodName_"^"_target_"^"_""_"^"_""
	;  s KPIInfo=KPICode_"^"_KPIName_"^"_calUnitName_"^"_methodName_"^"_target_"^"_level_"^"_parentKPI

	q DimenInfo
}

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:获取绩效单元考核方案明细记录
/// Table:dhc_pa_data.UnitResultDetail
/// Input:schemDr-方案Dr;jxUnitDr-绩效单元Dr;newPeriod-新的考核周期
/// Output:
/// Return:返回绩效单元考核方案明细记录
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).GetURDetailInfo("1||15",21)
ClassMethod GetURDetailInfo(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s urDetailInfo=""
	q:urRowid="" urDetailInfo
	q:KPIDr="" urDetailInfo
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_tValue,UnitResultDetail_actValue,UnitResultDetail_score,UnitResultDetail_Rscore,UnitResultDetail_rate,UnitResultDetail_estDesc,UnitResultDetail_fBDesc,    UnitResultDetail_KPIDr ,UnitResultDetail_estUserDr ,UnitResultDetail_estDate ,UnitResultDetail_fBUserDr ,UnitResultDetail_fBDate  from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0   and UnitResultDetail_isTarget=2 "
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	s sqlStr=sqlStr_whereStr
	

	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s tValue = result.Data("UnitResultDetail_tValue") //目标值
		s actValue = result.Data("UnitResultDetail_actValue") //指标值
		s scores = result.Data("UnitResultDetail_score") //实际分数
		s score = result.Data("UnitResultDetail_Rscore") //分数
		s rate = result.Data("UnitResultDetail_rate") //权重
		s estDesc = result.Data("UnitResultDetail_estDesc") //点评描述
		s estUserDr = result.Data("UnitResultDetail_estUserDr") //点评人
		s estUser=""
		i estUserDr'="" s estUser= $p($G(^SSU("SSUSR",estUserDr)),"^",2)
		
		s estDate = result.Data("UnitResultDetail_estDate")	//点评时间
		
		s fBDesc = result.Data("UnitResultDetail_fBDesc") //反馈描述
		
		s fBUserDr = result.Data("UnitResultDetail_fBUserDr") //反馈人
		s fBUser=""
		i fBUserDr'="" s fBUser= $p($G(^SSU("SSUSR",fBUserDr)),"^",2)
		
		s fBDate = result.Data("UnitResultDetail_fBDate")	//反馈时间
		
		//s estAndFBDesc=estDesc_"!"_fBDesc //点评和反馈描述
		s estAndFBDesc="点评描述:"_estDesc_"!点评人:"_estUser_"!点评时间:"_estDate_"!反馈描述:"_fBDesc_"!反馈人:"_fBUser_"!反馈时间:"_fBDate    //点评和反馈描述
		
		//指标值ID
		s kpiId = result.Data("UnitResultDetail_KPIDr")  
		
		;i estAndFBDesc="点评描述:!点评人:!点评时间:!反馈描述:!反馈人:!反馈时间:" s estAndFBDesc=""
		i (estDesc="")&&(estUser="")&&(estDate="")&&(fBDesc="")&&(fBUser="")&&(fBDate="") s estAndFBDesc=""
		
		
		;s urDetailInfo=tValue_"^"_actValue_"^"_score_"^"_rate_"^"_estAndFBDesc_"^"_kpiId
		s urDetailInfo=tValue_"^"_actValue_"^"_score_"^"_scores_"^"_rate_"^"_estAndFBDesc_"^"_kpiId
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
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).GetDimensInfo("1||15",21)
ClassMethod GetDimensInfo(urRowid, KPIDr) As %String
{
	n (urRowid,KPIDr)
	
	s urDetailInfo=""
	q:urRowid="" urDetailInfo
	q:KPIDr="" urDetailInfo
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResultDetail_score,UnitResultDetail_Rscore,UnitResultDetail_rate from dhc_pa_data.UnitResultDetail where UnitResultDetail_childSub>0"
	s whereStr=" and UnitResultDetail_parRef='"_urRowid_"'"
	s whereStr=whereStr_" and UnitResultDetail_isTarget=1"
	s whereStr=whereStr_" and UnitResultDetail_KPIDr='"_KPIDr_"'"
	s whereStr=whereStr_" and UnitResultDetail_parent=0"
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s scores = result.Data("UnitResultDetail_score")  //目标值
		s score = result.Data("UnitResultDetail_Rscore")
	
		s rate = result.Data("UnitResultDetail_rate") //目标值
		s urDetailInfo=""_"^"_""_"^"_score_"^"_scores_"^"_rate_"^"_""_"^"_""
		
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

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:处理节点信息字符串
/// Table:
/// Input:urRowid-绩效单元考核主表Dr;rootDr-根节点ID;NodeInfoStr-节点信息字符串
/// Output:
/// Return:
/// Others:w ##class(dhc.pa.report.uUnitKpiReport).DealNodeInfo("1||4303",2,"2!1^7!2^20!3^46!4^47!4^49!4^50!4^51!4^21!3^52!4^53!4^54!4^55!4^22!3^56!4^57!4^58!4^59!4^60!4^23!3^61!4^62!4^63!4^64!4^65!4^66!4^92!4")
ClassMethod DealNodeInfo(urRowid, rootDr, NodeInfoStr) As %String
{
	n (urRowid,rootDr,NodeInfoStr)

	q:urRowid=""
	q:rootDr=""
	q:NodeInfoStr=""
	
	s Len=$L(NodeInfoStr,"^")
	s KPIInfo=""
	
	s shortcut=""
	;w "NodeInfoStr="_NodeInfoStr,!
	f k=1:1:Len d
	.s NodeInfo=$P(NodeInfoStr,"^",k)
	.s KPIDr=$P(NodeInfo,"!",1)
	.s level=$P(NodeInfo,"!",2)
	.i k=1 d
	..s KPIInfo=..GetDimenInfo(KPIDr)
	..s KPIDr=-KPIDr
	.e  d
	..s KPIInfo=..GetKPIInfo(KPIDr, level)
	..;w "KPIDr="_KPIDr,!
	..s shortcut=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",3)   //20120206  快捷键
	
	
	.i KPIDr>0 s Info=..GetURDetailInfo(urRowid, KPIDr)
	.e  s Info=..GetDimensInfo(urRowid, -KPIDr)
	.;s =..GetTotalScore(urRowid)
	.s NodeAllInfo=KPIInfo_"^"_Info_"^"_shortcut //20120206  快捷键
	.;w NodeAllInfo,!
	.;将数据存入临时Global
	.i KPIDr<0 d
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,KPIDr,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,KPIDr,KPIDr))
	...;s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_$P(Curr,"^",4)_"^"_$P(Curr,"^",5)_"^"_($P(Curr,"^",6)+$P(Info,"^",1))_"^"_($P(Curr,"^",7)+$P(Info,"^",2))_"^"_($P(Curr,"^",8)+$P(Info,"^",3))_"^"_$P(Curr,"^",9)_"^"_$P(Curr,"^",10)
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_$P(Curr,"^",4)_"^"_$P(Curr,"^",5)_"^"_($P(Curr,"^",6)+$P(Info,"^",1))_"^"_($P(Curr,"^",7)+$P(Info,"^",2))_"^"_($P(Curr,"^",8)+$P(Info,"^",3))_"^"_($P(Curr,"^",9)+$P(Info,"^",4))_"^"_$P(Curr,"^",10)_"^"_$P(Curr,"^",11)

	...s ^TEMPDHCCJXPA("dhc","pa","report","locRerpot",urRowid,rootDr,KPIDr,KPIDr)=str
	...;w "11111111:  "_^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,KPIDr,KPIDr),!
	..e  d
	...s ^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,KPIDr,KPIDr)=NodeAllInfo
	...;w "22222222:  "_^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,KPIDr,KPIDr),!
	
	.e  d
	..s code=$P(NodeAllInfo,"^",1)
	..i $D(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr)) d
	...s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr))
	...;s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_$P(Curr,"^",4)_"^"_$P(Curr,"^",5)_"^"_($P(Curr,"^",6)+$P(Info,"^",1))_"^"_($P(Curr,"^",7)+$P(Info,"^",2))_"^"_($P(Curr,"^",8)+$P(Info,"^",3))_"^"_$P(Curr,"^",9)_"^"_$P(Curr,"^",10)
	...s str=$P(Curr,"^",1)_"^"_$P(Curr,"^",2)_"^"_$P(Curr,"^",3)_"^"_$P(Curr,"^",4)_"^"_$P(Curr,"^",5)_"^"_($P(Curr,"^",6)+$P(Info,"^",1))_"^"_($P(Curr,"^",7)+$P(Info,"^",2))_"^"_($P(Curr,"^",8)+$P(Info,"^",3))_"^"_($P(Curr,"^",9)+$P(Info,"^",4))_"^"_$P(Curr,"^",10)_"^"_$P(Curr,"^",11)
	...s ^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr)=str
	...;w "33333333:  "_^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr),!
	..e  d
	...;w urRowid_"^"_rootDr_"^"_code,!
	...s ^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr)=NodeAllInfo
	...;w "44444444:  "_^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr),!
}

ClassMethod GetUnitReportExecute(ByRef qHandle As %Binary, cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String, jxUnitDrStr As %String, USERCODE As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
  	q:frequency="" $$$OK
  	q:period="" $$$OK
  	q:schemDr="" $$$OK
  	q:USERCODE="" $$$OK
  
    s userID=##class(dhc.pa.report.uComm).getUserInfo(USERCODE)
  	s unitDr=##class(dhc.pa.report.uComm).getJXUnitInfo(jxUnitDrStr,userID)
  	
  	k ^TEMPDHCCJXPA("dhc","pa","report","locReport")
  	
  	//获取新的考核周期
  	s Period=..GetCycle(cycleDr, period)
  	s newPeriod=$p(Period,"^",1)
  	s perPeriod=$p(Period,"^",2)
  	
  	s flag=##class(dhc.pa.udata.uComm).getSchemStaus(schemDr,newPeriod) 
    ;q:flag'="60" $$$OK  
  	s shortcut=""
  	
  	q:newPeriod="" $$$OK
	q:newPeriod="UnCycle" $$$OK
	q:newPeriod="UnPeriod" $$$OK
	q:newPeriod="UnCycleCode" $$$OK
	//获取该方案下的所有绩效单元
	;s jxUnitDrStr=..GetJXUnitOfSchem(schemDr)
	q:jxUnitDrStr="" $$$OK
	//根据条件获取所有绩效单元考核主表记录字符串
	s urRowidStr=..GetURRowidStr(schemDr,newPeriod,jxUnitDrStr)
	;w urRowidStr,!
	q:urRowidStr="" $$$OK
	//操作UnitResultDetail表
	s Length=$L(urRowidStr,"^")
	f k=1:1:Length d
	.s urRowid=$P(urRowidStr,"^",k)
	.s level=1
	.;获取根节点信息
	.s urdRootInfoStr=..FindRoots(urRowid,level)
	.s Len=$L(urdRootInfoStr,"^")
	.f m=1:1:Len d
	..s urdRootInfo=$P(urdRootInfoStr,"^",m)
	..s rootDr=$P(urdRootInfo,"!",1)
	..s KPIDrInfoStr=""
	..s KPIDrInfoStr=..FindChildNodes(urRowid,rootDr,KPIDrInfoStr,level)
	..s NodeInfoStr=urdRootInfo_"^"_KPIDrInfoStr
	..d ..DealNodeInfo(urRowid,rootDr,NodeInfoStr)
	
	//从临时Global中取出数据
	//^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,KPIDr,KPIDr)
	s totalScore=0
	
	;w ^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,NodeInfoStr),!
	;^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr)

	s kpiFlag=0
  	i $D(^TEMPDHCCJXPA("dhc","pa","report","locReport")) d
	.s urRowid=0
	.f  s urRowid=$O(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid)) q:urRowid=""  d
	..s rootDr=0
	..f  s rootDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr)) q:rootDr=""  d
	...s code=""
	...f  s code=$O(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code))  q:code=""  d
	....s KPIDr=""
	....f  s KPIDr=$O(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr)) q:KPIDr=""  d
	.....;w KPIDr,! 
	.....s Curr=$G(^TEMPDHCCJXPA("dhc","pa","report","locReport",urRowid,rootDr,code,KPIDr))
	.....s Graph="柱形图"
	.....s KPICode=$P(Curr,"^",1)
	.....s KPIName=$P(Curr,"^",2)
	.....i KPICode'="" d
	......s jxQMRowID=$o(^DHCCJXQMQMSchemI("QMSchemCode",KPICode,""))
	.....e  d
	......s jxQMRowID=""

	.....s calUnitName=$P(Curr,"^",3)
	.....s tValue=$P(Curr,"^",8)
	.....s actValue=$P(Curr,"^",9)
	.....;i calUnitName="百分比" s tValue=$P(Curr,"^",6)*100,actValue=$P(Curr,"^",7)*100
	.....s score=$P(Curr,"^",10) ;最终考核分
	.....s scores=$P(Curr,"^",11)
	.....s methodName=$P(Curr,"^",4)
	.....s target=$P(Curr,"^",5)
	.....s level=$P(Curr,"^",6)
	.....s parentKPI=$P(Curr,"^",7)
	.....s estAndFBDesc=$P(Curr,"^",13)
	.....s rate=$P(Curr,"^",12)
	
	.....s jxUnitName=$p(^DHCCJXPAJXUNIT(jxUnitDrStr),"^",3)
	.....//可以得到绩效unit的code，但是格式不对，怎么才能和HIS中的code匹配
	.....s jxUnitCode=$p(^DHCCJXPAJXUNIT(jxUnitDrStr),"^",2)
	.....//HIS中的deptcode暂时为7位
	.....s HISDeptCodeLen=7
	.....s jxUnitCodeLen=$L(jxUnitCode)
	.....if (HISDeptCodeLen>jxUnitCodeLen) d
	......s codeAddStr=""
	......f i=jxUnitCodeLen+1:1:HISDeptCodeLen  do
	.......s codeAddStr=codeAddStr_"0"
	......s HisDeptCode=jxUnitCode_codeAddStr
	......s HisDeptId=$o(^RBC("DEP",0,"Code",HisDeptCode,""))
	.....;s lowerSchemID=""  //二级方案ID
	.....;s lowerSchemID=..GetLowerSchemId2(KPIDr,jxUnitDrStr,schemDr)  //根据结果指标ID 查询方案ID

	.....i KPIDr<0 d
	......;s totalScore=totalScore+((score*rate)/100)
	......s totalScore=totalScore+score
	......;w "KPIDr="_KPIDr,!
	......s lowerSchemID=""  //二级方案ID
	......s lowerSchemID=..GetLowerSchemId3(KPIDr,jxUnitDrStr,schemDr,frequency)  //根据结果指标ID 查询方案ID

    .....;w Curr,!
	.....s kpiId=$P(Curr,"^",14)
	.....s expName="",expression=""
	.....i kpiId'="" d
	......s expression=$P(^DHCCJXPAKPIINDEX1(kpiId),"^",10)  //指标计算公式
	......s expression=$E(expression,2,$L(expression)-1)
	......;s lowerSchemID=..GetLowerSchemId(kpiId,schemDr,frequency)  //根据结果指标ID 查询方案ID
	......s lowerSchemID=..GetLowerSchemId3(kpiId,jxUnitDrStr,schemDr,frequency)
	......i kpiId=10 s lowerSchemID="1||27"
	
	......s expName=$P(^DHCCJXPAKPIINDEX1(kpiId),"^",11)
	......s periodScore=..getPeriodScore(jxUnitDrStr,perPeriod,kpiId,2) 
	.....s shortcut=$P(Curr,"^",15)
	.....;i kpiId>0 s lowerSchemID=""
	.....s tmpKPI=0
	.....i kpiId>0 d
	......s tmpKPI=##class(dhc.pa.report.uComm).getKPIInfo(kpiId,userID)
	.....i KPIDr<0 d
	......;i KPIDr=9 w jxUnitDrStr,schemDr,newPeriod,KPIDr,!,!,!
	......;w KPIDr_"_______________________",!
	......s tmpkpiDr=##class(dhc.pa.report.uUnitKpiReport).getKPIChild(jxUnitDrStr,schemDr,newPeriod,KPIDr)
	......;w tmpkpiDr,!
	......s tmpKPI=##class(dhc.pa.report.uComm).getKPIInfo(tmpkpiDr,userID)
	......s periodScore=0
	......s periodScore=..getPeriodScore(jxUnitDrStr,perPeriod,KPIDr*(-1),1)
	.....i tmpKPI=0 s kpiFlag=1
	.....;i tmpKPI'=0 d
	.....;w Graph_"^"_KPICode_"^"_KPIName_"^"_calUnitName_"^"_$fn(tValue,"",2)_"^"_$fn(actValue,"",2)_"^"_$fn(score,"",2)_"^"_$fn(periodScore,"",2)_"^"_methodName_"^"_target_"^"_estAndFBDesc_"^"_$fn(rate,"",2)_"^"_expression_"^"_newPeriod_"^"_lowerSchemID_"^"_kpiId_"^"_KPIDr_"^"_shortcut_"^"_expName_"^"_jxUnitName,!
	.....d OutputRow
	
	
	;s ^TEMPDHCCJXPA("dhc","pa","report","locReportTotal")="^^^^^^^"_totalScore_"^^"
	/*
	s Graph="",KPICode="",KPIName="   考核总分",calUnitName="",tValue="",actValue="",methodName="",target="",estAndFBDesc="",rate="100"
	;s score=$fn($P(^TEMPDHCCJXPA("dhc","pa","report","locReportTotal"),"^",8),"",2)
	s score=..getTotal(jxUnitDrStr,newPeriod,schemDr)
	;i (tmpKPI'=0)&&(kpiFlag=0) d
	s periodScore=0
	;w Graph_"^"_KPICode_"^"_KPIName_"^"_calUnitName_"^"_$fn(tValue,"",2)_"^"_$fn(actValue,"",2)_"^"_$fn(score,"",2)_"^"_$fn(periodScore,"",2)_"^"_methodName_"^"_target_"^"_estAndFBDesc_"^"_$fn(rate,"",2)_"^"_expression_"^"_newPeriod_"^"_lowerSchemID_"^"_kpiId_"^"_KPIDr_"^"_shortcut_"^"_expName_"^"_jxUnitName,!
	*/
	;d OutputRow
	
	k ^TEMPDHCCJXPA("dhc","pa","report","locReport")
	k ^TEMPDHCCJXPA("dhc","pa","report","locReportTotal")

	
 	q $$$OK
OutputRow
	
 	;s Data=$lb(Graph,KPICode,KPIName,calUnitName,$fn(tValue,"",2),$fn(actValue,"",2),$fn(score,"",2),                 $fn(periodScore,"",2),methodName,target,estAndFBDesc,$fn(rate,"",2),expression,newPeriod,lowerSchemID,kpiId,KPIDr,shortcut,expName,jxUnitName,level,HisDeptCode,HisDeptId,jxQMRowID,parentKPI)
 	s Data=$lb(Graph,KPICode,KPIName,calUnitName,$fn(tValue,"",2),$fn(actValue,"",2),$fn(score,"",2),$fn(scores,"",2),$fn(periodScore,"",2),methodName,target,estAndFBDesc,$fn(rate,"",2),expression,newPeriod,lowerSchemID,kpiId,KPIDr,shortcut,expName,jxUnitName,level,HisDeptCode,HisDeptId,jxQMRowID,parentKPI)

	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetUnitReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnitReportExecute ]
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

ClassMethod GetUnitReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:杨旭
/// CreatDate:2010-9-29
/// Description:查询科室报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uUnitKpiReport","GetUnitReport",3,"Q",2,"1||1","4","demo")
Query GetUnitReport(cycleDr As %Integer, frequency As %String, period As %Integer, schemDr As %String, jxUnitDrStr As %String, USERCODE As %String) As %Query(ROWSPEC = "Graph:%String,KPICode:%String,KPIName:%String,calUnitName:%String,tValue:%Float,actValue:%Float,score:%Float,scores:%Float,periodScore:%Float,methodName:%String,target:%String,estAndFBDesc:%String,rate:%Float,expression:%String,Period:%String,lowerSchemID:%String,kpiId:%String,KPIDr:%String,shortcut:%String,expName:%String,jxUnitName:%String,level:%Integer,HisDeptCode:%String,HisDeptId:%String,jxQMRowID:%String,parentKPI:%Integer") [ SqlProc ]
{
}

/// Creator：刘洋
/// CreatDate：2011-12-12
/// Description:结果指标ID 查询方案ID
/// Table：dhc.pa.data.Schem
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId(9,"1||1","Q")
ClassMethod GetLowerSchemId(Id, SchemId, frequency) As %String
{
	n (Id,SchemId,frequency)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select *  from  dhc_pa_data.Schem   "
	s whereStr=""
	i Id '="" s whereStr=" where  Schem_KPIDr like '%"_Id_"%' and Schem_frequency='"_frequency_"'"

	s sqlStr=sqlStr_whereStr
	
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid =""
	s ResultRowid=""
	
	While(result.Next()){
		
		s rowid = result.Data("Schem_rowid")
		
		s UpSchem =  result.Data("Schem_UpSchemDr")
		s cuSchem =""
	    s ind = 1
	   for  set cuSchem= $P(UpSchem,",",ind) q:cuSchem=""  do 
	   	
	 	. if cuSchem = SchemId do
	 	
	 	..s ResultRowid=rowid
	 	.. q 
        .set ind=ind+1
        ;w "IIAfter-",ResultRowid,"--",SchemId,!
	  

	}
	d result.Close()

	q ResultRowid
}

/// Creator：刘洋
/// CreatDate：2012-02-02
/// Description:根据结果指标ID 和 科室Dr   查询方案ID
/// Table：dhc.pa.data.Schem
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串  (外科  13  ，工作效率  1 )
/// Others：w ##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId3("10","4","1||1","Q")
/// 2013-02-25 wangying 修改 2015-05-12 update  根据结果指标的上级指标dr和科室dr、方案dr 查询此方案对应的二级方案
ClassMethod GetLowerSchemId3(kpiDr, unitDr, SchemId, frequency) As %String
{
	n (kpiDr, unitDr,SchemId,frequency)
    ;s kpiDr=kpiDr*(-1)
    s flag=0  
	i kpiDr<0 s kpiDr=kpiDr*(-1),flag=1

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select *  from  dhc_pa_data.Schem ,dhc_pa_data.UnitSchem  where Schem_rowid=UnitSchem_schemDr and Schem_parRef="_$p(SchemId,"||",1)   
	s whereStr=""
	i unitDr '="" s whereStr=" and  UnitSchem_parRef = '"_unitDr_"' "
	i frequency'=""  s whereStr=whereStr_" and Schem_frequency='"_frequency_"'"

	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid =""
	While(result.Next()){

		s Lens=0
		s resultKPIs = result.Data("Schem_KPIDr")
		i resultKPIs'="" s Lens=$L(resultKPIs,",")
		;s a=$find(resultKPI,kpiDr)
		;i a'=0  s rowid = result.Data("Schem_rowid")
		;w resultKPIs,!
		f n=1:1:Lens  d
		.s resultKPI=$P(resultKPIs,",",n)
		.s upKPI=$p($g(^DHCCJXPAKPIINDEX1(resultKPI)),"^",21) //上级kpi
		.;w upKPI,!
        .s schemDr=result.Data("Schem_rowid")
		.i (upKPI=kpiDr)&&(schemDr'=SchemId)  s rowid = schemDr
		.e  i (upKPI=0)&&(schemDr'=SchemId)&&(flag=0)&&(resultKPIs=kpiDr) d 
		..s rowid = schemDr
	}
	d result.Close()

	q rowid
}

//d ##class(dhc.pa.report.uUnitKpiReport).test("3||6")

ClassMethod test(schemDr)
{
	n (schemDr)
	s cuurstragem=$p(schemDr,"||",1)
	s URChild=0
	f  s URChild=$o(^DHCCJXPASTRATAGEM(cuurstragem,"UnitResult",URChild)) q:URChild=""  d
	.i ^DHCCJXPASTRATAGEM(cuurstragem,"UnitResult",URChild)'="" d
	..s tmpSchem=$p(^DHCCJXPASTRATAGEM(cuurstragem,"UnitResult",URChild),"^",1)
	..i tmpSchem=schemDr d
	...w URChild,!
	...s UResultDetail=0
	...f  s UResultDetail=$o(^DHCCJXPASTRATAGEM(cuurstragem,"UnitResult",URChild,"URDetail",UResultDetail)) q:UResultDetail=""  d
	....b
	....w UResultDetail,!
	....s info=^DHCCJXPASTRATAGEM(cuurstragem,"UnitResult",URChild,"URDetail",UResultDetail)
	....s score=$p(info,"^",12)
	....s actValue=$p(info,"^",11)
	....i actValue="" d
	.....s actValue=score
	.....s rowid=cuurstragem_"||"_URChild_"||"_UResultDetail
	.....w "rowid"_rowid,!
	.....&sql(update dhc_pa_data.UnitResultDetail set UnitResultDetail_actValue=:actValue where %ID=:rowid)
}

ClassMethod test1()
{
	f i=1537:1:1625 d
	.k ^DHCCJXPASTRATAGEM(3,"UnitResult",i)
}

//w ##class(dhc.pa.report.uUnitKpiReport).getKPIChild(1,"1||1","201401",9)

ClassMethod getKPIChild(jxUnitDrStr, schemDr, newPeriod, kpidr) As %String
{
	n (jxUnitDrStr,schemDr,newPeriod,kpidr)
	s flag=""
	//用户信息
	s sqlStr="select top 1 * from dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail"
	s whereStr=" where  UnitResult_rowid=UnitResultDetail_parRef and UnitResult_schemDr='"_schemDr_"' and UnitResult_period='"_newPeriod_"' and UnitResultDetail_parent='"_kpidr_"' and UnitResult_jxUnitDr='"_jxUnitDrStr_"'"
    s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		//集体初始化
		s rowid=result.Data("UnitResultDetail_KPIDr")
		
	}
	d result.Close()
    q:rowid'="" rowid
}

/// Creator：wang ying
/// CreatDate：2014-04-15
/// Description:根据结果指标ID、指标类型、期间 和 科室Dr   查询分数
/// Table：dhc.pa.data.UnitResultDetail,dhc.pa.data.UnitResult
/// Input：
/// Output：
/// Return：有效绩效单元字符串  (外科  13  ，工作效率  1 )
/// Others：w ##class(dhc.pa.report.uUnitKpiReport).getPeriodScore(25,"201601","1",2)
ClassMethod getPeriodScore(jxUnitDr, newPeriod, kpidr, type) As %String
{
	n (jxUnitDr,newPeriod,kpidr,type)

	//用户信息
	s sqlStr="select  top 1* from dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail"
	s whereStr=" where  UnitResult_rowid=UnitResultDetail_parRef and  UnitResult_period='"_newPeriod_"' and UnitResultDetail_KPIDr='"_kpidr_"' and UnitResult_jxUnitDr='"_jxUnitDr_"' and UnitResultDetail_isTarget='"_type_"'"
    s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s score=0
	While(result.Next()){
		//集体初始化
		s score=result.Data("UnitResultDetail_score")
		
	}
	d result.Close()
    q score
}

/// Creator：wang ying
/// CreatDate：2014-04-15
/// Description:根据结果指标ID、指标类型、期间 和 科室Dr   查询分数
/// Table：dhc.pa.data.UnitResultDetail,dhc.pa.data.UnitResult
/// Input：
/// Output：
/// Return：有效绩效单元字符串  (外科  13  ，工作效率  1 )
/// Others：w ##class(dhc.pa.report.uUnitKpiReport).getTotal(15,"201601","1||1")
ClassMethod getTotal(jxUnitDr, newPeriod, SchemDr) As %String
{
	n (jxUnitDr,newPeriod,SchemDr)

	//用户信息
	;s sqlStr="select UnitResult_totalScore from dhc_pa_data.UnitResult"
	//s sqlStr="select UnitResult_RScore from dhc_pa_data.UnitResult"
	s sqlStr="select sum(UnitResultDetail_Rscore*UnitResultDetail_rate/100) as RScore from dhc_pa_data.UnitResultDetail"
	s whereStr=" where  UnitResultDetail_parRef->UnitResult_period='"_newPeriod_"' and UnitResultDetail_parRef->UnitResult_jxUnitDr='"_jxUnitDr_"' and UnitResultDetail_parRef->UnitResult_schemDr='"_SchemDr_"'"
	           _" and UnitResultDetail_parent<0"
    s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s score=0
	While(result.Next()){
		//集体初始化
		;s score=result.Data("UnitResult_totalScore")
		s score=result.Data("RScore")
		
	}
	d result.Close()
    q score
}

/// Creator：刘洋
/// CreatDate：2012-02-02
/// Description:根据结果指标ID 和 科室Dr   查询方案ID
/// Table：dhc.pa.data.Schem
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串  (外科  13  ，工作效率  1 )
/// Others：w ##class(dhc.pa.report.uUnitKpiReport).GetLowerSchemId2(20,"4","1||1","Q")
ClassMethod GetLowerSchemId2(kpiDr, unitDr, schemDr, frequency) As %String
{
	n (kpiDr, unitDr,schemDr,frequency)
	;w "kpiDr=", kpiDr, "unitDr=", unitDr,!
	
	/*
	s Stratagem = ""
	s curreStratagemDr = ""
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
	..i $g(^DHCCJXPASTRATAGEM(Stratagem))'="" d
	...s curreStratagem = $p(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
	...if curreStratagem="Y" d
	....s curreStratagemDr = Stratagem	
    */
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select *  from  dhc_pa_data.Schem ,dhc_pa_data.UnitSchem  where Schem_rowid=UnitSchem_schemDr and Schem_parRef="_$p(schemDr,"||",1)   
	s whereStr=""
	i unitDr '="" s whereStr=" and  UnitSchem_parRef = '"_unitDr_"'   "
    i frequency'=""  s whereStr=whereStr_" and Schem_frequency='"_frequency_"'"

	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid =""
	s Lens=""

	While(result.Next()){

		s resultKPIs = result.Data("Schem_KPIDr")
		i resultKPIs'="" s Lens=$L(resultKPIs,",")
		;s a=$find(resultKPI,kpiDr)
		;i a'=0  s rowid = result.Data("Schem_rowid")
		;w resultKPIs,!
		f n=1:1:Lens  d
		.s resultKPI=$P(resultKPIs,",",n)
		.i resultKPI=kpiDr  s rowid = result.Data("Schem_rowid")
	}
	d result.Close()

	q rowid
}

Storage Default
{
<Data name="uUnitKpiReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.r.uUnitKpiReportD</DataLocation>
<DefaultData>uUnitKpiReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.r.uUnitKpiReportD</IdLocation>
<IndexLocation>^dhc.pa.r.uUnitKpiReportI</IndexLocation>
<StreamLocation>^dhc.pa.r.uUnitKpiReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
