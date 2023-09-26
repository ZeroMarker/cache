Class dhc.ca.cache.io.uIncomeDatasReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-01
/// Description: 收入数据码表数据
/// Table: dhc.ca.data.cache.UnitDepts
/// Input:
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.io.uIncomeDatasReport).ReportData(5)
ClassMethod ReportData(month) As %String
{
	
	n (month)
	d ##class(dhc.ca.cache.io.IncomeDatasReport).%DeleteExtent()
    
	s rowid = 0
	f  s rowid = $o(^DHCCAINCOMEDATAS(0,"Interval",month,rowid)) q:rowid=""  d
	.s incomeData = $g(^DHCCAINCOMEDATAS(rowid))
	.s reportdata = ##class(dhc.ca.cache.io.IncomeDatasReport).%New()
	.s month = $p(incomeData,"^",1)
	.s reportdata.month = $p($g(^DHCCAACCOUNTMONTHS(month)),"^",2)
	.s feeDate = $p(incomeData,"^",2)
	.i feeDate'=""  d
	..s reportdata.feeDate = $zd(feeDate,3)
	.s patType = $p(incomeData,"^",3)
	.i patType = "I" d
	..s reportdata.patType = "住院"
	.i patType = "O" d
	..s reportdata.patType = "门诊"
	.i patType = "E" d
	..s reportdata.patType = "急诊"
	.s reportdata.itemCode = $p(incomeData,"^",4)
	.s reportdata.itemName = $p(incomeData,"^",5)
	.s reportdata.fee = $p(incomeData,"^",7)
	.s reportdata.fDeptCode = $p(incomeData,"^",9)
	.s reportdata.fDeptName = $p(incomeData,"^",10)
	.s reportdata.tDeptCode = $p(incomeData,"^",12)
	.s reportdata.tDeptName = $p(incomeData,"^",13)
	.s reportdata.patDeptCode = $p(incomeData,"^",15)
	.s reportdata.patDeptName = $p(incomeData,"^",16)
	.s inType = $p(incomeData,"^",18)
	.i inType = "load"  d
	..s reportdata.inType = "导入"
	.i inType = "input"  d
	..s reportdata.inType = "录入"
	.s reportdata.remark = $p(incomeData,"^",20)
	.s inDate = $p(incomeData,"^",21)
	.s reportdata.inDate = $zd(inDate,3)
	.s sr =reportdata.%Save()
}

Storage Default
{
<StreamLocation>^dhc.ca.cach549.uIncomeDatas739S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
