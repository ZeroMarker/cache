Class dhc.ca.cache.udata.uOutPerson Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.PersonSets
/// Input: name-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uOutPerson).IfRepName("1",3)
ClassMethod IfRepOrder(order, setDr) As %String
{
	n (order,setDr)
	s rowid=0
	s flag=0
	f  s rowid =$o(^DHCCAOUTPERSON(0,"OutOrder",order,rowid)) q:rowid=""  d
	.s inperson=""
	.i rowid'=0 s inperson=$p($g(^DHCCAOUTPERSON(rowid)),"^",6)
	.i inperson'="" d
	..s tmpDr=""
	..s tmpDr=$p($g(^DHCCAINPERSON(inperson)),"^",3)
	..s tmpName=""
	..i tmpDr'="" s tmpName=$p($g(^DHCCAUNITPERSONS(tmpDr)),"^",2)
	..s setid=""
	..i inperson'="" s setid=$p($g(^DHCCAINPERSON(inperson)),"^",4)
	..i setDr=setid s flag=tmpName
	q flag
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.PersonSets
/// Input: name-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uOutPerson).IfRepName("1",3)
ClassMethod IfRepName(name, setDr) As %String
{
	n (name,setDr)
	s rowid=0
	s flag=0
	f  s rowid =$o(^DHCCAOUTPERSON(0,"OutName",name,rowid)) q:rowid=""  d
	.s inperson=""
	.i rowid'=0 s inperson=$p($g(^DHCCAOUTPERSON(rowid)),"^",6)
	.i inperson'="" d
	..s tmpDr=""
	..s tmpDr=$p($g(^DHCCAINPERSON(inperson)),"^",3)
	..s tmpName=""
	..i tmpDr'="" s tmpName=$p($g(^DHCCAUNITPERSONS(tmpDr)),"^",2)
	..s setid=""
	..i inperson'="" s setid=$p($g(^DHCCAINPERSON(inperson)),"^",4)
	..i setDr=setid s flag=tmpName
	q flag
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.PersonSets
/// Input: name-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uOutPerson).IfRepName("1",3)
ClassMethod IfRepCode(code, setDr) As %String
{
	n (code,setDr)
	s rowid=0
	s flag=0
	f  s rowid =$o(^DHCCAOUTPERSON(0,"OutCode",code,rowid)) q:rowid=""  d
	.s inperson=""
	.i rowid'=0 s inperson=$p($g(^DHCCAOUTPERSON(rowid)),"^",6)
	.i inperson'="" d
	..s tmpDr=""
	..s tmpDr=$p($g(^DHCCAINPERSON(inperson)),"^",3)
	..s tmpName=""
	..i tmpDr'="" s tmpName=$p($g(^DHCCAUNITPERSONS(tmpDr)),"^",2)
	..s setid=""
	..i inperson'="" s setid=$p($g(^DHCCAINPERSON(inperson)),"^",4)
	..i setDr=setid s flag=tmpName
	q flag
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.OutPerson
/// Input: parRef-借口套ID;inDeptDr-核算部门ID;code-代码;order-序号;name-名称;remark-备注
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.uOutPerson).InsertRec(2,"code","name","remark",1)
ClassMethod InsertRec(order, code, name, remark, inPersonDr, setDr) As %String
{
	n (order, code, name, remark, inPersonDr, setDr)
	s rs=0
	s rs=..IfRepOrder(order,setDr)
	q:rs'=0 rs	
	s rs=..IfRepCode(code,setDr)
	q:rs'=0 rs	
	s rs=..IfRepName(name,setDr)
	q:rs'=0 rs	
	&SQL(INSERT INTO dhc_ca_cache_data.OutPerson(OutPerson_order,OutPerson_code,OutPerson_name,OutPerson_remark,OutPerson_inPersonDr) VALUES (:order, :code, :name, :remark, :inPersonDr))
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InPerson
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInPerson).ListRec("","","","",0,25,1)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="select OutPerson_rowid,OutPerson_order,OutPerson_code,OutPerson_name,OutPerson_remark,OutPerson_InPersonDr,OutPerson_InPersonDr->InPerson_personDr->UnitPersons_name as InPersonName,OutPerson_InPersonDr->InPerson_personDr->UnitPersons_code as InPersonCode from dhc_ca_cache_data.OutPerson"
	
	s whereStr=" where %ID>0"
	i parRef'="" s whereStr=whereStr_" AND OutPerson_InPersonDr='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OutPerson_rowid"
	.i sortField="order" s sortField1="OutPerson_order"
	.i sortField="remark" s sortField1="OutPerson_remark"
	.i sortField="outPersonCode" s sortField1="OutPerson_code"
	.i sortField="outPersonName" s sortField1="OutPerson_name"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^order^remark^inPersonDr^inPersonCode^inPersonName^outPersonCode^outPersonName"
		
	While(result.Next())
	{
		
		s rowid=result.Data("OutPerson_rowid")
		s order=result.Data("OutPerson_order")
		s remark=result.Data("OutPerson_remark")
		s inPersonDr=result.Data("OutPerson_InPersonDr")
		s inPersonName=result.Data("InPersonName")
		s inPersonCode=result.Data("InPersonCode")
		s outPersonCode=result.Data("OutPerson_code")
		s outPersonName=result.Data("OutPerson_name")
		
	
		s tmp=rowid_"^"_order_"^"_remark_"^"_inPersonDr_"^"_inPersonCode_"^"_inPersonName_"^"_outPersonCode_"^"_outPersonName
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="code")&(outPersonCode'[searchValue)
		.q:(searchField="name")&(outPersonName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
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
/// CreatDate: 2009-10-22
/// Description: 删除记录
/// Table: dhc.ca.cache.data.OutDepts
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.OutDepts).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.OutPerson WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2010-10-28
/// Description: 查询所有记录
/// Table: dhc.ca.cache.data.InPerson
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOutPerson).ListAllRec("","","","",0,25,1)
ClassMethod ListAllRec(searchField, searchValue, sortField, sortDir, start, limit, parParRef)
{
	n (parParRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s tmpIPs=""
	s tmpIPdr=1
	f  s tmpPSdr=$p($g(^DHCCAINPERSON(tmpIPdr)),"^",4) q:tmpPSdr=""  d
	.;w tmpPSdr,!
	.i tmpPSdr=parParRef d
	..i tmpIPs="" d
	...s tmpIPs=tmpIPdr
	..e  d
	...s tmpIPs=tmpIPs_","_tmpIPdr
	.s tmpIPdr=tmpIPdr+1
	;w tmpPSs
	
	s sqlStr="select OutPerson_rowid,OutPerson_order,OutPerson_code,OutPerson_name,OutPerson_remark,OutPerson_InPersonDr,OutPerson_InPersonDr->InPerson_personDr->UnitPersons_name as InPersonName,OutPerson_InPersonDr->InPerson_personDr->UnitPersons_code as InPersonCode from dhc_ca_cache_data.OutPerson"
	
	s whereStr=" where %ID>0"
	i parParRef'="" s whereStr=whereStr_" AND OutPerson_InPersonDr in("_tmpIPs_")"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OutPerson_rowid"
	.i sortField="order" s sortField1="OutPerson_order"
	.i sortField="remark" s sortField1="OutPerson_remark"
	.i sortField="outPersonCode" s sortField1="OutPerson_code"
	.i sortField="outPersonName" s sortField1="OutPerson_name"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^order^remark^inPersonDr^inPersonCode^inPersonName^outPersonCode^outPersonName"
		
	While(result.Next())
	{
		
		s rowid=result.Data("OutPerson_rowid")
		s order=result.Data("OutPerson_order")
		s remark=result.Data("OutPerson_remark")
		s inPersonDr=result.Data("OutPerson_InPersonDr")
		s inPersonName=result.Data("InPersonName")
		s inPersonCode=result.Data("InPersonCode")
		s outPersonCode=result.Data("OutPerson_code")
		s outPersonName=result.Data("OutPerson_name")
		
	
		s tmp=rowid_"^"_order_"^"_remark_"^"_inPersonDr_"^"_inPersonCode_"^"_inPersonName_"^"_outPersonCode_"^"_outPersonName
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="code")&(outPersonCode'[searchValue)
		.q:(searchField="name")&(outPersonName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
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

Storage Default
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^dhc.ca.c.uOutPersonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
