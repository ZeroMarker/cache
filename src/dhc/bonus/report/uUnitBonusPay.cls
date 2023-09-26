Class dhc.bonus.report.uUnitBonusPay Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 奖金分配汇总报表
/// Creator:王宏宇
/// CreatDate:2011-2-14
/// Description:期间Query
/// Table:
/// Others:
ClassMethod GetPeriodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s Freq="",PeriodDr="",PeriodName=""
	
	s FreqLen=4
	f k=1:1:FreqLen d
	.i k=1 d
	..s Freq="M"
	..f m=1:1:12 d
	...i m<10 s PeriodDr="0"_m
	...e  s PeriodDr=m
	...i m<10 s PeriodName="0"_m_"月"
	...e  s PeriodName=m_"月"
	
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr="0"_n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr="0"_l
	...i PeriodDr="01" s PeriodName="上半年"
	...i PeriodDr="02" s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr="00"
	..s PeriodName="全年"
	..d OutputRowPeriod
 
 	q $$$OK
OutputRowPeriod
	
 	s Data=$lb(Freq,PeriodDr,PeriodName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator:王宏宇
/// CreatDate:2011-2-14
/// Description:期间Query
/// Table:
/// Others:
ClassMethod GetPeriodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPeriodExecute ]
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

ClassMethod GetPeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:王宏宇
/// CreatDate:2011-2-14
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String") [ SqlProc ]
{
}

//

/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","SchemePeriod")
Query SchemePeriod() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%'
}

/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","UnitType")
Query UnitType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT BonusUnitTypeID,UnitTypeName
from  dhc_bonus_data.BonusUnitType WHERE
BonusUnitTypeID>0 and IsValid=1
}

ClassMethod GetUnitBonusPayExecute(ByRef qHandle As %Binary, BonusYear As %String, frequency As %String, period As %String, unittypeID As %String) As %Status
{
	
	n (qHandle,BonusYear,frequency,period,unittypeID)
	
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    
    k ^TMPDHCBOUNSPAY(0,"bounspay")
 	q:BonusYear="" $$$OK
	q:frequency="" $$$OK
	q:period="" $$$OK
	q:unittypeID="" $$$OK
     
    s PERIOD=frequency_period
   
     
    s sqlStr =" select  e.BonusUnitName as  UnitTypeName,b.BonusUnitName,d.SchemeItemName,a.BonusValue"_
    " from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnitType c , dhc_bonus_data.BonusSchemeItem d,dhc_bonus_data.BonusUnit e  "_
    " where a.BonusUnitID = b.BonusUnitID and b.BonusUnitTypeID = c.BonusUnitTypeID  and a.BonusSchemeItemID = d.BonusSchemeItemID and b.SuperiorUnitID =e.BonusUnitID "_
    " and a.BonusType=1 and b.UnitFlag=1  and b.IsValid=1 and c.IsValid=1 and d.IsValid=1"_
    " and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and c.BonusUnitTypeID in("_unittypeID_")"_
    " union all"_
    " select  e.BonusUnitName as UnitTypeName,b.BonusUnitName,d.SchemeItemName,sum(a.BonusValue) BonusValue"_
    " from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnitType c , dhc_bonus_data.BonusSchemeItem d,dhc_bonus_data.BonusUnit e  "_
    " where a.BonusUnitID->SuperiorUnitID =  b.BonusUnitID and b.BonusUnitTypeID = c.BonusUnitTypeID  and a.BonusSchemeItemID = d.BonusSchemeItemID and b.SuperiorUnitID =e.BonusUnitID "_
    " and a.BonusType=1 and a.BonusUnitID->UnitFlag in (2,3)  and b.IsValid=1 and c.IsValid=1 and d.IsValid=1"_
    " and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and c.BonusUnitTypeID in("_unittypeID_")"_
    " group by   c.UnitTypeName,b.BonusUnitName,d.SchemeItemName,d.BonusType"_
    " union all"_
    " select  e.BonusUnitName as UnitTypeName,b.BonusUnitName,d.SchemeItemName,a.BonusValue"_
    " from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnitType c , dhc_bonus_data.BonusSchemeItem d,dhc_bonus_data.BonusUnit e  "_
    " where a.BonusUnitID = b.BonusUnitID and b.BonusUnitTypeID = c.BonusUnitTypeID  and a.BonusSchemeItemID = d.BonusSchemeItemID and b.SuperiorUnitID =e.BonusUnitID "_
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
      s SchemeItemName=result.Data("SchemeItemName")
	  
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
	 i $d(^TMPDHCBOUNSPAY(0,"bounspay",$j,YearMonthName,UnitTypeName,SchemeItemName)) d
	 .s ^TMPDHCBOUNSPAY(0,"bounspay",$j,YearMonthName,UnitTypeName,SchemeItemName)=^TMPDHCBOUNSPAY(0,"bounspay",$j,YearMonthName,UnitTypeName,SchemeItemName)+RealBonus
	 e  s ^TMPDHCBOUNSPAY(0,"bounspay",$j,YearMonthName,UnitTypeName,SchemeItemName)=RealBonus
	} 
   	s YearMonthNameTmp="" 
   	f  s YearMonthNameTmp=$o(^TMPDHCBOUNSPAY(0,"bounspay",$j,YearMonthNameTmp)) q:YearMonthNameTmp=""  d
   	.s UnitTypeNameTmp=""
   	.f  s UnitTypeNameTmp=$o(^TMPDHCBOUNSPAY(0,"bounspay",$j,YearMonthNameTmp,UnitTypeNameTmp)) q:UnitTypeNameTmp=""  d
   	..s SchemeItemNameTmp=""
   	..f  s SchemeItemNameTmp=$o(^TMPDHCBOUNSPAY(0,"bounspay",$j,YearMonthNameTmp,UnitTypeNameTmp,SchemeItemNameTmp)) q:SchemeItemNameTmp=""  d
   	...s RealBonusTmp=^TMPDHCBOUNSPAY(0,"bounspay",$j,YearMonthNameTmp,UnitTypeNameTmp,SchemeItemNameTmp)
   	...d OutputRow28
   	
   	k ^TMPDHCBOUNSPAY(0,"bounspay")
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

/// Creator:王宏宇
/// CreatDate:2011-2-14
/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","GetUnitBonusPay","2012","M","2","13")
Query GetUnitBonusPay(BonusYear As %String, frequency As %String, period As %String, unittypeID As %String) As %Query(ROWSPEC = "YearMonthName:%String,UnitTypeName:%String,RealBonus:%Float,SchemeItemName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.rep64E.uUnitBonusPayS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
