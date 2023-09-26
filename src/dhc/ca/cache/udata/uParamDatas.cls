/// Creator: 王赢赢
/// CreatDate: 2009-12-2
/// Description: 参数数据表
Class dhc.ca.cache.udata.uParamDatas Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-12-4
/// Description: 是否存在
/// Table：dhc.ca.cache.data.ParamDatas
/// Input: 
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).IfRep(1,1,1,1)
ClassMethod IfRep(intervalDr, itemDr, servDeptDr, servedDeptDr) As %String
{
	n (intervalDr, itemDr, servDeptDr, servedDeptDr)
	s rowid=0
	s rowid=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",intervalDr,servedDeptDr,itemDr,rowid))
	i rowid'="" d  
	.i $p(^DHCCAPARAMDATAS(rowid),"^",7)'=servDeptDr d
	..s rowid=0
	e  i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-2
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.ParamDatas
/// Input: intervalDr-核算区间Dr; itemDr-数据项ID; servDeptDr-服务部门ID; servedDeptDr-被服务部门ID; value-参数数值; remark-备注;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).InsertRec(1,1,1,1,20,"remark",1)
ClassMethod InsertRec(intervalDr, itemDr, servDeptDr, servedDeptDr, value, remark, inPersonDr) As %String
{
	n (intervalDr, itemDr, servDeptDr, servedDeptDr, value, remark, inPersonDr)
	
	s rowid=0
	s rowid=..IfRep(intervalDr, itemDr, servDeptDr, servedDeptDr)
	q:rowid>0 "Rep"
	
	s tmpInDate = $P($HOROLOG,",",1)
	&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas (ParamDatas_intervalDr,ParamDatas_itemDr,ParamDatas_servDeptDr,ParamDatas_servedDeptDr,ParamDatas_value,ParamDatas_remark,ParamDatas_inType,ParamDatas_inPersonDr,ParamDatas_inDate) VALUES (:intervalDr, :itemDr, :servDeptDr, :servedDeptDr, :value, :remark, 'input', :inPersonDr, :tmpInDate))
	
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-2
/// Description: 更新记录
/// Table: dhc.ca.cache.data.ParamDatas
/// Input: rowid-数据行号,intervalDr-核算区间Dr; itemDr-数据项ID; servDeptDr-服务部门ID; servedDeptDr-被服务部门ID; value-参数数值; remark-备注;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uParamDatas).UpdateRec(2,2,2,2,2,40,"remark2",2)
ClassMethod UpdateRec(rowid, intervalDr, itemDr, servDeptDr, servedDeptDr, value, remark, inPersonDr) As %String
{
	n (rowid, intervalDr, itemDr, servDeptDr, servedDeptDr, value, remark, inPersonDr)
	
	s tmpRowid=0
	s tmpRowid=..IfRep(intervalDr, itemDr, servDeptDr, servedDeptDr)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "Rep"
	
	&SQL(UPDATE dhc_ca_cache_data.ParamDatas SET ParamDatas_intervalDr=:intervalDr,ParamDatas_itemDr=:itemDr,ParamDatas_servDeptDr=:servDeptDr,ParamDatas_servedDeptDr=:servedDeptDr,ParamDatas_value=:value,ParamDatas_remark=:remark,ParamDatas_inPersonDr=:inPersonDr WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-2
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.ParamDatas
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数;intervalDr-月份ID; deptDr-部门ID; itemDr-数据项ID; inType-录入类型; personDr-录入人ID;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// 单击字段排序:w ##class(dhc.ca.cache.udata.uParamDatas).ListRec("","","servedDeptName","ASC",0,25,6,"329")
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).ListRec("","","rowid","DESC",0,25,1,"476")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, intervalDr, itemDr)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_intervalDr_"^"_itemDr
	n (searchField, searchValue, sortField, sortDir, start, limit, intervalDr, itemDr)
	
	s sqlStr="SELECT ParamDatas_rowid,ParamDatas_intervalDr,ParamDatas_itemDr,ParamDatas_servDeptDr,ParamDatas_servedDeptDr,ParamDatas_value,ParamDatas_remark,ParamDatas_inType,ParamDatas_inPersonDr,ParamDatas_inDate,ParamDatas_servDeptCode,ParamDatas_servDeptName,ParamDatas_servedDeptCode,ParamDatas_servedDeptName,ParamDatas_itemCode,ParamDatas_itemName,ParamDatas_fDocCode,ParamDatas_fDocName,ParamDatas_fDocDr FROM dhc_ca_cache_data.ParamDatas"
	
	s whereStr=" WHERE %ID>0 "
	
	s whereStr=whereStr_"AND ParamDatas_intervalDr='"_intervalDr_"' "
	s whereStr=whereStr_"AND ParamDatas_itemDr='"_itemDr_"' "
		
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="ParamDatas_rowid"
	.i sortField="itemName" s sortField1="ParamDatas_itemDr"
	.i sortField="servDeptName" s sortField1="ParamDatas_servDeptDr"
	.i sortField="servedDeptName" s sortField1="ParamDatas_servedDeptDr"
	.i sortField="value" s sortField1="ParamDatas_value"
	.i sortField="outServDeptCode" s sortField1="ParamDatas_servDeptCode"
	.i sortField="outServDeptName" s sortField1="ParamDatas_servDeptName"
	.i sortField="outServedDeptCode" s sortField1="ParamDatas_servedDeptCode"
	.i sortField="outServedDeptName" s sortField1="ParamDatas_servedDeptName"
	.i sortField="outItemCode" s sortField1="ParamDatas_itemCode"
	.i sortField="outItemName" s sortField1="ParamDatas_itemName"
	.i sortField="inType" s sortField1="ParamDatas_inType"
	.i sortField="inPersonName" s sortField1="ParamDatas_inPersonDr"
	.i sortField="remark" s sortField1="ParamDatas_remark"
	.i sortField="inDate" s sortField1="ParamDatas_inDate"
	.i sortField="fDocCode" s sortField1="ParamDatas_fDocCode"
	.i sortField="fDocName" s sortField1="ParamDatas_fDocName"
	.i sortField="fInDocName" s sortField1="ParamDatas_fDocDr"
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
	s jsonTitle="rowid^intervalDr^intervalName^itemDr^itemCode^itemName^servDeptDr^servDeptCode^servDeptName^servedDeptDr^servedDeptCode^servedDeptName^value^inType^inPersonDr^inPersonName^remark^inDate^outServDeptCode^outServDeptName^outServedDeptCode^outServedDeptName^outItemCode^outItemName^fDocCode^fDocName^fDocDr^fInDocName"
	
	While(result.Next())
	{
		s rowid=result.Data("ParamDatas_rowid")
		s intervalDr=result.Data("ParamDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
				
		s itemDr=result.Data("ParamDatas_itemDr")
		s itemCode=""
		s itemName=""
		i itemDr'="" d
		.s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s outServDeptCode=result.Data("ParamDatas_servDeptCode")
		s outServDeptName=result.Data("ParamDatas_servDeptName")
		
		s outServedDeptCode=result.Data("ParamDatas_servedDeptCode")
		s outServedDeptName=result.Data("ParamDatas_servedDeptName")
		
		s outItemCode=result.Data("ParamDatas_itemCode")
		s outItemName=result.Data("ParamDatas_itemName")
		
		s servDeptDr=result.Data("ParamDatas_servDeptDr")
		s servDeptCode=""
		s servDeptName=""
		s servUnitDr=""
		i servDeptDr'="" d
		.s servDeptCode=$p($g(^DHCCAUNITDEPTS(servDeptDr)),"^",1)
		.s servDeptName=$p($g(^DHCCAUNITDEPTS(servDeptDr)),"^",2)

		s servedDeptDr=result.Data("ParamDatas_servedDeptDr")
		s servedDeptCode=""
		s servedDeptName=""
		s servedUnitDr=""
		i servedDeptDr'="" d
		.s servedDeptCode=$p($g(^DHCCAUNITDEPTS(servedDeptDr)),"^",1)
		.s servedDeptName=$p($g(^DHCCAUNITDEPTS(servedDeptDr)),"^",2)

		s value=result.Data("ParamDatas_value")
		
		s inType=result.Data("ParamDatas_inType")
		i inType="input" s inType="录入"
		i inType="load" s inType="导入"
		
		s inPersonDr=result.Data("ParamDatas_inPersonDr")
		s inPersonName=""
		i inPersonDr'="" d
		.s inPersonName=$p($g(^DHCCAUNITPERSONS(inPersonDr)),"^",2)
		
		s remark=result.Data("ParamDatas_remark")

		s inDate=result.Data("ParamDatas_inDate")
		i inDate'="" d
		.s inDate=$zd(inDate,3)
		
		s fDocCode=result.Data("ParamDatas_fDocCode")
		s fDocName=result.Data("ParamDatas_fDocName")
		s fDocDr=result.Data("ParamDatas_fDocDr")
		s fInDocName=""
		i fDocDr'="" d
		.s fInDocName=$p($g(^DHCCAUNITPERSONS(fDocDr)),"^",2)
				
		s tmp=rowid_"^"_intervalDr_"^"_intervalName_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_servDeptDr_"^"_servDeptCode_"^"_servDeptName_"^"_servedDeptDr_"^"_servedDeptCode_"^"_servedDeptName_"^"_value_"^"_inType_"^"_inPersonDr_"^"_inPersonName_"^"_remark_"^"_inDate_"^"_outServDeptCode_"^"_outServDeptName_"^"_outServedDeptCode_"^"_outServedDeptName_"^"_outItemCode_"^"_outItemName_"^"_fDocCode_"^"_fDocName_"^"_fDocDr_"^"_fInDocName
		i searchValue'="" d
		.q:(searchField="intervalName")&(intervalName'[searchValue)
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="servDeptCode")&(servDeptCode'[searchValue)
		.q:(searchField="servDeptName")&(servDeptName'[searchValue)
		.q:(searchField="servedDeptCode")&(servedDeptCode'[searchValue)
		.q:(searchField="servedDeptName")&(servedDeptName'[searchValue)
		.q:(searchField="value")&(value'[searchValue)
		.q:(searchField="inType")&(inType'[searchValue)
		.q:(searchField="inPersonName")&(inPersonName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="inDate")&(inDate'[searchValue)
		.q:(searchField="outServedDeptCode")&(outServedDeptCode'[searchValue)
		.q:(searchField="outServedDeptName")&(outServedDeptName'[searchValue)
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

/// Creator: 王赢赢
/// CreatDate: 2009-12-2
/// Description: 获得用户DR
/// Table: dhc.ca.cache.data.ParamDatas
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).CheckUser(1)
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

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.ParamDatas
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).DelRec(2)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.ParamDatas WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: zjw
/// CreatDate: 2014-7-10
/// Description: 删除记录
/// Table: dhc.ca.cache.data.ParamDatas
/// Input：MonthDr-月份ID
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).DelAllRec(37)
ClassMethod DelAllRec(MonthDr) As %String
{
	n (MonthDr)
	&SQL(DELETE FROM dhc_ca_cache_data.ParamDatas WHERE ParamDatas_intervalDr=:MonthDr  )
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-5-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.ParamDatas
/// Input：MonthDr-月份ID
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).DelRecByMonth(2)
ClassMethod DelRecByMonth(MonthDr, itemDr) As %String
{
	n (MonthDr, itemDr)
	&SQL(DELETE FROM dhc_ca_cache_data.ParamDatas WHERE ParamDatas_intervalDr=:MonthDr and ParamDatas_itemDr=:itemDr)
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-11-10
/// Description: 返回当前日期是否在指定核算区间内
/// Table：dhc.ca.cache.data.ParamDatas
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

/// Creator: 王赢赢
/// CreatDate: 2009-12-3
/// Description: 复制其它月份数据
/// Table: dhc.ca.cache.data.ParamDatas
/// Input：oldMon,newMon,itemDr
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).copyOtherMon(1,2,497,1)
ClassMethod copyOtherMon(oldMon, newMon, itemDr, inPersonDr) As %String
{
	n (oldMon,newMon,itemDr,inPersonDr)
	
	
	
	//zjw 20160201  增加回滚任务和删除历史数据功能，以防重复复制或误操作
	TSTART
	
	 &sql(DELETE FROM dhc_ca_cache_data.ParamDatas WHERE ParamDatas_intervalDr=:newMon AND ParamDatas_itemDr=:itemDr)
	s UserCode=$p(^SSU("SSUSR",inPersonDr),"^",1) //获取ssuerCode
	s userDr=##class(dhc.ca.cache.comm.CommMethod).CheckUser(UserCode)
	i userDr<0 d 
	.TROLLBACK
     
	s sqlStr="SELECT ParamDatas_rowid,ParamDatas_intervalDr,ParamDatas_itemDr,ParamDatas_servDeptDr,ParamDatas_servedDeptDr,ParamDatas_value,ParamDatas_remark,ParamDatas_inType,ParamDatas_inPersonDr,ParamDatas_inDate FROM dhc_ca_cache_data.ParamDatas"
	s whereStr=" WHERE %ID>0 "
	i oldMon'="" s whereStr=whereStr_"AND ParamDatas_intervalDr='"_oldMon_"' "
	i itemDr'="" s whereStr=whereStr_"AND ParamDatas_itemDr='"_itemDr_"' "
	s sqlStr=sqlStr_whereStr
	s ResultString=0	//zjw  20160201 
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s itemDr=result.Data("ParamDatas_itemDr")
		s servDeptDr=result.Data("ParamDatas_servDeptDr")
		s servedDeptDr=result.Data("ParamDatas_servedDeptDr")
		s value=result.Data("ParamDatas_value")
		s remark=result.Data("ParamDatas_remark")
		//s inType=result.Data("ParamDatas_inType")
		//s inPersonDr=result.Data("ParamDatas_inPersonDr")
		//s inDate=result.Data("ParamDatas_inDate")
		s tmpInDate = $P($HOROLOG,",",1)
		&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas (ParamDatas_intervalDr,ParamDatas_itemDr,ParamDatas_servDeptDr,ParamDatas_servedDeptDr,ParamDatas_value,ParamDatas_remark,ParamDatas_inType,ParamDatas_inPersonDr,ParamDatas_inDate) VALUES (:newMon, :itemDr, :servDeptDr, :servedDeptDr, :value, :remark, 'input', :inPersonDr, :tmpInDate))
		i SQLCODE'=0 s ResultString=SQLCODE		//zjw  20160201 
	    q:ResultString'=0
	}
	//zjw  20160201  
	d result.Close()
	i ResultString =0 d
  	.TCOMMIT
	e  d
 	.TROLLBACK
	
	q ResultString
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-4
/// Description: 显示未添加部门
/// Table: dhc.ca.cache.data.ParamDatas
/// Input：
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).unAddDept(1,1,2,0,25)
ClassMethod unAddDept(intervalDr, itemDr, unitDr, start, limit) As %String
{
	n (intervalDr, itemDr, unitDr, start, limit)
	s tmpDepts = "("
	s rowid = 1
	s tmpD = ""
	f  q:rowid=""  d
	.s rowid=$o(^DHCCAPARAMDATAS(0,"IntervalItem",intervalDr,itemDr,rowid))
	
	.i rowid="" d
	.e  i tmpDepts = "(" d
	..s tmpD = $p(^DHCCAPARAMDATAS(rowid),"^",10)
	..s tmpDepts = tmpDepts _ tmpD
	.e  d
	..s tmpD = $p(^DHCCAPARAMDATAS(rowid),"^",10)
	..s tmpDepts = tmpDepts _","_ tmpD
	s tmpDepts = tmpDepts_")"
	
	s sqlStr="SELECT UnitDepts_rowid,UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_address,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_unitDr,UnitDepts_propertyDr,UnitDepts_active FROM dhc_ca_cache_data.UnitDepts"
	s whereStr=" WHERE %ID>0 AND UnitDepts_unitDr="_unitDr_" AND UnitDepts_active='Y'"
	s sqlStr=sqlStr_whereStr_" AND UnitDepts_rowid NOT IN "_tmpDepts

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^code^name^shortcut^address^remark^startTime^stop^unitDr^propertyDr^active"

	
	While(result.Next())
	{
		s rowId = result.Data("UnitDepts_rowid")
		s code = result.Data("UnitDepts_code")
		s name = result.Data("UnitDepts_name")
		s shortcut = result.Data("UnitDepts_shortcut")
		s address = result.Data("UnitDepts_address")
		s remark = result.Data("UnitDepts_remark")
		s startTime = result.Data("UnitDepts_start")
		s stop = result.Data("UnitDepts_stop")
		s unitDr = result.Data("UnitDepts_unitDr")
		s propertyDr = result.Data("UnitDepts_propertyDr")
		s active = result.Data("UnitDepts_active")
		
		i startTime'="" s startTime=$zd(startTime,3)
		i stop'="" s stop=$zd(stop,3)
		
		s tmp=rowId_"^"_code_"^"_name_"^"_shortcut_"^"_address_"^"_remark_"^"_startTime_"^"_stop_"^"_unitDr_"^"_propertyDr_"^"_active
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
/// CreatDate: 2010-4-2
/// Description: 刷新对应数据的部门与项目
/// Table: dhc.ca.cache.data.ParamDatas
/// Input: intervalDr-核算区间;deptSetDr-部门接口套ID;itemDr-业务项ID;
/// Output: 
/// Return: 0为成功
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).RefreshRec(6,1,329)
ClassMethod RefreshRec(intervalDr, deptSetDr, itemDr) As %String
{
	n (intervalDr,deptSetDr,itemDr)

	TSTART
	s flag=0
	
	s sqlStr="SELECT * FROM dhc_ca_cache_data.ParamDatas"
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND ParamDatas_intervalDr='"_intervalDr_"' "
	;i itemDr'="" s whereStr=whereStr_"AND ParamDatas_itemDr='"_itemDr_"' "
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		k PLIST
		s rowid=result.Data("ParamDatas_rowid")

		s patType=""
	
		s servDeptCode=""
		s servDeptDr=""
		s servDeptCode=result.Data("ParamDatas_servDeptCode")
		
		i (servDeptCode'="")&(deptSetDr'="") d
		.s servDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,servDeptCode,patType)
		
		i (servDeptCode'="")&(deptSetDr="") d
		.s servDeptDr=##class(dhc.ca.cache.udata.uOtherData).GetDept(servDeptCode)
		
		i servDeptDr'="" s PLIST(8)=servDeptDr
		
		s servedDeptCode=""
		s servedDeptDr=""
		s servedDeptCode=result.Data("ParamDatas_servedDeptCode")
		
		i (servedDeptCode'="")&(deptSetDr'="") d
		.s servedDeptDr=##class(dhc.ca.cache.comm.CommMethod).DeptRelation(deptSetDr,servedDeptCode,patType)
		
		i (servedDeptCode'="")&(deptSetDr="") d
		.s servedDeptDr=##class(dhc.ca.cache.udata.uOtherData).GetDept(servedDeptCode)
		
		i servedDeptDr'="" s PLIST(11)=servedDeptDr
		
		s fDocCode=""
		s fDocDr=""
		s fDocCode=result.Data("ParamDatas_fDocCode")
		;w "fDocCode:"_fDocCode,!
		s fDocDr=##class(dhc.ca.cache.comm.CommMethod).UnitPersonsRelation(fDocCode)
		;w "PatDocDr:"_fDocDr,!
		i fDocDr'="" s PLIST(19)=fDocDr
		
		&SQL(UPDATE dhc_ca_cache_data.ParamDatas VALUES PLIST() where %ID=:rowid)
		i SQLCODE'=0 s flag=SQLCODE
	}
	d result.Close()
	i flag=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	q flag
}

/// Creator: 杨旭
/// CreatDate: 2010-05-11
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.ParamDatas
/// Input: intervalDr-核算区间Dr; inPersonDr-录入人;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).InsertRecTwo(2,1)
ClassMethod InsertRecTwo(intervalDr, inPersonDr) As %String
{
	n (intervalDr, inPersonDr)
	q:intervalDr="" ""
	q:inPersonDr="" ""
	TSTART
	s flag=0
	s rs1=##class(dhc.ca.cache.udata.DoCostDist1).GetVouchCost(intervalDr)
	s r2=##class(dhc.ca.cache.udata.DoCostDist1).GetBaseCost("cost","12",intervalDr)    //12为工资数据类
	s r3=##class(dhc.ca.cache.udata.DoCostDist1).GetLargCost(intervalDr)
	s tmpInDate = $P($HOROLOG,",",1)
	s deptDr=""
	f  s deptDr=$o(^TMPDHCCACALCOST("dhc","ca","directCost",deptDr)) q:deptDr=""  d
	.s amount=0
	.s itemDr=""
	.f  s itemDr=$o(^TMPDHCCACALCOST("dhc","ca","directCost",deptDr,itemDr)) q:itemDr=""  d
	..s amount=amount+^TMPDHCCACALCOST("dhc","ca","directCost",deptDr,itemDr)
	.;w $p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)_"|"_amount,!
	.&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas (ParamDatas_intervalDr,ParamDatas_itemDr,ParamDatas_servedDeptDr,ParamDatas_value,ParamDatas_inType,ParamDatas_inPersonDr,ParamDatas_inDate) VALUES (:intervalDr, 1167, :deptDr, :amount, 'load', :inPersonDr, :tmpInDate))
	.i SQLCODE'=0 s flag=SQLCODE
	k ^TMPDHCCACALCOST("dhc","ca")
	
	s deptDr=""
	f  s deptDr=$o(^DHCCAINDISTDATA(0,"IntDept",intervalDr,deptDr)) q:deptDr=""  d
	.s amount=0
	.s rowId=""
	.f  s rowId=$o(^DHCCAINDISTDATA(0,"IntDept",intervalDr,deptDr,rowId)) q:rowId=""  d
	..s amount=amount+$p(^DHCCAINDISTDATA(rowId),"^",5)
	.;w $p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)_"|"_amount_"|"_itemDr,!
	.&SQL(INSERT INTO dhc_ca_cache_data.ParamDatas (ParamDatas_intervalDr,ParamDatas_itemDr,ParamDatas_servedDeptDr,ParamDatas_value,ParamDatas_inType,ParamDatas_inPersonDr,ParamDatas_inDate) VALUES (:intervalDr, 1166, :deptDr, :amount, 'load', :inPersonDr, :tmpInDate))
	.i SQLCODE'=0 s flag=SQLCODE
	i flag=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	q flag
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uParamDatasS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
