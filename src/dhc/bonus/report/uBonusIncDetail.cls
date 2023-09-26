Class dhc.bonus.report.uBonusIncDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:chenwen
/// CreatDate:2015-6-5
/// Description:科室个人收入Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetDept")
ClassMethod GetReportExecute(ByRef qHandle As %Binary, yearmonth1 As %String, BonusUnitID As %String, DataType As %String) As %Status
{
	
	n (qHandle,yearmonth1,BonusUnitID,DataType)

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    k ^zlgtemp
	s ^zlgtemp="zlg1="_yearmonth1_":"_ BonusUnitID_":"_DataType
	;q:rptCode="" $$$OK
	s year=$p(yearmonth1,"-",1)
	s month=$p(yearmonth1,"-",2)
	s month="M"_month
 	q:year="" $$$OK
 	q:month="" $$$OK
     
    s strSql="SELECT yearM, BonusUnitName, ItemCode, ItemName,sum( IncValue) IncValue, ItemRate, sum(hsSum) AS hsSum, DataType, BonusUnitCode FROM("
    _"SELECT BonusYear||right(BonusPeriod,2) yearM,a.BonusUnitID->BonusUnitName ,b.ItemCode,b.ItemName"
    _" ,a.IncValue,a.ItemRate , a.ItemValue hsSum,a.DataType,BonusUnitID->BonusUnitCode"
	_" FROM dhc_bonus_module.BonusIncDetail a,dhc_bonus_module.BonusIncItem b"
    _" WHERE a.ItemCode = b.ItemCode AND BonusYear ='"_year_"' AND BonusPeriod ='"_month_"' "
	_" AND a.DataType='"_DataType_"' AND BonusUnitID='"_BonusUnitID_"'"
	_" union all "
	_"SELECT BonusYear||right(BonusPeriod,2) yearM,a.BonusUnitID->SuperiorUnitID->BonusUnitName ,b.ItemCode,b.ItemName"
    _" ,a.IncValue,a.ItemRate , a.ItemValue hsSum,a.DataType,a.BonusUnitID->SuperiorUnitID->BonusUnitCode"
	_" FROM dhc_bonus_module.BonusIncDetail a,dhc_bonus_module.BonusIncItem b"
    _" WHERE a.ItemCode = b.ItemCode AND BonusYear ='"_year_"' AND BonusPeriod ='"_month_"' "
	_" AND a.DataType='"_DataType_"' AND BonusUnitID->SuperiorUnitID='"_BonusUnitID_"'"
	_"  ) AS jj   GROUP BY   yearM, BonusUnitName, ItemCode, ItemName,  ItemRate, DataType, BonusUnitCode"
	
    k ^cwtemp
    s ^cwtemp=strSql

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	    s yearM=result.Data("yearM")
	    s ItemCode=result.Data("ItemCode") 	
	    s UnitCode=result.Data("BonusUnitCode") 
	    s ItemName=result.Data("ItemName") 	
	    s ItemValue=result.Data("IncValue") 
	    s ItemRate=result.Data("ItemRate")
		s RealMoney=result.Data("hsSum") 
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(yearM,ItemCode,ItemName,ItemValue,ItemRate,RealMoney,UnitCode)
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

/// Creator:ZHAOLIGUO
/// CreatDate:2013-12-05
/// Description:查询报表数据记录
/// Table: 2015-08:573:MK
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIncDetail","GetReport","2015-08","573","MK")
Query GetReport(yearmonth1 As %String, BonusUnitID As %String, DataType As %String) As %Query(ROWSPEC = "yearM:%String,ItemCode:%String,ItemName:%String,ItemValue:%Float,ItemRate:%Float,RealMoney:%Float,UnitCode:%String") [ SqlProc ]
{
}

//---------------------------------------

/// Creator:zhaoliguo
/// CreatDate:2015-12-5
/// Description:科室个人收入Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkItemResult","GetDept")
ClassMethod GetIncDetailExecute(ByRef qHandle As %Binary, yearmonth As %String, UnitCode As %String, ItemCode As %String, DataType As %String) As %Status
{
	
	n (qHandle,yearmonth,UnitCode,ItemCode,DataType)
    ;s ^zlg123=yearmonth_","_UnitCode_","_ItemCode_","_DataType
    
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

	;q:rptCode="" $$$OK
	s year=$E(yearmonth,1,4)
	s month=$E(yearmonth,5,6)
	
 	q:year="" $$$OK
 	q:month="" $$$OK
    s month="M"_month
     
     s sqlStr=""
 	i DataType="MK" d
	.s sqlStr=""
	.S sqlStr=sqlStr_" SELECT a.SickType, b.ItemCode,b.ItemName ,c.code1 mkUnitCode,c.Name mkUnitName ,d.code1 exUnitCode,d.Name exUnitName,a.IncomeMoney  "
	.S sqlStr=sqlStr_" FROM dhc_bonus_module.BonusIncomeCollect a,dhc_bonus_module.BonusIncItem b,dhc_sync_data.sync_loc c,dhc_sync_data.sync_loc  d"
	.S sqlStr=sqlStr_" ,dhc_bonus_subs.BonusSubDeptGroupMap e"
	.S sqlStr=sqlStr_" WHERE a.IncomeItemCode =b.ItemCode AND b.IsValid=1 AND a.MakeBillDeptCode=c.Code0 AND a.ExecuteDeptCode=d.Code0"
	.S sqlStr=sqlStr_" AND a.ExecuteDeptCode=e.BonusUnit->BonusUnitCode  AND e.BonusDeptGroupID =1 "
	.S sqlStr=sqlStr_" AND BonusYear ='"_year_"' AND BonusPeriod ='"_month_"' AND a.IncomeItemCode ='"_ItemCode_"' AND c.code0='"_UnitCode_"'"
	.S sqlStr=sqlStr_" UNION ALL"
	.S sqlStr=sqlStr_" SELECT a.SickType, b.ItemCode,b.ItemName ,c.code1,c.Name  ,d.code1 ,d.Name ,a.IncomeMoney"
	.S sqlStr=sqlStr_" FROM dhc_bonus_module.BonusIncomeCollect a,dhc_bonus_module.BonusIncItem b,dhc_sync_data.sync_loc c,dhc_sync_data.sync_loc  d"
	.S sqlStr=sqlStr_" ,dhc_bonus_subs.BonusSubDeptGroupMap e,dhc_bonus_data.BonusUnit f"
	.S sqlStr=sqlStr_" WHERE a.IncomeItemCode =b.ItemCode AND b.IsValid=1 AND a.MakeBillDeptCode=c.Code0 AND a.ExecuteDeptCode=d.Code0"
	.S sqlStr=sqlStr_" AND a.ExecuteDeptCode=e.BonusUnit->BonusUnitCode  AND e.BonusDeptGroupID =1 "
	.S sqlStr=sqlStr_" AND c.Code0=f.BonusUnitCode "
	.S sqlStr=sqlStr_" AND BonusYear ='"_year_"' AND BonusPeriod ='"_month_"' AND a.IncomeItemCode ='"_ItemCode_"'"
	.S sqlStr=sqlStr_" AND f.SuperiorUnitID->BonusUnitCode ='"_UnitCode_"'"
	e  d
	.s sqlStr=sqlStr_" SELECT a.SickType, b.ItemCode,b.ItemName ,c.code1 mkUnitCode,c.Name mkUnitName ,d.code1 exUnitCode,d.Name exUnitName,a.IncomeMoney  "
	.s sqlStr=sqlStr_" FROM dhc_bonus_module.BonusIncomeCollect a,dhc_bonus_module.BonusIncItem b,dhc_sync_data.sync_loc c,dhc_sync_data.sync_loc  d"
	.s sqlStr=sqlStr_" WHERE a.IncomeItemCode =b.ItemCode AND b.IsValid=1 AND a.MakeBillDeptCode=c.Code0 AND a.ExecuteDeptCode=d.Code0"
	.s sqlStr=sqlStr_" AND BonusYear ='"_year_"' AND BonusPeriod ='"_month_"' AND a.IncomeItemCode ='"_ItemCode_"' AND d.code0='"_UnitCode_"'"
	.s sqlStr=sqlStr_" UNION ALL"
	.s sqlStr=sqlStr_" SELECT a.SickType, b.ItemCode,b.ItemName ,c.code1,c.Name  ,d.code1 ,d.Name ,a.IncomeMoney"
	.s sqlStr=sqlStr_" FROM dhc_bonus_module.BonusIncomeCollect a,dhc_bonus_module.BonusIncItem b,dhc_sync_data.sync_loc c,dhc_sync_data.sync_loc  d"
	.s sqlStr=sqlStr_" ,dhc_bonus_data.BonusUnit f"
	.s sqlStr=sqlStr_" WHERE a.IncomeItemCode =b.ItemCode AND b.IsValid=1 AND a.MakeBillDeptCode=c.Code0 AND a.ExecuteDeptCode=d.Code0"
	.s sqlStr=sqlStr_" AND d.Code0=f.BonusUnitCode "
	.s sqlStr=sqlStr_" AND BonusYear ='"_year_"' AND BonusPeriod ='"_month_"' AND a.IncomeItemCode ='"_ItemCode_"'"
	.s sqlStr=sqlStr_" AND f.SuperiorUnitID->BonusUnitCode ='"_UnitCode_"'"
	
	;W sqlStr,!
	s ^zlg145=sqlStr
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
	  s SickType  =result.Data("SickType")
	  s ItemCode  =result.Data("ItemCode")
	  s ItemName  =result.Data("ItemName")
	  s mkUnitCode=result.Data("mkUnitCode") 
	  s mkUnitName=result.Data("mkUnitName") 
	  s exUnitCode=result.Data("exUnitCode") 
	  s exUnitName=result.Data("exUnitName") 
	  s IncomeMoney=result.Data("IncomeMoney")
	  i SickType=1 d
	  . s SickType="门诊"
	  e  d
	  . s SickType="住院"

	 d OutputRow35
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow35
  	s Data=$lb(SickType, ItemCode, ItemName, mkUnitCode, mkUnitName, exUnitCode, exUnitName, IncomeMoney)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetIncDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncDetailExecute ]
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

ClassMethod GetIncDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:
/// CreatDate:2015-12-05
/// Description:查询报表数据记录
/// Table: 201508,103220200,15,EX"
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusIncDetail","GetIncDetail","201508","103220200","15",EX"")
Query GetIncDetail(yearmonth As %String, UnitCode As %String, ItemCode As %String, DataType As %String) As %Query(ROWSPEC = "SickType:%String, ItemCode:%String, ItemName:%String, mkUnitCode:%String, mkUnitName:%String, exUnitCode:%String, exUnitName:%String, IncomeMoney:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusIncDe9AEAS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
