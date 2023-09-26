Class dhc.pa.udata.uMedInCome Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

///  w ##class(dhc.pa.udata.uMedInCome).InsertMedIncome("2014","M06","22","23")
ClassMethod InsertMedIncome(year, month, JXKPIdr, bonusKPIdr)
{
	//不够完整
	n (year, month, JXKPIdr, bonusKPIdr)
	s yearmonth=year_$E(month,2,3)
	;&sql(delete from dhc_pa_data.JXBaseData where JXBaseData_period=:yearmonth and JXBaseData_KPIDr=:JXKPIdr)
	s sqlString="INSERT INTO dhc_pa_data.JXBaseData(JXBaseData_parRef,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_actualValue) "
	s sqlString=""
	s sqlString=sqlString_"select myb.JXUnit_rowid,yearmonth,'M' AS type,'"_JXKPIdr_"' AS kpidr,mya.TargetValue from"
	//KPIDR--指标id
	s sqlString=sqlString_"(select yearmonth,BonusUnitCode,BonusUnitName,TargetValue,BonusTargetName FROM ( select   substring(bonusYear,1,4)||substring(BonusPeriod,2,3) AS yearmonth, a.%ID rowid,e.BonusUnitID,e.BonusUnitCode, e.BonusUnitName,e.BonusTargetID,"
	_" e.BonusTargetCode,e.BonusTargetName,e.DataSource,a.TargetValue, a.UpdateDate,MaxValue,TargetDesc from   dhc_bonus_data.BonusTargetCollect a right join ( select BonusTargetID,BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName, BonusTargetID->DataSource ,BonusTargetID->MaxValue,BonusTargetID->TargetDesc,c.BonusUnitID,c.BonusUnitCode,c.BonusUnitName "
	_"from dhc_bonus_data.BonusEmployeeTarget a,dhc_bonus_data.BonusEmployeeUnit b, dhc_bonus_data.BonusUnit c where a.BonusEmployeeID=b.BonusEmployeeID "
	_"and b.BonusUnitID=c.BonusUnitID and (c.SuperiorUnitID='' or ''='')  and (c.BonusUnitID='' or ''='') AND "
	_"(a.BonusTargetID='"_bonusKPIdr_"') ) e on  a.BonusTargetID = e.BonusTargetID  and a.BonusUnitID = E.BonusUnitID  and  a.BonusYear='"_year_"' AND a.BonusPeriod='"_month_"')) mya,"
	_"( select JXUnit_rowid,JXUnit_code from  dhc_pa_data.JXUnit ) myb "
	_"where mya.BonusUnitCode=myb.JXUnit_code"
				
	
	w !,sqlString,!
	s result=##class(%Library.ResultSet).%New()
	;q sqlStr
	d result.Prepare(sqlString)
	d result.Execute()
	d result.Close()
	q 0
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uMedInComeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
