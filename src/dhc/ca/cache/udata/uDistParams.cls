/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 分摊参数定义码表维护
Class dhc.ca.cache.udata.uDistParams Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.DistParams
/// Input: parRef-方法套ID, paramType-参数类型, itemDr-项目ID, right-权重
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDistParams).InsertRec("1||15","cost","4","12")
ClassMethod InsertRec(parRef, paramType, itemDr, right) As %String
{
	n (parRef, paramType, itemDr, right)
	
	&SQL(INSERT INTO dhc_ca_cache_data.DistParams (DistParams_parRef,DistParams_paramType,DistParams_itemDr,DistParams_right) VALUES (:parRef, :paramType, :itemDr, :right))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DistParams
/// Input: parRef-方法ID,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uDistParams).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parRef)
	
	s sqlStr="SELECT DistParams_rowid,DistParams_paramType,DistParams_itemDr,DistParams_right FROM dhc_ca_cache_data.DistParams"
	
	s whereStr=" WHERE DistParams_childSub>0"
	i parRef'="" s whereStr=whereStr_" and DistParams_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="DistParams_rowid"
	.i sortField="itemCode" s sortField1="DistParams_itemDr"
	.i sortField="itemName" s sortField1="DistParams_itemDr"
	.i sortField="paramType" s sortField1="DistParams_paramType"
	.i sortField="right" s sortField1="DistParams_right"
	
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
	s jsonTitle="rowid^paramType^itemDr^itemCode^itemName^right"
	
	While(result.Next())
	{
		s rowid=result.Data("DistParams_rowid")
		s itemDr=result.Data("DistParams_itemDr")
		s itemName=""
		s itemCode=""
		i itemDr'="" d
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		.s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		s paramType=result.Data("DistParams_paramType")
		i paramType="income" s paramType="收入"
		i paramType="param" s paramType="参数"
		i paramType="cost" s paramType="成本"
		s right=result.Data("DistParams_right")
	
		s tmp=rowid_"^"_paramType_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_right
		
		i searchValue'="" d
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="paramType")&(paramType'[searchValue)
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

/// Creator：杨旭
/// CreatDate：2009-12-23
/// Description: 删除记录
/// Table：dhc.ca.cache.data.CostDistMethods
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.DistParams WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 查看是否已经存在此记录
/// Table: dhc.ca.cache.data.DistParams
/// Input: parRef-方法套ID, itemDr-项目ID
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uDistParams).checkExist("1||15",127)
ClassMethod checkExist(parRef, itemDr)
{
	n (parRef,itemDr)
	
	s sqlStr="SELECT DistParams_rowid,DistParams_itemDr FROM dhc_ca_cache_data.DistParams"
	
	s whereStr=" WHERE DistParams_childSub>0"
	i parRef'="" s whereStr=whereStr_" and DistParams_parRef='"_parRef_"'"
	i itemDr'="" s whereStr=whereStr_" and DistParams_itemDr='"_itemDr_"'"
	s rs=0
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()

	d result.Prepare(sqlStr)
	d result.Execute()

	
	While(result.Next())
	{
		s rs=1
	}
	q rs
}

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: parRef-方法套ID, dataTypeDr-业务类别ID, searchField-查询对象, searchValue-查询内容, sortField-排序字段, sortDir-顺序, start-起始行号, limit-数量
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others:
ClassMethod ListItems(parRef, dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT DataItemCorres_rowid,DataItemCorres_typeDr,DataItemCorres_order,DataItemCorres_itemDr FROM dhc_ca_cache_data.DataItemCorres"
	
	s whereStr=" WHERE %ID>0"
	
	i dataTypeDr'="" d
	s whereStr=whereStr_" AND DataItemCorres_typeDr='"_dataTypeDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="DataItemCorres_rowid"
	.i sortField="typeName" s sortField1="DataItemCorres_typeDr"
	.i sortField="order" s sortField1="DataItemCorres_order"
	.i sortField="itemName" s sortField1="DataItemCorres_itemDr"
	
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
	s end=start+limit
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^typeDr^typeName^typeShortCut^order^itemDr^itemCode^itemName^itemShortCut^itemFlag"
	
	While(result.Next())
	{
		s rowid=result.Data("DataItemCorres_rowid")
		s typeDr=result.Data("DataItemCorres_typeDr")
		s typeName=""
		s typeShortCut=""
		i typeDr'="" d
		.s typeName=$p($g(^DHCCADATAITEMTYPES(typeDr)),"^",3)
		.s typeShortCut=$p($g(^DHCCADATAITEMTYPES(typeDr)),"^",4)
		
		s order=result.Data("DataItemCorres_order")
		
		s itemDr=result.Data("DataItemCorres_itemDr")
		s itemName=""
		s itemCode=""
		s itemShortCut=""
		s itemUnit=""
		i itemDr'="" d
		.s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		.s itemShortCut=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",4)
		.s itemFlag=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",6)
		
		s tmpRs=0
		
		s tmpRs= ..checkExist(parRef, itemDr)

		s tmp=rowid_"^"_typeDr_"^"_typeName_"^"_typeShortCut_"^"_order_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_itemShortCut_"^"_itemFlag
		
		i searchValue'="" d
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="typeName")&(typeName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="itemShortCut")&(itemShortCut'[searchValue)
		.q:(searchField="itemFlag")&(itemUnit'[searchValue)
		.i (count>=start)&(count<=end)&(tmpRs=0)&(itemFlag="Y") d
		..d json.InsertRowData(tmp)
		..s count=count+1
		e  d
		.i (count>=start)&(count<=end)&(tmpRs=0)&(itemFlag="Y") d
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
<StreamLocation>^dhc.ca.c.uDistParamsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
