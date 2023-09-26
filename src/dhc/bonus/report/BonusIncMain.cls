Class dhc.bonus.report.BonusIncMain Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:chenwen
/// CreatDate:2015-6-5
/// Description:科室个人收入Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetDept")
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
    s strSql="SELECT yearM, BonusUnitName, BonusUnitID,sum(BonusMakeBillM) BonusMakeBillM, sum(BonusExcuteM) BonusExcuteM, sum(SickpeopleM) SickpeopleM, Code1, BonusUnitCode"
    _" FROM ("
    _" SELECT BonusYear||'年'||right(BonusPeriod,2)||'月' as yearM  ,BonusUnitID->BonusUnitName  as BonusUnitName,BonusUnitID,"
    _" sum(CASE WHEN  DataType='MK'  THEN  ItemValue ELSE 0 end) AS BonusMakeBillM,"
    _" sum(CASE WHEN  DataType='EX'  THEN  ItemValue ELSE 0 end) AS BonusExcuteM,"
    _" sum(CASE WHEN  DataType='SK'  THEN  ItemValue ELSE 0 end) AS SickpeopleM"
    _" ,b.Code1,BonusUnitID->BonusUnitCode"
    _" FROM dhc_bonus_module.BonusIncMain a,dhc_sync_data.sync_loc b"
    _" WHERE a.BonusUnitID->BonusUnitCode=b.Code0 and BonusYear='"_year_"' AND BonusPeriod='"_month_"'  "
     i BonusUnitID'="" s strSql=strSql_" and BonusUnitID='"_BonusUnitID_"' "
      s strSql=strSql_"  GROUP BY BonusYear,BonusPeriod,BonusUnitID "

	s strSql=strSql_" union all "
    _" SELECT BonusYear||'年'||right(BonusPeriod,2)||'月' as yearM  ,BonusUnitID->SuperiorUnitID->BonusUnitName  as BonusUnitName,BonusUnitID->SuperiorUnitID, "
    _" sum(CASE WHEN  DataType='MK'  THEN  ItemValue ELSE 0 end) AS BonusMakeBillM, sum(CASE WHEN  DataType='EX'  THEN ItemValue ELSE 0 end) AS BonusExcuteM,"
    _" sum(CASE WHEN  DataType='SK'  THEN  ItemValue ELSE 0 end) AS SickpeopleM ,b.Code1,BonusUnitID->SuperiorUnitID->BonusUnitCode "
    _" FROM dhc_bonus_module.BonusIncMain a,dhc_sync_data.sync_loc b "
    _" WHERE a.BonusUnitID->SuperiorUnitID->BonusUnitCode=b.Code0 AND BonusUnitID->LastStage=1 AND BonusUnitID->IsValid =1"
    _"  and BonusYear='"_year_"' AND BonusPeriod='"_month_"'  "
    i BonusUnitID'="" s strSql=strSql_" and BonusUnitID->SuperiorUnitID='"_BonusUnitID_"' "
      s strSql=strSql_"  GROUP BY BonusYear,BonusPeriod,BonusUnitID->SuperiorUnitID "
      
    s strSql=strSql_ ") AS jj GROUP BY yearM, BonusUnitName, BonusUnitID, BonusUnitCode"
     
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	k ^now
	s ^now=strSql
		
 While(result.Next()){
	  
	    s yearM=result.Data("yearM")
	    s BonusUnitID=result.Data("BonusUnitID") 
	    s BonuUnitCode=result.Data("BonusUnitCode") 	
	    s BonusUnitName=result.Data("BonusUnitName") 
	    s BonusMakeBillM=result.Data("BonusMakeBillM")
		s BonusExcuteM=result.Data("BonusExcuteM") 
		s Code1=result.Data("Code1") //旧的科室编码
		s SickpeopleM=result.Data("SickpeopleM") 
		
		s total=BonusMakeBillM+BonusExcuteM+SickpeopleM
	
	
	
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(yearM,BonusUnitID,BonusUnitName,BonusMakeBillM,BonusExcuteM,SickpeopleM,total,Code1)
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

/// Creator:zhaoliguo
/// CreatDate:2015-12-05
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.BonusIncMain","GetReport","2015-08","")
Query GetReport(yearmonth As %String, BonusUnitID As %String) As %Query(ROWSPEC = "yearM:%String,BonusUnitID:%String,BonusUnitName:%String,BonusMakeBillM:%Float,BonusExcuteM:%Float,SickpeopleM:%Float,total:%Float,Code1:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="BonusIncMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus.report.BonusIncMainD</DataLocation>
<DefaultData>BonusIncMainDefaultData</DefaultData>
<IdLocation>^dhc.bonus.report.BonusIncMainD</IdLocation>
<IndexLocation>^dhc.bonus.report.BonusIncMainI</IndexLocation>
<StreamLocation>^dhc.bonus.report.BonusIncMainS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
