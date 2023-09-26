Class dhc.bonus.report.uBonusIncDetailTargetMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query GetItem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	SELECT BonusUnitID,BonusUnitName FROM dhc_bonus_data.BonusUnit WHERE LastStage=0 AND UnitFlag=1
}

Query GetTarget() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	SELECT BonusTargetID,BonusTargetName FROM dhc_bonus_data.BonusTarget
}

/// Creator:chenwen
/// CreatDate:2015-6-5
/// Description:科室个人收入Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetDept")
/// 主报表
/// 我在这里主要是通过报表的年月控件来取得日期的数据
/// 假设数据的格式是"2014-03"这样的格式
ClassMethod GetReportExecute(ByRef qHandle As %Binary, yearmonth1 As %String, BonusUnitID As %String, BonusTargetID As %String) As %Status
{
	
	n (qHandle,yearmonth1,BonusUnitID,BonusTargetID)

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    ;k ^zlgtemp
	;s ^zlgtemp="zlg1="_rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
	s year=$p(yearmonth1,"-",1)
	s month=$p(yearmonth1,"-",2)
	s month="M"_month
 	q:year="" $$$OK
 	q:month="" $$$OK
    s strSql="SELECT yearmonth,ItemName,BonusTargetName,BonusUnitName,sum(ItemRateValue) as ItemRateValue"
        _" FROM ("
        _" SELECT BonusYear||'年'||RIGHT(BonusPeriod,2)||'月' AS yearmonth ,BonusUnitID->BonusUnitName, ItemName,BonusTargetName,"
        _" CASE DataType WHEN 1 THEN b.MakeBillRate*ItemRate*ItemValue"
        _" WHEN 2  THEN b.ExecuteRate*ItemRate*ItemValue"
        _" WHEN 3 THEN b.SickRate*ItemRate*ItemValue END AS ItemRateValue"
        _" FROM dhc_bonus_module.BonusIncDetail a,dhc_bonus_module.BonusIncItemMap b,dhc_bonus_data.BonusTarget c"
        _" WHERE a.ItemCode=b.BonusIncItemMapID AND b.BonusTargetID=c.BonusTargetID"
        _" AND BonusPeriod='"_month_"' AND BonusYear='"_year_"'"
        i BonusUnitID'="" s strSql=strSql_" AND a.BonusUnitID='"_BonusUnitID_"'"
        i BonusTargetID'="" s strSql=strSql_" and c.BonusTargetID='"_BonusTargetID_"'"
     s strSql=strSql_" )"
      s strSql=strSql_" GROUP BY yearmonth,ItemName,BonusTargetName,BonusUnitName"
  
  

     k ^cwtemp
     s ^cwtemp=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	    s yearM=result.Data("yearmonth")
	    s ItemName=result.Data("ItemName") 	
	    s BonusTargetName=result.Data("BonusTargetName") 
	    s BonusUnitName=result.Data("BonusUnitName")
		s RealMoney=result.Data("ItemRateValue") 
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(yearM,ItemName,BonusTargetName,BonusUnitName,RealMoney)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIncDetailTargetMap","GetReport","2015-05","11",13)
Query GetReport(yearmonth1 As %String, BonusUnitID As %String, BonusTargetID As %String) As %Query(ROWSPEC = "yearM:%String,ItemName:%String,BonusTargetName:%String,BonusUnitName:%String,RealMoney:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusIncDeDB82S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
