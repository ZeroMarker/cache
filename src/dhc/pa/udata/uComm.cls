/// 绩效考核通用类
/// 将绩效考核用到的公共方法都写在这个类里
Class dhc.pa.udata.uComm Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-9-13
/// Description: 获取当前战略Dr
/// Table：dhc_pa_data.Stratagem
/// Input：
/// Output：
/// Return：当前战略DR
/// Others：w ##class(dhc.pa.udata.uComm).GetCurrStratagemDr()
ClassMethod GetCurrStratagemDr() As %String
{
	//获取当前战略
	s stratagemDr = 0 //定义并初始化战略Dr
	s count=0 //定义并初始化当前战略记录数量
	s currStratagemDr = 0 //定义并初始化当前战略Dr
	f  s stratagemDr=$O(^DHCCJXPASTRATAGEM(stratagemDr)) q:stratagemDr=""  d
	.i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	..i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	...s currStratagemFlag = $P(^DHCCJXPASTRATAGEM(stratagemDr),"^",14)
	...i currStratagemFlag="Y" d
	....s currStratagemDr = stratagemDr
	....s count=count+1

	q:count=0 "NoCurrRecord" //表示没有当前战略记录
	q:count>1 "RepCurrRecord" //表示有多条当前战略记录
	
	q currStratagemDr
}

/// Creator:wang ying
/// CreatDate:2015-4-28
/// Description:判断方案是否有权限
/// Table:
/// Input:schemDr-方案id,userCode-登录用户code
/// Output:
/// Return:返回0为没权限，返回非0为此方案由权限
/// Others:w ##class(dhc.pa.udata.uComm).SchemByAduit("1||12","DHC")
ClassMethod SchemByAduit(schemDr, userCode) As %String
{
	n (schemDr,userCode)

	q:schemDr="" "SchemByAduit UnschemDr" //
	q:userCode="" "SchemByAduit UnuserCode"
	
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "SchemByAduit UnuserId"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM dhc_pa_data.SchemAudit"
	s where=" WHERE SAudit_userDr='"_userId_"' AND SAudit_SchemDr='"_schemDr_"'"
	
	s sqlStr=sqlStr_where
	d result.Prepare(sqlStr)
	d result.Execute()
    s rowid=0
	While(result.Next()){
		s rowid = result.Data("SAudit_rowid")
	}
	d result.Close()
	q rowid
}

/// Creator:wang ying
/// CreatDate:2015-5-11
/// Description:根据期间、方案确定此期间的方案状态
/// Table:
/// Input:schemDr-方案id,userCode-登录用户code
/// Output:
/// Return:返回0为没权限，返回非0为此方案由权限
/// Others:w ##class(dhc.pa.udata.uComm).getSchemStaus("1||7","201501")
ClassMethod getSchemStaus(SchemDr As %String, period As %String) As %String
{
	n (SchemDr,period)
	s flag=""
	//用户信息
	s sqlStr="SELECT * FROM dhc_pa_data.Schem_Perid_Rec"
	s whereStr=" where %ID>0 and SPR_schemDr='"_SchemDr_"' and SPR_period='"_period_"'"
    s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s status=0
	While(result.Next()){
		//集体初始化
		s status=result.Data("SPR_auditState")
		
	}
	d result.Close()
    q:status'="" status
}

/// Creator:wang ying
/// CreatDate:2015-7-13
/// Description:删除科室自查global
/// Table:
/// Input:
/// Output:
/// Return:0 1
/// Others:w ##class(dhc.pa.udata.uComm).deleteGlobal()
ClassMethod deleteGlobal() As %String
{
	k ^DHCCJXPADeptKPIIndexD
	k ^DHCCJXPADeptKPIIndexI
	k ^DHCCJXPADeptSchemAuditD
	k ^DHCCJXPADeptSchemAuditI
	k ^DHCCJXPADeptSchemD
	k ^DHCCJXPADeptSchemDetailD
	k ^DHCCJXPADeptSchemDetailI
	k ^DHCCJXPASCHEMAUDIT
	k ^DHCCJXPAUnitDepResultDetailI
	k ^DHCCJXPAUnitDeptResultD
	k ^DHCCJXPAUnitDeptResultDetailD
	k ^DHCCJXPAUnitDeptResultI
	k ^DHCCJXPAUnitDeptSchemD
	k ^DHCCJXPAUnitDeptSchemI

	
    q 0
}

