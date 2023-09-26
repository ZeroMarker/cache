Class dhc.bonus.report.uBonusDRGSTotal Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:chenwen
/// CreatDate:2015-6-5
/// Description:科室DRGS奖金汇总报表 uBonusDRGSTotal
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetDept")
ClassMethod GetReportExecute(ByRef qHandle As %Binary, yearmonth1 As %String) As %Status
{
	
	n (qHandle,yearmonth1)

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
    s strSql="SELECT a.BonusUnitCode,a.BonusUnitName,sum(OutPNum) OutPNum,b.CMIRate,sum(OutPNum*b.CMIRate) CMISum "
    _",avg(InDays) InDays,b.CostRate ,avg(InDays)-b.CostRate costsum "
    _",(sum(OutPNum*b.CMIRate)+(avg(InDays)-b.CostRate))*80 zje "
    _"FROM dhc_bonus_module.DrgsItemCollect a,dhc_bonus_module.DrgsItem b "
    _"WHERE a.ItemCode=b.DrgsCode  AND a.bonusYear=b.DrgYear "
    _"AND a.BonusYear='"_year_"' AND BonusPeriod ='"_month_"' "
    _"GROUP BY a.BonusUnitCode,a.BonusUnitName "
    k ^cwtemp
    s ^cwtemp=strSql

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	    
	    s BonusUnitCode=result.Data("BonusUnitCode") 	
	    s BonusUnitName=result.Data("BonusUnitName") 
	    s OutPNum=result.Data("OutPNum")
		s CMIRate=result.Data("CMIRate") 
		s CMISum=result.Data("CMISum") 
		s InDays=result.Data("InDays")
		s CostRate=result.Data("CostRate") 
		s costsum=result.Data("costsum") 
		s zje=result.Data("zje")
		 
		
	
	
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(BonusUnitCode,BonusUnitName,OutPNum,CMIRate,CMISum,InDays,CostRate,costsum,zje)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusDRGSTotal","GetReport","2015-06")
Query GetReport(yearmonth As %String) As %Query(ROWSPEC = "BonusUnitCode:%String,BonusUnitName:%String,OutPNum:%Float,CMIRate:%Float,CMISum:%Float,InDays:%Float,CostRate:%Float,costsum:%Float,zje:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusDRGST4ABBS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
