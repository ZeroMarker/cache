Class dhc.ca.cache.udata.uOIncomeDatas Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-11-29
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input: intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;remark-备注;debit-借方;loans-贷方;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(intervalDr, feeDate, patType, itemDr, fee, cost, fDeptDr, tDeptDr, patDeptDr, inPersonDr, remark, PatWardDr, PatDocDr) As %String
{
	n (intervalDr, feeDate, patType, itemDr, fee, cost, fDeptDr, tDeptDr, patDeptDr, inPersonDr, remark,PatWardDr,PatDocDr)
	i feeDate'="" s feeDate=$zdh(feeDate,3)
	s nowDate=$p($h,",",1)
	&SQL(INSERT INTO dhc_ca_cache_data.OIncomeDatas (OIncomeDatas_intervalDr,OIncomeDatas_feeDate,OIncomeDatas_patType,OIncomeDatas_itemDr,OIncomeDatas_fee,OIncomeDatas_cost,OIncomeDatas_fDeptDr,OIncomeDatas_tDeptDr,OIncomeDatas_patDeptDr,OIncomeDatas_inType,OIncomeDatas_inPersonDr,OIncomeDatas_remark,OIncomeDatas_inDate,OIncomeDatas_PatWardDr, OIncomeDatas_PatDocDr) VALUES (:intervalDr, :feeDate, :patType, :itemDr, :fee, :cost, :fDeptDr, :tDeptDr, :patDeptDr, 'input', :inPersonDr, :remark, :nowDate,:PatWardDr,:PatDocDr))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-29
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input: rowid-数据ID;intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;remark-备注;debit-借方;loans-贷方;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
/// 	
ClassMethod UpdateRec(rowid, itemCode, itemName, fDeptCode, fDeptName, tDeptCode, tDeptName, patDeptCode, patDeptName, fee, cost, remark, inPersonDr, PatWardCode, PatWardDesc, PatDocCode, PatDocDesc) As %String
{
	n (rowid, itemCode, itemName, fDeptCode, fDeptName, tDeptCode, tDeptName, patDeptCode, patDeptName, fee, cost, remark, inPersonDr,PatWardCode,PatWardDesc,PatDocCode,PatDocDesc)
	k PLIST   
	s nowDate=$p($h,",",1)
	s PLIST(5)=itemCode
	s PLIST(6)=itemName
	s PLIST(8)=fee
	s PLIST(9)=cost
	s PLIST(10)=fDeptCode
	s PLIST(11)=fDeptName
	s PLIST(13)=tDeptCode
	s PLIST(14)=tDeptName
	s PLIST(16)=patDeptCode
	s PLIST(17)=patDeptName
	s PLIST(19)="input"
	s PLIST(20)=inPersonDr
	s PLIST(21)=remark
	s PLIST(22)=nowDate
	s PLIST(23)=PatWardCode
	s PLIST(24)=PatWardDesc
	s PLIST(26)=PatDocCode
	s PLIST(27)=PatDocDesc
	&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas VALUES PLIST() WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-29
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOIncomeDatas).ListRec("","","rowid","DESC",0,25,13)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_intervalDr
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr)
	
	s sqlStr="SELECT OIncomeDatas_inDate, OIncomeDatas_rowid,OIncomeDatas_intervalDr, OIncomeDatas_feeDate, OIncomeDatas_patType, OIncomeDatas_itemCode, OIncomeDatas_itemName, OIncomeDatas_itemDr, OIncomeDatas_fee, OIncomeDatas_cost, OIncomeDatas_fDeptCode, OIncomeDatas_fDeptName, OIncomeDatas_fDeptDr, OIncomeDatas_tDeptCode, OIncomeDatas_tDeptName, OIncomeDatas_tDeptDr, OIncomeDatas_patDeptCode, OIncomeDatas_patDeptName, OIncomeDatas_patDeptDr, OIncomeDatas_inType, OIncomeDatas_inPersonDr, OIncomeDatas_remark,OIncomeDatas_PatWardCode, OIncomeDatas_PatWardDesc, OIncomeDatas_PatWardDr, OIncomeDatas_PatDocCode, OIncomeDatas_PatDocDesc, OIncomeDatas_PatDocDr, OIncomeDatas_fDocCode, OIncomeDatas_fDocName, OIncomeDatas_fDocDr  FROM dhc_ca_cache_data.OIncomeDatas"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND OIncomeDatas_intervalDr='"_intervalDr_"' "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OIncomeDatas_rowid"
	.i sortField="feeDate" s sortField1="OIncomeDatas_feeDate"
	.i sortField="itemCode" s sortField1="OIncomeDatas_itemCode"
	.i sortField="itemName" s sortField1="OIncomeDatas_itemName"
	.i sortField="inItemName" s sortField1="OIncomeDatas_itemDr"
	.i sortField="fee" s sortField1="OIncomeDatas_fee"
	.i sortField="cost" s sortField1="OIncomeDatas_cost"
	.i sortField="fDeptCode" s sortField1="OIncomeDatas_fDeptCode"
	.i sortField="fDeptName" s sortField1="OIncomeDatas_fDeptName"
	.i sortField="inFDeptName" s sortField1="OIncomeDatas_fDeptDr"
	.i sortField="tDeptCode" s sortField1="OIncomeDatas_tDeptCode"
	.i sortField="tDeptName" s sortField1="OIncomeDatas_tDeptName"
	.i sortField="inTDeptName" s sortField1="OIncomeDatas_tDeptDr"
	.i sortField="patDeptCode" s sortField1="OIncomeDatas_patDeptCode"
	.i sortField="patDeptName" s sortField1="OIncomeDatas_patDeptName"
	.i sortField="inPatDeptName" s sortField1="OIncomeDatas_patDeptDr"
	.i sortField="inType" s sortField1="OIncomeDatas_inType"
	.i sortField="remark" s sortField1="OIncomeDatas_remark"
	.i sortField="inDate" s sortField1="OIncomeDatas_inDate"
	 
	.i sortField="patWardCode" s sortField1="OIncomeDatas_PatWardCode"
	.i sortField="patWardDesc" s sortField1="OIncomeDatas_PatWardDesc"
	.i sortField="inPatWardDesc" s sortField1="OIncomeDatas_PatWardDr"
	
	.i sortField="patDocCode" s sortField1="OIncomeDatas_PatDocCode,"
	.i sortField="patDocDesc" s sortField1="OIncomeDatas_PatDocDesc"
	.i sortField="inPatDocDesc" s sortField1="OIncomeDatas_PatDocDr"
	
	.i sortField="fDocCode" s sortField1="OIncomeDatas_fDocCode"
	.i sortField="fDocName" s sortField1="OIncomeDatas_fDocName"
	.i sortField="fInDocName" s sortField1="OIncomeDatas_fDocDr"
	//fDeptCode^fDeptName^fDeptDr^inFDeptCode^inFDeptName
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
	s jsonTitle="rowid^intervalDr^intervalName^feeDate^patType^itemCode^itemName^itemDr^inItemCode^inItemName^fee^cost^fDeptCode^fDeptName^fDeptDr^inFDeptCode^inFDeptName^tDeptCode^tDeptName^tDeptDr^inTDeptCode^inTDeptName^patDeptCode^patDeptName^patDeptDr^inPatDeptCode^inPatDeptName^inType^personDr^personName^remark^inDate^patWardCode^patWardDesc^patWardDr^inPatWardCode^inPatWardDesc^patDocCode^patDocDesc^patDocDr^inPatDocCode^inPatDocDesc^fDocCode^fDocName^fDocDr^fInDocName"
	
	While(result.Next())
	{
		s rowid=result.Data("OIncomeDatas_rowid")
		s intervalDr=result.Data("OIncomeDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s feeDate=result.Data("OIncomeDatas_feeDate")
		i feeDate'="" s feeDate=$zd(feeDate,3)
		
		s patType=result.Data("OIncomeDatas_patType")
		i patType="I" s patType="住院"
		i patType="O" s patType="门诊"
		i patType="E" s patType="急诊"
		i patType="H" s patType="体检"
		
		s itemCode=result.Data("OIncomeDatas_itemCode")
		s itemName=result.Data("OIncomeDatas_itemName")
		
		s itemDr=result.Data("OIncomeDatas_itemDr")
		s inItemName=""
		s inItemCode=""
		i itemDr'="" d
		.s inItemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s inItemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("OIncomeDatas_fee")
		s cost=result.Data("OIncomeDatas_cost")
		s fDeptCode=result.Data("OIncomeDatas_fDeptCode")
		s fDeptName=result.Data("OIncomeDatas_fDeptName")
		
		s fDeptDr=result.Data("OIncomeDatas_fDeptDr")
		s inFDeptCode=""
		s inFDeptName=""
		i fDeptDr'="" d
		.s inFDeptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
		.s inFDeptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
		
		s tDeptCode=result.Data("OIncomeDatas_tDeptCode")
		s tDeptName=result.Data("OIncomeDatas_tDeptName")
		
		s tDeptDr=result.Data("OIncomeDatas_tDeptDr")
		s inTDeptCode=""
		s inTDeptName=""
		i tDeptDr'="" d
		.s inTDeptCode=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",1)
		.s inTDeptName=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",2)
		
		s patDeptCode=result.Data("OIncomeDatas_patDeptCode")
		s patDeptName=result.Data("OIncomeDatas_patDeptName")
		
		s patDeptDr=result.Data("OIncomeDatas_patDeptDr")
		s inPatDeptCode=""
		s inPatDeptName=""
		i patDeptDr'="" d
		.s inPatDeptCode=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",1)
		.s inPatDeptName=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",2)
		
		s inType=result.Data("OIncomeDatas_inType")
		i inType="input" s inType="录入"
		i inType="load" s inType="导入"
		
		s personDr=result.Data("OIncomeDatas_inPersonDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("OIncomeDatas_remark")
		s inDate=result.Data("OIncomeDatas_inDate")
		i inDate'="" s inDate=$zd(inDate,3)
		
		s PatWardCode=result.Data("OIncomeDatas_PatWardCode")
		s PatWardDesc=result.Data("OIncomeDatas_PatWardDesc")
		
		s PatWardDr=result.Data("OIncomeDatas_PatWardDr")
		s inPatWardCode=""
		s inPatWardDesc=""
		i PatWardDr'="" d
		.s inPatWardCode=$p($g(^DHCCAUNITDEPTS(PatWardDr)),"^",1)
		.s inPatWardDesc=$p($g(^DHCCAUNITDEPTS(PatWardDr)),"^",2)
		
		s PatDocCode=result.Data("OIncomeDatas_PatDocCode")
		s PatDocDesc=result.Data("OIncomeDatas_PatDocDesc")
		
		s PatDocDr=result.Data("OIncomeDatas_PatDocDr")
		s inPatDocCode=""
		s inPatDocDesc=""
		i PatDocDr'="" d
		.s inPatDocCode=$p($g(^DHCCAUNITDEPTS(PatDocDr)),"^",1)
		.s inPatDocDesc=$p($g(^DHCCAUNITDEPTS(PatDocDr)),"^",2)
		
				
		s fDocCode=result.Data("OIncomeDatas_fDocCode")
		s fDocName=result.Data("OIncomeDatas_fDocName")
		s fDocDr=result.Data("OIncomeDatas_fDocDr")
		s fInDocName=""
		i fDocDr'="" d
		.s fInDocName=$p($g(^DHCCAUNITPERSONS(fDocDr)),"^",2)
         
		s tmp=rowid_"^"_intervalDr_"^"_intervalName_"^"_feeDate_"^"_patType_"^"_itemCode_"^"_itemName_"^"_itemDr_"^"_inItemCode_"^"_inItemName_"^"_fee_"^"_cost_"^"_fDeptCode_"^"_fDeptName_"^"_fDeptDr_"^"_inFDeptCode_"^"_inFDeptName_"^"_tDeptCode_"^"_tDeptName_"^"_tDeptDr_"^"_inTDeptCode_"^"_inTDeptName_"^"_patDeptCode_"^"_patDeptName_"^"_patDeptDr_"^"_inPatDeptCode_"^"_inPatDeptName_"^"_inType_"^"_personDr_"^"_personName_"^"_remark_"^"_inDate_"^"_PatWardCode_"^"_PatWardDesc_"^"_PatWardDr_"^"_inPatWardCode_"^"_inPatWardDesc_"^"_PatDocCode_"^"_PatDocDesc_"^"_PatDocDr_"^"_inPatDocCode_"^"_inPatDocDesc_"^"_fDocCode_"^"_fDocName_"^"_fDocDr_"^"_fInDocName
		
		i searchValue'="" d
		.q:(searchField="feeDate")&(feeDate'[searchValue)
		.q:(searchField="patType")&(patType'[searchValue)
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="inItemName")&(inItemName'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="cost")&(cost'[searchValue)
		.q:(searchField="fDeptCode")&(fDeptCode'[searchValue)
		.q:(searchField="fDeptName")&(fDeptName'[searchValue)
		.q:(searchField="inFDeptName")&(inFDeptName'[searchValue)
		.q:(searchField="tDeptCode")&(tDeptCode'[searchValue)
		.q:(searchField="tDeptName")&(tDeptName'[searchValue)
		.q:(searchField="inTDeptName")&(inTDeptName'[searchValue)
		.q:(searchField="patDeptCode")&(patDeptCode'[searchValue)
		.q:(searchField="patDeptName")&(patDeptName'[searchValue)
		.q:(searchField="inPatDeptName")&(inPatDeptName'[searchValue)
		.q:(searchField="personName")&(personName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="inDate")&(inDate'[searchValue)
		.q:(searchField="fDocCode")&(fDocCode'[searchValue)
		.q:(searchField="fDocName")&(fDocName'[searchValue)		
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
/// CreatDate: 2009-11-29
/// Description: 获得用户DR
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uOIncomeDatas).CheckUser(1)
ClassMethod CheckUser(userCode) As %String
{
	n (userCode)
	
	q:userCode="" 0
	s userDr =0
	s userDr=$o(^DHCCAUNITPERSONS(0,"Code", userCode, userDr))
	s flag="N"
	i userDr>0 d
	.s flag=$p($g(^DHCCAUNITPERSONS(userDr)),"^",18)
	i flag="" s flag="N"
	i flag="N" s userDr=0
	q userDr
}

/// Creator: 杨旭
/// CreatDate: 2009-12-3
/// Description: 刷新对应数据的部门与项目
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uOIncomeDatas).refreshRec(61,1)
ClassMethod refreshRec(intervalDr, loadRulesDr) As %String
{
	n (intervalDr,loadRulesDr)
	;w intervalDr_"^"_loadRulesDr,!
	
	TSTART
	/**	
	s RowId=""
    f  s RowId=$o(^DHCCAOIncomeDatas(0,"Interval",intervalDr,RowId)) q:RowId=""  d
    .s fDeptCode=$p(^DHCCAOIncomeDatas(RowId),"^",9)
    .s tDeptcode=$p(^DHCCAOIncomeDatas(RowId),"^",12)
    .s tDeptname=$p(^DHCCAOIncomeDatas(RowId),"^",13) 
    .i fDeptCode="1116" d
    ..&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_fDeptCode=:tDeptcode where OIncomeDatas_rowid=:RowId)
    ..&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_patDeptCode=:tDeptcode where OIncomeDatas_rowid=:RowId)
    ..&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_fDeptName=:tDeptname where OIncomeDatas_rowid=:RowId)
    ..&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_patDeptName=:tDeptname where OIncomeDatas_rowid=:RowId)
    .s type=$p(^DHCCAOIncomeDatas(RowId),"^",3) q:type'="I"
    .s PatDocCode=$p(^DHCCAOIncomeDatas(RowId),"^",25)
    .s PatDocDesc=$p(^DHCCAOIncomeDatas(RowId),"^",26)
    .&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_fDeptCode=:PatDocCode where OIncomeDatas_rowid=:RowId)
    .&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_patDeptCode=:PatDocCode where OIncomeDatas_rowid=:RowId)
    .&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_fDeptName=:PatDocDesc where OIncomeDatas_rowid=:RowId)
    .&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_patDeptName=:PatDocDesc where OIncomeDatas_rowid=:RowId)
	*/	
	s flag=0
	q:loadRulesDr="" 1
	
	;s sqlStr="SELECT OIncomeDatas_inDate, OIncomeDatas_rowid,OIncomeDatas_intervalDr, OIncomeDatas_feeDate, OIncomeDatas_patType, OIncomeDatas_itemCode, OIncomeDatas_itemName, OIncomeDatas_itemDr, OIncomeDatas_fee, OIncomeDatas_cost, OIncomeDatas_fDeptCode, OIncomeDatas_fDeptName, OIncomeDatas_fDeptDr, OIncomeDatas_tDeptCode, OIncomeDatas_tDeptName, OIncomeDatas_tDeptDr, OIncomeDatas_patDeptCode, OIncomeDatas_patDeptName, OIncomeDatas_patDeptDr, OIncomeDatas_inType, OIncomeDatas_inPersonDr, OIncomeDatas_remark FROM dhc_ca_cache_data.OIncomeDatas"
	s sqlStr="SELECT OIncomeDatas_inDate, OIncomeDatas_rowid,OIncomeDatas_intervalDr, OIncomeDatas_feeDate, OIncomeDatas_patType, OIncomeDatas_itemCode, OIncomeDatas_itemName, OIncomeDatas_itemDr, OIncomeDatas_fee, OIncomeDatas_cost, OIncomeDatas_fDeptCode, OIncomeDatas_fDeptName, OIncomeDatas_fDeptDr, OIncomeDatas_tDeptCode, OIncomeDatas_tDeptName, OIncomeDatas_tDeptDr, OIncomeDatas_patDeptCode, OIncomeDatas_patDeptName, OIncomeDatas_patDeptDr, OIncomeDatas_PatWardCode, OIncomeDatas_PatWardDesc, OIncomeDatas_PatWardDr, OIncomeDatas_PatDocCode, OIncomeDatas_PatDocDesc, OIncomeDatas_PatDocDr, OIncomeDatas_inType, OIncomeDatas_inPersonDr, OIncomeDatas_remark, OIncomeDatas_fDocCode, OIncomeDatas_fDocName, OIncomeDatas_fDocDr FROM dhc_ca_cache_data.OIncomeDatas"
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND OIncomeDatas_intervalDr='"_intervalDr_"' "
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	
	s deptSetDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",4)
	s itemSetDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",5)
	s itemTypeDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",6)
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		k PLIST
		s rowid=result.Data("OIncomeDatas_rowid")
		s itemCode=result.Data("OIncomeDatas_itemCode")
		s patType=result.Data("OIncomeDatas_patType")
	
		s itemDr=""
		
		i ((itemCode'="")&(itemSetDr'="")) s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemSetDr,itemCode)
		i ((itemCode'="")&(itemTypeDr'="")) s itemDr=..ItemRelation(itemTypeDr,itemCode)
		
		i itemDr'="" s PLIST(7)=itemDr
		s fDeptCode=""
		s fDeptDr=""
		s fDeptCode=result.Data("OIncomeDatas_fDeptCode")

		//w "fDeptCode:"_fDeptCode,!
		s fDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,fDeptCode,patType)
		//w "fDeptDr:"_fDeptDr,!
		i fDeptDr'="" s PLIST(12)=fDeptDr
		
		s tDeptCode=""
		s tDeptDr=""
		s tDeptCode=result.Data("OIncomeDatas_tDeptCode")
		//w "tDeptCode:"_tDeptCode,!
		s tDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,tDeptCode,patType)
		//w "tDeptDr:"_tDeptDr,!
		i tDeptDr'="" s PLIST(15)=tDeptDr
		
		s patDeptCode=""
		s patDeptDr=""
		s patDeptCode=result.Data("OIncomeDatas_patDeptCode")
		//w "patDeptCode:"_patDeptCode,!
		s patDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,patDeptCode,patType)
		//w "patDeptDr:"_patDeptDr,!
		i patDeptDr'="" s PLIST(18)=patDeptDr
		
	    s PatWardCode=""
		s PatWardDr=""
		s PatWardCode=result.Data("OIncomeDatas_PatWardCode")
		//w "PatWardCode:"_PatWardCode,!
		i patType="I"  s PatWardDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,PatWardCode,patType)
		//w "PatWardDr:"_PatWardDr,!
		i PatWardDr'="" s PLIST(25)=PatWardDr
		
	    s PatDocCode=""
		s PatDocDr=""
		s PatDocCode=result.Data("OIncomeDatas_PatDocCode")
		//w "PatDocCode:"_PatDocCode,!
		s PatDocDr=##class(dhc.ca.cache.comm.CommMethod).UnitPersonsRelation(PatDocCode)
		//w "PatDocDr:"_PatDocDr,!
		i PatDocDr'="" s PLIST(28)=PatDocDr
		
		s fDocCode=""
		s fDocDr=""
		s fDocCode=result.Data("OIncomeDatas_fDocCode")
		//w "fDocCode:"_fDocCode,!
		s fDocDr=##class(dhc.ca.cache.comm.CommMethod).UnitPersonsRelation(fDocCode)
		//w "PatDocDr:"_PatDocDr,!
		i fDocDr'="" s PLIST(31)=fDocDr
		
		&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas VALUES PLIST() where %ID=:rowid)
		i SQLCODE'=0 s flag=SQLCODE
	}

	d result.Close()
	i flag=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	//&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_tDeptDr=OIncomeDatas_fDeptDr where OIncomeDatas_intervaldr=:intervalDr and (OIncomeDatas_tdeptdr='32' or OIncomeDatas_tdeptdr='34'))
    //处理把急诊收入都归为门诊收入lxc2010-10-27
    &SQL(update dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_pattype='O' where OIncomeDatas_intervaldr=:intervalDr and OIncomeDatas_pattype='E')
	
	//1.如果开单科室没在科室分层套的直接医疗类科室里;//转病人科室wyy
	s fDept=""         
	s fDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s fDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(fDept)
	s sqlStr="SELECT OIncomeDatas_rowid FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_fDeptDr not in("_fDept_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("OIncomeDatas_rowid")
		&SQL(update dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_fDeptDr=OIncomeDatas_patDeptDr where OIncomeDatas_rowid=:rowid)	
	}

	//2.执行科室没在科室分层套的直接医疗类科室或医技类科室里；//转开单科室wyy
	s tDept="" 
	s tDepts=""         
	s tDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s tDepts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	s tDept= ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(5)
	s tDepts=tDepts_","_##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	s sqlStr="SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_tDeptDr not in("_tDepts_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("OIncomeDatas_rowid")
		&SQL(update dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_tDeptDr=OIncomeDatas_fDeptDr where OIncomeDatas_rowid=:rowid)	
	}

 	//3.如果病人科室没在科室分层套的直接医疗类科室里; 这几种情况都过滤出来；//转开单科室wyy
	s patDept="" 
	s patDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s patDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(patDept)
	s sqlStr="SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_patDeptDr not in("_patDept_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("OIncomeDatas_rowid")
		&SQL(update dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_patDeptDr=OIncomeDatas_fDeptDr where OIncomeDatas_rowid=:rowid)	
			
	}
    //4.转换病人科室为外科门诊治疗室为门诊治疗室开单
	//&SQL(update dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_patDeptDr='88',OIncomeDatas_patDeptDr='88' where OIncomeDatas_patDeptDr='112' and OIncomeDatas_intervaldr=:intervalDr)
	//&SQL(update dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_fDeptDr='280',OIncomeDatas_patDeptDr='280' where OIncomeDatas_patDeptDr='123' and OIncomeDatas_intervaldr=:intervalDr)	
	q flag
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.Users).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.OIncomeDatas WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input：remark-备注
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.Users).DelRec(3)
ClassMethod DelByRemarkRec(remark) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_remark=:remark)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-30
/// Description: 删除记录
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.Users).DelRec(3)
ClassMethod DelRecByMonth(monthDr) As %String
{
	n (monthDr)
	&SQL(DELETE FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_intervalDr=:monthDr)
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-11-10
/// Description: 返回当前日期是否在指定核算区间内
/// Table：dhc.ca.cache.data.OIncomeDatas
/// Input：monthID-核算月ID
/// Output：
/// Return：Y-是,N-否
/// Others：
ClassMethod getDayActive(monthID) As %String
{
	q:monthID="" "N"
	
	n (monthID)
	
	s result="N"
	s today=$p($h,",",1)
	
	i $d(monthID) d
	.s startDay=$p(^DHCCAACCOUNTMONTHS(monthID),"^",4)
	.s endDay=$p(^DHCCAACCOUNTMONTHS(monthID),"^",5)
	.i (today>=startDay)&&(today<=endDay) d
	..s result="Y"
	
	q result
}

/// Creator：杨旭
/// CreatDate：2010-01-5
/// Description: 按业务项类别对照项目
/// Table：dhc.ca.cache.data.OIncomeDatas
/// Input：TypeItemDr-业务项类别;ItemCode-需要对照的业务项CODE
/// Output：
/// Return：Y-是,N-否
/// Others：w ##class(dhc.ca.cache.udata.uOIncomeDatas).ItemRelation(7,"233")
ClassMethod ItemRelation(TypeItemDr, ItemCode) As %String
{
	q:TypeItemDr="" ""
	q:ItemCode="" ""
	n (TypeItemDr,ItemCode)
	s Rs=""
	s tmpItemDr=""
	f  s tmpItemDr=$o(^DHCCADATAITEMCORRES(0,"TypeItem",TypeItemDr,tmpItemDr)) q:(tmpItemDr="")!(Rs'="")  d
	.s tmpItemCode=$p($g(^DHCCAALLDATAITEMS(tmpItemDr)),"^",2)
	.i tmpItemCode=ItemCode s Rs=tmpItemDr
	q Rs
}

/// Creator: 杨旭
/// CreatDate: 2010-08-20[修改过滤条件]
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others:
ClassMethod ListRemain(intervalDr, searchField, searchValue, sortField, sortDir, start, limit, type)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, type)
	
	s sqlStr="SELECT * FROM (SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_tDeptDr is null union SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_fDeptDr is null union SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_patDeptDr is null union SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_itemDr is null "
	
	s whereStr=""
	
	s fDept=""          //1.如果开单科室没在科室分层套的直接医疗类科室里;//转病人科室wyy
	s fDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s fDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(fDept)
	i fDept'="" d  s whereStr=whereStr_" union SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_fDeptDr not in("_fDept_") "
	
	s tDept=""          //2.执行科室没在科室分层套的直接医疗类科室或医技类科室里；//转开单科室wyy
	s tDepts=""         
	s tDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s tDepts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	s tDept= ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(5)
	s tDepts=tDepts_","_##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	i tDepts'="" d  s whereStr=whereStr_" union SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_tDeptDr not in("_tDepts_") "
	
	s patDept=""          //3.如果病人科室没在科室分层套的直接医疗类科室里; 这几种情况都过滤出来。
	s patDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s patDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(patDept)
	i patDept'="" d  s whereStr=whereStr_" union SELECT * FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_patDeptDr not in("_patDept_")) "
	
	s whereStr=whereStr_" WHERE OIncomeDatas_rowid>0 "
	
	i intervalDr'="" s whereStr=whereStr_" AND OIncomeDatas_intervalDr='"_intervalDr_"' "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OIncomeDatas_rowid"
	.i sortField="feeDate" s sortField1="OIncomeDatas_feeDate"
	.i sortField="itemCode" s sortField1="OIncomeDatas_itemCode"
	.i sortField="itemName" s sortField1="OIncomeDatas_itemName"
	.i sortField="inItemName" s sortField1="OIncomeDatas_itemDr"
	.i sortField="fee" s sortField1="OIncomeDatas_fee"
	.i sortField="cost" s sortField1="OIncomeDatas_cost"
	.i sortField="fDeptCode" s sortField1="OIncomeDatas_fDeptCode"
	.i sortField="fDeptName" s sortField1="OIncomeDatas_fDeptName"
	.i sortField="inFDeptName" s sortField1="OIncomeDatas_fDeptDr"
	.i sortField="tDeptCode" s sortField1="OIncomeDatas_tDeptCode"
	.i sortField="tDeptName" s sortField1="OIncomeDatas_tDeptName"
	.i sortField="inTDeptName" s sortField1="OIncomeDatas_tDeptDr"
	.i sortField="patDeptCode" s sortField1="OIncomeDatas_patDeptCode"
	.i sortField="patDeptName" s sortField1="OIncomeDatas_patDeptName"
	.i sortField="inPatDeptName" s sortField1="OIncomeDatas_patDeptDr"
	.i sortField="inType" s sortField1="OIncomeDatas_inType"
	.i sortField="remark" s sortField1="OIncomeDatas_remark"
	.i sortField="inDate" s sortField1="OIncomeDatas_inDate"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY OIncomeDatas_rowid DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()

	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^intervalDr^intervalName^feeDate^patType^itemCode^itemName^itemDr^inItemCode^inItemName^fee^cost^fDeptCode^fDeptName^fDeptDr^inFDeptCode^inFDeptName^tDeptCode^tDeptName^tDeptDr^inTDeptCode^inTDeptName^patDeptCode^patDeptName^patDeptDr^inPatDeptCode^inPatDeptName^inType^personDr^personName^remark^inDate"
	
	While(result.Next())
	{
		s rowid=result.Data("OIncomeDatas_rowid")
		s intervalDr=result.Data("OIncomeDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s feeDate=result.Data("OIncomeDatas_feeDate")
		i feeDate'="" s feeDate=$zd(feeDate,3)
		
		s patType=result.Data("OIncomeDatas_patType")
		i patType="I" s patType="住院"
		i patType="O" s patType="门诊"
		i patType="E" s patType="急诊"
		i patType="H" s patType="体检"
		
		s itemCode=result.Data("OIncomeDatas_itemCode")
		s itemName=result.Data("OIncomeDatas_itemName")
		
		s itemDr=result.Data("OIncomeDatas_itemDr")
		s inItemName=""
		s inItemCode=""
		i itemDr'="" d
		.s inItemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s inItemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("OIncomeDatas_fee")
		s cost=result.Data("OIncomeDatas_cost")
		s fDeptCode=result.Data("OIncomeDatas_fDeptCode")
		s fDeptName=result.Data("OIncomeDatas_fDeptName")
		
		s fDeptDr=result.Data("OIncomeDatas_fDeptDr")
		s inFDeptCode=""
		s inFDeptName=""
		i fDeptDr'="" d
		.s inFDeptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
		.s inFDeptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
		
		s tDeptCode=result.Data("OIncomeDatas_tDeptCode")
		s tDeptName=result.Data("OIncomeDatas_tDeptName")
		
		s tDeptDr=result.Data("OIncomeDatas_tDeptDr")
		s inTDeptCode=""
		s inTDeptName=""
		i tDeptDr'="" d
		.s inTDeptCode=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",1)
		.s inTDeptName=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",2)
		
		s patDeptCode=result.Data("OIncomeDatas_patDeptCode")
		s patDeptName=result.Data("OIncomeDatas_patDeptName")
		
		s patDeptDr=result.Data("OIncomeDatas_patDeptDr")
		s inPatDeptCode=""
		s inPatDeptName=""
		i patDeptDr'="" d
		.s inPatDeptCode=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",1)
		.s inPatDeptName=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",2)
		
		s inType=result.Data("OIncomeDatas_inType")
		i inType="input" s inType="录入"
		i inType="load" s inType="导入"
		
		s personDr=result.Data("OIncomeDatas_inPersonDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("OIncomeDatas_remark")
		s inDate=result.Data("OIncomeDatas_inDate")
		i inDate'="" s inDate=$zd(inDate,3)
		

		s tmp=rowid_"^"_intervalDr_"^"_intervalName_"^"_feeDate_"^"_patType_"^"_itemCode_"^"_itemName_"^"_itemDr_"^"_inItemCode_"^"_inItemName_"^"_fee_"^"_cost_"^"_fDeptCode_"^"_fDeptName_"^"_fDeptDr_"^"_inFDeptCode_"^"_inFDeptName_"^"_tDeptCode_"^"_tDeptName_"^"_tDeptDr_"^"_inTDeptCode_"^"_inTDeptName_"^"_patDeptCode_"^"_patDeptName_"^"_patDeptDr_"^"_inPatDeptCode_"^"_inPatDeptName_"^"_inType_"^"_personDr_"^"_personName_"^"_remark_"^"_inDate
		
		i searchValue'="" d
		.q:(searchField="feeDate")&(feeDate'[searchValue)
		.q:(searchField="patType")&(patType'[searchValue)
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="inItemName")&(inItemName'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="cost")&(cost'[searchValue)
		.q:(searchField="fDeptCode")&(fDeptCode'[searchValue)
		.q:(searchField="fDeptName")&(fDeptName'[searchValue)
		.q:(searchField="inFDeptName")&(inFDeptName'[searchValue)
		.q:(searchField="tDeptCode")&(tDeptCode'[searchValue)
		.q:(searchField="tDeptName")&(tDeptName'[searchValue)
		.q:(searchField="inTDeptName")&(inTDeptName'[searchValue)
		.q:(searchField="patDeptCode")&(patDeptCode'[searchValue)
		.q:(searchField="patDeptName")&(patDeptName'[searchValue)
		.q:(searchField="inPatDeptName")&(inPatDeptName'[searchValue)
		.q:(searchField="personName")&(personName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="inDate")&(inDate'[searchValue)
		.q:(searchField="PatWardCode")&(patDeptCode'[searchValue)
		.q:(searchField="PatWardDesc")&(patDeptName'[searchValue)
		.q:(searchField="inPatWardDesc")&(inPatDeptName'[searchValue)
		 
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
/// CreatDate: 2009-11-29
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.OIncomeDatas
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOIncomeDatas).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod FindRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr, feeDate, itemDr, fDeptDr, tDeptDr, patDeptDr, itemCode, itemName, fDeptCode, fDeptName, tDeptCode, tDeptName, patDeptCode, patDeptName)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, feeDate, itemDr, fDeptDr, tDeptDr, patDeptDr, itemCode, itemName, fDeptCode, fDeptName, tDeptCode, tDeptName, patDeptCode, patDeptName )
	
	s sqlStr="SELECT OIncomeDatas_inDate, OIncomeDatas_rowid,OIncomeDatas_intervalDr, OIncomeDatas_feeDate, OIncomeDatas_patType, OIncomeDatas_itemCode, OIncomeDatas_itemName, OIncomeDatas_itemDr, OIncomeDatas_fee, OIncomeDatas_cost, OIncomeDatas_fDeptCode, OIncomeDatas_fDeptName, OIncomeDatas_fDeptDr, OIncomeDatas_tDeptCode, OIncomeDatas_tDeptName, OIncomeDatas_tDeptDr, OIncomeDatas_patDeptCode, OIncomeDatas_patDeptName, OIncomeDatas_patDeptDr, OIncomeDatas_inType, OIncomeDatas_inPersonDr, OIncomeDatas_remark FROM dhc_ca_cache_data.OIncomeDatas"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND OIncomeDatas_intervalDr='"_intervalDr_"' "
	i feeDate'="" d
	.s feeDate=$zdh(feeDate,3)
	.s whereStr=whereStr_"AND OIncomeDatas_feeDate='"_feeDate_"' "
	i itemDr'="" s whereStr=whereStr_"AND OIncomeDatas_itemDr='"_itemDr_"' "
	i fDeptDr'="" s whereStr=whereStr_"AND OIncomeDatas_fDeptDr='"_fDeptDr_"' "
	i tDeptDr'="" s whereStr=whereStr_"AND OIncomeDatas_tDeptDr='"_tDeptDr_"' "
	i itemCode'="" s whereStr=whereStr_"AND OIncomeDatas_itemCode='"_itemCode_"' "
	i itemName'="" s whereStr=whereStr_"AND OIncomeDatas_itemName='"_itemName_"' "
	i patDeptDr'="" s whereStr=whereStr_"AND OIncomeDatas_patDeptDr='"_patDeptDr_"' " 
	i fDeptCode'="" s whereStr=whereStr_"AND OIncomeDatas_fDeptCode='"_fDeptCode_"' "
	i fDeptName'="" s whereStr=whereStr_"AND OIncomeDatas_fDeptName='"_fDeptName_"' "
	i tDeptCode'="" s whereStr=whereStr_"AND OIncomeDatas_tDeptCode='"_tDeptCode_"' "
	i tDeptName'="" s whereStr=whereStr_"AND OIncomeDatas_tDeptName='"_tDeptName_"' "
	i patDeptCode'="" s whereStr=whereStr_"AND OIncomeDatas_patDeptCode='"_patDeptCode_"' "
	i patDeptName'="" s whereStr=whereStr_"AND OIncomeDatas_patDeptName='"_patDeptName_"' "
	
	
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OIncomeDatas_rowid"
	.i sortField="feeDate" s sortField1="OIncomeDatas_feeDate"
	.i sortField="itemCode" s sortField1="OIncomeDatas_itemCode"
	.i sortField="itemName" s sortField1="OIncomeDatas_itemName"
	.i sortField="inItemName" s sortField1="OIncomeDatas_itemDr"
	.i sortField="fee" s sortField1="OIncomeDatas_fee"
	.i sortField="cost" s sortField1="OIncomeDatas_cost"
	.i sortField="fDeptCode" s sortField1="OIncomeDatas_fDeptCode"
	.i sortField="fDeptName" s sortField1="OIncomeDatas_fDeptName"
	.i sortField="inFDeptName" s sortField1="OIncomeDatas_fDeptDr"
	.i sortField="tDeptCode" s sortField1="OIncomeDatas_tDeptCode"
	.i sortField="tDeptName" s sortField1="OIncomeDatas_tDeptName"
	.i sortField="inTDeptName" s sortField1="OIncomeDatas_tDeptDr"
	.i sortField="patDeptCode" s sortField1="OIncomeDatas_patDeptCode"
	.i sortField="patDeptName" s sortField1="OIncomeDatas_patDeptName"
	.i sortField="inPatDeptName" s sortField1="OIncomeDatas_patDeptDr"
	.i sortField="inType" s sortField1="OIncomeDatas_inType"
	.i sortField="remark" s sortField1="OIncomeDatas_remark"
	.i sortField="inDate" s sortField1="OIncomeDatas_inDate"
	
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
	s jsonTitle="rowid^intervalDr^intervalName^feeDate^patType^itemCode^itemName^itemDr^inItemCode^inItemName^fee^cost^fDeptCode^fDeptName^fDeptDr^inFDeptCode^inFDeptName^tDeptCode^tDeptName^tDeptDr^inTDeptCode^inTDeptName^patDeptCode^patDeptName^patDeptDr^inPatDeptCode^inPatDeptName^inType^personDr^personName^remark^inDate"
	
	While(result.Next())
	{
		s rowid=result.Data("OIncomeDatas_rowid")
		s intervalDr=result.Data("OIncomeDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s feeDate=result.Data("OIncomeDatas_feeDate")
		i feeDate'="" s feeDate=$zd(feeDate,3)
		
		s patType=result.Data("OIncomeDatas_patType")
		i patType="I" s patType="住院"
		i patType="O" s patType="门诊"
		i patType="E" s patType="急诊"
		i patType="H" s patType="体检"
		
		s itemCode=result.Data("OIncomeDatas_itemCode")
		s itemName=result.Data("OIncomeDatas_itemName")
		
		s itemDr=result.Data("OIncomeDatas_itemDr")
		s inItemName=""
		s inItemCode=""
		i itemDr'="" d
		.s inItemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s inItemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("OIncomeDatas_fee")
		s cost=result.Data("OIncomeDatas_cost")
		s fDeptCode=result.Data("OIncomeDatas_fDeptCode")
		s fDeptName=result.Data("OIncomeDatas_fDeptName")
		
		s fDeptDr=result.Data("OIncomeDatas_fDeptDr")
		s inFDeptCode=""
		s inFDeptName=""
		i fDeptDr'="" d
		.s inFDeptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
		.s inFDeptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
		
		s tDeptCode=result.Data("OIncomeDatas_tDeptCode")
		s tDeptName=result.Data("OIncomeDatas_tDeptName")
		
		s tDeptDr=result.Data("OIncomeDatas_tDeptDr")
		s inTDeptCode=""
		s inTDeptName=""
		i tDeptDr'="" d
		.s inTDeptCode=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",1)
		.s inTDeptName=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",2)
		
		s patDeptCode=result.Data("OIncomeDatas_patDeptCode")
		s patDeptName=result.Data("OIncomeDatas_patDeptName")
		
		s patDeptDr=result.Data("OIncomeDatas_patDeptDr")
		s inPatDeptCode=""
		s inPatDeptName=""
		i patDeptDr'="" d
		.s inPatDeptCode=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",1)
		.s inPatDeptName=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",2)
		
		s inType=result.Data("OIncomeDatas_inType")
		i inType="input" s inType="录入"
		i inType="load" s inType="导入"
		
		s personDr=result.Data("OIncomeDatas_inPersonDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("OIncomeDatas_remark")
		s inDate=result.Data("OIncomeDatas_inDate")
		i inDate'="" s inDate=$zd(inDate,3)
		

		s tmp=rowid_"^"_intervalDr_"^"_intervalName_"^"_feeDate_"^"_patType_"^"_itemCode_"^"_itemName_"^"_itemDr_"^"_inItemCode_"^"_inItemName_"^"_fee_"^"_cost_"^"_fDeptCode_"^"_fDeptName_"^"_fDeptDr_"^"_inFDeptCode_"^"_inFDeptName_"^"_tDeptCode_"^"_tDeptName_"^"_tDeptDr_"^"_inTDeptCode_"^"_inTDeptName_"^"_patDeptCode_"^"_patDeptName_"^"_patDeptDr_"^"_inPatDeptCode_"^"_inPatDeptName_"^"_inType_"^"_personDr_"^"_personName_"^"_remark_"^"_inDate
		
		i searchValue'="" d
		.q:(searchField="feeDate")&(feeDate'[searchValue)
		.q:(searchField="patType")&(patType'[searchValue)
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="inItemName")&(inItemName'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="cost")&(cost'[searchValue)
		.q:(searchField="fDeptCode")&(fDeptCode'[searchValue)
		.q:(searchField="fDeptName")&(fDeptName'[searchValue)
		.q:(searchField="inFDeptName")&(inFDeptName'[searchValue)
		.q:(searchField="tDeptCode")&(tDeptCode'[searchValue)
		.q:(searchField="tDeptName")&(tDeptName'[searchValue)
		.q:(searchField="inTDeptName")&(inTDeptName'[searchValue)
		.q:(searchField="patDeptCode")&(patDeptCode'[searchValue)
		.q:(searchField="patDeptName")&(patDeptName'[searchValue)
		.q:(searchField="inPatDeptName")&(inPatDeptName'[searchValue)
		.q:(searchField="personName")&(personName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
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

/// Creator：杨旭
/// CreatDate：2010-01-5
/// Description: 按业务项类别对照项目
/// Table：dhc.ca.cache.data.OIncomeDatas
/// Input：intervalDr-月份ID;deptType-转换部门类型
/// Output：
/// Return：0为成功,否则为错误代码
/// Others：w ##class(dhc.ca.cache.udata.uOIncomeDatas).InnerDeptControl(1,11)
ClassMethod InnerDeptControl(intervalDr, deptType) As %String
{
	q:intervalDr="" "emptyIntervalDr"
	q:deptType="" "emptyDeptType"
	n (intervalDr, deptType)
	
	TSTART
	s Rs=0
	s tmpIncomeDr=""
	f  s tmpIncomeDr=$o(^DHCCAOIncomeDatas(0,"Interval",intervalDr,tmpIncomeDr)) q:tmpIncomeDr=""  d
	.k PLIST
	.s tmpDeptDr=""
	.i $d(^DHCCAOIncomeDatas(tmpIncomeDr)) d
	..s tmpDeptDr=$p(^DHCCAOIncomeDatas(tmpIncomeDr),"^",deptType)
	.s controlDr=""
	.i tmpDeptDr'="" d
	..s controlDr=$o(^DHCCAINNERDEPTCONTROL(0,"OldDept",tmpDeptDr,controlDr))
	.s newDeptDr=""
	.i controlDr'="" d
	..i $d(^DHCCAINNERDEPTCONTROL(controlDr)) d
	...s newDeptDr=$p(^DHCCAINNERDEPTCONTROL(controlDr),"^",2)
	..s PLIST(deptType+1)=newDeptDr
	..&SQL(UPDATE dhc_ca_cache_data.OIncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)
	..i SQLCODE'=0 s Rs=SQLCODE
	i Rs'=0 TROLLBACK
	e  TCOMMIT
	q Rs
}

/// Others：w ##class(dhc.ca.cache.udata.uOIncomeDatas).Test()
ClassMethod Test() As %String
{
	s fDept=""          //1.如果开单科室没在科室分层套的直接医疗类科室里;//转病人科室wyy
	s fDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s fDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(fDept)
	s tmpD=""
	;&SQL(update dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_fDeptDr=OIncomeDatas_patDeptDr where OIncomeDatas_rowid in (SELECT OIncomeDatas_rowid FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_fDeptDr not in(:fDept)))
	s sqlStr="SELECT OIncomeDatas_rowid FROM dhc_ca_cache_data.OIncomeDatas WHERE OIncomeDatas_fDeptDr not in("_fDept_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s allRowid=""
	While(result.Next())
	{
		s rowid=result.Data("OIncomeDatas_rowid")
		i allRowid="" d
		.s allRowid=rowid
		e  d
		.s allRowid=allRowid_","_rowid
	}
	w allRowid,!
	;&SQL(update dhc_ca_cache_data.OIncomeDatas set OIncomeDatas_fDeptDr=OIncomeDatas_patDeptDr where OIncomeDatas_rowid in (:allRowid))
	q $$$OK
}

Storage Default
{
<StreamLocation>^dhc.ca.cache680.uOIncomeDatasS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
