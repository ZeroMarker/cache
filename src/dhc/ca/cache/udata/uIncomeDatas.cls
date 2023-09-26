/// Creator: 杨旭
/// CreatDate: 2009-11-29
/// Description: 收入数据表维护
Class dhc.ca.cache.udata.uIncomeDatas Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-11-29
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;remark-备注;debit-借方;loans-贷方;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(intervalDr, feeDate, patType, itemDr, fee, cost, fDeptDr, tDeptDr, patDeptDr, inPersonDr, remark, PatWardDr, PatDocDr) As %String
{
	n (intervalDr, feeDate, patType, itemDr, fee, cost, fDeptDr, tDeptDr, patDeptDr, inPersonDr, remark,PatWardDr,PatDocDr)
	i feeDate'="" s feeDate=$zdh(feeDate,3)
	s nowDate=$p($h,",",1)
	&SQL(INSERT INTO dhc_ca_cache_data.IncomeDatas (IncomeDatas_intervalDr,IncomeDatas_feeDate,IncomeDatas_patType,IncomeDatas_itemDr,IncomeDatas_fee,IncomeDatas_cost,IncomeDatas_fDeptDr,IncomeDatas_tDeptDr,IncomeDatas_patDeptDr,IncomeDatas_inType,IncomeDatas_inPersonDr,IncomeDatas_remark,IncomeDatas_inDate,IncomeDatas_PatWardDr, IncomeDatas_PatDocDr) VALUES (:intervalDr, :feeDate, :patType, :itemDr, :fee, :cost, :fDeptDr, :tDeptDr, :patDeptDr, 'input', :inPersonDr, :remark, :nowDate,:PatWardDr,:PatDocDr))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-29
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.IncomeDatas
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
	//s PLIST(23)=PatWardCode	//zhw  去掉这四项 20160818 
	//s PLIST(24)=PatWardDesc
	//s PLIST(26)=PatDocCode
	//s PLIST(27)=PatDocDesc
	&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-29
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// w ##class(dhc.ca.cache.udata.uIncomeDatas).ListRec("","","inPatDeptName","ASC",0,25,6)
/// Others: w ##class(dhc.ca.cache.udata.uIncomeDatas).ListRec("","","rowid","DESC",0,25,1)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_intervalDr
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr)
	
	s sqlStr="SELECT IncomeDatas_inDate, IncomeDatas_rowid,IncomeDatas_intervalDr, IncomeDatas_feeDate, IncomeDatas_patType, IncomeDatas_itemCode, IncomeDatas_itemName, IncomeDatas_itemDr, IncomeDatas_fee, IncomeDatas_cost, IncomeDatas_fDeptCode, IncomeDatas_fDeptName, IncomeDatas_fDeptDr, IncomeDatas_tDeptCode, IncomeDatas_tDeptName, IncomeDatas_tDeptDr, IncomeDatas_patDeptCode, IncomeDatas_patDeptName, IncomeDatas_patDeptDr, IncomeDatas_inType, IncomeDatas_inPersonDr, IncomeDatas_remark,IncomeDatas_PatWardCode, IncomeDatas_PatWardDesc, IncomeDatas_PatWardDr, IncomeDatas_PatDocCode, IncomeDatas_PatDocDesc, IncomeDatas_PatDocDr, IncomeDatas_fDocCode, IncomeDatas_fDocName, IncomeDatas_fDocDr  FROM dhc_ca_cache_data.IncomeDatas"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND IncomeDatas_intervalDr='"_intervalDr_"' "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="IncomeDatas_rowid"
	.i sortField="feeDate" s sortField1="IncomeDatas_feeDate"
	.i sortField="itemCode" s sortField1="IncomeDatas_itemCode"
	.i sortField="itemName" s sortField1="IncomeDatas_itemName"
	.i sortField="inItemName" s sortField1="IncomeDatas_itemDr"
	.i sortField="fee" s sortField1="IncomeDatas_fee"
	.i sortField="cost" s sortField1="IncomeDatas_cost"
	.i sortField="fDeptCode" s sortField1="IncomeDatas_fDeptCode"
	.i sortField="fDeptName" s sortField1="IncomeDatas_fDeptName"
	.i sortField="inFDeptName" s sortField1="IncomeDatas_fDeptDr"
	.i sortField="tDeptCode" s sortField1="IncomeDatas_tDeptCode"
	.i sortField="tDeptName" s sortField1="IncomeDatas_tDeptName"
	.i sortField="inTDeptName" s sortField1="IncomeDatas_tDeptDr"
	.i sortField="patDeptCode" s sortField1="IncomeDatas_patDeptCode"
	.i sortField="patDeptName" s sortField1="IncomeDatas_patDeptName"
	.i sortField="inPatDeptName" s sortField1="IncomeDatas_patDeptDr"
	.i sortField="inType" s sortField1="IncomeDatas_inType"
	.i sortField="remark" s sortField1="IncomeDatas_remark"
	.i sortField="inDate" s sortField1="IncomeDatas_inDate"
	 
	.i sortField="patWardCode" s sortField1="IncomeDatas_PatWardCode"
	.i sortField="patWardDesc" s sortField1="IncomeDatas_PatWardDesc"
	.i sortField="inPatWardDesc" s sortField1="IncomeDatas_PatWardDr"
	
	.i sortField="patDocCode" s sortField1="IncomeDatas_PatDocCode,"
	.i sortField="patDocDesc" s sortField1="IncomeDatas_PatDocDesc"
	.i sortField="inPatDocDesc" s sortField1="IncomeDatas_PatDocDr"
	
	.i sortField="fDocCode" s sortField1="IncomeDatas_fDocCode"
	.i sortField="fDocName" s sortField1="IncomeDatas_fDocName"
	.i sortField="fInDocName" s sortField1="IncomeDatas_fDocDr"
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
		s rowid=result.Data("IncomeDatas_rowid")
		s intervalDr=result.Data("IncomeDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s feeDate=result.Data("IncomeDatas_feeDate")
		i feeDate'="" s feeDate=$zd(feeDate,3)
		
		s patType=result.Data("IncomeDatas_patType")
		i patType="I" s patType="住院"
		i patType="O" s patType="门诊"
		i patType="E" s patType="急诊"
		i patType="H" s patType="体检"
		
		s itemCode=result.Data("IncomeDatas_itemCode")
		s itemName=result.Data("IncomeDatas_itemName")
		
		s itemDr=result.Data("IncomeDatas_itemDr")
		s inItemName=""
		s inItemCode=""
		i itemDr'="" d
		.s inItemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s inItemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("IncomeDatas_fee")
		s cost=result.Data("IncomeDatas_cost")
		s fDeptCode=result.Data("IncomeDatas_fDeptCode")
		s fDeptName=result.Data("IncomeDatas_fDeptName")
		
		s fDeptDr=result.Data("IncomeDatas_fDeptDr")
		s inFDeptCode=""
		s inFDeptName=""
		i fDeptDr'="" d
		.s inFDeptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
		.s inFDeptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
		
		s tDeptCode=result.Data("IncomeDatas_tDeptCode")
		s tDeptName=result.Data("IncomeDatas_tDeptName")
		
		s tDeptDr=result.Data("IncomeDatas_tDeptDr")
		s inTDeptCode=""
		s inTDeptName=""
		i tDeptDr'="" d
		.s inTDeptCode=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",1)
		.s inTDeptName=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",2)
		
		s patDeptCode=result.Data("IncomeDatas_patDeptCode")
		s patDeptName=result.Data("IncomeDatas_patDeptName")
		
		s patDeptDr=result.Data("IncomeDatas_patDeptDr")
		s inPatDeptCode=""
		s inPatDeptName=""
		i patDeptDr'="" d
		.s inPatDeptCode=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",1)
		.s inPatDeptName=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",2)
		
		s inType=result.Data("IncomeDatas_inType")
		i inType="input" s inType="录入"
		i inType="load" s inType="导入"
		
		s personDr=result.Data("IncomeDatas_inPersonDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("IncomeDatas_remark")
		s inDate=result.Data("IncomeDatas_inDate")
		i inDate'="" s inDate=$zd(inDate,3)
		
		s PatWardCode=result.Data("IncomeDatas_PatWardCode")
		s PatWardDesc=result.Data("IncomeDatas_PatWardDesc")
		
		s PatWardDr=result.Data("IncomeDatas_PatWardDr")
		s inPatWardCode=""
		s inPatWardDesc=""
		i PatWardDr'="" d
		.s inPatWardCode=$p($g(^DHCCAUNITDEPTS(PatWardDr)),"^",1)
		.s inPatWardDesc=$p($g(^DHCCAUNITDEPTS(PatWardDr)),"^",2)
		
		s PatDocCode=result.Data("IncomeDatas_PatDocCode")
		s PatDocDesc=result.Data("IncomeDatas_PatDocDesc")
		
		s PatDocDr=result.Data("IncomeDatas_PatDocDr")
		s inPatDocCode=""
		s inPatDocDesc=""
		i PatDocDr'="" d
		.s inPatDocCode=$p($g(^DHCCAUNITDEPTS(PatDocDr)),"^",1)
		.s inPatDocDesc=$p($g(^DHCCAUNITDEPTS(PatDocDr)),"^",2)
		
				
		s fDocCode=result.Data("IncomeDatas_fDocCode")
		s fDocName=result.Data("IncomeDatas_fDocName")
		s fDocDr=result.Data("IncomeDatas_fDocDr")
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
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uIncomeDatas).CheckUser(1)
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
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uIncomeDatas).refreshRec(31,1,"")
ClassMethod refreshRec(intervalDr, loadRulesDr, id) As %String
{
	n (intervalDr,loadRulesDr,id)

	
	TSTART

	s flag=0
	q:loadRulesDr="" 1
	
	s sqlStr="SELECT IncomeDatas_inDate, IncomeDatas_rowid,IncomeDatas_intervalDr, IncomeDatas_feeDate, IncomeDatas_patType, IncomeDatas_itemCode, IncomeDatas_itemName, IncomeDatas_itemDr, IncomeDatas_fee, IncomeDatas_cost, IncomeDatas_fDeptCode, IncomeDatas_fDeptName, IncomeDatas_fDeptDr, IncomeDatas_tDeptCode, IncomeDatas_tDeptName, IncomeDatas_tDeptDr, IncomeDatas_patDeptCode, IncomeDatas_patDeptName, IncomeDatas_patDeptDr, IncomeDatas_PatWardCode, IncomeDatas_PatWardDesc, IncomeDatas_PatWardDr, IncomeDatas_PatDocCode, IncomeDatas_PatDocDesc, IncomeDatas_PatDocDr, IncomeDatas_inType, IncomeDatas_inPersonDr, IncomeDatas_remark, IncomeDatas_fDocCode, IncomeDatas_fDocName, IncomeDatas_fDocDr FROM dhc_ca_cache_data.IncomeDatas"
	s whereStr=" WHERE %ID>0 "
	
	i id'="" d
	.i intervalDr'="" s whereStr=whereStr_"AND IncomeDatas_intervalDr='"_intervalDr_"' And IncomeDatas_rowid='"_id_"' "
	e  d
	.i intervalDr'="" s whereStr=whereStr_"AND IncomeDatas_intervalDr='"_intervalDr_"'"
	s sqlStr=sqlStr_whereStr

	
	s result=##class(%Library.ResultSet).%New()
	
	s deptSetDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",4)
	s itemSetDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",5)
	s itemTypeDr=$p($g(^DHCCALOADRULES(loadRulesDr)),"^",6)
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		k PLIST
		s rowid=result.Data("IncomeDatas_rowid")
		s itemCode=result.Data("IncomeDatas_itemCode")
		s patType=result.Data("IncomeDatas_patType")
	    i patType="E" s PLIST(4)="O"
		s itemDr=""
		
		i ((itemCode'="")&(itemSetDr'="")) s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemSetDr,itemCode)
		i ((itemCode'="")&(itemTypeDr'="")) s itemDr=..ItemRelation(itemTypeDr,itemCode)
		
		i itemDr'="" s PLIST(7)=itemDr
		

		s fDeptCode=""
		s fDeptDr=""
		s fDeptCode=result.Data("IncomeDatas_fDeptCode")
   
	    i fDeptCode'=""  d 
		.s fDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,fDeptCode,patType)
	
		.i fDeptDr'="" s PLIST(12)=fDeptDr
		
		s tDeptCode=""
		s tDeptDr=""
		s tDeptCode=result.Data("IncomeDatas_tDeptCode")
	
	    i tDeptCode'="" d
		.s tDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,tDeptCode,patType)

		.i tDeptDr'="" s PLIST(15)=tDeptDr
		
		s patDeptCode=""
		s patDeptDr=""
		s patDeptCode=result.Data("IncomeDatas_patDeptCode")
		
	    i patDeptCode'="" d
		.s patDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,patDeptCode,patType)
		.i patDeptDr'="" s PLIST(18)=patDeptDr
		
		
		&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() where %ID=:rowid)
		i SQLCODE'=0 d 
		s flag=SQLCODE
	}

	d result.Close()
	i flag=0 d
	.TCOMMIT
	e  d
	.TROLLBACK

	//处理把急诊收入都归为门诊收入lxc2010-10-27
    &SQL(update dhc_ca_cache_data.incomedatas set incomedatas_pattype='O' where incomedatas_intervaldr=:intervalDr and incomedatas_pattype='E')
    /*    
	//1.如果开单科室没在科室分层套的直接医疗类科室里;//转病人科室wyy
	s fDept=""         
	s fDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s fDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(fDept)
	s sqlStr="SELECT IncomeDatas_rowid FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_fDeptDr not in("_fDept_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("IncomeDatas_rowid")
		&SQL(update dhc_ca_cache_data.incomedatas set incomedatas_fDeptDr=incomedatas_patDeptDr where IncomeDatas_rowid=:rowid)	
	}
  
	//2.执行科室没在科室分层套的直接医疗类科室或医技类科室里；//转开单科室wyy
	s tDept="" 
	s tDepts=""         
	s tDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s tDepts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	s tDept= ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(5)
	s tDepts=tDepts_","_##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	s sqlStr="SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_tDeptDr not in("_tDepts_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("IncomeDatas_rowid")
		&SQL(update dhc_ca_cache_data.incomedatas set incomedatas_tDeptDr=incomedatas_fDeptDr where IncomeDatas_rowid=:rowid)	
	}

 	//3.如果病人科室没在科室分层套的直接医疗类科室里; 这几种情况都过滤出来；//转开单科室wyy
	s patDept="" 
	s patDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s patDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(patDept)
	s sqlStr="SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_patDeptDr not in("_patDept_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("IncomeDatas_rowid")
		&SQL(update dhc_ca_cache_data.incomedatas set incomedatas_patDeptDr=incomedatas_fDeptDr where IncomeDatas_rowid=:rowid)	
			
	}
	*/
	q flag
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uIncomeDatas).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input：remark-备注
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uIncomeDatas).DelRec(3)
ClassMethod DelByRemarkRec(remark) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_remark=:remark)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-30
/// Description: 删除记录
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uIncomeDatas).DelRecByMonth(3)
ClassMethod DelRecByMonth(monthDr) As %String
{
	n (monthDr)
	&SQL(DELETE FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=:monthDr)
	i SQLCODE=100 s SQLCODE=0	//zjw 20160913 针对月份数据为空时删除语句的返回值为100  
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-11-10
/// Description: 返回当前日期是否在指定核算区间内
/// Table：dhc.ca.cache.data.IncomeDatas
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
/// Table：dhc.ca.cache.data.IncomeDatas
/// Input：TypeItemDr-业务项类别;ItemCode-需要对照的业务项CODE
/// Output：
/// Return：Y-是,N-否
/// Others：w ##class(dhc.ca.cache.udata.uIncomeDatas).ItemRelation(7,"233")
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
/// Others:w ##class(dhc.ca.cache.udata.uIncomeDatas).ListRemain("6","","","RowId","DESC","26","25","")
ClassMethod ListRemain(intervalDr, searchField, searchValue, sortField, sortDir, start, limit, type)
{
	;q intervalDr_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_type
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, type)
	
	;s sqlStr="SELECT * FROM (SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_tDeptDr is null union SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_fDeptDr is null union SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_patDeptDr is null union SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_itemDr is null "
	s sqlStr="SELECT * FROM ( SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE (IncomeDatas_tDeptDr is null or IncomeDatas_fDeptDr is null or IncomeDatas_patDeptDr is null or IncomeDatas_itemDr is null) "
	
	s whereStr=""
	
	s fDept=""          //1.如果开单科室没在科室分层套的直接医疗类科室里;//转病人科室wyy
	s fDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s fDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(fDept)
	i fDept'="" d  s whereStr=whereStr_" union SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_fDeptDr not in("_fDept_") "
	/*
	s tDept=""          //2.执行科室没在科室分层套的直接医疗类科室或医技类科室里；//转开单科室wyy
	s tDepts=""         
	s tDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s tDepts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	s tDept= ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(5)
	s tDepts=tDepts_","_##class(dhc.ca.cache.udata.uCostResultData).GetDepts(tDept)
	i tDepts'="" d  s whereStr=whereStr_" union SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_tDeptDr not in("_tDepts_") "
	
	s patDept=""          //3.如果病人科室没在科室分层套的直接医疗类科室里; 这几种情况都过滤出来。
	s patDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s patDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(patDept)
	i patDept'="" d  s whereStr=whereStr_" union SELECT * FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_patDeptDr not in("_patDept_")) "
	*/
	s whereStr=whereStr_" ) WHERE IncomeDatas_rowid>0 "
	
	i intervalDr'="" s whereStr=whereStr_" AND IncomeDatas_intervalDr='"_intervalDr_"' "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="IncomeDatas_rowid"
	.i sortField="feeDate" s sortField1="IncomeDatas_feeDate"
	.i sortField="itemCode" s sortField1="IncomeDatas_itemCode"
	.i sortField="itemName" s sortField1="IncomeDatas_itemName"
	.i sortField="inItemName" s sortField1="IncomeDatas_itemDr"
	.i sortField="fee" s sortField1="IncomeDatas_fee"
	.i sortField="cost" s sortField1="IncomeDatas_cost"
	.i sortField="fDeptCode" s sortField1="IncomeDatas_fDeptCode"
	.i sortField="fDeptName" s sortField1="IncomeDatas_fDeptName"
	.i sortField="inFDeptName" s sortField1="IncomeDatas_fDeptDr"
	.i sortField="tDeptCode" s sortField1="IncomeDatas_tDeptCode"
	.i sortField="tDeptName" s sortField1="IncomeDatas_tDeptName"
	.i sortField="inTDeptName" s sortField1="IncomeDatas_tDeptDr"
	.i sortField="patDeptCode" s sortField1="IncomeDatas_patDeptCode"
	.i sortField="patDeptName" s sortField1="IncomeDatas_patDeptName"
	.i sortField="inPatDeptName" s sortField1="IncomeDatas_patDeptDr"
	.i sortField="inType" s sortField1="IncomeDatas_inType"
	.i sortField="remark" s sortField1="IncomeDatas_remark"
	.i sortField="inDate" s sortField1="IncomeDatas_inDate"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY IncomeDatas_rowid DESC"
	
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
		s rowid=result.Data("IncomeDatas_rowid")
		s intervalDr=result.Data("IncomeDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s feeDate=result.Data("IncomeDatas_feeDate")
		i feeDate'="" s feeDate=$zd(feeDate,3)
		
		s patType=result.Data("IncomeDatas_patType")
		i patType="I" s patType="住院"
		i patType="O" s patType="门诊"
		i patType="E" s patType="急诊"
		i patType="H" s patType="体检"
		
		s itemCode=result.Data("IncomeDatas_itemCode")
		s itemName=result.Data("IncomeDatas_itemName")
		
		s itemDr=result.Data("IncomeDatas_itemDr")
		s inItemName=""
		s inItemCode=""
		i itemDr'="" d
		.s inItemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s inItemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("IncomeDatas_fee")
		s cost=result.Data("IncomeDatas_cost")
		s fDeptCode=result.Data("IncomeDatas_fDeptCode")
		s fDeptName=result.Data("IncomeDatas_fDeptName")
		
		s fDeptDr=result.Data("IncomeDatas_fDeptDr")
		s inFDeptCode=""
		s inFDeptName=""
		i fDeptDr'="" d
		.s inFDeptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
		.s inFDeptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
		
		s tDeptCode=result.Data("IncomeDatas_tDeptCode")
		s tDeptName=result.Data("IncomeDatas_tDeptName")
		
		s tDeptDr=result.Data("IncomeDatas_tDeptDr")
		s inTDeptCode=""
		s inTDeptName=""
		i tDeptDr'="" d
		.s inTDeptCode=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",1)
		.s inTDeptName=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",2)
		
		s patDeptCode=result.Data("IncomeDatas_patDeptCode")
		s patDeptName=result.Data("IncomeDatas_patDeptName")
		
		s patDeptDr=result.Data("IncomeDatas_patDeptDr")
		s inPatDeptCode=""
		s inPatDeptName=""
		i patDeptDr'="" d
		.s inPatDeptCode=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",1)
		.s inPatDeptName=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",2)
		
		s inType=result.Data("IncomeDatas_inType")
		i inType="input" s inType="录入"
		i inType="load" s inType="导入"
		
		s personDr=result.Data("IncomeDatas_inPersonDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("IncomeDatas_remark")
		s inDate=result.Data("IncomeDatas_inDate")
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
/// Table: dhc.ca.cache.data.IncomeDatas
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uIncomeDatas).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod FindRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr, feeDate, itemDr, fDeptDr, tDeptDr, patDeptDr, itemCode, itemName, fDeptCode, fDeptName, tDeptCode, tDeptName, patDeptCode, patDeptName)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, feeDate, itemDr, fDeptDr, tDeptDr, patDeptDr, itemCode, itemName, fDeptCode, fDeptName, tDeptCode, tDeptName, patDeptCode, patDeptName )
	
	s sqlStr="SELECT IncomeDatas_inDate, IncomeDatas_rowid,IncomeDatas_intervalDr, IncomeDatas_feeDate, IncomeDatas_patType, IncomeDatas_itemCode, IncomeDatas_itemName, IncomeDatas_itemDr, IncomeDatas_fee, IncomeDatas_cost, IncomeDatas_fDeptCode, IncomeDatas_fDeptName, IncomeDatas_fDeptDr, IncomeDatas_tDeptCode, IncomeDatas_tDeptName, IncomeDatas_tDeptDr, IncomeDatas_patDeptCode, IncomeDatas_patDeptName, IncomeDatas_patDeptDr, IncomeDatas_inType, IncomeDatas_inPersonDr, IncomeDatas_remark FROM dhc_ca_cache_data.IncomeDatas"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND IncomeDatas_intervalDr='"_intervalDr_"' "
	i feeDate'="" d
	.s feeDate=$zdh(feeDate,3)
	.s whereStr=whereStr_"AND IncomeDatas_feeDate='"_feeDate_"' "
	i itemDr'="" s whereStr=whereStr_"AND IncomeDatas_itemDr='"_itemDr_"' "
	i fDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_fDeptDr='"_fDeptDr_"' "
	i tDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_tDeptDr='"_tDeptDr_"' "
	i itemCode'="" s whereStr=whereStr_"AND IncomeDatas_itemCode='"_itemCode_"' "
	i itemName'="" s whereStr=whereStr_"AND IncomeDatas_itemName='"_itemName_"' "
	i patDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_patDeptDr='"_patDeptDr_"' " 
	i fDeptCode'="" s whereStr=whereStr_"AND IncomeDatas_fDeptCode='"_fDeptCode_"' "
	i fDeptName'="" s whereStr=whereStr_"AND IncomeDatas_fDeptName='"_fDeptName_"' "
	i tDeptCode'="" s whereStr=whereStr_"AND IncomeDatas_tDeptCode='"_tDeptCode_"' "
	i tDeptName'="" s whereStr=whereStr_"AND IncomeDatas_tDeptName='"_tDeptName_"' "
	i patDeptCode'="" s whereStr=whereStr_"AND IncomeDatas_patDeptCode='"_patDeptCode_"' "
	i patDeptName'="" s whereStr=whereStr_"AND IncomeDatas_patDeptName='"_patDeptName_"' "
	
	
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="IncomeDatas_rowid"
	.i sortField="feeDate" s sortField1="IncomeDatas_feeDate"
	.i sortField="itemCode" s sortField1="IncomeDatas_itemCode"
	.i sortField="itemName" s sortField1="IncomeDatas_itemName"
	.i sortField="inItemName" s sortField1="IncomeDatas_itemDr"
	.i sortField="fee" s sortField1="IncomeDatas_fee"
	.i sortField="cost" s sortField1="IncomeDatas_cost"
	.i sortField="fDeptCode" s sortField1="IncomeDatas_fDeptCode"
	.i sortField="fDeptName" s sortField1="IncomeDatas_fDeptName"
	.i sortField="inFDeptName" s sortField1="IncomeDatas_fDeptDr"
	.i sortField="tDeptCode" s sortField1="IncomeDatas_tDeptCode"
	.i sortField="tDeptName" s sortField1="IncomeDatas_tDeptName"
	.i sortField="inTDeptName" s sortField1="IncomeDatas_tDeptDr"
	.i sortField="patDeptCode" s sortField1="IncomeDatas_patDeptCode"
	.i sortField="patDeptName" s sortField1="IncomeDatas_patDeptName"
	.i sortField="inPatDeptName" s sortField1="IncomeDatas_patDeptDr"
	.i sortField="inType" s sortField1="IncomeDatas_inType"
	.i sortField="remark" s sortField1="IncomeDatas_remark"
	.i sortField="inDate" s sortField1="IncomeDatas_inDate"
	
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
		s rowid=result.Data("IncomeDatas_rowid")
		s intervalDr=result.Data("IncomeDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s feeDate=result.Data("IncomeDatas_feeDate")
		i feeDate'="" s feeDate=$zd(feeDate,3)
		
		s patType=result.Data("IncomeDatas_patType")
		i patType="I" s patType="住院"
		i patType="O" s patType="门诊"
		i patType="E" s patType="急诊"
		i patType="H" s patType="体检"
		
		s itemCode=result.Data("IncomeDatas_itemCode")
		s itemName=result.Data("IncomeDatas_itemName")
		
		s itemDr=result.Data("IncomeDatas_itemDr")
		s inItemName=""
		s inItemCode=""
		i itemDr'="" d
		.s inItemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s inItemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("IncomeDatas_fee")
		s cost=result.Data("IncomeDatas_cost")
		s fDeptCode=result.Data("IncomeDatas_fDeptCode")
		s fDeptName=result.Data("IncomeDatas_fDeptName")
		
		s fDeptDr=result.Data("IncomeDatas_fDeptDr")
		s inFDeptCode=""
		s inFDeptName=""
		i fDeptDr'="" d
		.s inFDeptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
		.s inFDeptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
		
		s tDeptCode=result.Data("IncomeDatas_tDeptCode")
		s tDeptName=result.Data("IncomeDatas_tDeptName")
		
		s tDeptDr=result.Data("IncomeDatas_tDeptDr")
		s inTDeptCode=""
		s inTDeptName=""
		i tDeptDr'="" d
		.s inTDeptCode=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",1)
		.s inTDeptName=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",2)
		
		s patDeptCode=result.Data("IncomeDatas_patDeptCode")
		s patDeptName=result.Data("IncomeDatas_patDeptName")
		
		s patDeptDr=result.Data("IncomeDatas_patDeptDr")
		s inPatDeptCode=""
		s inPatDeptName=""
		i patDeptDr'="" d
		.s inPatDeptCode=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",1)
		.s inPatDeptName=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",2)
		
		s inType=result.Data("IncomeDatas_inType")
		i inType="input" s inType="录入"
		i inType="load" s inType="导入"
		
		s personDr=result.Data("IncomeDatas_inPersonDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("IncomeDatas_remark")
		s inDate=result.Data("IncomeDatas_inDate")
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
/// Table：dhc.ca.cache.data.IncomeDatas
/// Input：intervalDr-月份ID;deptType-转换部门类型
/// Output：
/// Return：0为成功,否则为错误代码
/// Others：w ##class(dhc.ca.cache.udata.uIncomeDatas).InnerDeptControl(1,11)
ClassMethod InnerDeptControl(intervalDr, deptType) As %String
{
	q:intervalDr="" "emptyIntervalDr"
	q:deptType="" "emptyDeptType"
	n (intervalDr, deptType)
	
	TSTART
	s Rs=0
	s tmpIncomeDr=""
	f  s tmpIncomeDr=$o(^DHCCAINCOMEDATAS(0,"Interval",intervalDr,tmpIncomeDr)) q:tmpIncomeDr=""  d
	.k PLIST
	.s tmpDeptDr=""
	.i $d(^DHCCAINCOMEDATAS(tmpIncomeDr)) d
	..s tmpDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeDr),"^",deptType)
	.s controlDr=""
	.i tmpDeptDr'="" d
	..s controlDr=$o(^DHCCAINNERDEPTCONTROL(0,"OldDept",tmpDeptDr,controlDr))
	.s newDeptDr=""
	.i controlDr'="" d
	..i $d(^DHCCAINNERDEPTCONTROL(controlDr)) d
	...s newDeptDr=$p(^DHCCAINNERDEPTCONTROL(controlDr),"^",2)
	..s PLIST(deptType+1)=newDeptDr
	..&SQL(UPDATE dhc_ca_cache_data.IncomeDatas VALUES PLIST() WHERE %ID=:tmpIncomeDr)
	..i SQLCODE'=0 s Rs=SQLCODE
	i Rs'=0 TROLLBACK
	e  TCOMMIT
	q Rs
}

