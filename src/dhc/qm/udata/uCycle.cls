Class dhc.qm.udata.uCycle Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 黄凤杰
/// CreatDate: 2015-6-12
/// Description: 添加功能
/// Table： dhc_qm_data.Cycle
/// Input: Cyclecode-年度code，Cyclename-年度名称，Cycleactive-是否有效
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.qm.udata.uCycle).AddCycle("23","系统模1212","")
ClassMethod AddCycle(Cyclecode As %String, Cyclename As %String, Cycleactive As %String) As %String [ SqlProc ]
{
	n (Cyclecode,Cyclename,Cycleactive)

	
	s rowid=0
	s rowid=..IfRepCode(Cyclecode)
	q:rowid>0 "RepCode"
	
	s rowid=0
	s rowid=..IfRepName(Cyclename)
	q:rowid>0 "RepName"
	
	
	
	&sql(insert into dhc_qm_data.Cycle(Cycle_code,Cycle_name,Cycle_active) values (:Cyclecode,:Cyclename,:Cycleactive))
	q SQLCODE
}

/// Creator: 黄凤杰
/// CreatDate: 2015-6-12
/// Description: 物理删除功能
/// Table： dhc_qm_data.Cycle
/// Input: rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.qm.udata.uCycle).PhysicsDelete("5")
ClassMethod PhysicsDelete(rowId) As %String
{
	n (rowId)	
	&sql(Delete from dhc_qm_data.Cycle where Cycle_rowid=:rowId)
	q SQLCODE
}

/// Creator: 黄凤杰
/// CreatDate: 2015-6-12
/// Description: 
/// Table： dhc_qm_data.Cycle
/// Input: rowId-数据行号，Cycleactive-是否有效
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.qm.udata.uCycle).LogicDelete("1")
ClassMethod LogicDelete(rowId) As %String
{
	n (rowId)
	
	&SQL(UPDATE dhc_qm_data.Cycle set Cycle_active ="N" where %ID=:rowId)
	q SQLCODE
}

/// Creator：黄凤杰
/// CreatDate：2015-6-12
/// Description: 修改记录
/// Table： dhc_qm_data.Cycle
/// Input: rowId-数据行号，Cyclecode-年度code，Cyclename-年度名称，Cycleactive-是否有效
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.qm.udata.uCycle).UpdateCycle("2","","SFAF")
ClassMethod UpdateCycle(rowId, Cyclecode, Cyclename, Cycleactive) As %String
{
	n (rowId, Cyclecode, Cyclename,Cycleactive)
	
	k PLIST	
	i Cyclecode=""       s Cyclecode=$list(^DHCCJXQMCycleD(rowId),2)
	i Cyclename=""       s Cyclename=$list(^DHCCJXQMCycleD(rowId),3)
	i Cycleactive=""       s Cycleactive=$list(^DHCCJXQMCycleD(rowId),4)
	
	
	/*s rowid=0
	s rowid=..IfRepSysOrganizationAffiliate(Code,Name,isStop,endDate)
	q:rowid>0 "IfRepSysOrganizationAffiliate"*/
	s tmpRowid=0
	s tmpRowid=..IfRepCode(Cyclecode)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(Cyclename)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	i Cyclecode      '="" s Plist(2)= Cyclecode       
	i Cyclename      '="" s Plist(3)= Cyclename
	i Cycleactive   '="" s Plist(4)= Cycleactive
	
  

	&SQL(UPDATE  dhc_qm_data.Cycle VALUES Plist() where %ID=:rowId)
	q SQLCODE
}

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 查询符合条件的记录
/// Table: dhc_qm_data.Cycle
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.qm.udata.uCycle).List("","",0,15,"","")
ClassMethod List(sortField, sortDir, start, limit, Cyclecode, Cyclename) As %String
{
	n (sortField,sortDir,start,limit,Cyclecode,Cyclename)
	s sqlStr="select Cycle_rowid,Cycle_code,Cycle_name,Cycle_active from dhc_qm_data.Cycle where 1=1  "
	i Cyclecode '="" s sqlStr=sqlStr_"and Cycle_code LIKE '%"_Cyclecode_"%'"
    i Cyclename '="" s sqlStr=sqlStr_"and Cycle_name LIKE '%"_Cyclename_"%'"
	
    
    ;w sqlStr!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="Rowid^Cyclecode^Cyclename^Cycleactive"
	While(result.Next())
	{   
		s Rowid= result.Data("Cycle_rowid")
		s Cyclecode= result.Data("Cycle_code")
		s Cyclename= result.Data("Cycle_name")
		s Cycleactive= result.Data("Cycle_active")
		i Cycleactive="N" d
		.s Cycleactive="否"
		e  d
		.s Cycleactive="是"
		
	//s IsValid= result.Data("org_affi_IsValid")
		 s tmp=Rowid_"^"_Cyclecode_"^"_Cyclename_"^"_Cycleactive
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 判断是否重复
/// Table: dhc_qm_data.Cycle
/// Input: rowId-数据行号
/// Output: 
/// Return: 
/// Others: w ##class(dhc.qm.udata.uCycle).IfRepCode("2")
ClassMethod IfRepCode(Cyclecode) As %String
{
	new (Cyclecode)
	s rowid=0
	s rowid=$o(^DHCCJXQMCycleI("IndexSysCode",Cyclecode,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 黄凤杰
/// CreatDate:2015-6-12
/// Description: 判断是否重复
/// Table: dhc_qm_data.Cycle
/// Input: rowId-数据行号
/// Output: 
/// Return: 
/// Others: w ##class(dhc.qm.udata.uCycle).IfRepName("2")
ClassMethod IfRepName(Cyclename) As %String
{
	new (Cyclename)
	s rowid=0
	s rowid=$o(^DHCCJXQMCycleI("IndexSysName",Cyclename,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

Storage Default
{
<StreamLocation>^dhc.qm.udata.uCycleS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
