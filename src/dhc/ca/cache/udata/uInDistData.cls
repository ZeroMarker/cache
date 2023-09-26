/// Creator: 杨旭
/// CreatDate: 2010-03-08
/// Description: 收入分配数据表
Class dhc.ca.cache.udata.uInDistData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-08
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDistData
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-收入类别; flag-数据标识; findType-是否是统计;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInDistData).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr, flag, deptDr, itemDr, inType, findType)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, flag, deptDr, itemDr, inType, findType)
	
	s sqlStr="SELECT InDistData_rowid,InDistData_intervalDr, InDistData_flag,InDistData_deptDr, InDistData_itemDr, InDistData_fee, InDistData_inType, InDistData_remark FROM dhc_ca_cache_data.InDistData"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND InDistData_intervalDr='"_intervalDr_"' "
	i flag'="" s whereStr=whereStr_"AND InDistData_flag='"_flag_"' "
	i deptDr'="" s whereStr=whereStr_"AND InDistData_deptDr='"_deptDr_"' "
	i itemDr'="" s whereStr=whereStr_"AND InDistData_itemDr='"_itemDr_"' "
	i inType'="" s whereStr=whereStr_"AND InDistData_inType='"_inType_"' "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InDistData_rowid"
	.i sortField="inType" s sortField1="InDistData_inType"
	.i sortField="itemCode" s sortField1="InDistData_itemDr"
	.i sortField="itemName" s sortField1="InDistData_itemDr"
	.i sortField="deptCode" s sortField1="InDistData_deptDr"
	.i sortField="deptName" s sortField1="InDistData_deptDr"
	.i sortField="inType" s sortField1="InDistData_inType"
	.i sortField="patType" s sortField1="InDistData_patType"
	.i sortField="remark" s sortField1="InDistData_remark"
	.i sortField="patType" s sortField1="InDistData_flag"
	.i sortField="fee" s sortField1="InDistData_fee"
	
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
	
	s total=0
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^intervalDr^intervalName^patType^itemDr^itemCode^itemName^fee^deptDr^deptCode^deptName^inType^remark"
	
	While(result.Next())
	{
		s rowid=result.Data("InDistData_rowid")
		s intervalDr=result.Data("InDistData_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s patType=result.Data("InDistData_flag")
		i patType="order" s patType="开单"
		i patType="do" s patType="执行"
		i patType="pat" s patType="病人"
		i patType="desig" s patType="指定"
		
		s itemDr=result.Data("InDistData_itemDr")
		s itemName=""
		s itemCode=""
		i itemDr'="" d
		.s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("InDistData_fee")
		s total=total+fee
		
		s deptDr=result.Data("InDistData_deptDr")
		s deptCode=""
		s deptName=""
		i deptDr'="" d
		.s deptCode=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",1)
		.s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		
		
		s inType=result.Data("InDistData_inType")
		i inType="O" s inType="门诊"
		i inType="I" s inType="住院"
		i inType="E" s inType="急诊"
		
		s remark=result.Data("InDistData_remark")
		

		s tmp=rowid_"^"_intervalDr_"^"_intervalName_"^"_patType_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_fee_"^"_deptDr_"^"_deptCode_"^"_deptName_"^"_inType_"^"_remark
		
		i searchValue'="" d
		.q:(searchField="patType")&(patType'[searchValue)
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="deptCode")&(deptCode'[searchValue)
		.q:(searchField="deptName")&(deptName'[searchValue)
		.q:(searchField="inType")&(inType'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	i findType="find" d json.InsertRowData("^^^总计^^^^"_total_"^^^^^")
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-03-08
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDistData
/// Input: intervalDr-核算区间; flag-数据标识; deptDr-部门; itemDr-项目; fee-金额; inType-收入类别;remark-备注;
/// Output: 
/// Return:执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(intervalDr, flag, deptDr, itemDr, fee, inType, remark) As %String
{
	n (intervalDr, flag, deptDr, itemDr, fee, inType, remark)
	&SQL(INSERT INTO dhc_ca_cache_data.InDistData(InDistData_intervalDr,InDistData_flag,InDistData_deptDr,InDistData_itemDr,InDistData_fee,InDistData_inType,InDistData_remark) VALUES (:intervalDr, :flag, :deptDr, :itemDr, :fee, :inType, :remark))
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-08
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InDistData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.data.uSalary).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDistData WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InDistData
/// Input：intervalDr-月份
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.data.uSalary).DelRec(3)
ClassMethod DelAllRec(intervalDr) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDistData WHERE InDistData_intervalDr=:intervalDr)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInDistDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
