Class dhc.bonus.report.uDeptThrendRwardResult Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptThrendRwardResult","GetBonusTrend","2014-03","11","1157","1") 
Query GetBonusTrend(yearmonth As %String, deptcode As %String, usercode As %String, ItemID As %String) As %Query(ROWSPEC = "type:%String,name:%String,ItemID:%String,ItemName:%String,Num:%String,sumtotal:%Float") [ SqlProc ]
{
}

//name,ItemID,ItemName,Num,sumtotal

ClassMethod GetBonusTrendExecute(ByRef qHandle As %Binary, yearmonth As %String, deptcode As %String, usercode As %String, ItemID As %String) As %Status
{
	
	n (qHandle,yearmonth,deptcode,usercode,ItemID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
    s year=$p(yearmonth,"-",1)
	s period=$p(yearmonth,"-",2)
 	q:year="" $$$OK
 	q:period="" $$$OK
 	s year1 = year-1
	 s sqlStr ="SELECT Type,name,ItemID,Num,sumtotal,"
	  _" (SELECT  WorkItemName FROM dhc_bonus_module.BonusWorkItem g WHERE h.ItemID=g.BonusWorkItemID ) ItemName"
      _" FROM"
      _" ("
      _" SELECT '本期' Type, b.BonusUnitName name,b.BonusUnitCode code,a.BonusWorkItemID ItemID,a.ItemNum Num,a.ItemNum*a.ItemPrice sumtotal,BonusYear,BonusPeriod"
      _" FROM dhc_bonus_module.WorkItemResult  a,dhc_bonus_data.BonusUnit  b,dhc_bonus_data.BonusEmployeeUnit c"
      _" Where  b.BonusUnitCode=c. BonusUnitID  AND  datatype=1 "
      _" AND a.BonusUnitCode='"_deptcode_"'"
      _" AND c.BonusEmployeeID-> EmployeeCode='"_usercode_"' AND a.BonusYear='"_year_"' AND a.BonusPeriod='"_period_"'  "
      _" UNION ALL     "
      _" SELECT '同期' Type, b.BonusUnitName,b.BonusUnitCode,a.BonusWorkItemID,a.ItemNum,a.ItemNum*a.ItemPrice sumtotal,BonusYear,BonusPeriod "
      _" FROM dhc_bonus_module.WorkItemResult  a,dhc_bonus_data.BonusUnit  b,dhc_bonus_data.BonusEmployeeUnit c"
      _" Where  b.BonusUnitCode=c. BonusUnitID  AND  datatype=1 "
      _" AND a.BonusUnitCode='"_deptcode_"'"
      _" AND c.BonusEmployeeID-> EmployeeCode='"_usercode_"' AND a.BonusYear='"_year1_"' AND a.BonusPeriod='"_period_"'  "
      _" UNION ALL"
      _" SELECT '去年上期' Type, b.BonusUnitName,b.BonusUnitCode,a.BonusWorkItemID,a.ItemNum,a.ItemNum*a.ItemPrice sumtotal,BonusYear,BonusPeriod"
      _" FROM dhc_bonus_module.WorkItemResult  a,dhc_bonus_data.BonusUnit  b,dhc_bonus_data.BonusEmployeeUnit c"
      _" Where  b.BonusUnitCode=c. BonusUnitID  AND  datatype=1 "
      _" AND a.BonusUnitCode='"_deptcode_"'"
      _" AND c.BonusEmployeeID-> EmployeeCode='"_usercode_"' AND a.BonusYear='"_year1_"' AND a.BonusPeriod='"_period_"'  "
      _" UNION ALL "
      _" SELECT '平均期' Type,  b.BonusUnitName,b.BonusUnitCode,a.BonusWorkItemID,a.ItemNum,avg(a.ItemNum*a.ItemPrice) sumtotal,BonusYear,BonusPeriod"
      _" FROM dhc_bonus_module.WorkItemResult  a,dhc_bonus_data.BonusUnit  b,dhc_bonus_data.BonusEmployeeUnit c"
      _" Where  b.BonusUnitCode=c. BonusUnitID  AND  datatype=1 "
      _" AND a.BonusUnitCode='"_deptcode_"' "
      _" AND c.BonusEmployeeID-> EmployeeCode='"_usercode_"' AND a.BonusYear='"_year1_"' AND a.BonusPeriod<'"_period_"'   "

      _" ) h "
      _" where  ItemID='"_ItemID_"'"
  
      k ^cwtemp
     s ^cwtemp=sqlStr
   
	
	
    
	   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	    s type=result.Data("Type")
        s dept=result.Data("name")
	    s ItemID=result.Data("ItemID") 
	    s ItemName=result.Data("ItemName")
	    s Num=result.Data("Num")
		s sumtotal=result.Data("sumtotal") 
	
	 d OutputRow28	  
	}
 
  	q $$$OK
OutputRow28
    s Data=$lb(type,dept,ItemID,ItemName,Num,sumtotal)
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
<StreamLocation>^dhc.bonus7006.uDeptThrendBD55S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
