Class dhc.bonus.report.uTargetCollectionReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 奖金分配汇总报表
/// Creator:赵立国
/// CreatDate:2011-03-21
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

/// Creator:赵立国
/// CreatDate:2011-03-21
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

/// Creator:赵立国
/// CreatDate:2011-03-21
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

//----------科室核算指标采集 带权限-----------------------------------------------

/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","SchemePeriod")
Query SchemePeriod() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%'
}

/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","UnitType")
Query UnitType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT BonusUnitTypeID,UnitTypeName from  dhc_bonus_data.BonusUnitType WHERE BonusUnitTypeID>0 and IsValid=1
}

//and SchemeState=1

Query BonusScheme() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where %ID>0 and IsValid=1
}

ClassMethod GetUnitBonusPayExecute(ByRef qHandle As %Binary, BonusYear As %String, frequency As %String, period As %String, bonusSchemeID As %String, isReal As %String, BonusUnit As %String) As %Status
{
	
	n (qHandle,BonusYear,frequency,period,bonusSchemeID,isReal,BonusUnit)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	q:BonusYear="" $$$OK
	q:frequency="" $$$OK
	q:period="" $$$OK
	q:bonusSchemeID="" $$$OK
    //q:isReal="" $$$OK
     
    s PERIOD=frequency_period
   
    s sqlStr=" select b.BonusSchemeID->BonusSchemeName ,d.BonusUnitID->BonusUnitTypeID->UnitTypeName,d.BonusUnitID->BonusUnitName,d.BonusUnitID->EmployeeNo,c.BonusTargetCode,c.BonusTargetName,a.TargetValue,'1' as iflag"_
 	", e.BonusUnitName as  superUnit"_
 	" from dhc_bonus_data.BonusTargetCollect a, dhc_bonus_data.SchemeTarget b,dhc_bonus_data.BonusTarget c,dhc_bonus_data.BonusSchemeUnit d,dhc_bonus_data.BonusUnit e"_
	" where a.BonusTargetID = b.BonusTargetID and b.BonusTargetID = c.BonusTargetID and b.BonusSchemeID = d.BonusSchemeID and a.BonusUnitID = d.BonusUnitID and c.DataSource=1"_
	" and a.TargetValue<>0 and d.BonusUnitID->SuperiorUnitID= e.BonusUnitID"_
    " and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and   b.BonusSchemeID="_bonusSchemeID_
    "     "
    if BonusUnit'=""{
	    s sqlStr=sqlStr_" and d.BonusUnitID->SuperiorUnitID="_BonusUnit
	    }
    
    if isReal ="1" {
	   s sqlStr= sqlStr_" union all Select a.BonusSchemeID->BonusSchemeName ,a.BonusUnitID->BonusUnitTypeID->UnitTypeName,a.BonusUnitID->BonusUnitName,a.BonusUnitID->EmployeeNo,'00' BonusTargetCode,'核算奖金' as BonusTargetName,RealBonus, '2' as iflag"_
 		" ,b.BonusUnitName as  superUnit"_
 		" from  dhc_bonus_data.UnitBonusPay a,dhc_bonus_data.BonusUnit b where a.BonusUnitID->SuperiorUnitID = b.BonusUnitID and"_
 		"  BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and   BonusSchemeID="_bonusSchemeID
 		_" and  RealBonus<>0"
	    }
	if BonusUnit'=""{
	    s sqlStr=sqlStr_" and b.BonusUnitID="_BonusUnit
	    }    
    w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
      s UnitTypeName=result.Data("UnitTypeName")
      s BonusUnitName=result.Data("BonusUnitName")
      s RealBonus=result.Data("TargetValue")
      s BonusTargetName=result.Data("BonusTargetName")
      s BonusSchemeName=result.Data("BonusSchemeName")
      s BonusType=result.Data("iflag")
	  s EmployeeNo = result.Data("EmployeeNo")
	  s BonusTargetCode= result.Data("BonusTargetCode")
	  s superUnit= result.Data("superUnit")
	  
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
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(YearMonthName,UnitTypeName,BonusUnitName,EmployeeNo,BonusTargetCode,BonusTargetName,RealBonus,BonusType,BonusSchemeName,superUnit)
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

