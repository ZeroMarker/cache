Class dhc.bonus.report.uBonusExpDetailTargetMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query GetItem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	SELECT BonusUnitID,BonusUnitName FROM dhc_bonus_data.BonusUnit WHERE LastStage=0 AND UnitFlag=1
}

Query GetTarget() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	
	SELECT BonusTargetID,BonusTargetName FROM dhc_bonus_data.BonusTarget
}

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

      s strSql="SELECT BonusYear||'年'||RIGHT(BonusPeriod,2)||'月' as yearM,a.BonusUnitID->BonusUnitName,BonusTargetName,ItemName,"
      _" sum(a.ItemValue*a.ItemRate*b.ItemRate) as RealMoney"
      _" FROM "
      _" dhc_bonus_module.BonusExpDetail a,dhc_bonus_module.BonusExpItemMap b,dhc_bonus_data.BonusTarget c"
      _" WHERE b.BonusTargetID=c.BonusTargetID AND b.BonusExpendItemID->ItemCode=a.ItemCode"
      _" AND BonusYear='"_year_"' AND BonusPeriod='"_month_"'"
     i BonusUnitID'="" s strSql=strSql_" and BonusUnitID='"_BonusUnitID_"' "
     i BonusTargetID'="" s strSql=strSql_" and b.BonusTargetID='"_BonusTargetID_"' "
     s strSql=strSql_"  group by  BonusYear ,BonusPeriod ,BonusUnitID,ItemName,BonusTargetName"
    
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	K ^cwtemp
	s ^cwtemp=strSql
		
    While(result.Next()){
	
        s yearM=result.Data("yearM")	 
	    s BonusUnitName=result.Data("BonusUnitName") 
	    s BonusTargetName=result.Data("BonusTargetName")
	    s ItemName=result.Data("ItemName")
	    s ItemValue=result.Data("RealMoney")

	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
 
  	s Data=$lb(yearM,BonusUnitName,BonusTargetName,ItemName,ItemValue)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusExpDetailTargetMap","GetReport","2015-05","","")
Query GetReport(yearmonth As %String, BonusUnitID As %String, BonusTargetID As %String) As %Query(ROWSPEC = "yearM:%String,BonusUnitName:%String,BonusTargetName:%String,ItemName:%String,ItemValue:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusExpDeD1E2S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
