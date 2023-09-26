/// Creator: wyy
Class dhc.pa.udata.uScoreDirectInput Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.udata.uScoreDirectInput).List(0,25,"201305","","1817","","")
ClassMethod List(start, limit, period, unitDr, userID, kpiType, kpiDr) As %String
{
	n (start, limit, period, unitDr, userID, kpiType,kpiDr)
	;s ^zlgtemp=start_":"_limit_":"_ period_":"_ unitDr_":"_ userID_":"_kpiType_":"_kpiDr
	
	s r=""
	i kpiType=1 d
	.s r= ..List1(start, limit, period, unitDr, userID)
	i kpiType=2 d
	.s r= ..List2(start, limit, period, unitDr, userID)
	i kpiType="" d
	.s r= ..List3(start, limit, period, unitDr, userID,kpiDr)
	q r
}

/// ^zlgtemp="0:25:201305::1679:"
/// w ##class(dhc.pa.udata.uScoreDirectInput).List2(0,25,"201305","","")
ClassMethod List2(start, limit, period, unitDr, userID) As %String
{
	n (start, limit, period, unitDr, userID)
	
	s sqlStr="select *,ScoreDirectInput_UnitDr->JXUnit_name as unitName,ScoreDirectInput_KPIDr->KPIIndex1_name as KPIName from dhc_pa_data.ScoreDirectInput "
	s whereStr=" where %ID >0 "
	s whereStr=whereStr_" and ScoreDirectInput_Month ='"_period_"' "
	i unitDr'="" s whereStr=whereStr_" and ScoreDirectInput_UnitDr ='"_unitDr_"' "
	i userID'="" d
	.s unitDrs=..GetUnitDrToUser(userID)
	.s whereStr=whereStr_" and ScoreDirectInput_KPIDr in ("_unitDrs_") "
	s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^period^unitDr^unitName^KPIDr^KPIName^score^flag"
	
	While(result.Next()){
		
		s rowid=result.Data("ScoreDirectInput_rowid")
		s period=result.Data("ScoreDirectInput_Month")
		s unitDr=result.Data("ScoreDirectInput_UnitDr")
		s unitName=result.Data("unitName")
		s KPIDr=result.Data("ScoreDirectInput_KPIDr")
		s KPIName=result.Data("KPIName")
		s score=$fn(result.Data("ScoreDirectInput_Score"),"",4)
		s flag=result.Data("ScoreDirectInput_Flag")
		
		s tmp=rowid_"^"_period_"^"_unitDr_"^"_unitName_"^"_KPIDr_"^"_KPIName_"^"_score_"^"_flag
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).List1(0,25,"201303","","")
ClassMethod List1(start, limit, period, unitDr, userID) As %String
{
	n (start, limit, period, unitDr, userID)
	
	s sqlStr="select *,JXBaseData_parRef->JXUnit_name as unitName,JXBaseData_KPIDr->KPIIndex1_name as KPIName from dhc_pa_data.JXBaseData "
	s whereStr=" where %ID >0 "
	s whereStr=whereStr_" and JXBaseData_period ='"_period_"' "
	i unitDr'="" s whereStr=whereStr_" and JXBaseData_parRef ='"_unitDr_"' "
	i userID'="" d
	.s unitDrs=..GetUnitDrToUser(userID)
	.s whereStr=whereStr_" and JXBaseData_KPIDr in ("_unitDrs_") "
	s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^period^unitDr^unitName^KPIDr^KPIName^score^flag"
	
	While(result.Next()){
		
		s rowid=result.Data("JXBaseData_rowid")
		s period=result.Data("JXBaseData_period")
		s unitDr=result.Data("JXBaseData_parRef")
		s unitName=result.Data("unitName")
		s KPIDr=result.Data("JXBaseData_KPIDr")
		s KPIName=result.Data("KPIName")
		s score=result.Data("JXBaseData_actualValue")
		
		i ((score'="")&& (score'=0)) d
		.s score=$fn(result.Data("JXBaseData_actualValue"),"",4)
		s flag=result.Data("JXBaseData_dataState")
		i flag=1 d
		.s flag="Y"
		e  d
		.s flag="N"
		
		
		s tmp=rowid_"^"_period_"^"_unitDr_"^"_unitName_"^"_KPIDr_"^"_KPIName_"^"_score_"^"_flag
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).List3(0,25,"201303","","1817","")
ClassMethod List3(start, limit, period, unitDr, userID, kpiDr) As %String
{
	n (start, limit, period, unitDr, userID,kpiDr)
	
	s resultString=""
	s count=0
	s jsonTitle="rowid^period^unitDr^unitName^KPIDr^KPIName^score^flag"
	
	s result=##class(%Library.ResultSet).%New()
	s json=##class(dhc.pa.comm.JsonObj).%New()
	
	s sqlStr="select *,JXBaseData_parRef->JXUnit_name as unitName,JXBaseData_KPIDr->KPIIndex1_name as KPIName from dhc_pa_data.JXBaseData "
	s whereStr=" where %ID >0 "
	s whereStr=whereStr_" and JXBaseData_period ='"_period_"' "
	i kpiDr="" d
	.s unitDrs=..GetUnitDrToUser(userID)
	.s whereStr=whereStr_" and JXBaseData_KPIDr in ("_unitDrs_") "
	e  d
	.s whereStr=whereStr_" and JXBaseData_KPIDr = '"_kpiDr_"' "
	s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	
	While(result.Next()){
		
		s rowid=result.Data("JXBaseData_rowid")
		s period=result.Data("JXBaseData_period")
		s unitDr=result.Data("JXBaseData_parRef")
		s unitName=result.Data("unitName")
		s KPIDr=result.Data("JXBaseData_KPIDr")
		s KPIName=result.Data("KPIName")
		s score=$fn(result.Data("JXBaseData_actualValue"),"",4)
		s flag=result.Data("JXBaseData_dataState")
		i flag=1 d
		.s flag="Y"
		e  d
		.s flag="N"
		
		s tmp=rowid_"^"_period_"^"_unitDr_"^"_unitName_"^"_KPIDr_"^"_KPIName_"^"_score_"^"_flag
		
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	
	s sqlStr="select *,ScoreDirectInput_UnitDr->JXUnit_name as unitName,ScoreDirectInput_KPIDr->KPIIndex1_name as KPIName from dhc_pa_data.ScoreDirectInput "
	s whereStr=" where %ID >0 "
	s whereStr=whereStr_" and ScoreDirectInput_Month ='"_period_"' "
	
	i kpiDr="" d
	.s unitDrs=..GetUnitDrToUser(userID)
	.s whereStr=whereStr_" and ScoreDirectInput_KPIDr in ("_unitDrs_") "
	e  d
	.s whereStr=whereStr_" and ScoreDirectInput_KPIDr  = '"_kpiDr_"' "
	s sortStr=" order by ScoreDirectInput_KPIDr desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		
		s rowid=result.Data("ScoreDirectInput_rowid")
		s period=result.Data("ScoreDirectInput_Month")
		s unitDr=result.Data("ScoreDirectInput_UnitDr")
		s unitName=result.Data("unitName")
		s KPIDr=result.Data("ScoreDirectInput_KPIDr")
		s KPIName=result.Data("KPIName")
		s score=result.Data("ScoreDirectInput_Score")
		s flag=result.Data("ScoreDirectInput_Flag")
		
		s tmp=rowid_"^"_period_"^"_unitDr_"^"_unitName_"^"_KPIDr_"^"_KPIName_"^"_score_"^"_flag
		
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：wyy
/// CreatDate：2010-7-29
/// Description: 获取考核期间
/// Table：dhc_pa_data.JXBaseData
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效考核期间字符串
/// Others：w ##class(dhc.pa.udata.uScoreDirectInput).GetPeriod(0,10,"")
ClassMethod GetPeriod(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DISTINCT ScoreDirectInput_Month from dhc_pa_data.ScoreDirectInput where ScoreDirectInput_rowid>0"
	i str'="" s sqlStr = sqlStr_" and ScoreDirectInput_Month like '%"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s period = result.Data("ScoreDirectInput_Month")
		s tmp=period
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("period",count)
 	k json
	q resultString
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).GetKPIs(1817)
ClassMethod GetKPIs(userDr) As %String
{
	n (userDr)

	//s sqlStr="select UserInUnit_jxUnitDr userDr,userInUnit_jxUnitDr->KPIIndex1_shortcut shortcut from dhc_pa_data.UserInUnit "
	//s whereStr=" where %ID>0 and UserInUnit_userDr = '"_userDr_"' "
	//s sortStr="  order by userInUnit_jxUnitDr->KPIindex1_code "
	//s sqlStr=sqlStr_whereStr_sortStr
	
	s sqlStr="select KPIAudit_KPIDr userDr,KPIAudit_KPIDr->KPIIndex1_shortcut shortcut from dhc_pa_data.KPIAudit "
	_" where %ID>0 and KPIAudit_userDr = '"_userDr_"' "
	_" order by KPIAudit_KPIDr->KPIindex1_code"
	
	//w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0	
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	d json.InsertRowData("^全部指标")
	While(result.Next()){
		s kpiDr = result.Data("userDr")
		s kpiName =result.Data("shortcut")  ;$p(^DHCCJXPAKPIINDEX1(kpiDr),"^",2)
		s tmp=kpiDr_"^"_kpiName
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("kpiDr^kpiName",count)
 	k json
	q resultString
}

/// Creator：wyy
/// CreatDate：2010-8-4
/// Description: 获取绩效单元
/// Table：dhc_pa_data.JXUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串;userCode-用户代码
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uScoreDirectInput).GetJXUnit(0,10,"病")
ClassMethod GetJXUnit(start, limit, str) As %String
{
	n (start, limit, str)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DISTINCT ScoreDirectInput_UnitDr, ScoreDirectInput_UnitDr->JXUnit_name as unitName from dhc_pa_data.ScoreDirectInput where ScoreDirectInput_rowid>0"
	i str'="" s sqlStr = sqlStr_" and ScoreDirectInput_UnitDr->JXUnit_name like '%"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		
		s unitDr = result.Data("ScoreDirectInput_UnitDr")
		s unitName = result.Data("unitName")
		s tmp=unitDr_"^"_unitName
		s count = count+1
		//i (count>start)&(count<=end) d
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("unitDr^unitName",count)
 	k json
	q resultString
}

/*
/// w ##class(dhc.pa.udata.uScoreDirectInput).Aduit("2")
ClassMethod Aduit(period, periodType, userCode) As %String
{
	
	n (period ,periodType,userCode)
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	s SQLCODE=0
	s kpiDr=""
	s auditData=$P($h,",",1)
	i userId'="" d
	.f  s kpiDr=$o(^DHCCJXPAKPIAUDIT(0,"User",userId,kpiDr)) q:kpiDr=""  d
	..&SQL(Update dhc_pa_data.JXBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=1  WHERE JXBaseData_period=:period and JXBaseData_periodType=:periodType)
	q SQLCODE
}
*/
/// w ##class(dhc.pa.udata.uScoreDirectInput).AduitAll("201305",1)
ClassMethod AduitAll(period, userID) As %String
{
	n (period,userID)
	
	s KPIs=..GetUnitDrToUser(userID)
	s tKPI=""
	s index=1
	f  s tKPI=$p(KPIs,",",index) q:tKPI=""  d
	.s index=index+1
	.;w tKPI,!
	.&SQL(UPDATE   dhc_pa_data.JXBaseData  set JXBaseData_dataState='1'  where JXBaseData_period =:period and JXBaseData_KPIDr=:tKPI)
	.&SQL(UPDATE   dhc_pa_data.ScoreDirectInput  set ScoreDirectInput_Flag='Y'  where ScoreDirectInput_Month=:period and ScoreDirectInput_KPIDr=:tKPI)
	q 0
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).Aduit("2")
ClassMethod Aduit(rowid, kpiDr) As %String
{
	n (rowid,kpiDr)
	i ..KpiType(kpiDr)=1 d
	.&SQL(UPDATE   dhc_pa_data.JXBaseData  set JXBaseData_dataState='1'  where JXBaseData_rowid=:rowid)
	e  d
	.&SQL(UPDATE   dhc_pa_data.ScoreDirectInput  set ScoreDirectInput_Flag='Y'  where ScoreDirectInput_rowid=:rowid)
	q SQLCODE
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).Delete(4)
ClassMethod CancelAduit(rowid, kpiDr) As %String
{
	n (rowid,kpiDr)
	i ..KpiType(kpiDr)=1 d
	.&SQL(UPDATE   dhc_pa_data.JXBaseData  set JXBaseData_dataState='-1'  where JXBaseData_rowid=:rowid)
	e  d
	.&SQL(UPDATE   dhc_pa_data.ScoreDirectInput  set ScoreDirectInput_Flag='N'  where ScoreDirectInput_rowid=:rowid)
	q SQLCODE
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).Aduit("2")
ClassMethod Change(rowid, newValue, kpiDr) As %String
{
	n (rowid,newValue,kpiDr)
	i ..KpiType(kpiDr)=1 d
	.&SQL(UPDATE   dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:newValue  where JXBaseData_rowid=:rowid)
	e  d
	.&SQL(UPDATE   dhc_pa_data.ScoreDirectInput  set ScoreDirectInput_Score=:newValue  where ScoreDirectInput_rowid=:rowid)
	q SQLCODE
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).GetUnitDrToUser("1817")
ClassMethod GetUnitDrToUser(userDr) As %String
{
	n (userDr)
	/*
	s sqlStr="select * from dhc_pa_data.UserInUnit "
	s whereStr=" where %ID>0 and UserInUnit_userDr = '"_userDr_"' "
	s sortStr=" order by %ID desc "
	s sqlStr=sqlStr_whereStr_sortStr
	*/
	s sqlStr=" select KPIAudit_userDr,KPIAudit_KPIDr from dhc_pa_data.KPIAudit"
	_" where %ID>0 and KPIAudit_userDr = '"_userDr_"' "

	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s unitDr=-1
	
	While(result.Next()){

		s jxUnitDr=result.Data("KPIAudit_KPIDr")
		i unitDr=-1 d
		.s unitDr=jxUnitDr
		e  d
		.s unitDr=unitDr_","_jxUnitDr
	}
	d result.Close()
	q unitDr
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).InitMonData("201302")
ClassMethod InitMonData(month, datatype) As %String
{
	n (month,datatype)
	;管理质量指标
	i datatype=2 d
	.&SQL(delete from  dhc_pa_data.ScoreDirectInput where ScoreDirectInput_Month=:month)
	.s index=""
	.f  s index=$o(^dhc.pa.data.UnitKPIMapDi80DD(index)) q:index=""  d
	..;w index,","
	..s tmpKPI = $List(^dhc.pa.data.UnitKPIMapDi80DD(index),2)
	..s tmpUnit =  $List(^dhc.pa.data.UnitKPIMapDi80DD(index),3)
	..;w tmpUnit,",",tmpKPI,!
	..&SQL(insert into dhc_pa_data.ScoreDirectInput(ScoreDirectInput_Month,ScoreDirectInput_UnitDr,ScoreDirectInput_KPIDr,ScoreDirectInput_Score,ScoreDirectInput_Flag) VALUES(:month,:tmpUnit,:tmpKPI,0,'N'))
	
	;业务质量指标
	i datatype=1 d
	.&SQL(delete from dhc_pa_data.JXBaseData where JXBaseData_period=:month)
	.s allUnits=$p(^DHCCJXPAJXGROUP(19),"^",3)
	.s allKPIs=$p(^DHCCJXPAJXGROUP(30),"^",3)
	.s aUnit=""
	.s index=1
	.f  s aUnit=$p(allUnits,"-",index) q:aUnit=""  d
	..s index=index+1
	..;w aUnit,","
	..s aKPI=""
	..s index2=1
	..f  s aKPI=$p(allKPIs,"-",index2) q:aKPI=""  d
	...s index2=index2+1
	...;w aUnit,",",aKPI,!
	...&SQL(insert into dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue,JXBaseData_dataState) VALUES(:aUnit,:month,'M',:aKPI,0,-1))
	q $$$OK
}

/// w ##class(dhc.pa.udata.uScoreDirectInput).KpiType("77")
ClassMethod KpiType(kpiDr) As %String
{
	n (kpiDr)
	s zbKPI=$p(^DHCCJXPAJXGROUP(30),"^",3)
	s flag=0
	s index=1
	s tKPI=""
	f  s tKPI=$p(zbKPI,"-",index) q:tKPI=""  d
	.s index=index+1
	.i tKPI=kpiDr d
	..s flag=1
	q flag
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uScoreDirect6DCS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
