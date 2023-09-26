/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 科室类别分配规则
Class dhc.ca.cache.udata.uInDeptTypeRules Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDeptTypeRules
/// Input: parRef-收入分配规则;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(parRef) As %String
{
	n (parRef)
	S resultStr=0
	&SQL(INSERT INTO dhc_ca_cache_data.InDeptTypeRules (InDeptTypeRules_parRef,InDeptTypeRules_deptType,InDeptTypeRules_percent) VALUES (:parRef,1,0))
	i SQLCODE'="" S resultStr=SQLCODE
	&SQL(INSERT INTO dhc_ca_cache_data.InDeptTypeRules (InDeptTypeRules_parRef,InDeptTypeRules_deptType,InDeptTypeRules_percent) VALUES (:parRef,2,0))
	i SQLCODE'="" S resultStr=SQLCODE
	&SQL(INSERT INTO dhc_ca_cache_data.InDeptTypeRules (InDeptTypeRules_parRef,InDeptTypeRules_deptType,InDeptTypeRules_percent) VALUES (:parRef,3,0))
	i SQLCODE'="" S resultStr=SQLCODE
	q resultStr
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InDeptTypeRules
/// Input: parRef-收入分配规则;fdept-开单部门比率;tdept-接收部门比率;patdept-病人部门比率;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(parRef, fdept, tdept, patdept) As %String
{
	n (parRef,fdept,tdept,patdept)
	TSTART
	S resultStr=0
	s resultStr=..DelRec(parRef)
	&SQL(INSERT INTO dhc_ca_cache_data.InDeptTypeRules (InDeptTypeRules_parRef,InDeptTypeRules_deptType,InDeptTypeRules_percent) VALUES (:parRef,1,:fdept))
	i SQLCODE'="" S resultStr=SQLCODE
	&SQL(INSERT INTO dhc_ca_cache_data.InDeptTypeRules (InDeptTypeRules_parRef,InDeptTypeRules_deptType,InDeptTypeRules_percent) VALUES (:parRef,2,:tdept))
	i SQLCODE'="" S resultStr=SQLCODE
	&SQL(INSERT INTO dhc_ca_cache_data.InDeptTypeRules (InDeptTypeRules_parRef,InDeptTypeRules_deptType,InDeptTypeRules_percent) VALUES (:parRef,3,:patdept))
	i SQLCODE'="" S resultStr=SQLCODE
	i resultStr=0 TCOMMIT
	e  TROLLBACK
	q resultStr
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDeptTypeRules
/// Input: parRef-收入分配规则,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: 
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parRef)
	
	s sqlStr="SELECT InDeptTypeRules_rowid,InDeptTypeRules_deptType,InDeptTypeRules_percent FROM dhc_ca_cache_data.InDeptTypeRules"
	
	s whereStr=" WHERE InDeptTypeRules_childSub>0"
	i parRef'="" s whereStr=whereStr_" AND InDeptTypeRules_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InDeptTypeRules_rowid"
	.i sortField="deptType" s sortField1="InDeptTypeRules_deptType"
	.i sortField="percent" s sortField1="InDeptTypeRules_percent"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^deptType^percent"
	
	While(result.Next())
	{
		s rowid=result.Data("InDeptTypeRules_rowid")
		s deptType=result.Data("InDeptTypeRules_deptType")
		i deptType="1" s deptType="开单科室"
		i deptType="2" s deptType="接收科室"
		i deptType="3" s deptType="病人科室"
		s percent=result.Data("InDeptTypeRules_percent")
		s tmp=rowid_"^"_deptType_"^"_percent
			
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InDeptTypeRules
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: 
ClassMethod DelRec(parRef) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDeptTypeRules WHERE InDeptTypeRules_parRef=:parRef)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInDeptTypeRulesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
