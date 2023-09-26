Class dhc.ca.cache.io.uVouchDatasReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-01
/// Description:凭证数据
/// Table: dhc.ca.data.cache.VouchDatas
/// Input:
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.io.uVouchDatasReport).ReportData(5)
ClassMethod ReportData(monthDr) As %String
{
	
	n (monthDr)
	d ##class(dhc.ca.cache.udata.uReportResult).Delete("VouchDatas",monthDr,-1,-1)

	s rowid = 0
	f  s rowid = $o(^DHCCAVOUCHDATAS(0,"Interval",monthDr,rowid)) q:rowid=""  d
	.;w "rowid="_rowid,!
	.s vouchDatas = $g(^DHCCAVOUCHDATAS(rowid))
	.;w vouchDatas,!
	.s month = $p(vouchDatas,"^",1)
	.i month'="" d
	..s month = $p($g(^DHCCAACCOUNTMONTHS(month)),"^",2)
	.s dept = $p(vouchDatas,"^",2)
	.;w "dept="_dept,!
	.i dept'="" d
	..s dept = $p($g(^DHCCAUNITDEPTS(dept)),"^",2)
	.s item = $p(vouchDatas,"^",3)
	.i item'="" d
	..s item = $p($g(^DHCCAALLDATAITEMS(item)),"^",3)
	.s inType = $p(vouchDatas,"^",4)
	.i inType = "load"  d
	..s inType = "导入"
	.i inType = "input"  d
	..s inType = "录入"
	.s personDr = $p(vouchDatas,"^",5)
	.i personDr'="" d
	..s person = $p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
	.s remark = $p(vouchDatas,"^",6)
	.s date = $p(vouchDatas,"^",10)
	.i date'="" d
	..s date = $zd(date,3)
	.s num = $p(vouchDatas,"^",9)
	.s abstract = $p(vouchDatas,"^",11)
	.s deptcode = $p(vouchDatas,"^",12)
	.s deptName = $p(vouchDatas,"^",13)
	.s subjCode = $p(vouchDatas,"^",14)
	.s subjName = $p(vouchDatas,"^",15)
	.s debit = $p(vouchDatas,"^",16)
	.s loans = $p(vouchDatas,"^",17)
	.;s data = "^"_subjName
	.s data = "^"_subjName_"^"_num_"^"_deptcode_"^"_dept_"^"_item_"^"_debit_"^"_loans_"^"_inType_"^"_person_"^"_remark_"^"_date_"^"_abstract_"^-1^"_deptName_"^-1^"_subjCode
	.d ##class(dhc.ca.cache.udata.uReportResult).Insert("VouchDatas",monthDr,-1,-1,data)
}

Storage Default
{
<StreamLocation>^dhc.ca.cach549.uVouchDatasR6E3S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