/// Creator:赵立国
/// CreatDate:2011-03-21
/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uTargetCollectionReport","GetUnitBonusPay","2010","M","06",39,1,"")
Query GetUnitBonusPay(BonusYear As %String, frequency As %String, period As %String, bonusSchemeID As %String, isReal As %String, BonusUnit As %String) As %Query(ROWSPEC = "YearMonthName:%String,UnitTypeName:%String,BonusUnitName:%String,EmployeeNo:%String,BonusTargetCode:%String,BonusTargetName:%String,RealBonus:%Float,BonusType:%String,BonusSchemeName:%String,superUnit:%String") [ SqlProc ]
{
}

ClassMethod GetDeptBonusPayExecute(ByRef qHandle As %Binary, BonusYear As %String, frequency As %String, period As %String, bonusSchemeID As %String, isReal As %String, BonusUnit As %String) As %Status
{
	
	n (qHandle,BonusYear,frequency,period,bonusSchemeID,isReal,BonusUnit)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	q:BonusYear="" $$$OK
	q:frequency="" $$$OK
	q:period="" $$$OK
	q:bonusSchemeID="" $$$OK
    //q:isReal="" $$$OK
     
    s PERIOD=frequency_period
   
    s sqlStr=" select b.BonusSchemeID->BonusSchemeName ,d.BonusUnitID->BonusUnitTypeID->UnitTypeName,d.BonusUnitID->BonusUnitName,d.BonusUnitID->EmployeeNo,c.BonusTargetCode,c.BonusTargetName,a.TargetValue,'1' as iflag"_
 	",  d.BonusUnitID->SuperiorUnitID->BonusUnitName as  superUnit"_
 	" from dhc_bonus_data.BonusTargetCollect a, dhc_bonus_data.SchemeTarget b,dhc_bonus_data.BonusTarget c,dhc_bonus_data.BonusSchemeUnit d "_
	" where a.BonusTargetID = b.BonusTargetID and b.BonusTargetID = c.BonusTargetID and b.BonusSchemeID = d.BonusSchemeID and a.BonusUnitID = d.BonusUnitID and c.DataSource=1"_
	" and a.TargetValue<>0 "_
    " and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"' and   b.BonusSchemeID="_bonusSchemeID
   
    if BonusUnit'=""{
	    s sqlStr=sqlStr_" and d.BonusUnitID->SuperiorUnitID="_BonusUnit
	    }
    
    if isReal ="1" {
	   s sqlStr= sqlStr_" union all Select a.BonusSchemeID->BonusSchemeName ,a.BonusUnitID->BonusUnitTypeID->UnitTypeName,a.BonusUnitID->BonusUnitName,a.BonusUnitID->EmployeeNo,'00' BonusTargetCode,'合计金额' as BonusTargetName,RealBonus, '2' as iflag"_
 		" ,a.BonusUnitID->SuperiorUnitID->BonusUnitName as  superUnit"_
 		" from  dhc_bonus_data.UnitBonusPay a where "_
 		"  BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and   BonusSchemeID="_bonusSchemeID
 		_" and  RealBonus<>0"
	    
		if BonusUnit'=""{
	    	s sqlStr=sqlStr_" and a.BonusUnitID->SuperiorUnitID="_BonusUnit
	    	}  
	   } 
	   
	
    w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
      s UnitTypeName=result.Data("UnitTypeName")
      s BonusUnitName=result.Data("BonusUnitName")
      //s BonusUnitName="BBBB"
      s RealBonus=result.Data("TargetValue")
      s BonusTargetName=result.Data("BonusTargetName")
      s BonusSchemeName=result.Data("BonusSchemeName")
      s BonusType=result.Data("iflag")
	  s EmployeeNo =result.Data("EmployeeNo")
	  s BonusTargetCode= result.Data("BonusTargetCode")
	  s superUnit= result.Data("superUnit")
	  
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
	 d OutputRow38
	  
	} 
   	  
  	q $$$OK
OutputRow38
	
  
  	s Data=$lb(YearMonthName,UnitTypeName,BonusUnitName,EmployeeNo,BonusTargetCode,BonusTargetName,RealBonus,BonusType,BonusSchemeName,superUnit)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetDeptBonusPayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptBonusPayExecute ]
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

