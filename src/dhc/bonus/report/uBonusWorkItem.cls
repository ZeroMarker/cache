Class dhc.bonus.report.uBonusWorkItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:chenwen
/// CreatDate:2015-4-30
/// Description:科室个人收入Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetDept")
Query GetDept() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	select BonusUnitCode,BonusUnitName from dhc_bonus_data.BonusUnit where UnitFlag=1 AND LastStage=0 order by cast(BonusUnitCode as int)
}

Query GetEmployee() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	select EmployeeCode, EmployeeName from dhc_bonus_data.BonusEmployee
}

Query GetItem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	SELECT BonusWorkItemID,WorkItemName FROM dhc_bonus_module.BonusWorkItem
}

/// 主报表
/// 我在这里主要是通过报表的年月控件来取得日期的数据
/// 假设数据的格式是"2014-03"这样的格式
ClassMethod GetReportExecute(ByRef qHandle As %Binary, yearmonth1 As %String, yearmonth2 As %String, deptcode As %String, employeecode As %String, item As %String, user As %String) As %Status
{
	
	n (qHandle,yearmonth1,yearmonth2,deptcode,employeecode,item,user)

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    ;k ^zlgtemp
	;s ^zlgtemp="zlg1="_rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
	s year=$p(yearmonth1,"-",1)
	s period=$p(yearmonth1,"-",2)
	s yearmonth=year_period
 	q:year="" $$$OK
 	q:period="" $$$OK
    s yearL=$p(yearmonth2,"-",1)
	s periodL=$p(yearmonth2,"-",2)
	s yearmonthL=yearL_periodL
    s strSql ="SELECT  dept,name,'趋势图' as map ,"
    _" (SELECT  WorkItemName FROM dhc_bonus_module.BonusWorkItem g WHERE h.BonusWorkItemID=g.BonusWorkItemID ) ItemName,"
    _" sum(CASE WHEN yearmonth='"_yearmonth_"' THEN ItemNum ELSE 0 end)AS bennum,"
    _" sum(CASE WHEN yearmonth='"_yearmonth_"' THEN total ELSE 0 end) AS bentotal,"
    _" sum(CASE WHEN yearmonth='"_yearmonthL_"' THEN ItemNum ELSE 0 end) AS lastnum,"
    _" sum (CASE WHEN yearmonth='"_yearmonthL_"' THEN total ELSE 0 end) AS lasttotal "
    _" FROM  "
    _" (SELECT c.BonusUnitID->BonusUnitName AS dept ,b.BonusUnitName AS name,b.BonusWorkItemID,b.BonusYear||b.BonusPeriod AS yearmonth,b.ItemNum,b.ItemPrice ,ItemNum*ItemPrice AS total  FROM "
    _" dhc_bonus_data.BonusEmployee a,"
    _" dhc_bonus_module.WorkItemResult b,"
    _" dhc_bonus_data.BonusEmployeeUnit c"
    _" WHERE a.EmployeeCode=b.BonusUnitCode AND a.BonusUnitID=c.BonusUnitID "
    _" AND b.BonusUnitCode='"_employeecode_"' AND b.DataType=2 "
    i item'="" s strSql=strSql_" AND b.BonusWorkItemID='"_item_"' "
    i year'="" s strSql=strSql_" AND b.BonusYear='"_year_"' "
    i period'="" s strSql=strSql_" AND b.BonusPeriod='"_period_"' "
    i deptcode'="" s strSql=strSql_" and c.BonusUnitID->BonusUnitCode='"_deptcode_"' "
    i user'="" s strSql=strSql_" AND c. BonusEmployeeID-> EmployeeCode='"_user_"' "
    
    s strsql=" UNION all"
    _" SELECT c.BonusUnitID->BonusUnitName,b.BonusUnitName,b.BonusWorkItemID,b.BonusYear||b.BonusPeriod,b.ItemNum,b.ItemPrice ,ItemNum*ItemPrice AS total  FROM "
    _" dhc_bonus_data.BonusEmployee a,"
    _" dhc_bonus_module.WorkItemResult b,"
    _" dhc_bonus_data.BonusEmployeeUnit c"
    _" WHERE a.EmployeeCode=b.BonusUnitCode AND a.BonusUnitID=c.BonusUnitID AND c. BonusEmployeeID-> EmployeeCode='"_user_"' "
    _" AND b.DataType=2 AND b.BonusWorkItemID='"_item_"' AND b.BonusYear='"_yearL_"' AND b.BonusPeriod='"_periodL_"'  and c.BonusUnitID->BonusUnitCode='"_deptcode_"' "
    _" AND b.BonusUnitCode='"_employeecode_"' "
    i item'="" s strsql=strsql_" AND b.BonusWorkItemID='"_item_"' "
    i yearL'="" s strsql=strsql_" AND b.BonusYear='"_yearL_"' "
    i periodL'="" s strsql=strsql_" AND b.BonusPeriod='"_periodL_"' "
    i deptcode'="" s strsql=strsql_" and c.BonusUnitID->BonusUnitCode='"_deptcode_"' "
    i user'="" s strsql=strsql_" AND c. BonusEmployeeID-> EmployeeCode='"_user_"' "
   s wherestr= " ) h"
    _" GROUP BY  dept,name,BonusWorkItemID"
  s strSql=strSql_strsql_wherestr
     k ^cwtemp
     s ^cwtemp=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	    s dept=result.Data("dept")
	    s name=result.Data("name") 
	    s ItemName=result.Data("ItemName")
		s bennum=result.Data("bennum") 
		s bentotal=result.Data("bentotal") 
		s lastnum=result.Data("lastnum") 
		s lasttotal=result.Data("lasttotal") 
		s map=result.Data("map")
	
	
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(dept,name,ItemName,bennum,bentotal,lastnum,lasttotal,map)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItem","GetReport","2014-03","2015-03","D0803","192","2","1157") 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItem","GetReport","2014-03","2015-03","D0803","demo","1","demo")
Query GetReport(yearmonth1 As %String, yearmonth2 As %String, deptcode As %String, employeecode As %String, item As %String, user As %String) As %Query(ROWSPEC = "dept:%String,name:%String,ItemName:%String,bennum:%String,bentotal:%String,lastnum:%String,lasttotal:%String,map:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r7006.uBonusWorkItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
