/// 基层科室绩效考核计算-考核数据调整-计算类指标实际值更改
/// creator:赵伟
/// date：2015-05
Class dhc.pa.udata.uBasicUnitPaCaluExtend Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：赵伟
/// CreatDate：2010-7-29
/// Description: 查询符合条件的基本数据记录
/// Table：dhc_pa_data.JXBaseData
/// Input：period-考核期间;periodType-期间类型;parRef-绩效单元ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uBasicUnitPaCaluExtend).List(0,25,"201501","床均出院病人数","Q","老年病房",1)
ClassMethod List(start, limit, period, kpidrs, periodType, deptdr, userID) As %String
{
	n ( start,limit,period,kpidrs, periodType,deptdr,userID)
	//w "deptdr"_deptdr_"kpidrs"_kpidrs,!
	s deptdr=..Getdeptid(deptdr)
	s kpidrs=..GetKpidrs(kpidrs)
	
	s sqlStr="select JXBaseData_parRef,JXBaseData_rowid,JXBaseData_childSub,JXBaseData_period,JXBaseData_periodType,JXBaseData_KPIDr,JXBaseData_KPIDr->KPIIndex1_calUnitDr,JXBaseData_actualValue,JXBaseData_auditDate,JXBaseData_auditUserDr,JXBaseData_dataState,JXBaseData_desc from dhc_pa_data.JXBaseData"
	s whereStr=" where JXBaseData_childSub>0"
	i period'="" s whereStr=whereStr_" and JXBaseData_period ='"_period_"'"
	i periodType'="" s whereStr=whereStr_" and JXBaseData_periodType ='"_periodType_"'"
	i deptdr'="" s whereStr=whereStr_" and JXBaseData_parRef ='"_deptdr_"'"
	i kpidrs'="" s whereStr=whereStr_" and JXBaseData_KPIDr in ("_kpidrs_")"		
	s sqlStr=sqlStr_whereStr
	//w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="parRef^parRefName^rowid^childSub^period^periodType^periodTypeName^KPIDr^KPIName^actualValue^auditDate^auditUserDr^auditUserName^dataState^dataStateName^desc^calUnitName"
	
	While(result.Next()){
		//集体初始化
		s parRefName="",dataStateName="",periodTypeName="",KPIName="",auditUserName="",dataStateName=""
		
		//绩效单元
		s parRef=result.Data("JXBaseData_parRef")
		
		
		i $d(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",parRef,userID)) d
		.i parRef'="" d
		..i $D(^DHCCJXPAJXUNIT(parRef)) d
		...i $G(^DHCCJXPAJXUNIT(parRef))'="" d
		....s parRefName=$P(^DHCCJXPAJXUNIT(parRef),"^",3)
		
		
		s rowid=result.Data("JXBaseData_rowid")
		s childSub=result.Data("JXBaseData_childSub")
		s period=result.Data("JXBaseData_period")
		//期间类型
		s periodType=result.Data("JXBaseData_periodType")
		i periodType="M" s periodTypeName="月份"
		i periodType="Q" s periodTypeName="季度"
		i periodType="H" s periodTypeName="半年"
		i periodType="Y" s periodTypeName="年度"
		//指标
		s KPIDr=result.Data("JXBaseData_KPIDr")
		i KPIDr'="" d
		.i $d(^DHCCJXPAKPIAUDIT(0,"User",userID,KPIDr)) d
		..i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
		...i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
		....s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
		//实际值
		s actualValue=result.Data("JXBaseData_actualValue")
		s actualValue=$fn(actualValue,"",2)
		
		s auditDate=result.Data("JXBaseData_auditDate")
		if auditDate'="" s auditDate=$ZD(auditDate,3)
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
		s dataState=0
		s desc=result.Data("JXBaseData_desc")
		
		//计量单位
		s calUnitDr = result.Data("KPIIndex1_calUnitDr")
		
		i calUnitDr'="" d
		.i $D(^DHCCJXPACALUNIT(calUnitDr)) d
		..i $G(^DHCCJXPACALUNIT(calUnitDr)) d
		...s calUnitName=$P(^DHCCJXPACALUNIT(calUnitDr),"^",2)
		
		
		
		s tmp=parRef_"^"_parRefName_"^"_rowid_"^"_childSub_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_KPIDr_"^"_KPIName_"^"_actualValue_"^"_auditDate_"^"_auditUserDr_"^"_auditUserName_"^"_dataState_"^"_dataStateName_"^"_desc_"^"_calUnitName
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

//科室id

/// Others:w ##class(dhc.pa.udata.uBasicUnitPaCaluExtend).Getdeptid("老年病房")
ClassMethod Getdeptid(str) As %String
{
	n ( str)
	s expression=""
	&SQL(SELECT JXUnit_rowid into:expression FROM dhc_pa_data.JXUnit WHERE JXUnit_name LIKE :str)
	q expression
}

//kpiname

/// Others:w ##class(dhc.pa.udata.uBasicUnitPaCaluExtend).GetKpidrs("床均出院病人数")
ClassMethod GetKpidrs(str) As %String
{
	n ( str)
	s expression=""
	&SQL(SELECT KPIIndex1_expression into :expression FROM dhc_pa_data.KPIIndex1 WHERE KPIIndex1_name LIKE :str)
	q ..GetKPIStrList(expression)
}

ClassMethod GetKPIStrList(string) As %String
{
	n (string)
	s StrList=""   s tmp=""
	f i=1:1:$L(string) d
	.i $E(string,i)="<" d
	..s k=..GetNextLocation(string,i)
	..s StrList=$E(string,i+1,k-1)
	
	..i tmp="" d 
	...s tmp=StrList
	..e  d
	...s tmp=tmp_","_StrList

	q tmp
}

/// 老刘和老刘的程序相遇了
/// Others:w ##class(dhc.pa.report.uKPIDataSources).GetNextLocation("{[(<21>+<51>)*0.5]/25}",2)
ClassMethod GetNextLocation(string, num) As %String
{
	s flag="false"
	//定义">"位置
	s k=0 

	i $E(string,num+1)=">" d
	.s flag="true"
	.s k=num+1
	.q:flag="true"
	e  d
	.s k=..GetNextLocation(string,num+1)
	
	q k
}

/// Creator:刘洋
/// CreatDate:2012-3-12
/// Description:修改数据
/// Table:dhc_pa_data.JXBaseData
/// Input:rowid-基本数据记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXBaseData).Update(4)
ClassMethod Update(rowid, aValue) As %String
{
	n (rowid,aValue)
	

	
	&SQL(UPDATE dhc_pa_data.JXBaseData  set JXBaseData_actualValue=:aValue   where JXBaseData_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uBasicUnitPa93ES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
