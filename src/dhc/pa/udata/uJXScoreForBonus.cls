/// Creator: wyy
Class dhc.pa.udata.uJXScoreForBonus Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.udata.uJXScoreForBonus).InitMonData("201303")
ClassMethod InitMonData(month) As %String
{
	n (month)
	
	&SQL(delete from  dhc_pa_data.JXScoreForBonus where JXScoreForBonus_Month=:month)
	s index=""
	f  s index=$o(^dhc.pa.data.UnitKPIMapDi80DD(index)) q:index=""  d
	.;w index,","
	.s tmpKPI = $List(^dhc.pa.data.UnitKPIMapDi80DD(index),2)
	.s tmpUnit =  $List(^dhc.pa.data.UnitKPIMapDi80DD(index),3)
	.;w tmpUnit,",",tmpKPI,!
	.;&SQL(insert into dhc_pa_data.JXScoreForBonus(JXScoreForBonus_Month,JXScoreForBonus_UnitDr,JXScoreForBonus_KPIDr,JXScoreForBonus_Score,JXScoreForBonus_Flag) VALUES(:month,:tmpUnit,:tmpKPI,0,"N"))
	q $$$OK
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXScoreForBonusS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
