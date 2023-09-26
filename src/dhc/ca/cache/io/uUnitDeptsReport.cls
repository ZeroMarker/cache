Class dhc.ca.cache.io.uUnitDeptsReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-01
/// Description: 单位部门码表数据
/// Table: dhc.ca.data.cache.UnitDepts
/// Input:
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.io.uUnitDeptsReport).ReportData()
ClassMethod ReportData() As %String
{
	
	d ##class(dhc.ca.cache.udata.uReportResult).Delete("UnitDepts",-1,-1,-1)

	s rowid = 0
	f  s rowid = $o(^DHCCAUNITDEPTS(rowid)) q:rowid=""  d
	.s unitdept = ^DHCCAUNITDEPTS(rowid)
	.s active = $p(unitdept,"^",10)
	.s code = $p(unitdept,"^",1)
	.s name = $p(unitdept,"^",2)
	.s shortcut = $p(unitdept,"^",3)
	.s address = $p(unitdept,"^",4)
	.s remark = $p(unitdept,"^",5)
	.s start = $p(unitdept,"^",6)
	.i start'="" d
	..s start = $zd(start,3)
	.s end = $p(unitdept,"^",7)
	.i end'=""  d
	..s end = $zd(end,3)
	.s unit = $p(unitdept,"^",8)
	.s unitName = $p($g(^DHCCAUNITS(unit)),"^",2)
	.s property = $p(unitdept,"^",9)
	.s data = "^"_code_"^1^2^"_name_"^"_shortcut_"^1^2^"_address_"^"_remark_"^"_start_"^"_end_"^"_property_"^^"_active
	.d ##class(dhc.ca.cache.udata.uReportResult).Insert("UnitDepts",-1,-1,-1,data)
}

Storage Default
{
<StreamLocation>^dhc.ca.cach549.uUnitDeptsRe691S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
