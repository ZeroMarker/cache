Class dhc.bonus.report.uBonusWorkLoadTJData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 收费项报表
/// Description:
/// Table:
/// Others:
Query BonusUnit(UserCode) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select a.BonusUnitID,a.BonusUnitName from dhc_bonus_data.BonusUnit a,dhc_bonus_data.BonusEmployeeUnit b
 where b.BonusUnitID=a.BonusUnitID and upper(b.BonusEmployeeID->EmployeeCode)=upper(:UserCode) and a.IsValid=1
}

ClassMethod GetTJWorkLoadExecute(ByRef qHandle As %Binary, sDate As %String, BonusUnitID As %String) As %Status
{
	
	n (qHandle,sDate,BonusUnitID)
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
	q:BonusUnitID="" $$$OK
	
	s sDate = $p(sDate,"-",1)_"-"_$p(sDate,"-",2)
	s JXYear=$p(sDate,"-",1)
	s JXMonth="M"_$p(sDate,"-",2)
	s sYearMonth=$P(sDate,"-",1)_"年"_$P(sDate,"-",2)_"月"
	
	&Sql(select InitValue into :InitValue from dhc_bonus_data.BonusTarget where BonusTargetCode='01020')
	i BonusUnitID'=58 d
	.s sqlStr=" select ItemCode,ItemName,PatDepDr,RecDepDr,TarNums,PatRate,RecRate,b.SuperiorUnitID->BonusUnitName from dhc_bonus_subs.WorkLoad a,dhc_bonus_data.BonusUnit b where a.YearMonth='"_sDate_"' and 'T' _ convert(int,a.RecDepDr)=b.BonusUnitCode and b.SuperiorUnitID='"_BonusUnitID_"' "
   	i BonusUnitID=58 d
   	.s sqlStr=" select ItemCode,ItemName,PatDepDr,RecDepDr,TarNums,PatRate,case when 'T' _ convert(int,a.RecDepDr) in ('T0','T49','T50','T68','T69','T90','T91','T92','T93') then RecRate else 0 end as RecRate,case when 'T' _ convert(int,a.RecDepDr) in ('T0','T49','T50','T68','T69','T90','T91','T92','T93') then TarNums  else 0 end as zxTarNums,a.YearMonth from dhc_bonus_subs.WorkLoad a where a.YearMonth='"_sDate_"' and (('T' _ convert(int,a.RecDepDr) in ('T0','T49','T50','T68','T69','T90','T91','T92','T93')) or (a.PatDepDr='"_BonusUnitID_"'))"
    &SQL(select TargetValue into :JXScore from dhc_bonus_data.BonusTargetCollect where BonusTargetID=13 and InterLocMethodID=7 and BonusYear=:JXYear and BonusPeriod=:JXMonth and BonusUnitID=:BonusUnitID)
    
    s workrate=1
    &sql(select BonusValue into :workrate from  dhc_bonus_data.UnitBonusDetail
	WHERE BonusSchemeItemID->SchemeItemCode='01055'  AND BonusYear =:JXYear AND BonusPeriod =:JXMonth
		AND BonusUnitID=:BonusUnitID)
    i workrate="" d
    .s workrate=1
    
    
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
       s ItemCode = result.Data("ItemCode")
       s ItemName = result.Data("ItemName")
       s PatDept = result.Data("PatDepDr")
       s RecDept = result.Data("RecDepDr")
      
       s TarNums = result.Data("TarNums")
       i BonusUnitID'=58 d
       .s BonusUnitName = result.Data("BonusUnitName")
       s RecRate = result.Data("RecRate") 
       s RecPrice = TarNums*RecRate
       
       s kdTarNums=0
       s PatRate=0
       s PatPrice=0
       i BonusUnitID="58" d
       .s kdTarNums=TarNums
       .s BonusUnitName="VIP体检科"
       .s TarNums = result.Data("zxTarNums")
       .s PatRate = result.Data("PatRate")
       .s PatPrice=kdTarNums*PatRate
       
      
       s JXScores=$fn(JXScore,"",2)
       
	d OutputRow28
	  
	} 
   	 
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(sYearMonth,ItemCode,ItemName,PatDept,RecDept,TarNums,PatRate,RecRate,PatPrice,RecPrice,JXScores,BonusUnitName,InitValue,kdTarNums,workrate)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetTJWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTJWorkLoadExecute ]
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

ClassMethod GetTJWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTJWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkLoadTJData","GetTJWorkLoad","2014-01","11")
Query GetTJWorkLoad(sDate As %String, BonusUnitID As %String) As %Query(ROWSPEC = "sYearMonth:%String,ItemCode:%String,ItemName:%String,PatDept:%String,RecDept:%String,TarNums:%Integer,PatRate:%Float,RecRate:%Float,PatPrice:%Float,RecPrice:%Float,JXScores:%Float,BonusUnitName:%String,InitValue:%Float,kdTarNums:%Integer,workrate:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusWorkLBD01S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
