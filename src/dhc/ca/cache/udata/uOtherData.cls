Class dhc.ca.cache.udata.uOtherData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-04
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DataItemTypes
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数,id-ID
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uDataItemTypes).ListRec("Y","shortcut","","","",0,10,"2")
ClassMethod getItemType(searchField, searchValue, sortField, sortDir, start, limit, active, id)
{
	;q active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_id
	n (active, searchField, searchValue, sortField, sortDir, start, limit, id)
	
	s sqlStr="SELECT DataItemTypes_rowid,DataItemTypes_order,DataItemTypes_code,DataItemTypes_name,DataItemTypes_shortcut,DataItemTypes_remark,DataItemTypes_active FROM dhc_ca_cache_data.DataItemTypes"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND DataItemTypes_active='"_active_"'"
	i id'="" s whereStr=whereStr_" AND DataItemTypes_rowid in ("_id_")"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="DataItemTypes_rowid"
	.i sortField="code" s sortField1="DataItemTypes_code"
	.i sortField="name" s sortField1="DataItemTypes_name"
	.i sortField="order" s sortField1="DataItemTypes_order"
	.i sortField="shortcut" s sortField1="DataItemTypes_shortcut"
	.i sortField="remark" s sortField1="DataItemTypes_remark"
	.i sortField="active" s sortField1="DataItemTypes_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^order^code^name^shortcut^remark^active"
	
	While(result.Next())
	{
		s rowid=result.Data("DataItemTypes_rowid")
		s code=result.Data("DataItemTypes_code")
		s name=result.Data("DataItemTypes_name")
		s shortcut=result.Data("DataItemTypes_shortcut")
		s order=result.Data("DataItemTypes_order")
		s remark=result.Data("DataItemTypes_remark")
		s active=result.Data("DataItemTypes_active")
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_remark_"^"_active
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="shortcut")&(shortcut'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="active")&(active'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 查询人员部门
/// Table: dhc.ca.cache.data.UnitPerson
/// Input：deptCode-人员ID
/// Output: 
/// Return: 返回待查人员的部门
/// Others: 
ClassMethod GetDept(deptCode) As %String
{
	q:deptCode="" ""
	s deptDr=""
 	s deptDr=$o(^DHCCAUNITDEPTS(0,"Code",deptCode,deptDr))
	q deptDr
}

/// Creator: 杨旭
/// CreatDate: 2010-3-4
/// Description: 刷新对应数据的部门与项目
/// Table: dhc.ca.cache.data.BaseData
/// Input: intervalDr-核算区间;deptSetDr-部门接口套ID;dataTypeDr-业务类别ID;
/// Output: 
/// Return: 0为成功
/// Others: w ##class(dhc.ca.cache.udata.uSalary).refreshRec(1,1,5)
ClassMethod RefreshRec(intervalDr, deptSetDr, dataTypeDr) As %String
{
	n (intervalDr,deptSetDr,dataTypeDr)

	TSTART
	s flag=0
	
	s sqlStr="SELECT BaseData_rowid,BaseData_sysDataType,BaseData_intervalDr,BaseData_servedDeptDr,BaseData_servedDeptCode,BaseData_servedDeptName,BaseData_dataTypeDr,BaseData_busDate,BaseData_itemDr,BaseData_itemCode,BaseData_itemName,BaseData_servDeptDr,BaseData_servDeptCode,BaseData_servDeptName,BaseData_serverDr,BaseData_serverCode,BaseData_serverName,BaseData_receiverDr,BaseData_receiverCode,BaseData_receiverName,BaseData_fee,BaseData_operType,BaseData_operDate,BaseData_operDr,BaseData_operDeptDr,BaseData_remark,BaseData_remark1,BaseData_remark2 FROM dhc_ca_cache_data.BaseData"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND BaseData_intervalDr='"_intervalDr_"' "
	i dataTypeDr'="" s whereStr=whereStr_"AND BaseData_dataTypeDr='"_dataTypeDr_"' "
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	
	//s deptSetDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",4)
	//s itemSetDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",5)
	//s itemTypeDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",6)
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		k PLIST
		s rowid=result.Data("BaseData_rowid")
		s itemCode=result.Data("BaseData_itemCode")
		s patType=""
	
		s itemDr=""
		S itemSetDr=1
		
		i ((itemCode'="")&(itemSetDr'="")) s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemSetDr,itemCode)
		//i ((itemCode'="")&(dataTypeDr'="")) s itemDr=##class(dhc.ca.cache.udata.uIncomeDatas).ItemRelation(dataTypeDr,itemCode)
		
		i itemDr'="" s PLIST(6)=itemDr
		s fDeptCode=""
		s fDeptDr=""
		s fDeptCode=result.Data("BaseData_servedDeptCode")

		i (fDeptCode'="")&(deptSetDr'="") d
		.s fDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,fDeptCode,patType)
		
		i (fDeptCode'="")&(deptSetDr="") d
		.s fDeptDr=..GetDept(fDeptCode)
		
		i fDeptDr'="" s PLIST(15)=fDeptDr
		
		&SQL(UPDATE dhc_ca_cache_data.BaseData VALUES PLIST() where %ID=:rowid)
		i SQLCODE'=0 s flag=SQLCODE
	}
	d result.Close()
	i flag=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	q flag
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 查询人员部门
/// Table: dhc.ca.cache.data.UnitPerson
/// Input：personId-人员ID
/// Output: 
/// Return: 返回待查人员的部门
/// Others: 
ClassMethod GetPersonDept(personId) As %String
{
	q:personId="" ""
	s resultStr=""
	s personDeptDr=""
	f  s personDeptDr=$o(^DHCCAUNITPERSONS(personId,"PersonDepts",personDeptDr)) q:personDeptDr=""  d
	.s tmpStr=$g(^DHCCAUNITPERSONS(personId,"PersonDepts",personDeptDr))
	.s deptDr=$p(tmpStr,"^",1)
	.s own=$p(tmpStr,"^",4)
	.i own="Y" s resultStr=deptDr
	q resultStr
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uOtherDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
