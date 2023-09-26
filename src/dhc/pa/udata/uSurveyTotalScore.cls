/// Creator: wang ying
/// CreatDate: 2011-7-19
/// Description: 问卷调查最终分数
Class dhc.pa.udata.uSurveyTotalScore Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2011-07-19
/// Description:计算最终结果
/// Table:dhc.pa.data.SurveyTotalScore
/// Input:schemDr:方案, unitDr:科室id, period:期间, periodType:期间类型
/// Output:
/// Return:返回计算后正确或错误的结果标志 
/// Others:w ##class(dhc.pa.udata.uSurveyTotalScore).getScorce("3||16","01","M",3)
/// 2013-08-09修改
ClassMethod getScorce(schemDr, period, periodType, cycleDr) As %String
{
	new (schemDr,period,periodType,cycleDr)
 	q:schemDr="" "NoSchemDr"
 	q:period="" "Noperiod"
 	q:periodType="" "NoperiodType"
 	q:cycleDr="" "NocycleDr"
 	
 	i $d(^DHCCJXPACYCLE(cycleDr)) d
 	.s cycleCode=$p($g(^DHCCJXPACYCLE(cycleDr)),"^",1)
  	s period=cycleCode_period
 	TSTART
 	s unitDr=0,SQLCODE=0
 	f  s unitDr=$o(^DHCCJXPASURVEYSCORETOTAL(0,"PPTTypeLoc",period,periodType,schemDr,unitDr))  q:unitDr=""  d
 	.s count=0
 	.s score=0
 	.s rowid=0,resultKPI=""
 	.f  s rowid=$o(^DHCCJXPASURVEYSCORETOTAL(0,"PPTTypeLoc",period,periodType,schemDr,unitDr,rowid)) q:rowid=""  d
 	..s count=count+1
 	..i $d(^DHCCJXPASURVEYSCORETOTAL(rowid)) d
 	..s score=score+$p($g(^DHCCJXPASURVEYSCORETOTAL(rowid)),"^",4)
 	.s total=score/count
 	.i $d(^DHCCJXPASURVEYTOTALSCORE(0,"PPSA",period,periodType,schemDr,unitDr)) d
 	..s totalRowid=0
 	..s totalRowid=$o(^DHCCJXPASURVEYTOTALSCORE(0,"PPSA",period,periodType,schemDr,unitDr,totalRowid))
 	..&sql(update dhc_pa_data.SurveyTotalScore set SurveyTotalScore_period=:period,SurveyTotalScore_periodType=:periodType,SurveyTotalScore_schemDr=:schemDr,SurveyTotalScore_AcceptUnitDr=:unitDr,SurveyTotalScore_score=:total where SurveyTotalScore_rowid=:totalRowid)
 	.e  d
 	..&sql(insert into dhc_pa_data.SurveyTotalScore (SurveyTotalScore_period,SurveyTotalScore_periodType,SurveyTotalScore_schemDr,SurveyTotalScore_AcceptUnitDr,SurveyTotalScore_score) values(:period,:periodType,:schemDr,:unitDr,:total))
	.i $d(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))) d
	..s resultKPI=$p($g(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",6)
	.i resultKPI'="" d
	..s detailRowidStr=..detailRowid(period,unitDr,resultKPI)
	..s len=$l(detailRowidStr,"^")
	..f i=1:1:len d
	...s rowid=$p(detailRowidStr,"^",i)
	...&sql(update dhc_pa_data.UnitResultDetail set UnitResultDetail_score=:total where UnitResultDetail_rowid=:rowid )
	
	i SQLCODE'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	Q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2013-08-9
/// Description: 查询调查问卷的上级方案明细id
/// Table: dhc_pa_data.UnitResult
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uSurveyTotalScore).detailRowid("201301",3,16)
ClassMethod detailRowid(period, unitDr, KPIDr) As %String
{
	  
	   	    
	    s sqlStr="select *  from dhc_pa_data.UnitResultDetail,dhc_pa_data.UnitResult where UnitResultDetail_parRef=UnitResult_rowid and UnitResult_period='"_period_"' and UnitResult_jxUnitDr='"_unitDr_"' and UnitResultDetail_KPIDr='"_KPIDr_"' and UnitResultDetail_isTarget=2"
	  
				
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s rowidStr=""
		While(result.Next())
		{
			s rowid=result.Data("UnitResultDetail_rowid")
			
			i rowidStr="" d
			.s rowidStr=rowid
			e  d
			.s rowidStr=rowidStr_"^"_rowid
			
			
		}
		d result.Close()
		q rowidStr
}

/// Creator：wang ying
/// CreatDate：2011-7-19
/// Description: 查询符合条件的基本数据记录
/// Table：dhc_pa_data.SurveyTotalScore
/// Input：period-考核期间;periodType-期间类型;parRef-绩效单元ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uSurveyTotalScore).List("","","","",0,25,"01","M",3)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, period, periodType, cycleDr) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, period, periodType,cycleDr)
	
	q:cycleDr="" "Nocycle"
  	i $d(^DHCCJXPACYCLE(cycleDr)) d
  	.s cycleCode=$p($g(^DHCCJXPACYCLE(cycleDr)),"^",1)
 	 s period=cycleCode_period
	
	s sqlStr="select SurveyTotalScore_rowid,SurveyTotalScore_period,SurveyTotalScore_periodType,SurveyTotalScore_schemDr,SurveyTotalScore_AcceptUnitDr,SurveyTotalScore_score from dhc_pa_data.SurveyTotalScore"
	s whereStr=" where %ID>0"
	s whereStr=whereStr_" and SurveyTotalScore_period ='"_period_"'"
    s whereStr=whereStr_" and SurveyTotalScore_periodType ='"_periodType_"'"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="SurveyTotalScore_rowid"
	.i sortField="period" s sortField1="SurveyTotalScore_period"
	.i sortField="periodTypeName" s sortField1="SurveyTotalScore_periodType"
	.i sortField="schemDr" s sortField1="SurveyTotalScore_schemDr"
	.i sortField="unitDr" s sortField1="SurveyTotalScore_AcceptUnitDr"
	.i sortField="score" s sortField1="SurveyTotalScore_score"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^period^periodType^periodTypeName^schemDr^schemName^unitDr^unitName^score"
	
	While(result.Next()){
		//集体初始化
		s periodTypeName="",schemName="",unitName=""
		
			
		s rowid=result.Data("SurveyTotalScore_rowid")
		s period=result.Data("SurveyTotalScore_period")
		//期间类型
		s periodType=result.Data("SurveyTotalScore_periodType")
		i periodType="M" s periodTypeName="月份"
		i periodType="Q" s periodTypeName="季度"
		i periodType="H" s periodTypeName="半年"
		i periodType="Y" s periodTypeName="年度"
		//指标
		s schemDr=result.Data("SurveyTotalScore_schemDr")
		i schemDr'="" d
		.i $D(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))) d
		..i $G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)))'="" d
		...s schemName=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",2)
		//接受科室
		s unitDr=result.Data("SurveyTotalScore_AcceptUnitDr")
		i $d(^DHCCJXPAJXUNIT(unitDr)) d
		.s unitName=$p($g(^DHCCJXPAJXUNIT(unitDr)),"^",3)
		
		//分数
		s score=result.Data("SurveyTotalScore_score")
		s score=$fn(score,"",2)
		
		s tmp=rowid_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_schemDr_"^"_schemName_"^"_unitDr_"^"_unitName_"^"_score
		
		i searchValue'="" d
		.q:(searchField = "period")&(period'[searchValue)
		.q:(searchField = "periodTypeName")&(periodTypeName'[searchValue)
		.q:(searchField = "schemName")&(schemName'[searchValue)
		.q:(searchField = "unitName")&(unitName'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2011-7-19
/// Description: 查询符合条件的基本数据记录
/// Table：dhc_pa_data.SurveyScoreTotal
/// Input：period-考核期间;periodType-期间类型;parRef-绩效单元ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uSurveyTotalScore).TotalList("01","M",24,1,"1||32")
ClassMethod TotalList(period, periodType, locDr, cycleDr, schemDr) As %String
{
	n (period, periodType,locDr,cycleDr,schemDr)
	
	q:schemDr="" "NoschemDr"
	q:cycleDr="" "Nocycle"
  	i $d(^DHCCJXPACYCLE(cycleDr)) d
  	.s cycleCode=$p($g(^DHCCJXPACYCLE(cycleDr)),"^",1)
 	s period=cycleCode_period
	
	s sqlStr="select SurveyScoreTotal_Rowid,SurveyScoreTotal_AcceptUnitDr,SurveyScoreTotal_unitType,SurveyScoreTotal_ScoreDr,SurveyScoreTotal_TotalScore,SurveyScoreTotal_Active,SurveyScoreTotal_period,SurveyScoreTotal_periodType,SurveyScoreTotal_SchemDr,SurveyScoreTotal_userDr,SurveyScoreTotal_patDr,SurveyScoreTotal_patName from dhc_pa_data.SurveyScoreTotal"
	s whereStr=" where %ID>0"
	s whereStr=whereStr_" and SurveyScoreTotal_period ='"_period_"'"
	s whereStr=whereStr_" and SurveyScoreTotal_periodType ='"_periodType_"'"
	s whereStr=whereStr_" and SurveyScoreTotal_AcceptUnitDr ='"_locDr_"'"
	s whereStr=whereStr_" and SurveyScoreTotal_SchemDr ='"_schemDr_"'"
	
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^period^periodType^periodTypeName^schemDr^schemName^unitDr^unitName^ScoreDr^ScoreName^score^cycleDr^userDr^patDr^patName"
	
	While(result.Next()){
		//集体初始化
		s periodTypeName="",schemName="",unitName="",cycleDr=""
		
			
		s rowid=result.Data("SurveyScoreTotal_Rowid")
		s period=result.Data("SurveyScoreTotal_period")
		//期间类型
		s periodType=result.Data("SurveyScoreTotal_periodType")
		i periodType="M" s periodTypeName="月份"
		i periodType="Q" s periodTypeName="季度"
		i periodType="H" s periodTypeName="半年"
		i periodType="Y" s periodTypeName="年度"
		//指标
		s schemDr=result.Data("SurveyScoreTotal_SchemDr")
		i schemDr'="" d
		.i $D(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))) d
		..i $G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)))'="" d
		...s schemName=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",2)
		...s cycleDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1)),"^",2)
		//接受科室
		s unitDr=result.Data("SurveyScoreTotal_AcceptUnitDr")
		i $d(^DHCCJXPAJXUNIT(unitDr)) d
		.s unitName=$p($g(^DHCCJXPAJXUNIT(unitDr)),"^",3)
		
		//打分科室
		s ScoreDr=result.Data("SurveyScoreTotal_ScoreDr")
		i $d(^CTLOC(ScoreDr)) d
		.s ScoreName=$p($g(^CTLOC(ScoreDr)),"^",2)
		
		//调查人
		s userDr=result.Data("SurveyScoreTotal_userDr")
		i userDr'="" d
		.i $d(^SSU("SSUSR",userDr)) d
		..s userName=$p($g(^SSU("SSUSR",userDr)),"^",2)
		
		//打分人id
		s patDr=result.Data("SurveyScoreTotal_patDr")
		
		//打分人Name
		s patName=result.Data("SurveyScoreTotal_patName")
		
		//分数
		s score=result.Data("SurveyScoreTotal_TotalScore")
		s score=$fn(score,"",2)
		
		s tmp=rowid_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_schemDr_"^"_schemName_"^"_unitDr_"^"_unitName_"^"_userDr_"^"_userName_"^"_score_"^"_cycleDr_"^"_userDr_"^"_patDr_"^"_patName
		d json.InsertRowData(tmp)
	
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2013-8-8
/// Description: 查询符合条件的基本数据记录
/// Table：dhc_pa_data.SurveyScoreTotal
/// Input：period-考核期间;periodType-期间类型;parRef-绩效单元ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uSurveyTotalScore).detailList("201301","M",3,"3||16",1,233)
ClassMethod detailList(period, periodType, locDr, schemDr, userDr, patDr) As %String
{
	n (period, periodType,locDr,schemDr,userDr,patDr)
	
	q:schemDr="" "NoschemDr"
	
	
	s sqlStr="select *  from dhc_pa_data.SurveyScore"
	s whereStr=" where %ID>0"
	i userDr'="" s whereStr=whereStr_" and SurveyScore_ScoreUserDr ='"_userDr_"'"
	s whereStr=whereStr_" and SurveyScore_period ='"_period_"'"
	s whereStr=whereStr_" and SurveyScore_periodType ='"_periodType_"'"
	s whereStr=whereStr_" and SurveyScore_AcceptUnitDr ='"_locDr_"'"
	s whereStr=whereStr_" and SurveyScore_SchemDr ='"_schemDr_"'"
	i patDr'="" s whereStr=whereStr_" and SurveyScore_patDr ='"_patDr_"'"
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^period^periodType^periodTypeName^schemDr^schemName^unitDr^unitName^ScoreDr^ScoreName^score^userDr^patDr^patName^KPIDr^KPIName"
	
	While(result.Next()){
		//集体初始化
		s periodTypeName="",schemName="",unitName="",cycleDr=""
				
		s rowid=result.Data("SurveyScore_Rowid")
		s period=result.Data("SurveyScore_period")
		//期间类型
		s periodType=result.Data("SurveyScore_periodType")
		i periodType="M" s periodTypeName="月份"
		i periodType="Q" s periodTypeName="季度"
		i periodType="H" s periodTypeName="半年"
		i periodType="Y" s periodTypeName="年度"
		
		//指标
		s KPIDr=result.Data("SurveyScore_KpiDr")
		i KPIDr'="" d
		.i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
	    ..s kpiName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
		
		s schemDr=result.Data("SurveyScore_SchemDr")
		i schemDr'="" d
		.i $D(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))) d
		..i $G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)))'="" d
		...s schemName=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",2)
		...s cycleDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1)),"^",2)
		//接受科室
		s unitDr=result.Data("SurveyScore_AcceptUnitDr")
		i unitDr'="" d
		.i $d(^DHCCJXPAJXUNIT(unitDr)) d
		..s unitName=$p($g(^DHCCJXPAJXUNIT(unitDr)),"^",3)
		
		//打分科室
		s ScoreDr=result.Data("SurveyScore_ScoreUnitDr")
		i ScoreDr'="" d
		.i $d(^CTLOC(ScoreDr)) d
		..s ScoreName=$p($g(^CTLOC(ScoreDr)),"^",2)
		
		//调查人
		s userDr=result.Data("SurveyScore_ScoreUserDr")
		i userDr'="" d
		.i $d(^SSU("SSUSR",userDr)) d
		..s userName=$p($g(^SSU("SSUSR",userDr)),"^",2)
		
		//打分人id
		s patDr=result.Data("SurveyScore_patDr")
		
		//打分人Name
		s patName=result.Data("SurveyScore_patName")
		
		//分数
		s score=result.Data("SurveyScore_DirectScore")
		s score=$fn(score,"",2)
		
		s tmp=rowid_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_schemDr_"^"_schemName_"^"_unitDr_"^"_unitName_"^"_userDr_"^"_userName_"^"_score_"^"_userDr_"^"_patDr_"^"_patName_"^"_KPIDr_"^"_kpiName
		d json.InsertRowData(tmp)
	
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSurveyTotal703S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
