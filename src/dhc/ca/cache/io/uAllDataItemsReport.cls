/// Creator: wang ying
/// CreatDate: 2010-07-01
/// Description: 数据项码表数据导出
Class dhc.ca.cache.io.uAllDataItemsReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-01
/// Description: 数据项码表数据
/// Table: dhc.ca.data.cache.AllDataItems
/// Input:
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.io.uAllDataItemsReport).ReportData()
ClassMethod ReportData() As %String
{
	
	d ##class(dhc.ca.cache.udata.uReportResult).Delete("alldataitems",-1,-1,-1)

	s rowid = 0
	f  s rowid = $o(^DHCCAALLDATAITEMS(rowid)) q:rowid=""  d
	.s allDataItems = $g(^DHCCAALLDATAITEMS(rowid))
	.s active = $p(allDataItems,"^",6)
	.s order = $p(allDataItems,"^",1)
	.s code = $p(allDataItems,"^",2)
	.s name = $p(allDataItems,"^",3)
	.s shortcut = $p(allDataItems,"^",4)
	.s remark = $p(allDataItems,"^",5)
	.s unit = $p(allDataItems,"^",7)
	.s data = "^"_code_"^1^2^"_name_"^"_shortcut_"^1^2^"_remark_"^"_unit_"^"_order_"^"_active
	.d ##class(dhc.ca.cache.udata.uReportResult).Insert("alldataitems",-1,-1,-1,data)
}

Storage Default
{
<StreamLocation>^dhc.ca.cach549.uAllDataItem786S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
