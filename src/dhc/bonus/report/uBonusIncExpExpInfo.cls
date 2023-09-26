Class dhc.bonus.report.uBonusIncExpExpInfo Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

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

      s strSql="select BonusYear||right(BonusPeriod,2) AS yearmonth,BonusUnitID->BonusUnitName ,ItemName,sum(ItemValue) as ItemValue"
       _"  FROM dhc_bonus_module.BonusExpMain"
       _" WHERE BonusYear='"_year_"' AND BonusPeriod='"_month_"'  "
     i BonusUnitID'="" s strSql=strSql_" and BonusUnitID='"_BonusUnitID_"' "
     s strSql=strSql_"  group BY BonusYear,BonusPeriod,BonusUnitID ,ItemName,ItemCode"
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
    While(result.Next()){
	
        s yearM=result.Data("yearmonth")	 
	    s BonusUnitName=result.Data("BonusUnitName") 
	    s ItemName=result.Data("ItemName")
	    s ItemValue=result.Data("ItemValue")  
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
 
  	s Data=$lb(yearM,BonusUnitName,ItemName,ItemValue)
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
/// Table: uBonusIncExpIncInfo
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIncExpExpInfo","GetReport","2015-05","")
Query GetReport(yearmonth As %String, BonusUnitID As %String) As %Query(ROWSPEC = "yearM:%String,BonusUnitName:%String,ItemName:%String,ItemValue:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusIncExDD7BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
