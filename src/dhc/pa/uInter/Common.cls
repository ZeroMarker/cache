Class dhc.pa.uInter.Common Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// input:年月
/// return:年月日
/// Others: w ##class(dhc.pa.uInter.Common).LastOfMonth("2014-05")
ClassMethod LastOfMonth(yearmonth)
{
	n (yearmonth)
	s yearmonth=$p(yearmonth,"-",1)_$p(yearmonth,"-",2)
	//w yearmonth,!
	s yearmonth=..Data(yearmonth)
	q yearmonth
}

/// Others: w ##class(dhc.pa.uInter.Common).Data("201406")
ClassMethod Data(yearmonth)
{
	n (yearmonth)
	s startyearmonth=$E(yearmonth,1,4)_"-"_$E(yearmonth,5,6)_"-"_"01"
	s month=$E(yearmonth,5,6)+1
	i month <=9 s month="0"_month
	i month=13 s yearmonth=($E(yearmonth,1,4)+1)_"01",month="01"
	s endyearmonth=$E(yearmonth,1,4)_"-"_month_"-"_"01"
	s endyearmonth=$zdateh(endyearmonth,3)-1
	s endyearmonth=$zdate(endyearmonth,3)
	//w "yearmonth->"_yearmonth_"->"_" startyearmonth->"_startyearmonth_" endyearmonth->"_endyearmonth,!
	q endyearmonth
}

Storage Default
{
<StreamLocation>^dhc.pa.uInter.CommonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