/// Others：w ##class(dhc.ca.cache.udata.uIncomeDatas).Test()
ClassMethod Test() As %String
{
	s fDept=""          //1.如果开单科室没在科室分层套的直接医疗类科室里;//转病人科室wyy
	s fDept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(6)
	s fDept=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(fDept)
	s tmpD=""
	;&SQL(update dhc_ca_cache_data.incomedatas set incomedatas_fDeptDr=incomedatas_patDeptDr where IncomeDatas_rowid in (SELECT IncomeDatas_rowid FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_fDeptDr not in(:fDept)))
	s sqlStr="SELECT IncomeDatas_rowid FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_fDeptDr not in("_fDept_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s allRowid=""
	While(result.Next())
	{
		s rowid=result.Data("IncomeDatas_rowid")
		i allRowid="" d
		.s allRowid=rowid
		e  d
		.s allRowid=allRowid_","_rowid
	}
	w allRowid,!
	;&SQL(update dhc_ca_cache_data.incomedatas set incomedatas_fDeptDr=incomedatas_patDeptDr where IncomeDatas_rowid in (:allRowid))
	q $$$OK
}

/// Creator: zjw
/// CreatDate: 2015-05-06
/// Description: 查询符合条件的记录
/// Table: dhc_ca_cache_data.IncomeDatas 
/// Input: Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串start=0&limit=25&monthDr=1
/// Others:w ##class(dhc.ca.cache.udata.uIncomeDatas).listIncome(3,0,25)
ClassMethod listIncome(intervalDr, start, limit)
{
	;q intervalDr_"^"_start_"^"_limit
	n (intervalDr, start, limit)
	

	s sqlStr="SELECT  IncomeDatas_patType, count(IncomeDatas_rowid) as counts, sum(IncomeDatas_fee)  as fees FROM dhc_ca_cache_data.IncomeDatas "
			_"	WHERE   IncomeDatas_intervalDr='"_intervalDr_"'"_" AND IncomeDatas_fDeptCode LIKE '%HC%' GROUP BY IncomeDatas_patType "
			_"	UNION SELECT  'Excel', count(IncomeDatas_rowid) as counts, sum(IncomeDatas_fee) as fees FROM dhc_ca_cache_data.IncomeDatas "
			_"	WHERE   IncomeDatas_intervalDr='"_intervalDr_"'"_"  AND IncomeDatas_fDeptCode NOT  LIKE '%HC%' GROUP BY 'Excel'"
			_"	UNION SELECT  'all', count(IncomeDatas_rowid) as counts, sum(IncomeDatas_fee) as fees FROM dhc_ca_cache_data.IncomeDatas "
			_"	WHERE  IncomeDatas_intervalDr='"_intervalDr_"'"_"  GROUP BY IncomeDatas_intervalDr"
			_"	UNION SELECT  'YP', count(IncomeDatas_rowid) as counts, sum(IncomeDatas_fee) as fees FROM dhc_ca_cache_data.IncomeDatas "
			_"	WHERE  IncomeDatas_intervalDr='"_intervalDr_"'"_" AND IncomeDatas_itemDr in ('115','116','117') GROUP BY IncomeDatas_intervalDr"

	//115, '西药费'   116, '中成药'   117, '中草药'
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
   
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="patType^counts^fees"
	
	While(result.Next())
	{
		s patType=result.Data("IncomeDatas_patType")
		i patType="I" s patType="住院"
		i patType="O" s patType="门诊"
		i patType="E" s patType="急诊"
		i patType="H" s patType="体检"
		i patType="Excel" s patType="上传"
		i patType="all" s patType="总计"
		i patType="YP" s patType="其中：药品"

		s counts=result.Data("counts")
		s fees=result.Data("fees")
		
		s tmp=patType_"^"_counts_"^"_$num(fees,2)
		
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uIncomeDatasS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
