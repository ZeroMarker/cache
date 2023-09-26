/// Creator: wang ying
/// CreatDate: 2013-8-12
/// Description: 问卷调查
Class dhc.pa.report.uSurveyScoreReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2013-8-12
/// Description:问卷调查总分
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uSurveyScoreReport","getSurveyTotalScore","201301","M","3||16",3)
Query getSurveyTotalScore(period As %String, periodType As %String, schemDr As %String, JXUnitDr As %String) As %Query(ROWSPEC = "schemDr:%String,schemName:%String,unitDr:%String,unitCode:%String,patDr:%String,sorce:%Float,periodName:%String") [ SqlProc ]
{
}

ClassMethod getSurveyTotalScoreExecute(ByRef qHandle As %Binary, period As %String, periodType As %String, schemDr As %String, JXUnitDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:schemDr="" $$$OK
  	q:periodType="" $$$OK
  	q:period="" $$$OK
  	q:JXUnitDr="" $$$OK
	
	i periodType="M" s Freq="月"
	i periodType="Q" s Freq="季"
	i periodType="H" s Freq="半年"
	i periodType="Y" s Freq="年"
			
	s sqlStr="select SurveyScoreTotal_Rowid,SurveyScoreTotal_AcceptUnitDr,SurveyScoreTotal_unitType,SurveyScoreTotal_ScoreDr,SurveyScoreTotal_TotalScore,SurveyScoreTotal_Active,SurveyScoreTotal_period,SurveyScoreTotal_periodType,SurveyScoreTotal_SchemDr,SurveyScoreTotal_userDr,SurveyScoreTotal_patDr,SurveyScoreTotal_patName from dhc_pa_data.SurveyScoreTotal"
	s whereStr=" where %ID>0"
	s whereStr=whereStr_" and SurveyScoreTotal_period ='"_period_"'"
	s whereStr=whereStr_" and SurveyScoreTotal_periodType ='"_periodType_"'"
	s whereStr=whereStr_" and SurveyScoreTotal_AcceptUnitDr ='"_JXUnitDr_"'"
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
		d OutputRow
	}
	d result.Close()
	Quit $$$OK
	
OutputRow
 	s Data=$lb(schemDr,schemName,userDr,userName,patDr,score,patName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getSurveyTotalScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getSurveyTotalScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getSurveyTotalScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getSurveyTotalScoreExecute ]
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

/// Creator:wang ying
/// CreatDate:2013-8-12
/// Description:问卷调查总分
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uSurveyScoreReport","getSurveyScore","201301","M","3||16",3,1,233)
Query getSurveyScore(period As %String, periodType As %String, schemDr As %String, JXUnitDr As %String, userDr As %String, patDr As %String) As %Query(ROWSPEC = "schemDr:%String,KPIDr:%String,KPICode:%String,KPIName:%String,score:%Float") [ SqlProc ]
{
}

ClassMethod getSurveyScoreExecute(ByRef qHandle As %Binary, period As %String, periodType As %String, schemDr As %String, JXUnitDr As %String, userDr As %String, patDr As %String) As %Status
{
	
	
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:period="" $$$OK
	q:periodType="" $$$OK
	q:JXUnitDr="" $$$OK
	q:schemDr="" $$$OK
	q:userDr="" $$$OK
	q:patDr="" $$$OK
	
	s sqlStr="select *  from dhc_pa_data.SurveyScore"
	s whereStr=" where %ID>0"
	s whereStr=whereStr_" and SurveyScore_ScoreUserDr ='"_userDr_"'"
	s whereStr=whereStr_" and SurveyScore_period ='"_period_"'"
	s whereStr=whereStr_" and SurveyScore_periodType ='"_periodType_"'"
	s whereStr=whereStr_" and SurveyScore_AcceptUnitDr ='"_JXUnitDr_"'"
	s whereStr=whereStr_" and SurveyScore_SchemDr ='"_schemDr_"'"
	s whereStr=whereStr_" and SurveyScore_patDr ='"_patDr_"'"
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	
	While(result.Next()){
		//集体初始化
		s periodTypeName="",schemName="",unitName="",cycleDr="",kpiCode="",kpiName=""
				
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
		..s kpiCode=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",1)
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
		d OutputRowDeail
	}
	d result.Close()
	Quit $$$OK
	
OutputRowDeail
 	s Data=$lb(schemDr,KPIDr,kpiCode,kpiName,score)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getSurveyScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getSurveyScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getSurveyScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getSurveyScoreExecute ]
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
<StreamLocation>^dhc.pa.report.uSurveyScore77BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