/// Creator:wang ying
/// CreatDate:2015-7-13
/// Description:通过用户id，查用户名
/// Table:
/// Input:
/// Output:
/// Return:0 1
/// Others:w ##class(dhc.pa.udata.uComm).getUserName(1)
ClassMethod getUserName(rowid) As %String
{
	q:rowid="" ""
	s usrName=""

	i $d(^SSU("SSUSR",rowid)) d
	.s updateName=$p($g(^SSU("SSUSR",rowid)),"^",2)

	
    q updateName
}

/// Creator:chu yali
/// CreatDate:2016-5-25
/// Description:计算传入的字符串中最大值和最小值
/// Input:
/// Output:最大值^最小值
/// Others:w ##class(dhc.pa.udata.uComm).getMaxMinValue("8^2^5^8")
ClassMethod getMaxMinValue(numberStr) As %String
{

	s max=0,min=0
	//去掉字符串首位的^
	s numberStr=$ZSTRIP(numberStr,"<>","^")
	s len=$L(numberStr,"^")
	s returnStr=""
	for i=1:1:len d
	.s value=$p(numberStr,"^",i)
	.if i=1 d
	..s min=value,max=value
	.e  d
	..if value<=min d
	...s min=value
	..if value>=max d
	...s max=value
	s returnStr=max_"^"_min
	q returnStr
}

/// Creator：chu yali
/// CreatDate：2016-8-2
/// Description: 获取权限KPI：权限（未停用&指标KPI&用户权限）
/// Table：dhc_pa_data.KPIIndex1
/// Input：str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uComm).GetAuditKPIStr("","")
ClassMethod GetAuditKPIStr(userCode, str) As %String
{
	n (userCode,str)

	s AuditKPIStr =" and KPIIndex1_isStop='N' " //未停用
			      _" and KPIIndex1_isKPI='Y' " //指标JPI
	if (userCode'="") d //用户权限
	.s AuditKPIStr =AuditKPIStr_" and KPIIndex1_rowid in (select KPIAudit_KPIDr from dhc_pa_data.KPIAudit where KPIAudit_rowid>0 and KPIAudit_userDr='"_userCode_"') "
	
	if (str="isEnd-Y") d
	.s AuditKPIStr =AuditKPIStr_" and  KPIIndex1_isEnd='Y' "
	if (str="isEnd-N") d
	.s AuditKPIStr =AuditKPIStr_" and  KPIIndex1_isEnd='N' "

	q AuditKPIStr
}

/// Creator：chu yali
/// CreatDate：2016-8-2
/// Description: 获取权限KPI：权限（未停用&指标KPI&用户权限）
/// Table：dhc_pa_data.KPIIndex1
/// Input：str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uComm).GetAuditUnitStr("","")
ClassMethod GetAuditUnitStr(userCode, str) As %String
{
	n (userCode,str)

	s AuditUnitStr =" and (JXUnit_isStop='N' OR JXUnit_isStop IS NULL) " //未停用
			        _" and JXUnit_isEnd='Y' " //参与核算
			        _" and JXUnit_End='Y' " //末端
	if (userCode'="") d //用户权限
	.s AuditUnitStr =AuditUnitStr_" and JXUnit_rowid  in (select JXUnitAudit_jxUnitDr from dhc_pa_data.JXUnitAudit where JXUnitAudit_userDr='"_userCode_"')" 
	/*
	if (str="isEnd-Y") d
	.s AuditUnitStr =AuditUnitStr_" and  KPIIndex1_isEnd='Y' "
	if (str="isEnd-N") d
	.s AuditUnitStr =AuditUnitStr_" and  KPIIndex1_isEnd='N' "
*/
	q AuditUnitStr
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uCommS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
