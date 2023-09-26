/// Creator: wang ying
/// CreatDate: 2011-8-8
/// Description: 奖金方案分配汇总
Class dhc.bonus.report.uUnitBonusSchemPay Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetUnitBonusPayExecute(ByRef qHandle As %Binary, BonusYear As %String, frequency As %String, period As %String, unittypeID As %String) As %Status
{
	
	n (qHandle,BonusYear,frequency,period,unittypeID)
	
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    
    k ^TMPDHCBOUNSSCHEMPAY(0,"bounspay")
 	q:BonusYear="" $$$OK
	q:frequency="" $$$OK
	q:period="" $$$OK
	q:unittypeID="" $$$OK
     
    s PERIOD=frequency_period
   
     
    s sqlStr =" select  e.BonusUnitName as  UnitTypeName,b.BonusUnitName,f.SchemeTypeName,a.BonusValue"_
    " from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnitType c , dhc_bonus_data.BonusScheme d,dhc_bonus_data.BonusUnit e,dhc_bonus_data.BonusSchemeType f  "_
    " where a.BonusUnitID = b.BonusUnitID and b.BonusUnitTypeID = c.BonusUnitTypeID  and a.BonusSchemeID = d.BonusSchemeID and b.SuperiorUnitID =e.BonusUnitID and d.SchemeType=BonusSchemeTypeID "_
    " and a.BonusType=1 and b.UnitFlag=1  and b.IsValid=1 and c.IsValid=1 and d.IsValid=1"_
    " and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and c.BonusUnitTypeID in("_unittypeID_")"_
    " union all"_
    " select  e.BonusUnitName as UnitTypeName,b.BonusUnitName,f.SchemeTypeName,sum(a.BonusValue) BonusValue"_
    " from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnitType c , dhc_bonus_data.BonusScheme d,dhc_bonus_data.BonusUnit e ,dhc_bonus_data.BonusSchemeType f "_
    " where a.BonusUnitID->SuperiorUnitID =  b.BonusUnitID and b.BonusUnitTypeID = c.BonusUnitTypeID  and a.BonusSchemeID = d.BonusSchemeID and b.SuperiorUnitID =e.BonusUnitID "_
    " and a.BonusType=1 and a.BonusUnitID->UnitFlag in (2,3)  and b.IsValid=1 and c.IsValid=1 and d.IsValid=1"_
    " and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and c.BonusUnitTypeID in("_unittypeID_")"_
    " group by   c.UnitTypeName,b.BonusUnitName,f.SchemeTypeName"_
    " union all"_
    " select  e.BonusUnitName as UnitTypeName,b.BonusUnitName,f.SchemeTypeName,a.BonusValue"_
    " from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnitType c , dhc_bonus_data.BonusScheme d,dhc_bonus_data.BonusUnit e ,dhc_bonus_data.BonusSchemeType f "_
    " where a.BonusUnitID = b.BonusUnitID and b.BonusUnitTypeID = c.BonusUnitTypeID  and a.BonusSchemeID = d.BonusSchemeID and b.SuperiorUnitID =e.BonusUnitID "_
    " and a.BonusType=1 and b.UnitFlag in (2,3)  and b.IsValid=1 and c.IsValid=1 and d.IsValid=1"_
    " and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and c.BonusUnitTypeID in("_unittypeID_")"
    
    ;w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
      s UnitTypeName=result.Data("UnitTypeName")
      s BonusUnitName=result.Data("BonusUnitName")
      s RealBonus=result.Data("BonusValue")
      s SchemeItemName=result.Data("SchemeTypeName")
	  
        i PERIOD="M01" s PeriodName="1月"
		i PERIOD="M02" s PeriodName="2月"
		i PERIOD="M03" s PeriodName="3月"
		i PERIOD="M04" s PeriodName="4月"
		i PERIOD="M05" s PeriodName="5月"
		i PERIOD="M06" s PeriodName="6月"
		i PERIOD="M07" s PeriodName="7月"
		i PERIOD="M08" s PeriodName="8月"
		i PERIOD="M09" s PeriodName="9月"
		i PERIOD="M10" s PeriodName="10月"
		i PERIOD="M11" s PeriodName="11月"
		i PERIOD="M12" s PeriodName="12月"
		i PERIOD="Q01" s PeriodName="第一季度"
		i PERIOD="Q02" s PeriodName="第二季度"
		i PERIOD="Q03" s PeriodName="第三季度"
		i PERIOD="Q04" s PeriodName="第四季度"
		i PERIOD="H01" s PeriodName="上半年"
		i PERIOD="H02" s PeriodName="下半年"
		s YearMonthName=BonusYear_"年"_PeriodName
		//w YearMonthName,!
	 ;d OutputRow28
	 i $d(^TMPDHCBOUNSSCHEMPAY(0,"bounspay",$j,YearMonthName,UnitTypeName,SchemeItemName)) d
	 .s ^TMPDHCBOUNSSCHEMPAY(0,"bounspay",$j,YearMonthName,UnitTypeName,SchemeItemName)=^TMPDHCBOUNSSCHEMPAY(0,"bounspay",$j,YearMonthName,UnitTypeName,SchemeItemName)+RealBonus
	 e  s ^TMPDHCBOUNSSCHEMPAY(0,"bounspay",$j,YearMonthName,UnitTypeName,SchemeItemName)=RealBonus
	} 
   	s YearMonthNameTmp="" 
   	f  s YearMonthNameTmp=$o(^TMPDHCBOUNSSCHEMPAY(0,"bounspay",$j,YearMonthNameTmp)) q:YearMonthNameTmp=""  d
   	.s UnitTypeNameTmp=""
   	.f  s UnitTypeNameTmp=$o(^TMPDHCBOUNSSCHEMPAY(0,"bounspay",$j,YearMonthNameTmp,UnitTypeNameTmp)) q:UnitTypeNameTmp=""  d
   	..s SchemeItemNameTmp=""
   	..f  s SchemeItemNameTmp=$o(^TMPDHCBOUNSSCHEMPAY(0,"bounspay",$j,YearMonthNameTmp,UnitTypeNameTmp,SchemeItemNameTmp)) q:SchemeItemNameTmp=""  d
   	...s RealBonusTmp=^TMPDHCBOUNSSCHEMPAY(0,"bounspay",$j,YearMonthNameTmp,UnitTypeNameTmp,SchemeItemNameTmp)
   	...d OutputRow28
   	
   	k ^TMPDHCBOUNSSCHEMPAY(0,"bounspay")
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(YearMonthNameTmp,UnitTypeNameTmp,$fn(RealBonusTmp,"",2),SchemeItemNameTmp)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetUnitBonusPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnitBonusPayExecute ]
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

ClassMethod GetUnitBonusPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitBonusPayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wang ying
/// CreatDate:2011-8-8
/// Description:奖金方案分配报表
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusSchemPay","GetUnitBonusPay","2011","M","07","7,8,9,10")
Query GetUnitBonusPay(BonusYear As %String, frequency As %String, period As %String, unittypeID As %String) As %Query(ROWSPEC = "YearMonthName:%String,UnitTypeName:%String,RealBonus:%Float,SchemeItemName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uUnitBonusSc736S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
