/// Creator: 杨旭
/// CreatDate: 2010-03-24
/// Description: 数据类别码表维护
Class dhc.ca.cache.udata.uLargCost Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-24
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.LargCost
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uLargCost).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(vouchDate, vouchNum, abstract, deptDr, itemDr, fee, calFlag, cycles, inPersonDr) As %String
{
	n (vouchDate, vouchNum, abstract, deptDr, itemDr, fee, calFlag, cycles, inPersonDr)
	
	q:deptDr="" "EmptyDeptDr"
	q:itemDr="" "EmptyItemDr"
	
	i vouchDate'="" s vouchDate=$zdh(vouchDate,3)
	s inDate=$p($h,",",1)
	s calFlag="N"
	&SQL(INSERT INTO dhc_ca_cache_data.LargCost (LargCost_vouchDate,LargCost_vouchNum,LargCost_abstract,LargCost_deptDr,LargCost_itemDr,LargCost_fee,LargCost_calFlag,LargCost_cycles,LargCost_inPersonDr,LargCost_inDate) VALUES (:vouchDate, :vouchNum, :abstract, :deptDr, :itemDr, :fee, :calFlag, :cycles, :inPersonDr, :inDate))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-24
/// Description: 更新记录
/// Table: dhc.ca.cache.data.LargCost
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uLargCost).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, vouchDate, vouchNum, abstract, deptDr, itemDr, fee, calFlag, cycles, inPersonDr) As %String
{
	n (rowid, vouchDate, vouchNum, abstract, deptDr, itemDr, fee, calFlag, cycles, inPersonDr)
	
	i vouchDate'="" s vouchDate=$zdh(vouchDate,3)
	s inDate=$p($h,",",1)

	&SQL(UPDATE dhc_ca_cache_data.LargCost SET LargCost_vouchDate=:vouchDate,LargCost_vouchNum=:vouchNum,LargCost_abstract=:abstract,LargCost_deptDr=:deptDr,LargCost_itemDr=:itemDr,LargCost_fee=:fee,LargCost_calFlag=:calFlag,LargCost_cycles=:cycles,LargCost_inPersonDr=:inPersonDr,LargCost_inDate=:inDate WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-24
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.LargCost
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uLargCost).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT LargCost_rowid,LargCost_vouchDate,LargCost_vouchNum,LargCost_abstract,LargCost_deptDr,LargCost_itemDr,LargCost_fee,LargCost_calFlag,LargCost_cycles,LargCost_inPersonDr,LargCost_inDate FROM dhc_ca_cache_data.LargCost"
	
	s whereStr=" WHERE %ID>0"
	
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="LargCost_rowid"
	.i sortField="vouchDate" s sortField1="LargCost_vouchDate"
	.i sortField="vouchNum" s sortField1="LargCost_vouchNum"
	.i sortField="abstract" s sortField1="LargCost_abstract"
	.i sortField="deptName" s sortField1="LargCost_deptDr"
	.i sortField="itemName" s sortField1="LargCost_itemDr"
	.i sortField="fee" s sortField1="LargCost_fee"
	.i sortField="calFlag" s sortField1="LargCost_calFlag"
	.i sortField="cycles" s sortField1="LargCost_cycles"
	.i sortField="inPersonName" s sortField1="LargCost_inPersonDr"
	.i sortField="inDate" s sortField1="LargCost_inDate"
	
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
	s jsonTitle="rowid^vouchDate^vouchNum^abstract^deptDr^deptName^itemDr^itemName^fee^calFlag^cycles^inPersonDr^inPersonName^inDate"
	
	While(result.Next())
	{
		s rowid=result.Data("LargCost_rowid")
		s vouchDate=result.Data("LargCost_vouchDate")
		i vouchDate'="" d
		.s vouchDate=$zd(vouchDate,3)
		
		s vouchNum=result.Data("LargCost_vouchNum")
		s abstract=result.Data("LargCost_abstract")
		s deptDr=result.Data("LargCost_deptDr")
		s deptName=""
		i deptDr'="" d
		.i $d(^DHCCAUNITDEPTS(deptDr)) d
		..s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		
		s itemDr=result.Data("LargCost_itemDr")
		s itemName="" 
		i itemDr'="" d
		.i $d(^DHCCAALLDATAITEMS(itemDr)) d
		..s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("LargCost_fee")
		s calFlag=result.Data("LargCost_calFlag")
		s cycles=result.Data("LargCost_cycles")
		s inPersonDr=result.Data("LargCost_inPersonDr")
		s inPersonName=""
		i inPersonDr'="" d
		.i $d(^DHCCAUNITPERSONS(inPersonDr)) d
		..s inPersonName=$p($g(^DHCCAUNITPERSONS(inPersonDr)),"^",2)
		
		s inDate=result.Data("LargCost_inDate")
		i inDate'="" d
		.s inDate=$zd(inDate,3)
		
		s tmp=rowid_"^"_vouchDate_"^"_vouchNum_"^"_abstract_"^"_deptDr_"^"_deptName_"^"_itemDr_"^"_itemName_"^"_fee_"^"_calFlag_"^"_cycles_"^"_inPersonDr_"^"_inPersonName_"^"_inDate
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="vouchDate")&(vouchDate'[searchValue)
		.q:(searchField="vouchNum")&(vouchNum'[searchValue)
		.q:(searchField="abstract")&(abstract'[searchValue)
		.q:(searchField="deptName")&(deptName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="cycles")&(cycles'[searchValue)
		.q:(searchField="inPersonName")&(inPersonName'[searchValue)
		.q:(searchField="inDate")&(inDate'[searchValue)
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
/// CreatDate: 2010-03-24
/// Description: 删除记录
/// Table: dhc.ca.cache.data.LargCost
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.LargCost WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uLargCostS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
