/// Creator: 杨旭
/// CreatDate: 2010-01-28
/// Description: 数据类别码表维护
Class dhc.ca.cache.udata.uInnerDeptControl Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-01-28
/// Description: 判断原始部门是否重复
/// Table: dhc.ca.cache.data.InnerDeptControl
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInnerDeptControl).IfRepOldDept("1")
ClassMethod IfRepOldDept(oldDeptDr) As %String
{
	n (oldDeptDr)
	s rowid=0
	s rowid=$o(^DHCCAINNERDEPTCONTROL(0,"OldDept",oldDeptDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-01-28
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InnerDeptControl
/// Input: oldDeptDr-原始部门Dr; newDeptDr-转换成部门Dr;
/// Output: 
/// Return: 原始科室为空,返回"EmptyoldDeptDr";原始科室存在,返回"RepoldDeptDr";转化成的科室为空,返回"EmptynewDeptDr";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uInnerDeptControl).InsertRec(1,1)
ClassMethod InsertRec(oldDeptDr, newDeptDr) As %String
{
	n (oldDeptDr, newDeptDr)
	
	q:oldDeptDr="" "EmptyoldDeptDr"
	q:newDeptDr="" "EmptynewDeptDr"
	
	s rowid=0
	s rowid=..IfRepOldDept(oldDeptDr)
	q:rowid>0 "RepoldDeptDr"

	&SQL(INSERT INTO dhc_ca_cache_data.InnerDeptControl (InnerDeptControl_oldDeptDr,InnerDeptControl_newDeptDr) VALUES (:oldDeptDr,:newDeptDr))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-01-27
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InnerDeptControl
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInnerDeptControl).ListRec("sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InnerDeptControl_rowid,InnerDeptControl_oldDeptDr,InnerDeptControl_newDeptDr FROM dhc_ca_cache_data.InnerDeptControl"
	
	s whereStr=" WHERE %ID>0"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InnerDeptControl_rowid"
	.i sortField="oldDeptName" s sortField1="InnerDeptControl_oldDeptDr"
	.i sortField="newDeptName" s sortField1="InnerDeptControl_newDeptDr"
	
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
	s jsonTitle="rowid^oldDeptDr^oldDeptName^newDeptDr^newDeptName"
	
	While(result.Next())
	{
		s rowid=result.Data("InnerDeptControl_rowid")
		s oldDeptDr=result.Data("InnerDeptControl_oldDeptDr")
		s oldDeptName=""
		i oldDeptDr'="" d
		.i $d(^DHCCAUNITDEPTS(oldDeptDr)) d
		..s oldDeptName=$p(^DHCCAUNITDEPTS(oldDeptDr),"^",2)
		s newDeptDr=result.Data("InnerDeptControl_newDeptDr")
		s newDeptName=""
		i newDeptDr'="" d
		.i $d(^DHCCAUNITDEPTS(newDeptDr)) d
		..s newDeptName=$p(^DHCCAUNITDEPTS(newDeptDr),"^",2)
	
		s tmp=rowid_"^"_oldDeptDr_"^"_oldDeptName_"^"_newDeptDr_"^"_newDeptName
		
		i searchValue'="" d
		.q:(searchField="newDeptName")&(newDeptName'[searchValue)
		.q:(searchField="oldDeptName")&(oldDeptName'[searchValue)
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
/// CreatDate: 2010-01-27
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InnerDeptControl
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uInnerDeptControl).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InnerDeptControl WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInnerDeptControlS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
