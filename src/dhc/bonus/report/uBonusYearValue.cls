Class dhc.bonus.report.uBonusYearValue Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, BonusDrgs As %String) As %Status
{
	
	n (qHandle,year,BonusDrgs)

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    ;k ^zlgtemp
	;s ^zlgtemp="zlg1="_rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
 	q:year="" $$$OK
    s strSql="SELECT DrgYear, DrgsCode, DrgsName , CMIRate, CostRate  FROM dhc_bonus_module.DrgsItem "
    _"WHERE DrgYear='"_year_"'  "
    i BonusDrgs'="" s strSql=strSql_" and DrgsCode LIKE '%"_BonusDrgs_"%'"_" OR DrgsName LIKE '%"_BonusDrgs_"%' "

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	    s DrgYear=result.Data("DrgYear") 	
	    s DrgsCode=result.Data("DrgsCode")
	    s DrgsName=result.Data("DrgsName") 
	    s CMIRate=result.Data("CMIRate") 
	    s CostRate=result.Data("CostRate")
	    

	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(DrgYear,DrgsCode,DrgsName,CMIRate,CostRate)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusYearValue","GetReport","2015","不伴")
Query GetReport(year As %String, BonusDrgs As %String) As %Query(ROWSPEC = "DrgYear:%String,DrgsCode:%String,DrgsName:%String,CMIRate:%Float,CostRate:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusYearVB219S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
