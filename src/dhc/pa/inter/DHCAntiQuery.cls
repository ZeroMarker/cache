Class dhc.pa.inter.DHCAntiQuery Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.inter.DHCAntiQuery).GetInDocAntiData()
ClassMethod GetInDocAntiData(startDate, endDate) As %String
{
		n (startDate, endDate)
		k ^TMPJXImportData
		s ^TMPJXImportData(1)="刘泽英组^1^2^3^4^5^6"
		
		
		q 3
}

/// w ##class(dhc.pa.inter.DHCAntiQuery).importData()
ClassMethod importData() As %String
{
	s rowid=0
	f  s rowid=$O(^TMPJXImportData(rowid)) q:rowid=""  d
	.s unit=$p(^TMPJXImportData(rowid),"^",1)
	.s kpi=$p(^TMPJXImportData(rowid),"^",2)
	.s val=$p(^TMPJXImportData(rowid),"^",3)
	.&SQL(UPDATE dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:val where JXBaseData_parRef->JXUnit_name=:unit and JXBaseData_KPIDr=:kpi)
	
		q 3
}

/// w ##class(dhc.pa.inter.DHCAntiQuery).ImportJXData("201206","M")
ClassMethod ImportJXData(period, periodType) As %String
{
	n (period,periodType)
	s rowid=0
	f  s rowid=$O(^TMPJXImportData(rowid)) q:rowid=""  d
	.s unit=$p(^TMPJXImportData(rowid),"^",1)
	.s v1=$p(^TMPJXImportData(rowid),"^",2) //9
	.s v2=$p(^TMPJXImportData(rowid),"^",4) //10
	.s v3=$p(^TMPJXImportData(rowid),"^",6) //5
	.s v4=$p(^TMPJXImportData(rowid),"^",7) //6
	.&SQL(UPDATE dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:v1 where JXBaseData_parRef->JXUnit_name=:unit and JXBaseData_KPIDr=9)
	.&SQL(UPDATE dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:v2 where JXBaseData_parRef->JXUnit_name=:unit and JXBaseData_KPIDr=10)
	.&SQL(UPDATE dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:v3 where JXBaseData_parRef->JXUnit_name=:unit and JXBaseData_KPIDr=5)
	.&SQL(UPDATE dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:v4 where JXBaseData_parRef->JXUnit_name=:unit and JXBaseData_KPIDr=6)
	q 0
}

Storage Default
{
<StreamLocation>^dhc.pa.inter.DHCAntiQueryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
