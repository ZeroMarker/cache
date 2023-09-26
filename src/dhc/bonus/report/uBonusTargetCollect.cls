Class dhc.bonus.report.uBonusTargetCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//

Query SchemePeriod() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%'
}

/// 调整方案
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusTargetCollect","GetScheme")
Query GetScheme() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select  BonusSchemeID BonusSchemeAdjustID,BonusSchemeName from dhc_bonus_data.BonusScheme WHERE IsValid=1 AND SchemeState=1
}

/// 指标
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusTargetCollect","GetTarget")
Query GetTarget() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select  a.BonusSchemeID, a.BonusSchemeID->BonusSchemeName,c.BonusTargetID,c.BonusTargetName from dhc_bonus_data.BonusScheme d,
dhc_bonus_data.BonusSchemeAdjust a ,
dhc_bonus_data.SchemeAdjustTarget b ,
dhc_bonus_data.BonusTarget  c
where a.BonusSchemeAdjustID=b.BonusSchemeAdjustID and b.bonusTargetID=c.bonusTargetID and a.BonusSchemeID=d.BonusSchemeID and d.SchemeState=1
}

/// 主报表
ClassMethod GetBonusTargetCollectExecute(ByRef qHandle As %Binary, BonusYear As %String, frequency As %String, SchemeID As %String, TargetID As %String) As %Status
{
	
	n (qHandle,BonusYear,frequency,SchemeID,TargetID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	q:BonusYear="" $$$OK
	q:frequency="" $$$OK
	q:SchemeID="" $$$OK
	q:TargetID="" $$$OK
     

   
    s sqlStr="select c.BonusUnitID,a.BonusTargetID,a.BonusTargetName,b.CalUnitName,TargetValue,BonusYear,BonusPeriod"_
    " from dhc_bonus_data.BonusSchemeUnit c,dhc_bonus_data.BonusTargetCollect e,dhc_bonus_data.BonusTarget a,dhc_bonus_data.CalUnit b"_
    " where a.BonusTargetID=e.BonusTargetID and a.CalUnitID=b.CalUnitID and c.BonusUnitID=e.BonusUnitID "_
    " and e.BonusPeriod like'"_frequency_"%' and e.BonusYear='"_BonusYear_"' and a.BonusTargetID='"_TargetID_"' and c.BonusSchemeID='"_SchemeID_"' "_
    " union all"_
    " select c.BonusUnitID,a.BonusTargetID,a.BonusTargetName,b.CalUnitName,e.TargetRate,f.BonusYear,f.BonusPeriod"_
    " from dhc_bonus_data.BonusSchemeUnit c, dhc_bonus_data.TargetCalculateRate e, dhc_bonus_data.BonusTarget a, dhc_bonus_data.CalUnit b,"_
    " dhc_bonus_data.BonusSchemeAdjust f, dhc_bonus_data.SchemeAdjustTarget d"_
    "  where a.BonusTargetID=e.BonusTargetID and a.CalUnitID=b.CalUnitID and c.BonusUnitID=e.BonusUnitID"_
    " and a.BonusTargetID=d.BonusTargetID and d.BonusSchemeAdjustID=f.BonusSchemeAdjustID     and c.BonusSchemeID=f.BonusSchemeID"_
    " and f.BonusPeriod like'"_frequency_"%' and f.BonusYear='"_BonusYear_"' and a.BonusTargetID='"_TargetID_"' and c.BonusSchemeID='"_SchemeID_"' order by BonusPeriod"
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
      s BonusUnitID=result.Data("BonusUnitID")
      i BonusUnitID'="" d
		.i $D(^dhcbsBonusUnitD(BonusUnitID)) d
		..i $G(^dhcbsBonusUnitD(BonusUnitID))'="" d
		...s BonusUnitName=$LIST(^dhcbsBonusUnitD(BonusUnitID),3)
		
      s BonusTargetName=result.Data("BonusTargetName")
      s CalUnitName=result.Data("CalUnitName")
      s TargetValue=result.Data("TargetValue")
      s BonusYear=result.Data("BonusYear")
         s BonusPeriod=result.Data("BonusPeriod")
         
        i BonusPeriod="M01" s PeriodName="01月"
		i BonusPeriod="M02" s PeriodName="02月"
		i BonusPeriod="M03" s PeriodName="03月"
		i BonusPeriod="M04" s PeriodName="04月"
		i BonusPeriod="M05" s PeriodName="05月"
		i BonusPeriod="M06" s PeriodName="06月"
		i BonusPeriod="M07" s PeriodName="07月"
		i BonusPeriod="M08" s PeriodName="08月"
		i BonusPeriod="M09" s PeriodName="09月"
		i BonusPeriod="M10" s PeriodName="10月"
		i BonusPeriod="M11" s PeriodName="11月"
		i BonusPeriod="M12" s PeriodName="12月"
		i BonusPeriod="Q01" s PeriodName="第一季度"
		i BonusPeriod="Q02" s PeriodName="第二季度"
		i BonusPeriod="Q03" s PeriodName="第三季度"
		i BonusPeriod="Q04" s PeriodName="第四季度"
		i BonusPeriod="H01" s PeriodName="上半年"
		i BonusPeriod="H02" s PeriodName="下半年"
		s YearMonthName=BonusYear_"年"_PeriodName
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(BonusUnitName,BonusTargetName,CalUnitName,TargetValue,YearMonthName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusTargetCollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusTargetCollectExecute ]
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

ClassMethod GetBonusTargetCollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusTargetCollectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:王宏宇
/// CreatDate:2011-2-17
/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusTargetCollect","GetBonusTargetCollect","2008","M","1","1")
Query GetBonusTargetCollect(BonusYear As %String, frequency As %String, SchemeID As %String, TargetID As %String) As %Query(ROWSPEC = "BonusUnitName:%String,BonusTargetName:%String,CalUnitName:%String,TargetValue:%Float,YearMonthName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uBonusTarget7A9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
