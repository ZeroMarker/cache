Class dhc.bonus.report.uBonusIncExpResult Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query GetItem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	SELECT BonusUnitID,BonusUnitName FROM dhc_bonus_data.BonusUnit WHERE LastStage=0 AND UnitFlag=1
}

/// 主报表
/// 我在这里主要是通过报表的年月控件来取得日期的数据
/// 假设数据的格式是"2014-03"这样的格式
ClassMethod GetReportExecute(ByRef qHandle As %Binary, yearmonth1 As %String, BonusUnitID As %String) As %Status
{
	
	n (qHandle,yearmonth1,BonusUnitID)

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

      s strSql="SELECT BonusYear||RIGHT(Bonusperiod,2) AS yearmonth,BonusUnitID->BonusUnitName,sum(IncValue) IncValue,sum(ExpValue) ExpValue,BonusUnitID"
      _" FROM dhc_bonus_module.BonusIncExpResult"
      _" WHERE BonusYear='"_year_"' AND Bonusperiod='"_month_"'"
     i BonusUnitID'="" s strSql=strSql_" and BonusUnitID='"_BonusUnitID_"' "
     s strSql=strSql_"  group BY BonusYear,BonusPeriod,BonusUnitID "
     k ^cwtemp
     s ^cwtemp=strSql
    
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
    While(result.Next()){
	
        s yearM=result.Data("yearmonth")	 
	    s BonusUnitID=result.Data("BonusUnitID") 
	    s BonusUnitName=result.Data("BonusUnitName") 
	    s IncValue=result.Data("IncValue")
	    s ExpValue=result.Data("ExpValue")  
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
 
  	s Data=$lb(yearM,BonusUnitID,BonusUnitName,IncValue,ExpValue)
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

//Query GetReport(yearmonth As %String, BonusUnitID As %String) As %Query(ROWSPEC = "yearM:%String,BonusUnitID:%String,BonusUnitName:%String,PopCost:%Float,CutOff:%Float,HealthCost:%Float,total:%Float") [ SqlProc ]

/// Creator:侯勃
/// CreatDate:2013-12-05
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIncExpResult","GetReport","2015-05",11)
Query GetReport(yearmonth As %String, BonusUnitID As %String) As %Query(ROWSPEC = "yearM:%String,BonusUnitID:%String,BonusUnitName:%String,IncValue:%Float,ExpValue:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusIncEx7AEDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
