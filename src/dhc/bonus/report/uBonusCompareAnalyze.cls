Class dhc.bonus.report.uBonusCompareAnalyze Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusCompareAnalyze","GetWorkItem")

Query GetWorkItem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT %ID,WorkItemName FROM dhc_bonus_module.BonusWorkItem
}

//d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusCompareAnalyze","GetBonusCompare","2015-03","","")

Query GetBonusCompare(yearmonth As %String, bonusworkitemid As %String, bonusunitid As %String) As %Query(ROWSPEC = "bonusyear:%String,bonusperiod:%String,workitemname:%String,bonusunitid:%String,bonusunitname:%String,nownum:%Float,nowreward:%Float,lastyearnum:%Float,lastyearreward:%Float,lastmonthnum:%Float,lastmonthreward:%Float,averagenum:%Float,averagereward:%Float") [ SqlProc ]
{
}

ClassMethod GetBonusCompareExecute(ByRef qHandle As %Binary, yearmonth As %String, bonusworkitemid As %String, bonusunitid As %String) As %Status
{
	
	n (qHandle,yearmonth,bonusworkitemid,bonusunitid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	s year=$P(yearmonth,"-",1)
	s month=$P(yearmonth,"-",2)


    s sqlStr="SELECT a.BonusYear,a.BonusPeriod,c.WorkItemName,b.BonusUnitID,b.BonusUnitName,a.ItemNum nownum,a.ItemNum*a.ItemPrice AS nowreward,"
	_" lastyear.ItemNum lastyearnum,lastyear.ItemNum*lastyear.ItemPrice AS lastyearreward,"
	_" lastmonth.ItemNum lastmonthnum,lastmonth.ItemNum*lastmonth.ItemPrice AS lastmonthreward,"
	_" myavrage.itemnum averagenum,myavrage.reward AS averagereward "
	_" FROM dhc_bonus_module.WorkItemResult a "
	_" LEFT JOIN dhc_bonus_module.WorkItemResult lastyear ON a.BonusWorkItemID=lastyear.BonusWorkItemID AND a.BonusYear=lastyear.BonusYear+1 AND a.BonusPeriod=lastyear.BonusPeriod"
	_" LEFT JOIN dhc_bonus_module.WorkItemResult lastmonth ON  a.BonusWorkItemID=lastmonth.BonusWorkItemID AND a.BonusYear=lastmonth.BonusYear AND a.BonusPeriod+0=lastmonth.BonusPeriod+1"
	_" LEFT JOIN "
	_" (SELECT BonusUnitCode,BonusWorkItemID,  avg(itemnum) itemnum,avg(itemNum*Itemprice) reward FROM dhc_bonus_module.WorkItemResult "
	_" WHERE BonusYear=2015 AND BonusPeriod BETWEEN '01' AND '"_month_"' GROUP BY BonusWorkItemID, BonusUnitCode"
	_" ) myavrage "
	_" ON  a.BonusWorkItemID=myavrage.BonusWorkItemID "
	_" JOIN dhc_bonus_data.BonusUnit b ON a.BonusUnitCode=b.BonusUnitCode JOIN dhc_bonus_module.BonusWorkItem c ON a.BonusWorkItemID=c.BonusWorkItemID "
	_" WHERE "
	_" a.BonusYear='"_year_"' AND a.BonusPeriod LIKE '"_month_"'"
	s whereStr=""
	if bonusworkitemid'="" {
	s whereStr=" and a.BonusWorkItemID="_bonusworkitemid	
		}
	if bonusunitid'="" {
	s whereStr=whereStr_" and b.BonusUnitID="_bonusunitid	
		}
		
	s sqlStr=sqlStr_whereStr
	
    
	   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	//w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	s bonusyear= result.Data("BonusYear")
	s bonusperiod= result.Data("BonusPeriod")
	s workitemname= result.Data("WorkItemName")
	s bonusunitid=result.Data("BonusUnitID")
	s bonusunitname= result.Data("BonusUnitName")
	s nownum= result.Data("nownum")
	//s nownum=$fn(nownum,",","2")
	s nowreward= result.Data("nowreward")
	//s nowreward=$fn(nowreward,",","2")
	s lastyearnum= result.Data("lastyearnum")
	//s lastyearnum=$fn(lastyearnum,",","2")
	s lastyearreward= result.Data("lastyearreward")
	//s lastyearreward=$fn(lastyearreward,",","2")
	s lastmonthnum= result.Data("lastmonthnum")
	//s lastmonthnum=$fn(lastmonthnum,",","2")
	s lastmonthreward= result.Data("lastmonthreward")
	//s lastmonthreward=$fn(lastmonthreward,",","2")
	s averagenum= result.Data("averagenum")
	//s averagenum=$fn(averagenum,",","2")
	s averagereward = result.Data("averagereward")
	//s averagereward=$fn(averagereward,",","2")

	 d OutputRow28	  
	}
 
  	q $$$OK
OutputRow28
    s Data=$lb(bonusyear,bonusperiod,workitemname,bonusunitid,bonusunitname,nownum,nowreward,lastyearnum,lastyearreward,lastmonthnum,lastmonthreward,averagenum,averagereward)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetBonusCompareFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusCompareExecute ]
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

ClassMethod GetBonusCompareClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusCompareExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusComparF6CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
