Class dhc.bonus.report.uPersonTrendRewardResult Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("dhc.bonus.report.uPersonTrendRewardResult","GetBonusTrend","2014-03","2015-03","D0803","192","2","1157")

Query GetBonusTrend(yearmonth1 As %String, yearmonth2 As %String, deptcode As %String, employeecode As %String, item As %String, user As %String) As %Query(ROWSPEC = "year:%String,dept:%String,name:%String,ItemName:%String,ItemNum:%String,total:%Float") [ SqlProc ]
{
}

ClassMethod GetBonusTrendExecute(ByRef qHandle As %Binary, yearmonth1 As %String, yearmonth2 As %String, deptcode As %String, employeecode As %String, item As %String, user As %String) As %Status
{
	
	n (qHandle,yearmonth1,yearmonth2,deptcode,employeecode,item,user)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	s year=$p(yearmonth1,"-",1)
	s period=$p(yearmonth1,"-",2)
	s yearmonth=year_period
 	q:year="" $$$OK
 	q:period="" $$$OK
    s yearL=$p(yearmonth2,"-",1)
	s periodL=$p(yearmonth2,"-",2)
	s yearmonthL=yearL_periodL
	 s sqlStr ="SELECT  year, dept,name,ItemNum,total,"
    _" (SELECT  WorkItemName FROM dhc_bonus_module.BonusWorkItem g WHERE h.BonusWorkItemID=g.BonusWorkItemID ) ItemName"
    _" FROM  "
    _" (SELECT b.BonusYear||b.BonusPeriod as year,c.BonusUnitID->BonusUnitName AS dept ,b.BonusUnitName AS name,b.BonusWorkItemID,b.BonusYear||b.BonusPeriod AS yearmonth,b.ItemNum,b.ItemPrice ,ItemNum*ItemPrice AS total  FROM "
    _" dhc_bonus_data.BonusEmployee a,"
    _" dhc_bonus_module.WorkItemResult b,"
    _" dhc_bonus_data.BonusEmployeeUnit c"
    _" WHERE a.EmployeeCode=b.BonusUnitCode AND a.BonusUnitID=c.BonusUnitID AND c. BonusEmployeeID-> EmployeeCode='"_user_"'"
    _" AND b.DataType=2 AND b.BonusWorkItemID='"_item_"' AND b.BonusYear='"_year_"' AND b.BonusPeriod='"_period_"' "
    _" and c.BonusUnitID->BonusUnitCode='"_deptcode_"' "
    _" AND b.BonusUnitCode='"_employeecode_"' "
    _" UNION all"
    _" SELECT b.BonusYear||b.BonusPeriod as year,c.BonusUnitID->BonusUnitName,b.BonusUnitName,b.BonusWorkItemID,b.BonusYear||b.BonusPeriod,b.ItemNum,b.ItemPrice ,ItemNum*ItemPrice AS total  FROM "
    _" dhc_bonus_data.BonusEmployee a,"
    _" dhc_bonus_module.WorkItemResult b,"
    _" dhc_bonus_data.BonusEmployeeUnit c"
    _" WHERE a.EmployeeCode=b.BonusUnitCode AND a.BonusUnitID=c.BonusUnitID AND c. BonusEmployeeID-> EmployeeCode='"_user_"' "
    _" AND b.DataType=2 AND b.BonusWorkItemID='"_item_"' AND b.BonusYear='"_yearL_"' AND b.BonusPeriod='"_periodL_"'  and c.BonusUnitID->BonusUnitCode='"_deptcode_"' "
    _" AND b.BonusUnitCode='"_employeecode_"' "
    _" ) h"
      k ^cwtemp
     s ^cwtemp=sqlStr
   
	
	
    
	   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	    s year=result.Data("year")
        s dept=result.Data("dept")
	    s name=result.Data("name") 
	    s ItemName=result.Data("ItemName")
		s num=result.Data("ItemNum") 
		s total=result.Data("total") 
	 d OutputRow28	  
	}
 
  	q $$$OK
OutputRow28
    s Data=$lb(year,dept,name,ItemName,num,total)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetBonusTrendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusTrendExecute ]
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

ClassMethod GetBonusTrendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusTrendExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uPersonTrenD73AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
