Class dhc.ca.test Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.ca.test).insertDept()
ClassMethod insertDept() As %String
{
	s result="OK"
	
	s rowid=0
	f  s rowid=$o(^DHCCALOCS(rowid)) q:rowid=""  d
	.i $d(^DHCCALOCS(rowid)) d
	..s deptCode=$p(^DHCCALOCS(rowid),"^",1)
	..s deptName=$p(^DHCCALOCS(rowid),"^",2)
	..s deptDesc=$p(^DHCCALOCS(rowid),"^",3)
	..&SQL(INSERT INTO dhc_ca_cache_data.UnitDepts (UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_unitDr,UnitDepts_active) VALUES (:deptCode,:deptName,:deptDesc,1,'Y'))
	..i SQLCODE'=0 d
	...i result="OK" s result=rowid
	...e  s result=result_"^"_rowid 
	
	q result
}

/// w ##class(dhc.ca.test).insertItems()
ClassMethod insertItems() As %String
{
	s result="OK"
	
	s rowid=0
	f  s rowid=$o(^DHCCAALLDATAITEMSXU(rowid)) q:rowid=""  d
	.i $d(^DHCCAALLDATAITEMSXU(rowid)) d
	..s order=200+rowid
	..s code=$p(^DHCCAALLDATAITEMSXU(rowid),"^",2)
	..s name=$p(^DHCCAALLDATAITEMSXU(rowid),"^",3)
	..s shortcut=$p(^DHCCAALLDATAITEMSXU(rowid),"^",4)
	..s remark=$p(^DHCCAALLDATAITEMSXU(rowid),"^",5)
	..s active="Y"
	..&SQL(INSERT INTO dhc_ca_cache_data.AllDataItems (AllDataItems_order,AllDataItems_code,AllDataItems_name,AllDataItems_shortcut,AllDataItems_remark,AllDataItems_active) VALUES (:order,:code,:name,:shortcut,:remark,:active))
	..i SQLCODE'=0 d
	...i result="OK" s result=rowid
	...e  s result=result_"^"_rowid 
	
	q result
}

//d ##class(dhc.ca.test).listDepts()

ClassMethod listDepts() As %String
{
	f  s i=$o(^DHCCAUNITDEPTS(i)) q:i=""  d
	.s code=$p(^DHCCAUNITDEPTS(1),"^",1)
	.s newcode=code_"x"
	.&SQL(UPDATE dhc_ca_cache_data.UnitDepts SET UnitDepts_code=:newcode WHERE %ID=:i)
	.//&SQL(UPDATE dhc_ca_cache_data.UnitDepts SET UnitDepts_code=:code WHERE %ID=:i)

	q "OK"
}

Storage Default
{
<StreamLocation>^dhc.ca.testS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
