/// Class dhc.bonus.report.uYTPacsWork Extends %SerialObject
/// 标题:财务绩效奖金统计表
/// 作者：Zhao LiGuo
/// 日期：2013-01-22
/// 需求：烟台中医院
Class dhc.bonus.report.uYTPacsWork Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 主报表
ClassMethod PacsWorkExecute(ByRef qHandle As %Binary, sDate As %String, sDept As %String) As %Status
{
	
	n (qHandle,sDate,sDept)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	q:sDate="" $$$OK

  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
	s strSql=""
	s strSql=strSql_" select SuperiorUnitID->SuperiorUnitID->BonusUnitName supUnitName,BonusYear,BonusPeriod, UnitCode," 
		_" UnitName,ItemCode,ItemName,ItemValue,ExecuteRate, BonusTargetCode"
 		_" from dhc_bonus_subs.PACSWorkLoadDetail a,dhc_bonus_data.BonusUnit b"
 		_" where a.UnitCode= b.BonusUnitCode and BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"'"
 		_" and  BonusTargetCode like '"_sDept_"%'"

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s sYear=result.Data("BonusYear")
      s smonth = $p(sDate,"-",2)
      s UnitName = result.Data("UnitName")
      s UnitCode = result.Data("UnitCode")
      s ItemCode = result.Data("ItemCode")
      s ItemName = result.Data("ItemName")
      s supname =  result.Data("supUnitName")
       
      s ItemValue = result.Data("ItemValue")
 	  s ExecuteRate = result.Data("ExecuteRate")
 	  s TargetCode = result.Data("BonusTargetCode")	
 	  s zje=ItemValue*ExecuteRate	
      s YearMonth=BonusYear_"年"_smonth_"月"
	  ;w supname_":"_zje,!
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(sYear,smonth,supname,UnitCode,UnitName,ItemCode,ItemName,ItemValue,ExecuteRate,zje,TargetCode,YearMonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod PacsWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PacsWorkExecute ]
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

ClassMethod PacsWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PacsWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table:  sYear,smonth,supname,UnitName,zje,YearMonth
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uYTPacsWork","PacsWork","2013-11")
Query PacsWork(sDate As %String, sDept As %String) As %Query(ROWSPEC = "sYear:%String,smonth:%String,supname:%String,UnitCode:%String,UnitName:%String,ItemCode:%String,ItemName:%String,ItemValue:%Float,ExecuteRate:%Float,zje:%Float,TargetCode:%String,YearMonth:%String") [ SqlProc ]
{
}

/// 主报表
ClassMethod PacsWorkSumExecute(ByRef qHandle As %Binary, sDate As %String, sDept As %String) As %Status
{
	
	n (qHandle,sDate,sDept)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	q:sDate="" $$$OK

  
    s BonusYear =$p(sDate,"-",1)
    s BonusPeriod ="M" _ $p(sDate,"-",2)
	s strSql=""
	s strSql=strSql_"select SuperiorUnitID->SuperiorUnitID->BonusUnitName supUnitName, BonusYear,BonusPeriod, UnitCode, UnitName, BonusTargetCode,sum(ItemValue*ExecuteRate) zje" 
 		_" from dhc_bonus_subs.PacsWorkLoadDetail a,dhc_bonus_data.BonusUnit b"
 		_" where a.UnitCode= b.BonusUnitCode and BonusYear='"_BonusYear_"' and BonusPeriod='"_BonusPeriod_"'"
 		_" and  BonusTargetCode like '"_sDept_"%'"
		_" group by SuperiorUnitID->SuperiorUnitID->BonusUnitName , BonusYear,BonusPeriod, UnitCode, UnitName, BonusTargetCode"
    w strSql,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s sYear=result.Data("BonusYear")
      s smonth = $p(sDate,"-",2)
      s UnitName = result.Data("UnitName")
      s UnitCode = result.Data("UnitCode")
      ;s ItemCode = result.Data("ItemCode")
      ;s ItemName = result.Data("ItemName")
      s supname =  result.Data("supUnitName")
       
      s ItemValue =0
 	  s ExecuteRate = 0
 	  s TargetCode = result.Data("BonusTargetCode")	
 	  s zje=result.Data("zje")	
      s YearMonth=BonusYear_"年"_smonth_"月"
	  ;w supname_":"_zje,!
	 d OutputRow2
	  
	} 
   	  
  	q $$$OK
OutputRow2
  	s Data=$lb(sYear,smonth,supname,UnitCode,UnitName,ItemValue,ExecuteRate,zje,TargetCode,YearMonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod PacsWorkSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PacsWorkSumExecute ]
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

ClassMethod PacsWorkSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PacsWorkSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table:  sYear,smonth,supname,UnitName,zje,YearMonth
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uYTPacsWork","PacsWorkSum","2013-11","")
Query PacsWorkSum(sDate As %String, sDept As %String) As %Query(ROWSPEC = "sYear:%String,smonth:%String,supname:%String,UnitCode:%String,UnitName:%String,ItemValue:%Float,ExecuteRate:%Float,zje:%Float,TargetCode:%String,YearMonth:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.report.uYTPacsWorkS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
