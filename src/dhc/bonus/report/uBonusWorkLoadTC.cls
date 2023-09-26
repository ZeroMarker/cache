Class dhc.bonus.report.uBonusWorkLoadTC Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
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

ClassMethod GetBonusWorkLoadExecute(ByRef qHandle As %Binary, sDate As %String, BonusUnitID As %String, Item As %String, startDate As %String, endDate As %String, Flag As %String) As %Status
{
	
	n (qHandle,sDate,BonusUnitID,Item,startDate,endDate,Flag)
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
   // s Item="hb310905026"
	k ^zlgtem4
    s ^zlgtem4=sDate_"^"_BonusUnitID_"^"_Item_"^"_startDate_"^"_endDate_"^"_Flag
 	;q:sDate="" $$$OK
	q:BonusUnitID="" $$$OK

	s InitValue=0

    &Sql(select InitValue into :InitValue from dhc_bonus_data.BonusTarget where BonusTargetCode='01020')
	;q:BonusUnitID="" $$$OK
	s JXYear=$p(sDate,"-",1)
	s JXMonth="M"_$p(sDate,"-",2)
	s asDate=$P(sDate,"-",1)_$P(sDate,"-",2)
	s astartDate=$P(startDate,"-",1)_$P(startDate,"-",2)
	s aendDate=$P(endDate,"-",1)_$P(endDate,"-",2)
	s sYearMonth=$P(sDate,"-",1)_"年"_$P(sDate,"-",2)_"月"
	
	s sstartDate=$P(startDate,"-",1)_"年"_$P(startDate,"-",2)_"月"
	s sendDate=$P(endDate,"-",1)_"年"_$P(endDate,"-",2)_"月"
  	
    /*s sqlStr=" select ItemCode,ItemName, BonusUnitName,sum(kdNums) kdNums,kdRate,sum(zxNums) zxNums,zxRate  from ( "
        _" select a.ItemCode,a.ItemName,a.PatDepDr,a.RecDepDr,"
			_" case b.SuperiorUnitID when '"_BonusUnitID_"' then b.SuperiorUnitID->BonusUnitName  else  c.SuperiorUnitID->BonusUnitName end as BonusUnitName, "
			_" case when b.SuperiorUnitID='"_BonusUnitID_"' then a.TarNums else 0 end as kdNums, "
			_" a.TarPrice*a.PatRate as kdRate, "
			_" case when c.SuperiorUnitID='"_BonusUnitID_"' then a.TarNums else 0 end as zxNums, "
			_" a.TarPrice*a.RecRate as zxRate "
			_" from dhc_bonus_subs.workload a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnit c,dhc_bonus_subs.BonusSubItem d "
			_" where b.BonusUnitCode='H' _ a.PatDepDr  and c.BonusUnitCode='H' _ a.RecDepDr and (b.SuperiorUnitID='"_BonusUnitID_"' or c.SuperiorUnitID='"_BonusUnitID_"')  and b.IsValid=1 and c.IsValid=1 and a.Flag='"_Flag_"' "
    		_" and a.ItemCode=d.SubItemCode and d.superiorItemID->superiorItemID->SubItemCode='01' "
    i (astartDate'="") && (aendDate'="") s sqlStr = sqlStr_" and a.YearMonth>='"_astartDate_"' and a.YearMonth<='"_aendDate_"' "
    i Item'="" s sqlStr = sqlStr_" and (a.ItemCode like '%"_Item_"%' or a.ItemName like '%"_Item_"%')"
    i asDate'="" s sqlStr = sqlStr_" and a.YearMonth='"_asDate_"' "
   	s sqlStr = sqlStr_" ) as jj group by ItemCode,ItemName, BonusUnitName,kdRate,zxRate"
   	*/
   	
   	s sqlStr=" select ItemCode,ItemName,BonusUnitName,sum(kdNums) kdNums,kdRate,sum(zxNums) zxNums,zxRate,TarPrice,YearMonth "
			_"from ( "
			_"select a.ItemCode,a.ItemName,a.PatDepDr, "
			_"b.SuperiorUnitID->BonusUnitName  BonusUnitName,"
			_"case when b.SuperiorUnitID='"_BonusUnitID_"' then a.TarNums else 0 end as kdNums,0 zxNums, "
			_"a.TarPrice,a.PatRate kdRate,a.RecRate zxRate,YearMonth "
			_"from dhc_bonus_subs.workload a,dhc_bonus_data.BonusUnit b,dhc_bonus_subs.BonusSubItem d "
			_"where b.BonusUnitCode='H' _ a.PatDepDr   and "
   			_"b.SuperiorUnitID='"_BonusUnitID_"' and b.IsValid=1 and a.Flag='"_Flag_"' "
			_"and a.ItemCode=d.SubItemCode and d.superiorItemID->superiorItemID->SubItemCode='01' "
			_"union all "
			_"select a.ItemCode,a.ItemName,a.RecDepDr, "
			_"c.SuperiorUnitID->BonusUnitName BonusUnitName,0 kdNums, "
			_"case when c.SuperiorUnitID='"_BonusUnitID_"' then a.TarNums else 0 end as zxNums, "
			_"a.TarPrice,a.PatRate,a.RecRate,YearMonth "
			_"from dhc_bonus_subs.workload a,dhc_bonus_data.BonusUnit c,dhc_bonus_subs.BonusSubItem d "
			_"where   c.BonusUnitCode='H' _ a.RecDepDr and c.SuperiorUnitID='"_BonusUnitID_"' "
			_"and c.IsValid=1 and a.Flag='"_Flag_"'  and a.ItemCode=d.SubItemCode "
			_"and d.superiorItemID->superiorItemID->SubItemCode='01' "
 			_") as jj where 1=1 "
 			i (astartDate'="") && (aendDate'="") s sqlStr = sqlStr_" and YearMonth>='"_astartDate_"' and YearMonth<='"_aendDate_"' "
 			i Item'="" s sqlStr = sqlStr_" and (ItemCode like '%"_Item_"%' or ItemName like '%"_Item_"%')"
 			i asDate'="" s sqlStr = sqlStr_" and YearMonth='"_asDate_"' "
 			s sqlStr = sqlStr_" group by ItemCode,ItemName,BonusUnitName,kdRate,zxRate,TarPrice "
   	
    ;w sqlStr ,!

    &SQL(select TargetValue into :JXScore from dhc_bonus_data.BonusTargetCollect where BonusTargetID=13 and InterLocMethodID=7 and BonusYear=:JXYear and BonusPeriod=:JXMonth and BonusUnitID=:BonusUnitID)
    
    s workrate=1
    &sql(select BonusValue into :workrate from  dhc_bonus_data.UnitBonusDetail
	WHERE BonusSchemeItemID->SchemeItemCode='01055'  AND BonusYear =:JXYear AND BonusPeriod =:JXMonth
		AND BonusUnitID=:BonusUnitID)
    i workrate="" d
    .s workrate=1
    
    //k ^zlgtem55
   // s ^zlgtem55=sqlStr
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
       s ItemCode = result.Data("ItemCode")
       s ItemName = result.Data("ItemName")
       s BonusUnitName = result.Data("BonusUnitName")
       s kdNums = result.Data("kdNums")
       s aRate = result.Data("kdRate")
       s TarPrice = result.Data("TarPrice")
       s kdRate = aRate*TarPrice
       s kdPrice = kdNums*kdRate
       
       s zxNums = result.Data("zxNums")
       s bRate = result.Data("zxRate")
       s zxRate = bRate*TarPrice
       s zxPrice = zxNums*zxRate
       i zxRate=0 s zxNums=0
       i kdRate=0 s kdNums=0
       s JXScores=$fn(JXScore,"",2)
       
      // w ItemCode_"^"_ItemName_"^"_ kdNums_"^"_zxNums_"^"_kdRate_"^"_zxPrice_"^"_"",!
	i (kdNums>0) || (zxNums>0) d
	.d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(sYearMonth,ItemCode,ItemName,BonusUnitName,kdNums,kdRate,zxNums,zxRate,sstartDate,sendDate,kdPrice,zxPrice,InitValue,JXScores,workrate)
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
/// Table: 2015-03^12^hb310905026^^^ss
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusWorkLoadTC","GetBonusWorkLoad","2015-03","12","hb310905026","","","0")
Query GetBonusWorkLoad(sDate As %String, BonusUnitID As %String, Item As %String, startDate As %String, endDate As %String, Flag As %String) As %Query(ROWSPEC = "sYearMonth:%String,ItemCode:%String,ItemName:%String,BonusUnitName:%String,kdNums:%Integer,kdRate:%Float,zxNums:%Integer,zxRate:%Float,sstartDate:%String,sendDate:%String,kdPrice:%Float,zxPrice:%Float,InitValue:%Float,JXScores:%Float,workrate:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusWorkL74C8S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
