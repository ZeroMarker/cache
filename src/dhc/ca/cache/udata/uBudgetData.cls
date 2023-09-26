/// Creator: 杨旭
/// CreatDate: 2010-03-15
/// Description: 预算数据表
Class dhc.ca.cache.udata.uBudgetData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-15
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.BudgetData
/// Input: intervalDr-核算区间; deptDr-部门ID; itemDr-项目ID; amount-数量; price-单价; fee-金额; remark-备注; type-类别;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(intervalDr, deptDr, itemDr, amount, price, fee, remark, type) As %String
{
	n (intervalDr, deptDr, itemDr, amount, price, fee, remark, type)
	
	&SQL(INSERT INTO dhc_ca_cache_data.BudgetData (BudgetData_intervalDr,BudgetData_deptDr,BudgetData_itemDr,BudgetData_amount,BudgetData_price,BudgetData_fee,BudgetData_remark,BudgetData_type) VALUES (:intervalDr, :deptDr, :itemDr, :amount, :price, :fee, :remark, :type))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-15
/// Description: 更新记录
/// Table: dhc.ca.cache.data.BudgetData
/// Input: rowid-数据行号;intervalDr-核算区间; deptDr-部门ID; itemDr-项目ID; amount-数量; price-单价; fee-金额; remark-备注; type-类别;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, intervalDr, deptDr, itemDr, amount, price, fee, remark, type) As %String
{
	n (rowid, intervalDr, deptDr, itemDr, amount, price, fee, remark, type)

	&SQL(UPDATE dhc_ca_cache_data.BudgetData SET BudgetData_intervalDr=:intervalDr,BudgetData_deptDr=:deptDr,BudgetData_itemDr=:itemDr,BudgetData_amount=:amount,BudgetData_price=:price,BudgetData_fee=:fee,BudgetData_remark=:remark,BudgetData_type=:type WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-15
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.BudgetData
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;intervalDr-核算区间;deptDr-部门ID;itemDr-项目ID;type-类别;findType-查询方式;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: 
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr, deptDr, itemDr, type, findType)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, deptDr, itemDr, type, findType)
	
	s sqlStr="SELECT BudgetData_rowid,BudgetData_intervalDr,BudgetData_deptDr,BudgetData_itemDr,BudgetData_amount,BudgetData_price,BudgetData_fee,BudgetData_remark,BudgetData_type FROM dhc_ca_cache_data.BudgetData"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND BudgetData_intervalDr='"_intervalDr_"' "
	i deptDr'="" s whereStr=whereStr_"AND BudgetData_deptDr='"_deptDr_"' "
	i itemDr'="" s whereStr=whereStr_"AND BudgetData_itemDr='"_itemDr_"' "
	i type'="" s whereStr=whereStr_"AND BudgetData_type='"_type_"' "
	
	s sortStr=""
	s sortField1=""
	s total=0
	s tmpCount=0 
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BudgetData_rowid"
	.i sortField="deptName" s sortField1="BudgetData_deptDr"
	.i sortField="itemName" s sortField1="BudgetData_itemDr"
	.i sortField="amount" s sortField1="BudgetData_amount"
	.i sortField="price" s sortField1="BudgetData_price"
	.i sortField="fee" s sortField1="BudgetData_fee"
	.i sortField="remark" s sortField1="BudgetData_remark"
	
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
	s jsonTitle="rowid^deptDr^deptName^itemDr^itemName^amount^price^fee^remark^type"
	
	While(result.Next())
	{
		s rowid=result.Data("BudgetData_rowid")
		s deptDr=result.Data("BudgetData_deptDr")
		s deptName=""
		i deptDr'="" d
		.i $d(^DHCCAUNITDEPTS(deptDr)) d
		..s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		
		s itemDr=result.Data("BudgetData_itemDr")
		s itemName="" 
		i itemDr'="" d
		.i $d(^DHCCAALLDATAITEMS(itemDr)) d
		..s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s amount=result.Data("BudgetData_amount")
		s price=result.Data("BudgetData_price")
		s fee=result.Data("BudgetData_fee")
		s total=total+fee
		s tmpCount=tmpCount+amount
		s remark=result.Data("BudgetData_remark")
		s type=result.Data("BudgetData_type")
		i type="amount" s type="数量"
		i type="price" s type="金额"
		
		s tmp=rowid_"^"_deptDr_"^"_deptName_"^"_itemDr_"^"_itemName_"^"_amount_"^"_price_"^"_fee_"^"_remark_"^"_type
		
		i searchValue'="" d
		.q:(searchField="deptName")&(deptName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="amount")&(amount'[searchValue)
		.q:(searchField="price")&(price'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="type")&(type'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	
	i (findType="find") d
	.d json.InsertRowData("^^总计:^^^"_tmpCount_"^^"_total_"^^") 
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-03-15
/// Description: 删除记录
/// Table: dhc.ca.cache.data.BudgetData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: 
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.BudgetData WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-15
/// Description: 删除某月记录
/// Table: dhc.ca.cache.data.BudgetData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: 
ClassMethod DelAllRec(intervalDr) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.BudgetData WHERE BudgetData_intervalDr=:intervalDr)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uBudgetDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
