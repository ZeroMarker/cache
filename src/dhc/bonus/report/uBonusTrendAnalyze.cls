Class dhc.bonus.report.uBonusTrendAnalyze Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("herp.srm.report.GetDeptUser","GetLoc")

Query GetWorkItem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    SELECT %ID,WorkItemName FROM dhc_bonus_module.BonusWorkItem
}

//d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusTrendAnalyze","GetBonusTrend","2014-03","2015-02","","")

Query GetBonusTrend(startdate As %String, enddate As %String, bonusworkitemid As %String, bonusunitid As %String) As %Query(ROWSPEC = "workitemname:%String,bonusunitid:%String,bonusunitname:%String,itemnum:%Float,reward:%Float,yearmonth:%String") [ SqlProc ]
{
}

ClassMethod GetBonusTrendExecute(ByRef qHandle As %Binary, startdate As %String, enddate As %String, bonusworkitemid As %String, bonusunitid As %String) As %Status
{
	
	n (qHandle,startdate,enddate,bonusworkitemid,bonusunitid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	s startyear=$p(startdate,"-",1)
	s startmonth=$p(startdate,"-",2)
	s endyear=$p(enddate,"-",1)
	s endmonth=$p(enddate,"-",2)
	
	s mystart=startyear_startmonth
	s myend=endyear_endmonth

    s sqlStr="SELECT WorkItemName, BonusUnitID, BonusUnitName, ItemNum, reward, yearmonth FROM ( SELECT c.WorkItemName,b.BonusUnitID,b.BonusUnitName,a.ItemNum,a.ItemNum*a.ItemPrice AS reward,a.BonusYear||a.BonusPeriod AS yearmonth FROM dhc_bonus_module.WorkItemResult a,dhc_bonus_data.BonusUnit b,dhc_bonus_module.BonusWorkItem c" 
	_" WHERE a.BonusUnitCode=b.BonusUnitCode AND a.BonusWorkItemID=c.BonusWorkItemID "
	s whereStr=""
	if bonusworkitemid'="" {
	s whereStr=whereStr_" and a.BonusWorkItemID="_bonusworkitemid	
		}
	if bonusunitid'="" {
	s whereStr=whereStr_" and b.BonusUnitID="_bonusunitid	
		}
	s sqlStr=sqlStr_whereStr_")"
	s outWhere=""
	if mystart'="" {
	
		s outWhere=outWhere_" where yearmonth >= "_mystart
	
	}
	if myend'="" {
	
		s outWhere=outWhere_" and yearmonth <= "_myend
	
	}
	
	s sqlStr=sqlStr_outWhere
	
    
	   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	w sqlStr,!
	d result.Execute()	
    While(result.Next()){
        s workitemname = result.Data("WorkItemName")
        s bonusunitid=result.Data("BonusUnitID")
		s bonusunitname=result.Data("BonusUnitName")
		s itemnum=result.Data("ItemNum")
		//s itemnum=$fn(itemnum,",","2")
		s reward=result.Data("reward")
		//s reward=$fn(reward,",","2")
		s yearmonth=result.Data("yearmonth")

	 d OutputRow28	  
	}
 
  	q $$$OK
OutputRow28
    s Data=$lb(workitemname,bonusunitid,bonusunitname,itemnum,reward,yearmonth)
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
<StreamLocation>^dhc.bonus7006.uBonusTrendF57CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
