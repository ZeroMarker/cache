/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 接口核算部门表维护
Class dhc.ca.cache.udata.uOutDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.OutDepts
/// Input: parRef-借口套ID;inDeptDr-核算部门ID;code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uOutDepts).IfRepCode(4,1,1)
ClassMethod IfRepCode(parRef, inDeptDr, code, patType) As %String
{
	n (parRef, inDeptDr, code, patType)
	s rowid=0
	s inDeptDr=0
	s rs=0
	i patType="" d  //没有病人类型
	.s inDeptDr=$o(^DHCCAINDEPTSETS(0,"Outcode",parRef,code,inDeptDr))
	.i inDeptDr'="" s rs=inDeptDr
	e  d  //有病人类型
	.f  s inDeptDr=$o(^DHCCAINDEPTSETS(0,"Outcode",parRef,code,inDeptDr)) q:inDeptDr=""  d
	..s tmpId=""
	..s tmpId=$o(^DHCCAINDEPTSETS(0,"Outcode",parRef,code,inDeptDr,tmpId))
	..s tmpFalg=""
	..s tmpRow=""
	..//w "inDeptDr:"_inDeptDr_" parRef:"_parRef_" code:"_code_" tmpId:"_tmpId,!
	..i tmpId'="" d
	...s tmpRow=$g(^DHCCAINDEPTSETS(parRef,"In",inDeptDr,"Out",tmpId))
	...//w tmpRow,!
	...s tmpFalg=$p(tmpRow,"^",5)  //得到病人类型
	..i tmpFalg'="" d
	...i $d(^DHCCAINDEPTSETS(0,"OutCodePattype",parRef,code,inDeptDr,patType)) d //判断有什么病人类型的数据
	....s rs=inDeptDr
	...e  d
	....f  s rowid=$o(^DHCCAINDEPTSETS(0,"OutCodePattype",parRef,code,inDeptDr,patType,rowid)) q:rowid=""  d
	.....i rowid'="" d 
	......s rs=inDeptDr
	..e  d
	...s rs=inDeptDr
	q rs
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.OutDepts
/// Input: parRef-借口套ID;inDeptDr-核算部门ID;code-代码;order-序号;name-名称;remark-备注
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.uOutDepts).InsertRec(1,"1||224",5,"cb488","测试科室1","",11)
ClassMethod InsertRec(parRef, inDeptDr, order, code, name, patType, remark) As %String
{
	n (parRef, inDeptDr, order, code, name, patType, remark)
	
	q:code="" "EmptyCode"
	
	s rowid=0
	s rowid=..IfRepCode(parRef, inDeptDr, code, patType)
	//w rowid,!
	q:rowid'=0 $P($g(^DHCCAUNITDEPTS($p($g(^DHCCAINDEPTSETS(parRef,"InDepts",rowid)),"^",2))),"^",2)
	
	&SQL(INSERT INTO dhc_ca_cache_data.OutDepts(OutDepts_parRef,OutDepts_order,OutDepts_code,OutDepts_name,OutDepts_patType,OutDepts_remark) VALUES (:inDeptDr,:order,:code,:name,:patType,:remark))
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 更新记录
/// Table: dhc.ca.cache.data.OutDepts
/// Input: rowid-数据行号;parRef-借口套ID;inDeptDr-核算部门ID;code-代码;order-序号;name-名称;remark-备注
/// Output: 
/// Return: 
/// Others：w ##class(dhc.ca.cache.udata.uOutDepts).UpdateRec("5||9||9","5","5||9","2","2","2","I","")
ClassMethod UpdateRec(rowid, parRef, inDeptDr, order, code, name, patType, remark) As %String
{
	n (rowid, parRef, inDeptDr, order, code, name, patType, remark)
	//w "rowid:"_rowid_" parRef:"_parRef_" inDeptDr:"_inDeptDr_" order:"_order_" code:"_code_" name:"_name_" patType:"_patType_" remark:"_remark,!
	q:code="" "EmptyCode"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(parRef, inDeptDr, code, patType)
	s tmpId=""
	
	i patType'="" d
	.s tmpId=$o(^DHCCAINDEPTSETS(0,"OutCodePattype",parRef,code,tmpRowid,patType,tmpId))
	e  d
	.s tmpId=$o(^DHCCAINDEPTSETS(0,"Outcode",parRef,code,tmpRowid,tmpId))
	
	q:(tmpRowid'=0)&((parRef_"||"_tmpRowid_"||"_tmpId)'=rowid)&(tmpId'="") $P($g(^DHCCAUNITDEPTS($p($g(^DHCCAINDEPTSETS(parRef,"InDepts",tmpRowid)),"^",2))),"^",2)
	
	&SQL(UPDATE dhc_ca_cache_data.OutDepts SET OutDepts_order=:order,OutDepts_code=:code,OutDepts_name=:name,OutDepts_remark=:remark,OutDepts_patType=:patType WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.OutDepts
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOutDepts).ListRec("","","RowId","DESC",0,25,"1||1")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_parRef
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT OutDepts_parRef,OutDepts_rowid,OutDepts_order,OutDepts_code,OutDepts_name,OutDepts_patType,OutDepts_remark FROM dhc_ca_cache_data.OutDepts"
	
	s whereStr=" WHERE OutDepts_childSub>0"
	
	i parRef'="" s whereStr=whereStr_" AND OutDepts_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OutDepts_rowid"
	.i sortField="code" s sortField1="OutDepts_code"
	.i sortField="name" s sortField1="OutDepts_name"
	.i sortField="order" s sortField1="OutDepts_order"
	.i sortField="remark" s sortField1="OutDepts_remark"
	
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
	s jsonTitle="parRef^rowid^order^code^name^patType^remark"
	
	While(result.Next())
	{
		s parRef=result.Data("OutDepts_parRef")
		s rowid=result.Data("OutDepts_rowid")
		s order=result.Data("OutDepts_order")
		s code=result.Data("OutDepts_code")
		s name=result.Data("OutDepts_name")
		s patType=result.Data("OutDepts_patType")
		i patType="I" s patType="住院"
		i patType="O" s patType="门诊"
		i patType="H" s patType="体检"
		s remark=result.Data("OutDepts_remark")
		
	
	
		s tmp=parRef_"^"_rowid_"^"_order_"^"_code_"^"_name_"^"_patType_"^"_remark
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)&(code'[searchValue)
		.q:(searchField="patType")&(patType'[searchValue)
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
	&SQL(DELETE FROM dhc_ca_cache_data.OutDepts WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 删除记录
/// Table: dhc.ca.cache.data.OutDepts
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uOutDepts).ListRecTwo(1,0,10)
ClassMethod ListRecTwo(inDeptSetsId, start, limit) As %String
{
	i inDeptSetsId="" s inDeptSetsId=0
	n (inDeptSetsId, start, limit)
	s count=0
	s resultString=""
	s end=start+limit-1
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^order^code^name^remark^patType"
	s inDeptsId=""
	f  s inDeptsId=$o(^DHCCAINDEPTSETS(inDeptSetsId,"In",inDeptsId)) q:inDeptsId=""  d
	.s outDeptsId=""
	.f  s outDeptsId=$o(^DHCCAINDEPTSETS(inDeptSetsId,"In",inDeptsId,"Out",outDeptsId)) q:outDeptsId=""  d
	..q:outDeptsId=0
	..s order=""
	..s code=""
	..s name=""
	..s remark=""
	..s order=$p($g(^DHCCAINDEPTSETS(inDeptSetsId,"In",inDeptsId,"Out",outDeptsId)),"^",1)
	..s code =$p($g(^DHCCAINDEPTSETS(inDeptSetsId,"In",inDeptsId,"Out",outDeptsId)),"^",2)
	..s name =$p($g(^DHCCAINDEPTSETS(inDeptSetsId,"In",inDeptsId,"Out",outDeptsId)),"^",3)
	..s remark=$p($g(^DHCCAINDEPTSETS(inDeptSetsId,"In",inDeptsId,"Out",outDeptsId)),"^",4)
	..s patType=$p($g(^DHCCAINDEPTSETS(inDeptSetsId,"In",inDeptsId,"Out",outDeptsId)),"^",5)
	..i patType="I" s patType="住院"
	..i patType="O" s patType="门诊"
	..i patType="H" s patType="体检"
	..s tmp="^"_order_"^"_code_"^"_name_"^"_remark_"^"_patType
	..i (count>=start)&(count<=end) d
	...d json.InsertRowData(tmp)
	..s count=count+1
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Others: w ##class(dhc.ca.cache.udata.uOutDepts).outDeptsChange("1||223","1||223||14","cb489","测试科室2","","22")
ClassMethod outDeptsChange(inDeptId, rowid, code, name, patType, remark) As %String [ SqlProc ]
{
    n (inDeptId,rowid,code,name,patType,remark)
    q:(inDeptId="")||(rowid="") "IdNull"
    s Time=$zd($h,8)
    &sql(select OutDepts_parRef,OutDepts_order into :oldInDeptId, :order from dhc_ca_cache_data.OutDepts where OutDepts_rowid=:rowid)
    //&sql(select max(OutDepts_order) into :maxOrder from dhc_ca_cache_data.OutDepts where OutDepts_parRef=:oldInDeptId and OutDepts_childSub>0)
    &sql(SELECT InDepts_deptDr->unitdepts_code into :newIndeptcode FROM dhc_ca_cache_data.InDepts WHERE InDepts_childSub>0 and InDepts_rowid=:inDeptId)
    &sql(update dhc_ca_cache_data.OutDepts set OutDepts_code=OutDepts_code||'-'||:Time||'-'||:newIndeptcode where OutDepts_rowid=:rowid)
    &sql(select max(OutDepts_order)+1 into :newOrder from dhc_ca_cache_data.OutDepts where OutDepts_parRef=:inDeptId and OutDepts_childSub>0)
    i newOrder="" s newOrder=1	//zjw  针对新接口部门尚未有接口
    &sql(insert into dhc_ca_cache_data.OutDepts (OutDepts_parRef,OutDepts_order,OutDepts_code,OutDepts_name,OutDepts_remark,OutDepts_patType)
    values (:inDeptId,:newOrder,:code,:name,:remark,:patType))
    //i maxOrder>order d
    //.&sql(update dhc_ca_cache_data.OutDepts set OutDepts_order=OutDepts_order-1 where OutDepts_parRef=:oldInDeptId and OutDepts_order>:order and OutDepts_childSub>0)
    q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uOutDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
