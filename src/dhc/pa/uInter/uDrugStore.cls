Class dhc.pa.uInter.uDrugStore Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 药品进价、售价金额采集
///  w ##class(dhc.pa.uInter.uDrugStore).PillBuyAndSell("2014","M12")
ClassMethod PillBuyAndSell(year, month)
{
	    n (year, month)
		s yearmonthtype="%"_year_"-"_$E(month,2,3)_"%"
		s yearmonth=year_$E(month,2,3)
		s startyearmonth=$E(yearmonth,1,4)_"-"_$E(yearmonth,5,6)_"-"_"01"
		s startyearmonth=$zdh(startyearmonth,3)
		s month=$E(yearmonth,5,6)+1
		i month <=9 s month="0"_month
		i month=13 d
		.s endyearmonth=($E(yearmonth,1,4)+1)_"-01-01"
		e  d
		.s endyearmonth=$E(yearmonth,1,4)_"-"_month_"-"_"01"
		s endyearmonth=$zdateh(endyearmonth,3)-1
		//s endyearmonth=$zdate(endyearmonth,3)
		
		;w yearmonth,!
		;W "WHERE INIT_AckDate>="_startyearmonth_" AND INIT_AckDate<="_endyearmonth,!
	
		//w "yearmonth"_yearmonth,"startyearmonth"_startyearmonth,"endyearmonth"_endyearmonth,!			
		//kpidr 67->药品零用进价金额，68->药品销售零售金额
	
		&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
		SELECT  54,:yearmonth,'M',67, sum(d.DHCITI_RPAmount) jinjia 
		FROM SQLUSER.DHC_InIsTrf a,SQLUSER.ct_loc b ,SQLUSER.ct_loc c,SQLUSER.DHC_InIsTrfItm d
		WHERE INIT_AckDate>=:startyearmonth AND INIT_AckDate<:endyearmonth
		AND a.INIT_FrLoc_DR=b.%ID AND a.INIT_ToLoc_DR=c.%ID
		AND a.INIT_RowId=d.INITI_INIT_ParRef
		AND a.INIT_Type ='T'
		AND INIT_FrLoc_DR IN (85,212,537))
		s err=SQLCODE
		;w err,!
		&sql(INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue)
		SELECT  54,:yearmonth,'M',68, sum(d.DHCITI_SPAmount ) lingshoujia
		FROM SQLUSER.DHC_InIsTrf a,SQLUSER.ct_loc b ,SQLUSER.ct_loc c,SQLUSER.DHC_InIsTrfItm d
		WHERE INIT_AckDate>=:startyearmonth AND INIT_AckDate<:endyearmonth
		AND a.INIT_FrLoc_DR=b.%ID AND a.INIT_ToLoc_DR=c.%ID
		AND a.INIT_RowId=d.INITI_INIT_ParRef
		AND a.INIT_Type ='T'
		AND INIT_FrLoc_DR IN (85,212,537))
		s err=SQLCODE
		;w err,!
		
	q 0
}

///  w ##class(dhc.pa.uInter.uDrugStore).ChangeYearmonth("201405")
ClassMethod ChangeYearmonth(yearmonth)
{
	n (yearmonth)
	s startyearmonth=$E(yearmonth,1,4)_"-"_$E(yearmonth,5,6)_"-"_"01"
	s month=$E(yearmonth,5,6)+1
	i month <=9 s month="0"_month
	i month=13 s yearmonth=($E(yearmonth,1,4)+1)_"01",month="01"
	s endyearmonth=$E(yearmonth,1,4)_"-"_month_"-"_"01"
	s endyearmonth=$zdateh(endyearmonth,3)-1
	s endyearmonth=$zdate(endyearmonth,3)
	w "yearmonth->"_yearmonth_"->"_" startyearmonth->"_startyearmonth_" endyearmonth->"_endyearmonth,!

	
	
	q 0
}

///  w ##class(dhc.pa.uInter.uDrugStore).hi("201405")
ClassMethod hi(yearmonth)
{
	w "hello",!
	q "what"
}

Storage Default
{
<StreamLocation>^dhc.pa.uInter.uDrugStoreS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
