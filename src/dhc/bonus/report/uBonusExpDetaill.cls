Class dhc.bonus.report.uBonusExpDetaill Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

// Creator:chenwen

/// CreatDate:2015-6-5
/// Description:科室个人收入Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetDept")
/// 主报表
/// 我在这里主要是通过报表的年月控件来取得日期的数据
/// 假设数据的格式是"2014-03"这样的格式
ClassMethod GetReportExecute(ByRef qHandle As %Binary, yearmonth1 As %String, BonusUnitID As %String, BonusItem As %String) As %Status
{
	
	n (qHandle,yearmonth1,BonusUnitID,BonusItem)

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	s year=$p(yearmonth1,"-",1)
	s month=$p(yearmonth1,"-",2)
	s month="M"_month
 	q:year="" $$$OK
 	q:month="" $$$OK
    s strSql="SELECT BonusYear||right(BonusPeriod,2) AS yearmonth,a.BonusUnitID->BonusUnitName AS BonusUnit,b.ItemName ItemName,"
    _" a.ItemValue ItemValue  ,a.ItemRate,a.ItemRate *a.ItemValue AS total"
    _" FROM  dhc_bonus_module.BonusExpDetail a,dhc_bonus_module.BonusExpendItem b  "
    _" WHERE BonusYear='"_year_"' AND BonusPeriod='"_month_"'"
    _" AND a.ItemCode=b.ItemCode AND  b.SuperItemID->ItemCode ='"_BonusItem_"' AND a.BonusUnitID='"_BonusUnitID_"'"
    _" GROUP BY BonusYear||right(BonusPeriod,2) , a.BonusUnitID->BonusUnitName,b.ItemName"
  
    k ^cwtemp
    s ^cwtemp=strSql

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	    s yearM=result.Data("yearmonth")
	    s BonusUnit=result.Data("BonusUnit") 
	    s ItemName=result.Data("ItemName") 	
	    s ItemValue=result.Data("ItemValue") 
	    s ItemRate=result.Data("ItemRate")
		s total=result.Data("total") 
	
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(yearM,BonusUnit,ItemName,ItemValue,ItemRate,total)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusExpDetaill","GetReport","2015-05","11",12)
Query GetReport(yearmonth1 As %String, BonusUnitID As %String, BonusItem As %String) As %Query(ROWSPEC = " yearM:%String,BonusUnit:%String,ItemName:%String,ItemValue:%Float,ItemRate:%Float,total:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusExpDeE47CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
