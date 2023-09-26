Class dhc.bonus.report.uBonusWorkItemResult Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:chenwen
/// CreatDate:2013-12-05
/// Description:科室工作量汇总
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetDept")
Query GetDept() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	select BonusUnitCode,BonusUnitName from dhc_bonus_data.BonusUnit where UnitFlag=1 AND LastStage=0 order by cast(BonusUnitCode as int)
}

/// 主报表
/// 我在这里主要是通过报表的年月控件来取得日期的数据
/// 假设数据的格式是"2014-03"这样的格式
ClassMethod GetReportExecute(ByRef qHandle As %Binary, yearmonth As %String, deptcode As %String, itemtid As %String, usercode As %String) As %Status
{
	
	n (qHandle,yearmonth,deptcode,itemtid,usercode)
	k ^zmb
	s ^zmb=yearmonth_"^"_deptcode_"^"_itemtid_"^"_usercode
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    ;k ^zlgtemp
	;s ^zlgtemp="zlg1="_rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
	s year=$p(yearmonth,"-",1)
	s period=$p(yearmonth,"-",2)
 	q:year="" $$$OK
 	q:period="" $$$OK
 	s year1 = year-1
  
	s strSql ="SELECT '柱图' as map,name,ItemID,"
	  _" (SELECT  WorkItemName FROM dhc_bonus_module.BonusWorkItem g WHERE h.ItemID=g.BonusWorkItemID ) ItemName,"
      _" sum(CASE WHEN type='本期' THEN Num   ELSE 0 END ) AS numbenqi,"
      _" sum(CASE WHEN type='同期' THEN Num   ELSE 0 END ) AS numtongqi,"
      _" sum(CASE WHEN type='去年上期' THEN Num   ELSE 0 END) AS numqunianshangqi,"
      _" sum (CASE WHEN type='平均期' THEN Num   ELSE 0 END) AS numavgqi,"
      _" sum(CASE WHEN type='本期' THEN sumtotal   ELSE 0 END ) AS benqi,"
      _" sum(CASE WHEN type='同期' THEN sumtotal   ELSE 0 END ) AS tongqi,"
      _" sum(CASE WHEN type='去年上期' THEN sumtotal   ELSE 0 END) AS qunianshangqi,"
      _" sum (CASE WHEN type='平均期' THEN sumtotal   ELSE 0 END) AS avgqi"
      _" FROM"
      _" ("
      _" SELECT '本期' type, b.BonusUnitName name,b.BonusUnitCode code,a.BonusWorkItemID ItemID,a.ItemNum Num,a.ItemNum*a.ItemPrice sumtotal,BonusYear,BonusPeriod"
      _" FROM dhc_bonus_module.WorkItemResult  a,dhc_bonus_data.BonusUnit  b,dhc_bonus_data.BonusEmployeeUnit c"
      _" Where  b.BonusUnitID=c. BonusUnitID  AND  dataTypeID=1 "
      i deptcode'="" s strSql=strSql_" AND a.BonusUnitID='"_deptcode_"'"
      i usercode'="" s strSql=strSql_" AND c.BonusEmployeeID-> EmployeeCode='"_usercode_"'"
      i year'="" s strSql=strSql_" AND a.BonusYear='"_year_"'"
      i period'="" s strSql=strSql_"  AND a.BonusPeriod='M"_period_"'"
      ;i itemtid'="" s strSql=strSql_" AND g.BonusWorkItemID="_itemtid
    
      s whereSql=" UNION ALL"
      _" SELECT '同期' type, b.BonusUnitName,b.BonusUnitCode,a.BonusWorkItemID,a.ItemNum,a.ItemNum*a.ItemPrice sumtotal,BonusYear,BonusPeriod "
      _" FROM dhc_bonus_module.WorkItemResult  a,dhc_bonus_data.BonusUnit  b,dhc_bonus_data.BonusEmployeeUnit c"
      _" Where  b.BonusUnitID=c. BonusUnitID  AND  dataTypeID=1 "
      i deptcode'="" s whereSql=whereSql_" AND a.BonusUnitID='"_deptcode_"'"
      i usercode'="" s whereSql=whereSql_" AND c.BonusEmployeeID-> EmployeeCode='"_usercode_"'"
      i year1'="" s whereSql=whereSql_" AND a.BonusYear='"_year1_"'"
      i period'="" s whereSql=whereSql_"  AND a.BonusPeriod='M"_period_"'"
      ;i itemtid'="" s strSql=strSql_" AND g.BonusWorkItemID="_itemtid
     
      s BonusSql=" UNION ALL"
      _" SELECT '去年上期' type, b.BonusUnitName,b.BonusUnitCode,a.BonusWorkItemID,a.ItemNum,a.ItemNum*a.ItemPrice sumtotal,BonusYear,BonusPeriod"
      _" FROM dhc_bonus_module.WorkItemResult  a,dhc_bonus_data.BonusUnit  b,dhc_bonus_data.BonusEmployeeUnit c"
      _" Where  b.BonusUnitID=c. BonusUnitID  AND  dataTypeID=1 "
      i deptcode'="" s BonusSql=BonusSql_" AND a.BonusUnitID='"_deptcode_"'"
      i usercode'="" s BonusSql=BonusSql_" AND c.BonusEmployeeID-> EmployeeCode='"_usercode_"'"
      i year1'="" s BonusSql=BonusSql_" AND a.BonusYear='"_year1_"'"
      i period'="" s BonusSql=BonusSql_"  AND a.BonusPeriod='M"_period_"'"
      ;i itemtid'="" s strSql=strSql_" AND g.BonusWorkItemID="_itemtid
      s workStr=" UNION ALL "
      _" SELECT '平均期' type, b.BonusUnitName,b.BonusUnitCode,a.BonusWorkItemID,a.ItemNum,avg(a.ItemNum*a.ItemPrice) sumtotal,BonusYear,BonusPeriod"
      _" FROM dhc_bonus_module.WorkItemResult  a,dhc_bonus_data.BonusUnit  b,dhc_bonus_data.BonusEmployeeUnit c"
      _" Where  b.BonusUnitID=c. BonusUnitID  AND  dataTypeID=1 "
      i deptcode'="" s workStr=workStr_" AND a.BonusUnitID='"_deptcode_"'"
      i usercode'="" s workStr=workStr_" AND c.BonusEmployeeID-> EmployeeCode='"_usercode_"'"
      i year1'="" s workStr=workStr_" AND a.BonusYear='"_year1_"'"
      i period'="" s workStr=workStr_"  AND a.BonusPeriod<'M"_period_"'"
      ;i itemtid'="" s strSql=strSql_" AND g.BonusWorkItemID="_itemtid
      s OverSql=" ) h "
      _" GROUP BY ItemID,name"
	
   s strSql=strSql_whereSql_BonusSql_workStr_OverSql
	
	k ^zlgtemp
	s ^zlgtemp=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	
		
 While(result.Next()){
	    s ItemID=result.Data("ItemID")
	    s deptname=result.Data("name")
	    s ItemName=result.Data("ItemName") 
	    s map=result.Data("map")
		s numbenqi=result.Data("numbenqi") 
		s numtongqi=result.Data("numtongqi") 
		s numqunianshangqi=result.Data("numqunianshangqi") 
		s numavgqi=result.Data("numavgqi") 
		s benqi=result.Data("benqi") 
		s tongqi=result.Data("tongqi") 
		s qunianshangqi=result.Data("qunianshangqi") 
		s avgqi=result.Data("avgqi") 
	 
		
		i tongqi '= "0" d 
		.s percent1 = (benqi-tongqi)/tongqi-1
		e  d
		.s percent1 = ""
		
		i qunianshangqi '= "0" d 
		.s percent2 = (qunianshangqi-tongqi)/tongqi-1
		e  d
		.s percent2 = ""
		
		i avgqi '= "0" d 
		.s percent3 = (avgqi-tongqi)/tongqi-1
		e  d
		.s percent3 = ""
		
		
     
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(ItemID,deptname,ItemName,map,numbenqi,numtongqi,numqunianshangqi,numavgqi,benqi,tongqi,qunianshangqi,avgqi,percent1,percent2,percent3)
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

/// Creator:侯勃
/// CreatDate:2013-12-05
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetReport","2015-08","572","28","") 
Query GetReport(yearmonth As %String, deptcode As %String, itemtid As %String, usercode As %String) As %Query(ROWSPEC = "ItemID:%String,deptname:%String,ItemName:%String,map:%String,numbenqi:%String,numtongqi:%String,numqunianshangqi:%String,numavgqi:%String,benqi:%String,tongqi:%String,qunianshangqi:%String,avgqi:%String,percent1:%String,percent2:%String,percent3:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusWorkIB167S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