ClassMethod GetDeptBonusPayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptBonusPayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:赵立国
/// CreatDate:2011-03-21
/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uTargetCollectionReport","GetDeptBonusPay","2013","M","05",4,0,"A0063")
Query GetDeptBonusPay(BonusYear As %String, frequency As %String, period As %String, bonusSchemeID As %String, isReal As %String, BonusUnit As %String) As %Query(ROWSPEC = "YearMonthName:%String,UnitTypeName:%String,BonusUnitName:%String,EmployeeNo:%String,BonusTargetCode:%String,BonusTargetName:%String,RealBonus:%Float,BonusType:%String,BonusSchemeName:%String,superUnit:%String") [ SqlProc ]
{
}

ClassMethod GetCollectionTargetExecute(ByRef qHandle As %Binary, BonusYear As %String, period As %String, bonusSchemeID As %String, UserCode As %String) As %Status
{
	
	n (qHandle,BonusYear,period,bonusSchemeID,UserCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	q:BonusYear="" $$$OK
	q:period="" $$$OK
	q:bonusSchemeID="" $$$OK
    //q:isReal="" $$$OK
     
    s PERIOD="M"_period
   
    s sqlStr=" select b.BonusSchemeID->BonusSchemeName ,d.BonusUnitID->BonusUnitTypeID->UnitTypeName,d.BonusUnitID->BonusUnitName,d.BonusUnitID->EmployeeNo,c.BonusTargetCode,c.BonusTargetName,a.TargetValue,'1' as iflag"_
 	", e.BonusUnitName as  superUnit"_
 	" from dhc_bonus_data.BonusTargetCollect a, dhc_bonus_data.SchemeTarget b,dhc_bonus_data.BonusTarget c,dhc_bonus_data.BonusSchemeUnit d,dhc_bonus_data.BonusUnit e"_
 	" ,dhc_bonus_data.BonusEmployeeUnit f"_
	" where a.BonusTargetID = b.BonusTargetID and b.BonusTargetID = c.BonusTargetID and b.BonusSchemeID = d.BonusSchemeID and a.BonusUnitID = d.BonusUnitID "_
	" and c.DataSource in (1,5)"_
	" and a.TargetValue<>0 and d.BonusUnitID->SuperiorUnitID= e.BonusUnitID"_
	"  and a.BonusUnitID = f.BonusUnitID  and upper(f.BonusEmployeeID ->EmployeeCode)=upper('"_UserCode_"')"_
    " and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'and   b.BonusSchemeID="_bonusSchemeID_
    "     "

    w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
      s UnitTypeName=result.Data("UnitTypeName")
      s BonusUnitName=result.Data("BonusUnitName")
      s RealBonus=result.Data("TargetValue")
      s BonusTargetName=result.Data("BonusTargetName")
      s BonusSchemeName=result.Data("BonusSchemeName")
      s BonusType=result.Data("iflag")
	  s EmployeeNo = result.Data("EmployeeNo")
	  s BonusTargetCode= result.Data("BonusTargetCode")
	  s superUnit= result.Data("superUnit")
	  
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
	 d OutputRow29
	  
	} 
   	  
  	q $$$OK
OutputRow29
	
  
  	s Data=$lb(YearMonthName,UnitTypeName,BonusUnitName,EmployeeNo,BonusTargetCode,BonusTargetName,RealBonus,BonusType,BonusSchemeName,superUnit)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetCollectionTargetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCollectionTargetExecute ]
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

ClassMethod GetCollectionTargetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCollectionTargetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:赵立国
/// CreatDate:2011-03-21
/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uTargetCollectionReport","GetCollectionTarget","2013","05",3,"A0063")
Query GetCollectionTarget(BonusYear As %String, period As %String, bonusSchemeID As %String, UserCode As %String) As %Query(ROWSPEC = "YearMonthName:%String,UnitTypeName:%String,BonusUnitName:%String,EmployeeNo:%String,BonusTargetCode:%String,BonusTargetName:%String,RealBonus:%Float,BonusType:%String,BonusSchemeName:%String,superUnit:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uTargetColle964S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
