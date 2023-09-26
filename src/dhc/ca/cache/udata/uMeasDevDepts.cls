/// Creator: 王赢赢
/// CreatDate: 2009-10-15
/// Description: 计量表计部门
Class dhc.ca.cache.udata.uMeasDevDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-10-15
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.MeasDevDepts
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uMeasDevDepts).IfRepDept("3","3")
ClassMethod IfRepDept(deptDr, parRef) As %String
{
	n (deptDr,parRef)
	s rowid=0
	s rowid=$o(^DHCCAUNITMEASDEV(0,"DeptDevs",deptDr,parRef,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-15
/// Description: 验证百分比
/// Table: dhc.ca.cache.data.MeasDevDepts
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uPhoneDepts).CheckPercent("3")
ClassMethod CheckPercent(rowid) As %String
{
	n (rowid)
	s sqlStr="SELECT MeasDevDepts_parRef,MeasDevDepts_rowid,MeasDevDepts_deptDr,MeasDevDepts_rate,MeasDevDepts_inputPersonDr FROM dhc_ca_cache_data.MeasDevDepts WHERE %ID>0"
	
	i (rowid'="") s sqlStr=sqlStr_" AND MeasDevDepts_parRef ='"_rowid_"'"
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString=0
	
	While(result.Next())
	{
		
		s rate=result.Data("MeasDevDepts_rate")
		s resultString=resultString+rate
		
	}

	d result.Close()
	q resultString
}

/// Creator：王赢赢
/// CreatDate：2009-10-15
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.MeasDevDepts
/// Input：parRef-单位计量表计;deptDr-部门Dr;rate-比例;inputPersonDr-录入人Dr;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uMeasDevDepts).InsertRec(4,1,25,1)
ClassMethod InsertRec(parRef, deptDr, rate, inputPersonDr) As %String
{
	
	n (parRef, deptDr, rate, inputPersonDr)

	
	s rowid=0
	s rowid=..IfRepDept(deptDr,parRef)
	q:rowid>0 "RepDept"
	
	&sql(insert into dhc_ca_cache_data.MeasDevDepts (MeasDevDepts_parRef,MeasDevDepts_deptDr,MeasDevDepts_rate,MeasDevDepts_inputPersonDr) values(:parRef,:deptDr,:rate,:inputPersonDr))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-10-15
/// Description: 更新记录
/// Table：dhc.ca.cache.data.MeasDevDepts
/// Input：parRef-单位电话Dr;deptDr-部门Dr;rate-比例;inputPersonDr-录入人Dr;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uMeasDevDepts).UpdateRec(4,"4||1",2,80,3)
ClassMethod UpdateRec(parRef, rowId, deptDr, rate, inputPersonDr) As %String
{
	
	n (parRef, rowId, deptDr, rate, inputPersonDr)
	
	//s deptDrDr=0
	//s deptDrDr=$o(^DHCCAUNITDEPTS(0,"Name",deptDr,deptDrDr))
	
	s tmpRowid=0
	s tmpRowid=..IfRepDept(deptDr,parRef)
	q:(tmpRowid'=0)&(tmpRowid'=$p(rowId,"||",2)) "RepDept"
	
	&sql(update dhc_ca_cache_data.MeasDevDepts set MeasDevDepts_deptDr=:deptDr,MeasDevDepts_rate=:rate,MeasDevDepts_inputPersonDr=:inputPersonDr where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-15
/// Description: 删除记录
/// Table：dhc.ca.cache.data.MeasDevDepts
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uMeasDevDepts).DelRec("4||1")
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.MeasDevDepts WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-15
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.MeasDevDepts
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uMeasDevDepts).ListRec("1","","","","",0,25)
ClassMethod ListRec(parRef, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="select MeasDevDepts_rowid,MeasDevDepts_deptDr,MeasDevDepts_rate,MeasDevDepts_inputPersonDr from dhc_ca_cache_data.MeasDevDepts where MeasDevDepts_childSub>0 and MeasDevDepts_parRef="_parRef
	
	s whereStr=" and %ID>0"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="MeasDevDepts_rowid"
	.i sortField="deptDr" s sortField1="MeasDevDepts_deptDr"
	.i sortField="rate" s sortField1="MeasDevDepts_rate"
	.i sortField="inputPersonDr" s sortField1="MeasDevDepts_inputPersonDr"
	
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
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^deptDr^rate^inputPersonDr^deptCode^deptName^inputPersonName^deptShortCut"
	
	While(result.Next())
	{
		s rowId=result.Data("MeasDevDepts_rowid")
		s deptDr=result.Data("MeasDevDepts_deptDr")
		s rate=result.Data("MeasDevDepts_rate")
		s inputPersonDr=result.Data("MeasDevDepts_inputPersonDr")
		
		s deptName=""
		i deptDr'="" d
		.i $d(^DHCCAUNITDEPTS(deptDr)) d
		..s deptCode=$p(^DHCCAUNITDEPTS(deptDr),"^",1)
		..s deptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
		..s deptShortCut=$p(^DHCCAUNITDEPTS(deptDr),"^",3)
		
		s inputPersonName=""
		i inputPersonDr'="" d
		.i $d(^DHCCAUNITPERSONS(inputPersonDr)) d
		..s inputPersonName=$p(^DHCCAUNITPERSONS(inputPersonDr),"^",2)		
		
		s tmp=rowId_"^"_deptDr_"^"_rate_"^"_inputPersonDr_"^"_deptCode_"^"_deptName_"^"_inputPersonName_"^"_deptShortCut
		
		i searchValue'="" d
		.q:(searchField = "deptDr")&(deptDr'[searchValue)
		.q:(searchField = "rate")&(rate'[searchValue)
		.q:(searchField = "inputPersonDr")&(inputPersonDr'[searchValue)
		.q:(searchField = "deptShortCut")&(deptShortCut'[searchValue)
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
/// CreatDate: 2009-11-12
/// Description: 获得用户DR
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).CheckUser(1)
ClassMethod CheckUser(userCode) As %String
{
	n (userCode)
	
	q:userCode="" 0
	s userDr =0
	s userDr=$o(^DHCCAUSERS(0,"Loginname",userCode,userDr))
	s personDr=0
	i userDr>0 d
	.s personDr=$p($g(^DHCCAUSERS(userDr)),"^",4)
	s flag="N"
	i personDr>0 d
	.s flag=$p($g(^DHCCAUNITPERSONS(personDr)),"^",18)
	i flag="" s flag="N"
	i flag="N" s personDr=0
	q personDr
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uMeasDevDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
