/// Creator: 杨旭
/// CreatDate: 2010-03-25
/// Description: 数据类别码表维护
Class dhc.ca.cache.udata.uLargCostDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-25
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.LargCostDetail
/// Input: largCostDr-大额成本ID;dateStr-日期;feeStr-金额;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertAllRec(largCostDr, dateStr, feeStr) As %String
{
	n (largCostDr, dateStr, feeStr)
	q:largCostDr="" ""
	TSTART
	
	s resultStr=0
	i $d(^DHCCALARGCOST(largCostDr,"Detail")) d
	.s resultStr=..DelRec(largCostDr)
	s length= $l(dateStr,"^")
	&SQL(UPDATE dhc_ca_cache_data.LargCost SET LargCost_calFlag='Y' WHERE %ID=:largCostDr)
	i SQLCODE'=0 s resultStr=SQLCODE
	f i=1:1:length d
	.s mDate=""
	.s mDate=$p(dateStr,"^",i)
	.i mDate'="" s mDate=$zdh(mDate,3)
	.s fee=""
	.s fee=$p(feeStr,"^",i)
	.&SQL(INSERT INTO dhc_ca_cache_data.LargCostDetail (LargCostDetail_parRef,LargCostDetail_date,LargCostDetail_fee,LargCostDetail_flag) VALUES (:largCostDr, :mDate, :fee, 'N'))
	.i SQLCODE'=0 s resultStr=SQLCODE
	i resultStr=0 TCOMMIT
	e  TROLLBACK
	q resultStr
}

/// Creator: 杨旭
/// CreatDate: 2010-03-25
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.LargCostDetail
/// Input: largCostDr-大额成本Dr;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: 
ClassMethod ListRec(largCostDr, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (largCostDr, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT LargCostDetail_rowid,LargCostDetail_date,LargCostDetail_fee,LargCostDetail_flag FROM dhc_ca_cache_data.LargCostDetail"
	
	s whereStr=" WHERE LargCostDetail_childSub>0"
	
	i largCostDr'="" s whereStr=whereStr_" AND LargCostDetail_parRef='"_largCostDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="LargCostDetail_rowid"
	.i sortField="mDate" s sortField1="LargCostDetail_date"
	.i sortField="fee" s sortField1="LargCostDetail_fee"
	.i sortField="flag" s sortField1="LargCostDetail_flag"
	
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
	s jsonTitle="rowid^mDate^fee^flag"
	
	While(result.Next())
	{
		s rowid=result.Data("LargCostDetail_rowid")
		s mDate=result.Data("LargCostDetail_date")
		i mDate'="" d
		.s mDate=$zd(mDate,3)
		
		s fee=result.Data("LargCostDetail_fee")
		s flag=result.Data("LargCostDetail_flag")
		
		s tmp=rowid_"^"_mDate_"^"_fee_"^"_flag
		
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
/// CreatDate: 2010-03-25
/// Description: 删除记录
/// Table: dhc.ca.cache.data.LargCostDetail
/// Input：rowid-大额成本表ID;
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.LargCostDetail WHERE LargCostDetail_parRef=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uLargCostDetailS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
