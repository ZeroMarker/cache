Class dhc.bonus.report.uBonusWorkLoadTab Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
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

ClassMethod GetBonusWorkLoadExecute(ByRef qHandle As %Binary, sDate As %String, BonusUnitCode As %String, Item As %String, startDate As %String, endDate As %String, Flag As %String) As %Status
{
	
	n (qHandle,sDate,BonusUnitCode,Item,startDate,endDate,Flag)
	

	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	;q:sDate="" $$$OK
	q:BonusUnitCode="" $$$OK

	s InitValue=0

    &Sql(select InitValue into :InitValue from dhc_bonus_data.BonusTarget where BonusTargetCode='01020')
	&SQL(select BonusUnitID into :BonusUnitID from dhc_bonus_data.BonusUnit where BonusUnitCode=:BonusUnitCode)
	;q:BonusUnitID="" $$$OK
	s asDate=$P(sDate,"-",1)_$P(sDate,"-",2)
	s astartDate=$P(startDate,"-",1)_$P(startDate,"-",2)
	s aendDate=$P(endDate,"-",1)_$P(endDate,"-",2)
	s sYearMonth=$P(sDate,"-",1)_"年"_$P(sDate,"-",2)_"月"
	
	s sstartDate=$P(startDate,"-",1)_"年"_$P(startDate,"-",2)_"月"
	s sendDate=$P(endDate,"-",1)_"年"_$P(endDate,"-",2)_"月"
  	
    s sqlStr=" select a.ItemCode,a.ItemName,a.PatDepDr,a.RecDepDr,"
			_" case b.SuperiorUnitID when '"_BonusUnitID_"' then b.SuperiorUnitID->BonusUnitName  else  c.SuperiorUnitID->BonusUnitName end as BonusUnitName, "
			_" case when b.SuperiorUnitID='"_BonusUnitID_"' then sum(a.TarNums) else 0 end as kdNums, "
			_" case when b.SuperiorUnitID='"_BonusUnitID_"' then a.TarPrice*a.PatRate else 0 end as kdRate, "
			_" case when c.SuperiorUnitID='"_BonusUnitID_"' then sum(a.TarNums) else 0 end as zxNums, "
			_" case when c.SuperiorUnitID='"_BonusUnitID_"' then a.TarPrice*a.RecRate else 0 end as zxRate "
			_" from dhc_bonus_subs.workload a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnit c,dhc_bonus_subs.BonusSubItem d "
			_" where b.BonusUnitCode='H' _ a.PatDepDr  and c.BonusUnitCode='H' _ a.RecDepDr and (b.SuperiorUnitID='"_BonusUnitID_"' or c.SuperiorUnitID='"_BonusUnitID_"')  "
			_" and b.IsValid=1 and c.IsValid=1 "
            _" and a.ItemCode=d.SubItemCode and d.superiorItemID->superiorItemID->SubItemCode='01' "
    
    i Flag'="" s sqlStr=sqlStr_" and a.Flag='"_Flag_"' "
    i (astartDate'="") && (aendDate'="") s sqlStr = sqlStr_" and a.YearMonth>='"_astartDate_"' and a.YearMonth<='"_aendDate_"' "
    i Item'="" s sqlStr = sqlStr_" and (a.ItemCode like '%"_Item_"%' or a.ItemName like '%"_Item_"%')"
    i asDate'="" s sqlStr = sqlStr_" and a.YearMonth='"_asDate_"' "
   s sqlStr = sqlStr_" group by a.ItemCode,a.ItemName,a.PatDepDr,a.RecDepDr, a.TarPrice,a.PatRate"
    ;w sqlStr ,!

    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
       s ItemCode = result.Data("ItemCode")
       s ItemName = result.Data("ItemName")
       s BonusUnitName = result.Data("BonusUnitName")
       s kdNums = result.Data("kdNums")
       s kdRate = result.Data("kdRate")
       s kdPrice = kdNums*kdRate
       
       s zxNums = result.Data("zxNums")
       s zxRate = result.Data("zxRate")
       s zxPrice = zxNums*zxRate
       i zxRate=0 s zxNums=0
       i kdRate=0 s kdNums=0
       s InitValue=InitValue
	i (kdNums>0) || (zxNums>0) d
	.d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(sYearMonth,ItemCode,ItemName,BonusUnitName,kdNums,kdRate,zxNums,zxRate,sstartDate,sendDate,kdPrice,zxPrice,InitValue)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusWorkLoadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusWorkLoadExecute ]
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

ClassMethod GetBonusWorkLoadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusWorkLoadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkLoadTab","GetBonusWorkLoad","2014-01","D0101","","2014-01","2014-01","ss")
Query GetBonusWorkLoad(sDate As %String, BonusUnitCode As %String, Item As %String, startDate As %String, endDate As %String, Flag As %String) As %Query(ROWSPEC = "sYearMonth:%String,ItemCode:%String,ItemName:%String,BonusUnitName:%String,kdNums:%Integer,kdRate:%Float,zxNums:%Integer,zxRate:%Float,sstartDate:%String,sendDate:%String,kdPrice:%Float,zxPrice:%Float,InitValue:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusWorkLDFECS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
