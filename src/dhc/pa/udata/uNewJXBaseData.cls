/// Creator: wang ying
/// CreatDate: 2011-04-12
/// Description: 新基本数字表维护
Class dhc.pa.udata.uNewJXBaseData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2011-04-12
/// Description: 查询符合条件的基本数据记录
/// Table：dhc_pa_data.NewBaseData
/// Input：period-考核期间;periodType-期间类型;parRef-绩效单元ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uNewJXBaseData).List("","","","",0,25,1,"Y")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, period, periodType) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit, period, periodType)
	
	s sqlStr="select JXBaseData_rowid,JXBaseData_period,JXBaseData_periodType,JXBaseData_jxUnitDr,JXBaseData_jxUnitCode,JXBaseData_jxUnitName,JXBaseData_KPIDr,JXBaseData_KPICode,JXBaseData_KPIName,JXBaseData_actualValue,JXBaseData_auditDate,JXBaseData_auditUserDr,JXBaseData_dataState from dhc_pa_data.NewBaseData"
	s whereStr=" where JXBaseData_rowid>0"
	i period'="" s whereStr=whereStr_" and JXBaseData_period ='"_period_"'"
	i periodType'="" s whereStr=whereStr_" and JXBaseData_periodType ='"_periodType_"'"
 
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="JXBaseData_rowid"
	.i sortField="period" s sortField1="JXBaseData_period"
	.i sortField="periodTypeName" s sortField1="JXBaseData_periodType"
	.i sortField="KPIName" s sortField1="JXBaseData_KPIName"
	.i sortField="actualValue" s sortField1="JXBaseData_actualValue"
	.i sortField="auditDate" s sortField1="JXBaseData_auditDate"
	.i sortField="auditUserName" s sortField1="JXBaseData_auditUserDr"
	.i sortField="dataStateName" s sortField1="JXBaseData_dataState"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^period^periodType^periodTypeName^jxUnitDr^jxUnitCode^jxUnitName^KPIDr^KPIName^KPICode^actualValue^auditDate^auditUserDr^auditUserName^dataState^dataStateName"
	
	While(result.Next()){
		//集体初始化
		s dataStateName="",periodTypeName="",KPIName="",auditUserName=""
		//绩效单元
		s jxUnitDr=result.Data("JXBaseData_jxUnitDr")
		s jxUnitCode=result.Data("JXBaseData_jxUnitCode")
		s jxUnitName=result.Data("JXBaseData_jxUnitName")
		s rowid=result.Data("JXBaseData_rowid")
		s period=result.Data("JXBaseData_period")
		//期间类型
		s periodType=result.Data("JXBaseData_periodType")
		i periodType="M" s periodTypeName="月份"
		i periodType="Q" s periodTypeName="季度"
		i periodType="H" s periodTypeName="半年"
		i periodType="Y" s periodTypeName="年度"
		//指标
		s KPIDr=result.Data("JXBaseData_KPIDr")
		s KPICode=result.Data("JXBaseData_KPICode")
		s KPIName=result.Data("JXBaseData_KPIName")
		
		//实际值
		s actualValue=result.Data("JXBaseData_actualValue")
		s actualValue=$fn(actualValue,"",2)
		
		s auditDate=result.Data("JXBaseData_auditDate")
		s auditDate=$ZD(auditDate,3)
		//审核人员
		s auditUserDr=result.Data("JXBaseData_auditUserDr")
		i auditUserDr'="" d
		.i $D(^SSU("SSUSR",auditUserDr)) d
		..i $G(^SSU("SSUSR",auditUserDr))'="" d
		...s auditUserName=$P(^SSU("SSUSR",auditUserDr),"^",2)
		//数据状态
		s dataState=result.Data("JXBaseData_dataState")
		i dataState=-1 s dataStateName="未审核"
		i dataState=0 s dataStateName="审核中"
		i dataState=1 s dataStateName="审核通过"
		
		s tmp=rowid_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_jxUnitDr_"^"_jxUnitCode_"^"_jxUnitName_"^"_KPIDr_"^"_KPIName_"^"_KPICode_"^"_actualValue_"^"_auditDate_"^"_auditUserDr_"^"_auditUserName_"^"_dataState_"^"_dataStateName
		i searchValue'="" d
		.q:(searchField = "period")&(period'[searchValue)
		.q:(searchField = "periodTypeName")&(periodTypeName'[searchValue)
		.q:(searchField = "parRefName")&(parRefName'[searchValue)
		.q:(searchField = "KPIName")&(KPIName'[searchValue)
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

/// Creator：wang ying
/// CreatDate：2011-04-12
/// Description: 获取考核期间
/// Table：dhc_pa_data.NewBaseData
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效考核期间字符串
/// Others：w ##class(dhc.pa.udata.uNewJXBaseData).GetPeriod(0,10,"")
ClassMethod GetPeriod(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DISTINCT JXBaseData_period from dhc_pa_data.NewBaseData where JXBaseData_rowid>0"
	i str'="" s sqlStr = sqlStr_" and JXBaseData_period like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s period = result.Data("JXBaseData_period")
		s tmp=period
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("period",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2011-04-13
/// Description: 判断同一绩效单元下是否存在同一记录
/// Table：dhc_pa_data.NewBaseData
/// Input：jxUnitDr-绩效单元ID;period-考核期间;periodType-期间类型;kpidr-指标
/// Output：
/// Return：返回childSub
/// Others：w ##class(dhc.pa.udata.uNewJXBaseData).IfRepRecode(5,"201000",58,"Y")
ClassMethod IfRepRecode(jxUnitDr, period, kpidr, periodType) As %String
{
	n (jxUnitDr,period,kpidr,periodType)
	
	s childSub=""
	s childSub = $O(^DHCCJXPAJXBASEDATA(0,"PPTUnitKpi",period,periodType,jxUnitDr,kpidr,childSub))
	q childSub
}

/// Creator：wang ying
/// CreatDate：2011-4-13
/// Description: 为给定的绩效单元添加基本数据记录
/// Table：dhc_pa_data.NewBaseData
/// Input：data-待插入数据(jxunitdr^period^periodType^kpidr^actualValue^state);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uNewJXBaseData).Insert("1^200902^M^2^0^-1")
ClassMethod Insert(data) As %String
{
	n (data)
	
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s jxUnitDr=$p(data,"^",1)				//绩效单元
	i jxUnitDr'="" d 
	.i $d(^DHCCJXPAJXUNIT(jxUnitDr)) d
	..s jxUnitCode=$p($g(^DHCCJXPAJXUNIT(jxUnitDr)),"^",2)
	..s jxUnitName=$p($g(^DHCCJXPAJXUNIT(jxUnitDr)),"^",3)
	..i jxUnitCode'="" s PLIST(5)=jxUnitCode
	..i jxUnitName'="" s PLIST(6)=jxUnitName
	.s PLIST(4)=jxUnitDr 
	
	s period=$p(data,"^",2)					//考核期间
	i period'="" s PLIST(2)=period
	
	s periodType=$p(data,"^",3)				//期间类型
	i periodType'="" s PLIST(3)=periodType 
	 
	s kpidr=$p(data,"^",4)					//KPI指标
	i kpidr'="" d
	.i $d(^DHCCJXPAKPIINDEX1(kpidr)) d
	..s kpiCode=$p($g(^DHCCJXPAKPIINDEX1(kpidr)),"^",1)
	..s kpiName=$p($g(^DHCCJXPAKPIINDEX1(kpidr)),"^",2)
	..i kpiCode'="" s PLIST(8)=kpiCode
	..i kpiName'="" s PLIST(9)=kpiName
	.s PLIST(7)=kpidr 
	
	q:(..IfRepRecode(jxUnitDr,period,kpidr,periodType))'="" "RepRecode" 
	
	s actualValue=$p(data,"^",5)			//实际值
	i actualValue'="" s PLIST(10)=actualValue
	
	s state=$p(data,"^",6)					//审核状态
	i state'="" s PLIST(13)=state
	
	&SQL(insert into dhc_pa_data.NewBaseData VALUES PLIST())
	q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2011-4-13
/// Description:删除绩效单元下的基本数据记录
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uNewJXBaseData).Delete(1790)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.NewBaseData where JXBaseData_rowid=:rowid)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2011-4-13
/// Description: 获取绩效单元
/// Table：dhc_pa_data.JXUnit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串;userCode-用户代码
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetJXUnit(0,10,"311","fhq")
ClassMethod GetJXUnit(start, limit, str, userCode) As %String
{
	n (start, limit, str, userCode)
	
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnitAudit_jxUnitDr,JXUnit_shortcut from dhc_pa_data.JXUnitAudit,dhc_pa_data.jxUnit where JXUnitAudit_rowid>0 and JXUnitAudit_userDr="_userId_" and JXUnitAudit_jxUnitDr=JXUnit_rowid and JXUnit_appSysDr=2"
	s whereStr=""
	i str'="" s whereStr=" and JXUnit_shortcut LIKE '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s jxUnitDr = result.Data("JXUnitAudit_jxUnitDr")
		s jxUnitShortCut = result.Data("JXUnit_shortcut")
		s tmp=jxUnitDr_"^"_jxUnitShortCut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitShortCut",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2011-4-123
/// Description: 获取指标
/// Table：dhc_pa_data.KPIAudit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串;userCode-用户代码
/// Output：
/// Return：有指标字符串
/// Others：w ##class(dhc.pa.udata.uJXBaseData).GetKPI(0,10,"","fhq")
ClassMethod GetKPI(start, limit, str, userCode) As %String
{
	n (start, limit, str, userCode)
	
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIAudit_KPIDr,KPIIndex1_shortcut from dhc_pa_data.KPIAudit,dhc_pa_data.KPIIndex1 where KPIAudit_rowid>0 and KPIAudit_userDr="_userId_" and KPIAudit_KPIDr=KPIIndex1_rowid"
	s whereStr=""
	i str'="" s whereStr=" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s KPIDr = result.Data("KPIAudit_KPIDr")
		s shortCut=result.Data("KPIIndex1_shortcut")
		s tmp=KPIDr_"^"_shortCut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("KPIDr^shortCut",count)
 	k json
	q resultString
}

/// Creator: wang ying
/// CreatDate: 2011-04-13
/// Description: 删除记录
/// Table: dhc.pa.data.JXBaseData
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uJXBaseData).Aduit("2")
ClassMethod Aduit(period, periodType, userCode) As %String
{
	
	n (period ,periodType,userCode)
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	s SQLCODE=0
	s kpiDr=""
	s auditData=$P($h,",",1)
	i userId'="" d
	.f  s kpiDr=$o(^DHCCJXPAKPIAUDIT(0,"User",userId,kpiDr)) q:kpiDr=""  d
	..&SQL(Update dhc_pa_data.NewBaseData set JXBaseData_auditDate=:auditData,JXBaseData_auditUserDr=:userId,JXBaseData_dataState=1  WHERE JXBaseData_period=:period and JXBaseData_periodType=:periodType)
	q SQLCODE
}

/// ======================================2011-04-26=======================================
/// Creator：李明忠
/// CreatDate：2011-4-26
/// Description: 获取该用户所拥有权限的绩效单元代码
/// Table：dhc_pa_data.JXUnitAudit
/// Input：userId:用户ID
/// Output：
/// Return：有效绩效单元代码字符串
/// Others：w ##class(dhc.pa.udata.uNewJXBaseData).getLocs(5412)
ClassMethod getLocs(userId) As %String
{
	n (userId)
	
	s locCodeStr=""
	q:userId="" locCodeStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnit_code from dhc_pa_data.JXUnitAudit,dhc_pa_data.jxUnit where JXUnitAudit_rowid>0 and JXUnitAudit_userDr="_userId_" and JXUnitAudit_jxUnitDr=JXUnit_rowid and JXUnit_appSysDr=2"
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s locCode = result.Data("JXUnit_code")
		i locCodeStr="" s locCodeStr=locCode
		e  s locCodeStr=locCodeStr_"^"_locCode
	}
	
	q locCodeStr
}

/// Creator：李明忠
/// CreatDate：2011-4-26
/// Description: 获取该用户所拥有权限的指标代码
/// Table：dhc_pa_data.KPIAudit
/// Input：userId-用户Id
/// Output：
/// Return：有指标代码串
/// Others：w ##class(dhc.pa.udata.uNewJXBaseData).getKpis(5412)
ClassMethod getKpis(userId) As %String
{
	n (userId)
	
	s kpiCodeStr=""
	q:userId="" kpiCodeStr
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIIndex1_code from dhc_pa_data.KPIAudit,dhc_pa_data.KPIIndex1 where KPIAudit_rowid>0 and KPIAudit_userDr="_userId_" and KPIAudit_KPIDr=KPIIndex1_rowid"
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s kpiCode = result.Data("KPIIndex1_code")
		i kpiCodeStr="" s kpiCodeStr=kpiCode
		e  s kpiCodeStr=kpiCodeStr_"^"_kpiCode
	}

	q kpiCodeStr
}

/// Creator: 李明忠
/// CreatDate: 2011-04-26
/// Description: 刷新新导入的基础指标数据记录
/// Table: dhc_pa_data.NewBaseData
/// Input：period-考核期间;periodType-考核期间类型;userCode-用户代码号
/// Output: 
/// Return: 返回刷新成功与否标示值
/// Others: w ##class(dhc.pa.udata.uNewJXBaseData).Refresh("201101","Y","zhuangyan")
ClassMethod Refresh(period, periodType, userCode) As %String
{
	
	n (period ,periodType,userCode)
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	//取该用户所拥有权限的科室代码,并放入一个list集合
	s locCodeStr=..getLocs(userId)
	s locList=##class(%Library.ListOfDataTypes).%New() 
	s locLen=$L(locCodeStr,"^")
	f n=1:1:locLen d
	.s locCode=$P(locCodeStr,"^",n)
	.i locCode'="" d
	..d locList.Insert(locCode)
	//取该用户所拥有权限的指标代码,并放入一个list集合
	s kpiCodeStr=..getKpis(userId)
	s kpiList=##class(%Library.ListOfDataTypes).%New() 
	s kpiLen=$L(kpiCodeStr,"^")
	f k=1:1:kpiLen d
	.s kpiCode=$P(kpiCodeStr,"^",k)
	.i kpiCode'="" d
	..d kpiList.Insert(kpiCode)
	
	TSTART
	s rs=0,signer=0
	
	i $D(^DHCCJXPAJXBASEDATA(0,"PeriodPeriodType",period,periodType)) d
	.s rowid=0
	.f  s rowid=$O(^DHCCJXPAJXBASEDATA(0,"PeriodPeriodType",period,periodType,rowid)) q:rowid=""  d
	..;获取科室ID
	..s locDr=$P(^DHCCJXPAJXBASEDATA(rowid),"^",3)
	..i locDr="" d //需要对照
	...s locCode=$P(^DHCCJXPAJXBASEDATA(rowid),"^",4)
	...i locList.Find(locCode,0)'="" d //需要刷新
	....;获取指标ID
	....s kpiDr=$P(^DHCCJXPAJXBASEDATA(rowid),"^",6)
	....i kpiDr="" d //需要对照
	.....s kpiCode=$P(^DHCCJXPAJXBASEDATA(rowid),"^",7)
	.....i kpiList.Find(kpiCode,0)'="" d //需要刷新
	......;根据科室代码和指标代码查询科室ID和指标ID
	......i $D(^DHCCJXPAJXUNIT(0,"Code",locCode)) d
	.......s locDr=$O(^DHCCJXPAJXUNIT(0,"Code",locCode,0))
	.......i $D(^DHCCJXPAKPIINDEX1(0,"Code",kpiCode)) d
	........s kpiDr=$O(^DHCCJXPAKPIINDEX1(0,"Code",kpiCode,0))
	........&SQL(update dhc_pa_data.NewBaseData set JXBaseData_jxUnitDr=:locDr,JXBaseData_KPIDr=:kpiDr where JXBaseData_rowid=:rowid)
	........i SQLCODE'=0 s rs=1
	
	i rs'=0 d
	.TRollBack
	.s signer="error"
	e  d
	.TCOMMIT
	
	q signer
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uNewJXBaseDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
