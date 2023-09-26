Class dhc.ca.cache.io.uParamDatasReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-02
/// Description:参数数据
/// Table: dhc.ca.data.cache.VouchDatas
/// Input:
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.io.uParamDatasReport).ReportData(1)
ClassMethod ReportData(monthDr) As %String
{
	
	n (monthDr)
	d ##class(dhc.ca.cache.udata.uReportResult).Delete("paramdatas",monthDr,-1,-1)

	s rowid = 0
	f  s rowid = $o(^DHCCAPARAMDATAS(0,"Interval",monthDr,rowid)) q:rowid=""  d
	.s paramdatas = $g(^DHCCAPARAMDATAS(rowid))
	.s serveDept = $p(paramdatas,"^",7)
	.i serveDept'="" d
	..s serveDept = $p($g(^DHCCAUNITDEPTS(serveDept)),"^",2)
	.s servedDept = $p(paramdatas,"^",10)
	.i servedDept '="" d
	..s servedDept = $p($g(^DHCCAUNITDEPTS(servedDept)),"^",2)
	.s item = $p(paramdatas,"^",4)
	.s itemDr = item
	.i item'=""  d
	..s item = $p($g(^DHCCAALLDATAITEMS(item)),"^",3)
	.s paraValue = $p(paramdatas,"^",11)
	.s data = itemDr_"^"_serveDept_"^"_paraValue_"^2^"_servedDept_"^"_item
	.d ##class(dhc.ca.cache.udata.uReportResult).Insert("paramdatas",monthDr,-1,-1,data)
}

Storage Default
{
<StreamLocation>^dhc.ca.cach549.uParamDatasR6CFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
