/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 凭证数据表维护
Class dhc.ca.cache.udata.uSalary Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.BaseData
/// Input: intervalDr-月份ID; dataTypeDr-业务类别; itemDr-业务项; servedDeptDr-部门ID; receiverDr-接收人ID; fee-金额; operDr-操作人; remark-备注;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(intervalDr, dataTypeDr, itemDr, servedDeptDr, receiverDr, fee, operDr, remark) As %String
{
	n (intervalDr, dataTypeDr, itemDr, servedDeptDr, receiverDr, fee, operDr, remark)
	
	s operType="input"
	s operDate=$p($h,",",1)
	s operDeptDr=..GetPersonDept(operDr)
	
	&SQL(INSERT INTO dhc_ca_cache_data.BaseData (BaseData_intervalDr,BaseData_sysDataType,BaseData_dataTypeDr,BaseData_itemDr,BaseData_servedDeptDr,BaseData_receiverDr,BaseData_fee,BaseData_operType,BaseData_operDate,BaseData_operDr,BaseData_operDeptDr,BaseData_remark) VALUES (:intervalDr, 'cost', :dataTypeDr, :itemDr, :servedDeptDr, :receiverDr, :fee, :operType, :operDate,'1', :operDeptDr, :remark))  ///:operDr,写成固定值'1'
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 更新记录
/// Table: dhc.ca.cache.data.BaseData
/// Input: rowid-数据行号;itemCode-项目代码; itemName-项目名称; servedDeptCode-部门代码; servedDeptName-部门名称; receiverCode-人员名称; receiverName-人员名称; fee-金额; operDr-操作人; remark-备注;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, itemCode, itemName, servedDeptCode, servedDeptName, receiverCode, receiverName, fee, operDr, remark) As %String
{
	n (rowid, itemCode, itemName, servedDeptCode, servedDeptName, receiverCode, receiverName, fee, operDr, remark)
	s operType="input"
	s operDate=$p($h,",",1)
	s operDeptDr=..GetPersonDept(operDr)
	
	&SQL(UPDATE dhc_ca_cache_data.BaseData SET BaseData_itemCode=:itemCode,BaseData_itemName=:itemName,BaseData_servedDeptCode=:servedDeptCode,BaseData_servedDeptName=:servedDeptName,BaseData_receiverCode=:receiverCode,BaseData_receiverName=:receiverName,BaseData_fee=:fee,BaseData_operType=:operType,BaseData_operDate=:operDate,BaseData_operDr=:operDr,BaseData_operDeptDr=:operDeptDr,BaseData_remark=:remark WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.BaseData
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;intervalDr-月份ID; deptDr-部门ID; personDr-人员ID; itemType-业务类别;type-查询方式;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uSalary).ListRec
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr, inDeptDr, inPersonDr, inItemDr, itemType, type)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_intervalDr_"^"_inDeptDr_"^"_inPersonDr_"^"_inItemDr_"^"_itemType_"^"_type
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, inDeptDr, inPersonDr, inItemDr, itemType, type)
	
	s sqlStr="SELECT BaseData_rowid,BaseData_sysDataType,BaseData_intervalDr,BaseData_servedDeptDr,BaseData_servedDeptCode,BaseData_servedDeptName,BaseData_dataTypeDr,BaseData_busDate,BaseData_itemDr,BaseData_itemCode,BaseData_itemName,BaseData_servDeptDr,BaseData_servDeptCode,BaseData_servDeptName,BaseData_serverDr,BaseData_serverCode,BaseData_serverName,BaseData_receiverDr,BaseData_receiverCode,BaseData_receiverName,BaseData_fee,BaseData_operType,BaseData_operDate,BaseData_operDr,BaseData_operDeptDr,BaseData_remark,BaseData_remark1,BaseData_remark2 FROM dhc_ca_cache_data.BaseData"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND BaseData_intervalDr='"_intervalDr_"' "
	i inDeptDr'="" s whereStr=whereStr_"AND BaseData_servedDeptDr='"_inDeptDr_"' "
	i inPersonDr'="" s whereStr=whereStr_"AND BaseData_receiverDr='"_inPersonDr_"' "
	i itemType'="" s whereStr=whereStr_"AND BaseData_dataTypeDr='"_itemType_"' "
	i inItemDr'="" s whereStr=whereStr_"AND BaseData_itemDr='"_inItemDr_"' "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BaseData_rowid"
	.i sortField="itemInName" s sortField1="BaseData_itemDr"
	.i sortField="itemCode" s sortField1="BaseData_itemCode"
	.i sortField="itemName" s sortField1="BaseData_itemName"
	.i sortField="servedInDeptName" s sortField1="BaseData_servedDeptDr"
	.i sortField="servedDeptCode" s sortField1="BaseData_servedDeptCode"
	.i sortField="servedDeptName" s sortField1="BaseData_servedDeptName"
	.i sortField="receiverInName" s sortField1="BaseData_receiverDr"
	.i sortField="receiverCode" s sortField1="BaseData_receiverCode"
	.i sortField="receiverName" s sortField1="BaseData_receiverName"
	.i sortField="fee" s sortField1="BaseData_fee"
	..i sortField="operType" s sortField1="BaseData_operType"
	.i sortField="operDate" s sortField1="BaseData_operDate"
	.i sortField="operName" s sortField1="BaseData_operDr"
	.i sortField="operDeptName" s sortField1="BaseData_operDeptDr"
	.i sortField="remark" s sortField1="BaseData_remark"
	
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
	
	s total=0
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^intervalDr^intervalName^sysDataType^dataTypeDr^dataTypeName^busDate^itemDr^itemInName^itemCode^itemName^servedDeptDr^servedInDeptName^servedDeptCode^servedDeptName^receiverDr^receiverInName^receiverCode^receiverName^fee^operType^operDate^operDr^operName^operDeptDr^operDeptName^remark^remark1^remark2"
	
	While(result.Next())
	{
		s rowid=result.Data("BaseData_rowid")
		s intervalDr=result.Data("BaseData_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s sysDataType=result.Data("BaseData_sysDataType")
		s dataTypeDr=result.Data("BaseData_dataTypeDr")
		s dataTypeName=""
		i dataTypeDr'="" d 
		.i $d(^DHCCADATAITEMTYPES(dataTypeDr)) d
		..s dataTypeName=$p($g(^DHCCADATAITEMTYPES(dataTypeDr)),"^",3)
		
		s busDate=result.Data("BaseData_busDate")
		i busDate'="" d
		.s busDate=$zd(busDate,3)
		
		s itemDr=result.Data("BaseData_itemDr")
		s itemInName="" 
		i itemDr'="" d
		.i $d(^DHCCAALLDATAITEMS(itemDr)) d
		..s itemInName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s itemCode=result.Data("BaseData_itemCode")
		s itemName=result.Data("BaseData_itemName")
		
		s servedDeptDr=result.Data("BaseData_servedDeptDr")
		s servedInDeptName=""
		i servedDeptDr'="" d
		.i $d(^DHCCAUNITDEPTS(servedDeptDr)) d
		..s servedInDeptName=$p($g(^DHCCAUNITDEPTS(servedDeptDr)),"^",2)
		
		s servedDeptCode=result.Data("BaseData_servedDeptCode")
		s servedDeptName=result.Data("BaseData_servedDeptName")
		
		s receiverDr=result.Data("BaseData_receiverDr")
		s receiverInName=""
		i receiverDr'="" d
		.i $d(^DHCCAUNITPERSONS(receiverDr)) d
		..s receiverInName=$p($g(^DHCCAUNITPERSONS(receiverDr)),"^",2)
		
		s receiverCode=result.Data("BaseData_receiverCode")
		s receiverName=result.Data("BaseData_receiverName")
		
		s fee=result.Data("BaseData_fee")
		s total=total+fee
		s operType=result.Data("BaseData_operType")
		i operType="input" s operType="录入"
		i operType="load" s operType="导入"
		s operDate=result.Data("BaseData_operDate")
		i operDate'="" d
		.s operDate=$zd(operDate,3)
		
		s operDr=result.Data("BaseData_operDr")
		s operName=""
		i operDr'="" d
		.i $d(^DHCCAUNITPERSONS(operDr)) d
		..s operName=$p($g(^DHCCAUNITPERSONS(operDr)),"^",2)
		
		s operDeptDr=result.Data("BaseData_operDeptDr")
		s operDeptName=""
		i operDeptDr'="" d
		.i $d(^DHCCAUNITDEPTS(operDeptDr)) d
		..s operDeptName=$p($g(^DHCCAUNITDEPTS(operDeptDr)),"^",2)
		
		
		s remark=result.Data("BaseData_remark")
		s remark1=result.Data("BaseData_remark1")
		s remark2=result.Data("BaseData_remark2")

		s tmp=rowid_"^"_intervalDr_"^"_intervalName_"^"_sysDataType_"^"_dataTypeDr_"^"_dataTypeName_"^"_busDate_"^"_itemDr_"^"_itemInName_"^"_itemCode_"^"_itemName_"^"_servedDeptDr_"^"_servedInDeptName_"^"_servedDeptCode_"^"_servedDeptName_"^"_receiverDr_"^"_receiverInName_"^"_receiverCode_"^"_receiverName_"^"_fee_"^"_operType_"^"_operDate_"^"_operDr_"^"_operName_"^"_operDeptDr_"^"_operDeptName_"^"_remark_"^"_remark1_"^"_remark2
		
		i searchValue'="" d
		.q:(searchField="busDate")&(busDate'[searchValue)
		.q:(searchField="itemInName")&(itemInName'[searchValue)
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="servedInDeptName")&(servedInDeptName'[searchValue)
		.q:(searchField="servedDeptCode")&(servedDeptCode'[searchValue)
		.q:(searchField="servedDeptName")&(servedDeptName'[searchValue)
		.q:(searchField="receiverInName")&(receiverInName'[searchValue)
		.q:(searchField="receiverCode")&(receiverCode'[searchValue)
		.q:(searchField="receiverName")&(receiverName'[searchValue)
		.q:(searchField="fee")&(fee'[searchValue)
		.q:(searchField="operDate")&(operDate'[searchValue)
		.q:(searchField="operName")&(operName'[searchValue)
		.q:(searchField="operDeptName")&(operDeptName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	i (type="find") d
	.d json.InsertRowData("^^^^^^^^总计^^^^^^^^^^^"_total_"^^^^^^^^^")
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 删除记录
/// Table: dhc.ca.cache.data.BaseData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.data.uSalary).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.BaseData WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 删除记录
/// Table: dhc.ca.cache.data.BaseData
/// Input：intervalDr-月份
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.data.uSalary).DelRec(3)
ClassMethod DelAllRec(intervalDr, dataTypeDr) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.BaseData WHERE BaseData_intervalDr=:intervalDr and BaseData_dataTypeDr=:dataTypeDr)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-3-1
/// Description: 查询人员部门
/// Table: dhc.ca.cache.data.UnitPerson
/// Input：personId-人员ID
/// Output: 
/// Return: 返回待查人员的部门
/// Others: 
ClassMethod GetPersonDept(personId) As %String
{
	q:personId="" ""
	s resultStr=""
	s personDeptDr=""
	f  s personDeptDr=$o(^DHCCAUNITPERSONS(personId,"PersonDepts",personDeptDr)) q:personDeptDr=""  d
	.s tmpStr=$g(^DHCCAUNITPERSONS(personId,"PersonDepts",personDeptDr))
	.s deptDr=$p(tmpStr,"^",1)
	.s own=$p(tmpStr,"^",4)
	.i own="Y" s resultStr=deptDr
	q resultStr
}

/// Creator: 杨旭
/// CreatDate: 2009-12-3
/// Description: 刷新对应数据的部门与项目
/// Table: dhc.ca.cache.data.BaseData
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uSalary).refreshRec(1,1,5)
ClassMethod RefreshRec(intervalDr, itemTypeDr) As %String
{
	n (intervalDr,itemTypeDr)

	TSTART
	s flag=0
	
	s sqlStr="SELECT BaseData_rowid,BaseData_sysDataType,BaseData_intervalDr,BaseData_servedDeptDr,BaseData_servedDeptCode,BaseData_servedDeptName,BaseData_dataTypeDr,BaseData_busDate,BaseData_itemDr,BaseData_itemCode,BaseData_itemName,BaseData_servDeptDr,BaseData_servDeptCode,BaseData_servDeptName,BaseData_serverDr,BaseData_serverCode,BaseData_serverName,BaseData_receiverDr,BaseData_receiverCode,BaseData_receiverName,BaseData_fee,BaseData_operType,BaseData_operDate,BaseData_operDr,BaseData_operDeptDr,BaseData_remark,BaseData_remark1,BaseData_remark2 FROM dhc_ca_cache_data.BaseData"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND BaseData_intervalDr='"_intervalDr_"' "
	i itemTypeDr'="" s whereStr=whereStr_"AND BaseData_dataTypeDr='"_itemTypeDr_"' "
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		k PLIST
		s rowid=result.Data("BaseData_rowid")
		s itemCode=result.Data("BaseData_itemCode")
		s patType=""
	
		s itemDr=""
		
		//i ((itemCode'="")&(itemTypeDr'="")) s itemDr=##class(dhc.ca.cache.comm.CommMethod).ItemRelation(itemTypeDr,itemCode)
		i ((itemCode'="")&(itemTypeDr'="")) s itemDr=##class(dhc.ca.cache.udata.uIncomeDatas).ItemRelation(itemTypeDr,itemCode)
		
		i itemDr'="" s PLIST(6)=itemDr
		
		s personCode=""
		s personDr=""
		s personCode=result.Data("BaseData_receiverCode")
		i personCode'="" d
		.s personDr=$o(^DHCCAUNITPERSONS(0,"Code",personCode,personDr))
		
		i personDr'="" s PLIST(18)=personDr
		
		s fDeptDr=""

		i personDr'="" d
		.s fDeptDr=..GetPersonDept(personDr)
		
		i fDeptDr'="" s PLIST(15)=fDeptDr
		
		&SQL(UPDATE dhc_ca_cache_data.BaseData VALUES PLIST() where %ID=:rowid)
		i SQLCODE'=0 s flag=SQLCODE
	}
	d result.Close()
	i flag=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	q flag
}

/// Creator：zjw
/// CreatDate：2015-10-29
/// Description: 用友辅助总账导入
/// Table：dhc_ca_cache_data.BaseData
/// Input：intervalDr-核算区间，userCode-导入人
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.udata.uSalary).ImportAccassRec("13","2","demo")
ClassMethod ImportAccassRec(intervalDr, dataTypeDr, userCode) As %String
{

	q:intervalDr="" "emptyIntervalDr"
	q:dataTypeDr="" "emptydataTypeDr"
	q:userCode="" "emptyuserCode"
	TSTART
	n (intervalDr,dataTypeDr,userCode)
	s remark="用友财务数据"
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM  dhc_ca_cache_data.BaseData WHERE BaseData_intervalDr=:intervalDr AND BaseData_dataTypeDr=:dataTypeDr  and BaseData_remark=:remark )
	.s startdate=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)		 //核算区间起始日期(数字)
	.s start=$zd(startdate,8)       //63553->20150101                               
	.s YearMonth=$e(start,1,6)      //201501                                   
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	s OperatDate=+$h
	s SqlStr="SELECT a.ccode,c.ccodename,a.cdeptid,b.cDepName,a.md,a.iYPeriod   FROM dbo.GL_accass a "
			_" LEFT  JOIN herp_acct_U8Link.Department  b ON cdeptid=cDepCode "
			_" LEFT  JOIN herp_acct_U8Link.AcctSubj  c ON a.ccode=c.ccode AND a.iyear=c.iyear "
			_" WHERE  (c.ccode like '5001%' or c.ccode like '5301%'  or c.ccode like '5302%') "
			_" and c.bend=1 AND a.iYPeriod ='"_YearMonth_"' AND a.md<>0 "
	
	s ResultString=0
	s Result= ##class(%Library.ResultSet).%New()
	//w SqlStr,!
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		
		//w $zt($p($h,",",2),1),!
		s ItemCode=Result.Data("ccode")
		s ItemName=Result.Data("ccodename")
		
		s DeptCode=Result.Data("cdeptid")
		s DeptName=Result.Data("cDepName")
		
		s fee=Result.Data("md")
		
		s tmpFlag=0
	    s tmpFlag=..InsertBaseRec(intervalDr,dataTypeDr,ItemCode,ItemName,DeptCode,DeptName,fee,userDr,OperatDate,remark)
	    i tmpFlag'=0 s ResultString=tmpFlag
		q:ResultString'=0
	}
	d Result.Close()
	i ResultString =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	
	q "OK"
}

/// Creator: zjw
/// CreatDate: 2015-10-29
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.BaseData
/// Input:
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uSalary).InsertHCRec(1,"2","2","234","1","test",10,12,63553)
ClassMethod InsertBaseRec(intervalDr, dataTypeDr, ItemCode, ItemName, DeptCode, DeptName, fee, userDr, OperatDate, remark) As %Text
{
	n (intervalDr,dataTypeDr,ItemCode,ItemName,DeptCode,DeptName,fee,userDr,OperatDate,remark)
	
	&SQL(INSERT INTO dhc_ca_cache_data.BaseData(BaseData_intervalDr, BaseData_sysDataType, BaseData_dataTypeDr,BaseData_itemCode, BaseData_itemName,BaseData_servedDeptCode, BaseData_servedDeptName,BaseData_fee, BaseData_operType, BaseData_operDate, BaseData_operDr,BaseData_remark)
	VALUES (:intervalDr,"cost",:dataTypeDr,:ItemCode,:ItemName,:DeptCode,:DeptName,:fee,"load",:OperatDate,:userDr,:remark))
	
	q SQLCODE
}

/// Creator：zjw
/// CreatDate：2015-11-12
/// Description: 按照药品收入比例导入药品成本
/// Table：dhc_ca_cache_data.BaseData
/// Input：intervalDr-核算区间，userCode-导入人
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.udata.uSalary).ImportYPDataRec("12","2","1.2","demo")
ClassMethod ImportYPDataRec(intervalDr, dataTypeDr, Ratio, userCode) As %String
{

	q:intervalDr="" "emptyIntervalDr"
	q:dataTypeDr="" "emptydataTypeDr"
	q:Ratio="" "emptyRatio"
	q:userCode="" "emptyuserCode"
	s Ratio=Ratio*1
	;w Ratio,!
	;s ypincome=0
	;s ypcost=0
	TSTART
	n (intervalDr,dataTypeDr,Ratio,userCode)
	//'50010301', '西药' '50010302', '中成药' '50010303', '中草药'
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.;&sql(SELECT SUM(IncomeDatas_fee) into :ypincome FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_intervalDr=:intervalDr AND IncomeDatas_itemDr IN (SELECT LevelItems_itemDr FROM dhc_ca_cache_data.LevelItems WHERE  LevelItems_parRef=3 AND LevelItems_childSub>0))  //3 药品收入分类
	.;&sql(SELECT SUM(BaseData_fee) into :ypcost FROM dhc_ca_cache_data.BaseData WHERE BaseData_intervalDr=:intervalDr AND BaseData_dataTypeDr=:dataTypeDr and BaseData_itemCode in ('50010301','50010302','50010303','cb010301','cb010302','cb010303'))
	.&sql(DELETE FROM  dhc_ca_cache_data.BaseData WHERE BaseData_intervalDr=:intervalDr AND BaseData_dataTypeDr=:dataTypeDr and BaseData_itemCode in ('50010301','50010302','50010303','cb010301','cb010302','cb010303') )
	.s startdate=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)		 //核算区间起始日期(数字)                                 
	
	;s Ratio=ypcost/ypincome
	;w ypincome_"^"_ypcost_"^"_Ratio,!

	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	s OperatDate=+$h
	s SqlStr="SELECT IncomeDatas_itemCode, IncomeDatas_itemName,IncomeDatas_fDeptCode, IncomeDatas_fDeptName,sum(IncomeDatas_fee) AS fee  FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_intervalDr_"'"
	 		_" AND  IncomeDatas_itemDr IN ('115','116','117') "
			_" GROUP BY IncomeDatas_itemCode, IncomeDatas_itemName,IncomeDatas_fDeptCode, IncomeDatas_fDeptName "
	//  115, '西药费'  116, '中成药'  117, '中草药'   118, '试剂'   137, '煎药费'
	
	s ResultString=0
	s Result= ##class(%Library.ResultSet).%New()
	;w SqlStr,!
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		
		//w $zt($p($h,",",2),1),!
		//cb010301西药    cb010302中成药  cb010303中草药
		s ItemCode=Result.Data("IncomeDatas_itemCode")
		i ItemCode="西药费" s ItemCode="cb010301"
		i ItemCode="中成药" s ItemCode="cb010302"
		i ItemCode="中草药" s ItemCode="cb010303"
		s ItemName=Result.Data("IncomeDatas_itemName")
		
		s DeptCode=Result.Data("IncomeDatas_fDeptCode")
		s DeptName=Result.Data("IncomeDatas_fDeptName")
		
		s fee=Result.Data("fee")
		;w ItemCode_"#"_ItemName_"#"_DeptCode_"#"_DeptName_"#"_fee_"#"_Ratio,!
		s fee=fee*Ratio
		;w fee,!
		s tmpFlag=0
	    s tmpFlag=..InsertBaseRec(intervalDr,dataTypeDr,ItemCode,ItemName,DeptCode,DeptName,fee,OperatDate,userDr)
	    i tmpFlag'=0 s ResultString=tmpFlag
		q:ResultString'=0
	}
	d Result.Close()
	i ResultString =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	
	q "OK"
}

/// Creator：zjw
/// CreatDate：2016-03-24
/// Description: 折旧信息录入
/// Table：
/// Input：start-起始日期,end-终止日期
/// Output：
/// Return：
/// Others：w ##class(dhc.ca.cache.udata.uSalary).GetDepreciationRec("1","2","demo")
ClassMethod GetDepreciationRec(intervalDr, dataTypeDr, userCode) As %String
{
	//info="intervalDr^userDr^inType^itemDr"
	//row="病人科室Dr!科室描述!病床日数"
	//维修费ID:235,折旧费ID:253.
	q:intervalDr="" "emptyIntervalDr"
	q:userCode="" "emptyUserCode"
	TSTART
	n (intervalDr, userCode)
	s remark="ZJCB"
	k ^TMP("dhc","ca","Depreciation")
	k ^TMP("dhc","ca","MaintFee")
	
	s start=""
	s end=""
	i $d(^DHCCAACCOUNTMONTHS(intervalDr)) d
	.&sql(DELETE FROM  dhc_ca_cache_data.BaseData WHERE BaseData_intervalDr=:intervalDr AND BaseData_dataTypeDr=:dataTypeDr and BaseData_remark=:remark)
	.s start=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",4)		//核算区间起始日期63918  2016-01-01
	.s end=$p(^DHCCAACCOUNTMONTHS(intervalDr),"^",5)		//核算区间终止日期63948	 2016-01-31
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(userCode)
	i userDr<0 d 
	.TROLLBACK
	s info=intervalDr_"^"_userDr_"^"_dataTypeDr_"^load^"_remark
	//s start="2016-01-01"
	//s end="2016-01-31"
	
	q:start="" "emptyStart"
	q:end="" "emptyEnd"
	
	d ##class(web.DHCEQForCA).getDepreciation(start,end)
	s flag=0
	s tmpJob=""
	f  s tmpJob=$o(^TMP("dhc","ca","Depreciation",tmpJob)) q:tmpJob=""  d
	.s tmpNow=""
	.f  s tmpNow=$o(^TMP("dhc","ca","Depreciation",tmpJob,tmpNow)) q:tmpNow=""  d
	..s data=$g(^TMP("dhc","ca","Depreciation",tmpJob,tmpNow))
	..s data="^^"_$p(data,"^",5)_"^^342^^"_$P(data,"^",2)_"^"_$P(data,"^",3)_"^"_"sbzj"_$p(data,"^",4)_"^^^"_$P(data,"^",6)    //342为专用设备折旧rowid
	..s tmpRs=""
	..s tmpRs=##class(dhc.ca.cache.comm.DataLoadHS).BaseDataInsert(info, data)
	..i tmpRs'="" s flag=tmpRs
	/* 取设备维修
	s tmpJob=""
	f  s tmpJob=$o(^TMP("dhc","ca","MaintFee",tmpJob)) q:tmpJob=""  d
	.s tmpNow=""
	.f  s tmpNow=$o(^TMP("dhc","ca","MaintFee",tmpJob,tmpNow)) q:tmpNow=""  d
	..s data=$g(^TMP("dhc","ca","MaintFee",tmpJob,tmpNow))
	..s data="^^^^235^^"_$P(data,"^",2)_"^"_$P(data,"^",3)_"^wxf^^^"_$P(data,"^",6)  //235为设备维修rowid
	..s tmpRs=""
	..s tmpRs=..VouchDataInsertTwo(info, data, job)
	..i tmpRs'="" s flag=tmpRs
	*/
	i flag=0 TCOMMIT
	e  TROLLBACK
	q flag
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uSalaryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
