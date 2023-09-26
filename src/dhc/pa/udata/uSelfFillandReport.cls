Class dhc.pa.udata.uSelfFillandReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

///  Creator: liu xiao ming
///  CreatDate: 2015-05-21
///  Description: 根据登录用户ID查找权限科室
///  Table: dhc_pa_data.JXUnitAudit
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).ListDept("1","2","","0","20")
ClassMethod ListDept(userId, DSchemDr, shortCutStr, start, limit) As %String
{
	n (userId,DSchemDr, shortCutStr, start, limit)
	
	
	s sqlStr="select JXUnitAudit_jxUnitDr,JXUnit_name"
			_" from dhc_pa_data.JXUnitAudit JXUnitAudit join dhc_pa_data.JXUnit JXUnit on JXUnit.JXUnit_rowid=JXUnitAudit.JXUnitAudit_jxUnitDr"
			_" where JXUnitAudit.JXUnitAudit_userDr='"_userId_"' and JXUnitAudit.JXUnitAudit_isRead='Y' and JXUnitAudit.JXUnitAudit_isWrite='Y'"  
			 
	i shortCutStr'="" d
	.s sqlStr=sqlStr_" and JXUnit_shortcut like '%"_shortCutStr_"%'"
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit

	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	while(result.Next())
	{
		s rowid=result.Data("JXUnitAudit_jxUnitDr")
		i $d(^DHCCJXPAUnitDeptSchemI("DschemDrJXUnit",DSchemDr,rowid)) d
		.s name=result.Data("JXUnit_name")
		.s tmp=rowid_"^"_name
		.s count=count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}	
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

///  Creator: liu xiao ming
///  CreatDate: 2015-05-14
///  Description: 根据自查期间、用户ID、自查权限查找自查定义
///  Table: dhc_pa_data.DeptSchemAudit, dhc_pa_data.DeptSchem
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).ListDeptSchem("1","Q","","0","10")
ClassMethod ListDeptSchem(userId, frequency, shortCutStr, start, limit) As %String
{
	n (userId,frequency,shortCutStr,start,limit)
	
	
	s sqlStr="select DSA_DSchemDr,DSA_DSchemDr->DSC_name from dhc_pa_data.DeptSchemAudit where DSA_userDr='"_userId_"' and DSA_DSchemDr->DSC_frequency='"_frequency_"'" 
	
	i shortCutStr'="" d
	.s sqlStr=sqlStr_" and DSA_DSchemDr->DSC_shortcut like '%"_shortCutStr_"%'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit

	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	while(result.Next())
	{
		s DSCrowid=result.Data("DSA_DSchemDr")
		s DSCname=result.Data("DSC_name")
		s tmp=DSCrowid_"^"_DSCname
		s count=count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}	
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/*
///  Creator: liu xiao ming
///  CreatDate: 2015-05-19
///  Description: 根据查询条件（自查期间、用户ID、自查权限）查询自查项目、类别（1-前台显示多行文本 2-前台显示单选项）、填报内容、填报要求
///  Table: dhc_pa_data.UnitDeptResultDetail(自查科室明细表),dhc_pa_data.UnitDeptResult(自查科室主表),dhc_pa_data.JXUnitAudit(绩效单元设置表),dhc_pa_data.Dept_KPIIndex(自查项目表) 
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).List("2015","M","1","1","4","2","0","10")
ClassMethod OldList(year, frequency, acuttypeitem, userId, deptDr, DschemDr, start, limit) As %String
{
	n (year, frequency, acuttypeitem, userId, deptDr, DschemDr, start, limit)
	
	i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	s Period=year_$p(data,"^",acuttypeitem) 	//自查期间
	
	s sqlStr="SELECT UDRD_rowid,UDRD_DKPIDr->DKX_name,UDRD_DKPIDr->DKX_type,UDRD_DKPIDr->DKX_level,UDRD_estDesc,UDRD_fBDesc,UDRD_UDResult,UDRD_UDResult->UDR_submitState,UDRD_parent"
	         _" FROM dhc_pa_data.UnitDeptResultDetail"
			 _" WHERE UDRD_UDResult->UDR_DschemDr='"_DschemDr_"' AND UDRD_UDResult->UDR_jxUnitDr='"_deptDr_"'"
			 _" AND UDRD_UDResult->UDR_period='"_Period_"' AND UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_frequency_"'"
			 //_" order by UDRD_DKPIDr asc"

	;w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit

	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="UDRDrowid^DKXname^DKXtype^UDRDestDesc^UDRDfBDesc^UDRDUDResult^UDRsubmitState^upload"
	
	while(result.Next())
	{
		s UDRDrowid=result.Data("UDRD_rowid")		
		s DKXname=result.Data("DKX_name")
		
		//按层次显示处理
		s DKXlevel=result.Data("DKX_level")
		s UDRDparent=result.Data("UDRD_parent")
		if (DKXlevel=2) {
			s DKXname="- -"_DKXname
		}elseif(DKXlevel=3){
			s DKXname="- - - -"_DKXname
		}elseif(DKXlevel=4){
			s DKXname="- - - - - -"_DKXname
		}
		
		s DKXtype=result.Data("DKX_type")
		s UDRDestDesc=result.Data("UDRD_estDesc")
		s UDRDfBDesc=result.Data("UDRD_fBDesc")
		s UDRsubmitState=result.Data("UDR_submitState")
		s UDRDUDResult=result.Data("UDRD_UDResult")
		i UDRsubmitState="1" s UDRsubmitState="已提交"
		i UDRsubmitState="0" s UDRsubmitState="未提交"
		
		s tmp=UDRDrowid_"^"_DKXname_"^"_DKXtype_"^"_UDRDestDesc_"^"_UDRDfBDesc_"^"_UDRDUDResult_"^"_UDRsubmitState_"^"_""
		s count=count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}	
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}
*/
///  Creator: liu xiao ming
///  CreatDate: 2015-05-19
///  Description: 提交
///  Table: dhc_pa_data.UnitDeptResultDetail, dhc_pa_data.UnitDeptResult, dhc_pa_data.JXUnitAudit
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).Submit("127","平均主","平均住院日填报","2015","1","4","2","1")
ClassMethod Submit(UDRDrowid, UDRDestDesc, UDRDfBDesc, year, acuttypeitem, deptDr, DschemDr, userId) As %String
{
	n (UDRDrowid,UDRDestDesc,UDRDfBDesc,year,acuttypeitem,deptDr,DschemDr,userId)
	
	q:UDRDrowid="" 
	
	//更新自查明细表填报内容、填报要求字段
	&sql(update dhc_pa_data.UnitDeptResultDetail set UDRD_estDesc=:UDRDestDesc,UDRD_fBDesc=:UDRDfBDesc where UDRD_rowid=:UDRDrowid)
	q:SQLCODE=-105 "overflow"
	
	
	//更新自查主表提交人、提交时间、提交状态
	s submitdate=$ZDT($H,3) 
	;i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	;s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	;s Period=year_$p(data,"^",acuttypeitem) 	//自查期间
	s Period=year_acuttypeitem
	&sql(update dhc_pa_data.UnitDeptResult set UDR_submiDr=:userId, UDR_submiDate=:submitdate, UDR_submitState='1',UDR_updateState=0 where UDR_DschemDr=:DschemDr and UDR_period=:Period and UDR_jxUnitDr=:deptDr)
																   
	q SQLCODE
}

/*///  Creator: liu xiao ming
///  CreatDate: 2015-05-27
///  Description: 取消提交
///  Table: dhc_pa_data.UnitDeptResultDetail, dhc_pa_data.UnitDeptResult, dhc_pa_data.JXUnitAudit
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).CancelSubmit("")
ClassMethod CancelSubmit(UDResultDr) As %String
{
	n (UDResultDr)
	
	&sql(update dhc_pa_data.UnitDeptResult set UDR_submitState='0' where UDR_rowid=:UDResultDr)

	q SQLCODE
}*/
///  Creator: liu xiao ming
///  CreatDate: 2015-05-19
///  Description: 提交
///  Table: dhc_pa_data.UnitDeptResultDetail, dhc_pa_data.UnitDeptResult, dhc_pa_data.JXUnitAudit
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).Update("1","平均主","平均住院日填报","2015","1","4","2","1")
ClassMethod Update(UDRDrowid, UDRDestDesc, UDRDfBDesc, year, acuttypeitem, deptDr, DschemDr, userId) As %String
{
	n (UDRDrowid,UDRDestDesc,UDRDfBDesc,year,acuttypeitem,deptDr,DschemDr,userId)
	
	q:UDRDrowid="" 
	
	k UDRList	
	
 	s UDRList(8)= UDRDestDesc       
 	s UDRList(9)= UDRDfBDesc
	//更新自查明细表填报内容、填报要求字段
	&sql(update dhc_pa_data.UnitDeptResultDetail values UDRList() where UDRD_rowid=:UDRDrowid)
	q:SQLCODE=-105 "overflow"
	
	//更新自查主表提交人、提交时间、提交状态
	s submitdate=$ZDT($H,3) 
	i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	s Period=year_$p(data,"^",acuttypeitem) 	//自查期间
	
	k UDRDList
	
	s UDRDList(12)=userId
	s UDRDList(13)=submitdate
	s UDRDList(14)="0"

	&sql(update dhc_pa_data.UnitDeptResult values UDRDList() where UDR_DschemDr=:DschemDr and UDR_period=:Period and UDR_jxUnitDr=:deptDr)

	q SQLCODE
}

///  Creator: liu xiao ming
///  CreatDate: 2015-06-2
///  Description: 根据查询条件（自查期间、用户ID、自查权限）查询自查项目、类别（1-前台显示多行文本 2-前台显示单选项）、填报内容、填报要求
///  Table: dhc_pa_data.UnitDeptResultDetail(自查科室明细表),dhc_pa_data.UnitDeptResult(自查科室主表),dhc_pa_data.JXUnitAudit(绩效单元设置表),dhc_pa_data.Dept_KPIIndex(自查项目表) 
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).List("2015","M","1","1","5","1","0","0","1000")
ClassMethod ListLXM(year, frequency, acuttypeitem, userId, deptDr, DschemDr, parent, start, limit) As %String
{
	n (year, frequency, acuttypeitem, userId, deptDr, DschemDr, parent, start, limit)
	
	i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	s Period=year_$p(data,"^",acuttypeitem) 	//自查期间
	
	s count=0
	s resultString=""
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="UDRDrowid^DKXname^DKXtype^DKXisEnd^UDRDestDesc^UDRDfBDesc^UDRDUDResult^UDRsubmitState^upload"

	//查找parent=0的子节点ID，并组装成"^"串
	s idString=..SearchId(Period, frequency, deptDr, DschemDr, parent)
	;w idString,!
	i idString'="" d
		.s idlen=$l(idString,"^")
		.f i=1:1:idlen d
		..s temUDRDid=$p(idString,"^",i)	
		..s temInfor=..GetInfor(temUDRDid)
		..s count=count+1
		..d json.InsertRowData(temInfor)					
		
	s resultString = json.getJsonData(jsonTitle,count)	
 	k json
	q resultString
}

///  Creator: liu xiao ming
///  CreatDate: 2015-06-2
///  Description: 根据查询条件（自查期间、用户ID、自查权限）查询自查项目、类别（1-前台显示多行文本 2-前台显示单选项）、填报内容、填报要求
///  Table: dhc_pa_data.UnitDeptResultDetail(自查科室明细表),dhc_pa_data.UnitDeptResult(自查科室主表),dhc_pa_data.JXUnitAudit(绩效单元设置表),dhc_pa_data.Dept_KPIIndex(自查项目表) 
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).List("2016","M","1","1","3","1","0","0","1000")
ClassMethod List(year, frequency, acuttypeitem, userId, deptDr, DschemDr, parent, start, limit) As %String
{
	n (year, frequency, acuttypeitem, userId, deptDr, DschemDr, parent, start, limit)
	
	q:year="" "NoYear"
	q:frequency="" "Nofrequency"
	q:acuttypeitem="" "Noacuttypeitem"
	q:userId="" "NouserId"
	q:deptDr="" "NodeptDr"
	q:DschemDr="" "NoDschemDr"
	q:parent="" "Noparent"
	
	i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	s Period=year_$p(data,"^",acuttypeitem) 	//自查期间
	
	s count=0
	s resultString=""
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="UDRDrowid^DKXname^DKXtype^DKXisEnd^UDRDestDesc^UDRDfBDesc^UDRDUDResult^UDRsubmitState^UDRauditState^UDRupdateState^upload"

	s sqlStr=" SELECT UDRD_rowid,UDRD_DKPIDr,UDRD_DKPIDr->DKX_name,UDRD_DKPIDr->DKX_type,UDRD_DKPIDr->DKX_isEnd,UDRD_estDesc,UDRD_fBDesc,UDRD_UDResult,UDRD_UDResult->UDR_submitState,UDRD_UDResult->UDR_auditState,UDRD_UDResult->UDR_updateState,UDRD_UDResult->UDR_jxUnitDr" 
             _" FROM dhc_pa_data.UnitDeptResultDetail where UDRD_DKPIDr->DKX_isEnd='Y'" 
    
    i DschemDr'="" s sqlStr=sqlStr_" and UDRD_UDResult->UDR_DschemDr->DSC_rowid='"_DschemDr_"'"
    i Period'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_period='"_Period_"'"
    i deptDr'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_jxUnitDr='"_deptDr_"'"
    i frequency'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_frequency_"'"
    ;i userId'=""  s sqlStr=" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_userId_"'"
	s sqlStr=sqlStr_" order by UDRD_DKPIDr->DKX_code asc"
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	
	while(result.Next())
	{
		s flag=0
		s UDRDrowid = result.Data("UDRD_rowid") 
		s UDRDDKPIDr=result.Data("UDRD_DKPIDr") ;自查项目ID			
		s DKXname=result.Data("DKX_name")		;自查项目名称
	    s jxunitDr=result.Data("UDR_jxUnitDr")
	    i jxunitDr'="" d
	    .i $d(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",jxunitDr,userId)) d
	    .s flag=1
	    q:flag=0
		s DKXtype=result.Data("DKX_type")
		s DKXisEnd=result.Data("DKX_isEnd")			
		s UDRDestDesc=result.Data("UDRD_estDesc")
		s UDRDfBDesc=result.Data("UDRD_fBDesc")
		s UDRDUDResult=result.Data("UDRD_UDResult")
		s UDRsubmitState=result.Data("UDR_submitState")
		i UDRsubmitState="1" s UDRsubmitState="已提交"
		i UDRsubmitState="0" s UDRsubmitState="未提交"
		
		
		s UDRauditState=result.Data("UDR_auditState")
		i UDRauditState="1" s UDRauditState="审核通过"
		i UDRauditState="0" s UDRauditState="未审核"
		
		
		s UDRupdateState=result.Data("UDR_updateState")
		i UDRupdateState="1" s UDRupdateState="允许修改"
		i UDRupdateState="0" s UDRupdateState="不许修改"
		s tmp=UDRDrowid_"^"_DKXname_"^"_DKXtype_"^"_DKXisEnd_"^"_UDRDestDesc_"^"_UDRDfBDesc_"^"_UDRDUDResult_"^"_UDRsubmitState_"^"_UDRauditState_"^"_UDRupdateState_"^"_""
	    s count=count+1
		d json.InsertRowData(tmp)
	
	}		
		
	s resultString = json.getJsonData(jsonTitle,count)	
 	k json
	q resultString
}

///  Creator: hfj
///  CreatDate: 2015-06-2
///  Description: 根据查询条件（自查期间、用户ID、自查权限）查询自查项目、类别（1-前台显示多行文本 2-前台显示单选项）、填报内容、填报要求
///  Table: dhc_pa_data.UnitDeptResultDetail(自查科室明细表),dhc_pa_data.UnitDeptResult(自查科室主表),dhc_pa_data.JXUnitAudit(绩效单元设置表),dhc_pa_data.Dept_KPIIndex(自查项目表) 
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).Getcode("2016","M","1","1","3","1")
ClassMethod Getcode(year, frequency, acuttypeitem, userId, deptDr, DschemDr) As %String
{
	n (year, frequency, acuttypeitem, userId, deptDr, DschemDr)
	
	q:year="" "NoYear"
	q:frequency="" "Nofrequency"
	q:acuttypeitem="" "Noacuttypeitem"
	q:userId="" "NouserId"
	q:deptDr="" "NodeptDr"
	q:DschemDr="" "NoDschemDr"
	
	
	i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	s Period=year_$p(data,"^",acuttypeitem) 	//自查期间
	s num=0
	s count=0
	s resultString=""
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="DKXcode"

	s sqlStr=" SELECT UDRD_rowid,UDRD_DKPIDr,count(*) AS num,UDRD_DKPIDr->DKX_code,UDRD_DKPIDr->DKX_name,UDRD_DKPIDr->DKX_type,UDRD_DKPIDr->DKX_isEnd,UDRD_estDesc,UDRD_fBDesc,UDRD_UDResult,UDRD_UDResult->UDR_submitState,UDRD_UDResult->UDR_auditState,UDRD_UDResult->UDR_updateState,UDRD_UDResult->UDR_jxUnitDr" 
             _" FROM dhc_pa_data.UnitDeptResultDetail where 1=1" 
    
    i DschemDr'="" s sqlStr=sqlStr_" and UDRD_UDResult->UDR_DschemDr->DSC_rowid='"_DschemDr_"'"
    i Period'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_period='"_Period_"'"
    i deptDr'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_jxUnitDr='"_deptDr_"'"
    i frequency'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_frequency_"'"
    ;i userId'=""  s sqlStr=" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_userId_"'"
	s sqlStr=sqlStr_" order by UDRD_DKPIDr->DKX_code asc"
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s DKXcodeL=0
	while(result.Next())
	{
		s flag=0
		s UDRDrowid = result.Data("UDRD_rowid") 
		s UDRDDKPIDr=result.Data("UDRD_DKPIDr") ;自查项目ID
		s num=result.Data("num")
		s DKXcode=result.Data("DKX_code")		;自查项目代码
		s DKXcodeL=DKXcode_"^"_DKXcodeL
		;w DKXcodeL,!
		
	    s count=count+1
		
	
	}		
	s ds=0,n=0	
	f i=1:1:num d
	.s n=n+1
	.s codeL=$p(DKXcodeL,"^",n)
	.s code=$l(codeL)
	.;w code,!
	.;w ds,!
    .i code>=ds d
	..s ds=code 
	.e   d
	..s ds=ds
	
   
	q ds
}

/// Creator：hfj
/// CreatDate：2016-4-11
/// Description: 获取生成自查项目数量的Count
/// Table：
/// Input：
/// Output：
/// Return：返回数量Count
/// Others：w ##class(dhc.pa.udata.uSelfFillandReport).GetCount("2016","M","1","1","3","1")
ClassMethod GetCount(year, frequency, acuttypeitem, userId, deptDr, DschemDr) As %String
{
	n (year, frequency, acuttypeitem, userId, deptDr, DschemDr)
	
	s ds=..Getcode(year, frequency, acuttypeitem, userId, deptDr, DschemDr)
	s Count=(ds-3)/2
	
	q Count
}

/// Creator：hfj
/// CreatDate：2016-4-11
/// Description: 获取表头信息
/// Table：
/// Input：
/// Output：
/// Return：表头信息字符串
/// Others：w ##class(dhc.pa.udata.uSelfFillandReport).GetGridTitle("2016","M","1","1","3","1")
ClassMethod GetGridTitle(year, frequency, acuttypeitem, userId, deptDr, DschemDr) As %String
{
	n (year, frequency, acuttypeitem, userId, deptDr, DschemDr)
	
	
	q:year="" "NoYear"
	q:frequency="" "Nofrequency"
	q:acuttypeitem="" "Noacuttypeitem"
	q:userId="" "NouserId"
	q:deptDr="" "NodeptDr"
	q:DschemDr="" "NoDschemDr"
	
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	s rowid=1,title="代码",name="DKXcode"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=2,title="分类",name="DKXname"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	
	s resultString=..GetPeriodTitle(json,rowid,year, frequency, acuttypeitem, userId, deptDr, DschemDr)
 	k json
 	
 	q resultString
}

/// Creator：hfj
/// CreatDate：2016-4-11
/// Description: 获取自查项目表头信息
/// Table：dhc_pa_data.UnitResultDetail
/// Input：json-数据格式类;rowid-计数器;cycleCode-考核年度code;currMonth-月份,frequency-期间类型
/// Output：
/// Return：表头考核期间信息字符串
/// Others：w ##class(dhc.pa.udata.uKPITargetSet).GetPeriodTitle(1@dhc.pa.comm.JsonObj,6,"2013","1","Q")
ClassMethod GetPeriodTitle(json, rowid, year, frequency, acuttypeitem, userId, deptDr, DschemDr) As %String
{
	n (json,rowid,year, frequency, acuttypeitem, userId, deptDr, DschemDr)
	
	
	s Count=..GetCount(year, frequency, acuttypeitem, userId, deptDr, DschemDr)
	f i=1:1:Count d
	.s rowid=rowid+1
	.s title=i_"级项目"
	.s name="DKXname0"_i
	.s tmp=rowid_"^"_title_"^"_name
	.d json.InsertRowData(tmp)
	s rowid=rowid+1,title="填报内容",name="UDRDestDesc"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=rowid+1,title="填报要求",name="UDRDfBDesc"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=rowid+1,title="自查项目类别",name="DKXtype"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=rowid+1,title="是否末级",name="DKXisEnd"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=rowid+1,title="提交状态",name="UDRsubmitState"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=rowid+1,title="审核状态",name="UDRauditState"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	s rowid=rowid+1,title="修改状态",name="UDRupdateState"
	s tmp=rowid_"^"_title_"^"_name
	d json.InsertRowData(tmp)
	
	s resultString = ""
	s resultString = json.getJsonData("rowid^title^name",rowid)
	q resultString
}

///  Creator: hfj
///  CreatDate: 2015-06-2
///  Description: 根据查询条件（自查期间、用户ID、自查权限）查询自查项目、类别（1-前台显示多行文本 2-前台显示单选项）、填报内容、填报要求
///  Table: dhc_pa_data.UnitDeptResultDetail(自查科室明细表),dhc_pa_data.UnitDeptResult(自查科室主表),dhc_pa_data.JXUnitAudit(绩效单元设置表),dhc_pa_data.Dept_KPIIndex(自查项目表) 
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).ListH("2016","M","1","1","3","1","0","0","1000")
ClassMethod ListH(year, frequency, acuttypeitem, userId, deptDr, DschemDr, parent, start, limit) As %String
{
	n (year, frequency, acuttypeitem, userId, deptDr, DschemDr, parent, start, limit)
	
	q:year="" "NoYear"
	q:frequency="" "Nofrequency"
	q:acuttypeitem="" "Noacuttypeitem"
	q:userId="" "NouserId"
	q:deptDr="" "NodeptDr"
	q:DschemDr="" "NoDschemDr"
	q:parent="" "Noparent"
	
	i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	s Period=year_$p(data,"^",acuttypeitem) 	//自查期间
	
	s count=0
	s resultString=""
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="UDRDrowid^DKXcode^DKXname^DKXname01^DKXname02^DKXname03^DKXname04^DKXname05^DKXname06^DKXname07^DKXname08^DKXname09^DKXtype^DKXisEnd^UDRDestDesc^UDRDfBDesc^UDRDUDResult^UDRsubmitState^UDRauditState^UDRupdateState^upload"

	s sqlStr=" SELECT UDRD_rowid,UDRD_DKPIDr,UDRD_DKPIDr->DKX_code,UDRD_DKPIDr->DKX_name,UDRD_DKPIDr->DKX_type,UDRD_DKPIDr->DKX_isEnd,UDRD_estDesc,UDRD_fBDesc,UDRD_UDResult,UDRD_UDResult->UDR_submitState,UDRD_UDResult->UDR_auditState,UDRD_UDResult->UDR_updateState,UDRD_UDResult->UDR_jxUnitDr" 
             _" FROM dhc_pa_data.UnitDeptResultDetail where 1=1" 
    
    i DschemDr'="" s sqlStr=sqlStr_" and UDRD_UDResult->UDR_DschemDr->DSC_rowid='"_DschemDr_"'"
    i Period'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_period='"_Period_"'"
    i deptDr'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_jxUnitDr='"_deptDr_"'"
    i frequency'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_frequency_"'"
    ;i userId'=""  s sqlStr=" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_userId_"'"
	s sqlStr=sqlStr_" order by UDRD_DKPIDr->DKX_code asc"
	;w sqlStr,!
	s DKXname01="",DKXname02="",DKXname03="",DKXname04="",DKXname05="",DKXname06="",DKXname07="",DKXname08="",DKXname09=""
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	 ;s Count=..GetCount(year, frequency, acuttypeitem, userId, deptDr, DschemDr)
        ;w Count,!
	s n=0
	while(result.Next())
	{
		s flag=0
		s UDRDrowid = result.Data("UDRD_rowid") 
		s UDRDDKPIDr=result.Data("UDRD_DKPIDr") ;自查项目ID	
		s DKXcode=result.Data("DKX_code")
		s n=($l(DKXcode)-3)/2
		i n=0  s DKXname=result.Data("DKX_name"),DKXname01="",DKXname02="",DKXname03="",DKXname04="",DKXname05="",DKXname06="",DKXname07="",DKXname08="",DKXname09=""
		i n=1  s DKXname01=result.Data("DKX_name"),DKXname02="",DKXname03="",DKXname04="",DKXname05="",DKXname06="",DKXname07="",DKXname08="",DKXname09=""
		i n=2  s DKXname02=result.Data("DKX_name"),DKXname03="",DKXname04="",DKXname05="",DKXname06="",DKXname07="",DKXname08="",DKXname09=""
		i n=3  s DKXname03=result.Data("DKX_name"),DKXname04="",DKXname05="",DKXname06="",DKXname07="",DKXname08="",DKXname09=""
		i n=4  s DKXname04=result.Data("DKX_name"),DKXname05="",DKXname06="",DKXname07="",DKXname08="",DKXname09=""
		i n=5  s DKXname05=result.Data("DKX_name"),DKXname06="",DKXname07="",DKXname08="",DKXname09=""
		i n=6  s DKXname06=result.Data("DKX_name"),DKXname07="",DKXname08="",DKXname09=""
		i n=7  s DKXname07=result.Data("DKX_name"),DKXname08="",DKXname09=""
		i n=8  s DKXname08=result.Data("DKX_name"),DKXname09=""
		i n=9  s DKXname09=result.Data("DKX_name")
	    s jxunitDr=result.Data("UDR_jxUnitDr")
	    i jxunitDr'="" d
	    .i $d(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",jxunitDr,userId)) d
	    .s flag=1
	    q:flag=0
		s DKXtype=result.Data("DKX_type")
		s DKXisEnd=result.Data("DKX_isEnd")			
		s UDRDestDesc=result.Data("UDRD_estDesc")
		s UDRDfBDesc=result.Data("UDRD_fBDesc")
		s UDRDUDResult=result.Data("UDRD_UDResult")
		s UDRsubmitState=result.Data("UDR_submitState")
		i UDRsubmitState="1" s UDRsubmitState="已提交"
		i UDRsubmitState="0" s UDRsubmitState="未提交"
		
		
		s UDRauditState=result.Data("UDR_auditState")
		i UDRauditState="1" s UDRauditState="审核通过"
		i UDRauditState="0" s UDRauditState="未审核"
		
		
		s UDRupdateState=result.Data("UDR_updateState")
		i UDRupdateState="1" s UDRupdateState="允许修改"
		i UDRupdateState="0" s UDRupdateState="不许修改"
		
		;s sumList=UDRDrowid_"^"_DKXcode_"^"_DKXname_"^"_DKXname01_"^"_DKXname02_"^"_DKXname03_"^"_DKXname04_"^"_DKXname05_"^"_DKXname06_"^"_DKXname07_"^"_DKXname08_"^"_DKXname09_"^"_DKXtype_"^"_DKXisEnd_"^"_UDRDestDesc_"^"_UDRDfBDesc_"^"_UDRDUDResult_"^"_UDRsubmitState_"^"_UDRauditState_"^"_UDRupdateState_"^"_""
        
      s sumList(DKXcode)=UDRDrowid_"^"_DKXcode_"^"_DKXname_"^"_DKXname01_"^"_DKXname02_"^"_DKXname03_"^"_DKXname04_"^"_DKXname05_"^"_DKXname06_"^"_DKXname07_"^"_DKXname08_"^"_DKXname09_"^"_DKXtype_"^"_DKXisEnd_"^"_UDRDestDesc_"^"_UDRDfBDesc_"^"_UDRDUDResult_"^"_UDRsubmitState_"^"_UDRauditState_"^"_UDRupdateState_"^"_""
		;i DKXname01'=""  s sumList(DKXcode,DKXname01)=DKXcode_"^"_DKXname01_"^"_DKXisEnd
        ;i DKXname01'=""  s ^TMPYGB(DKXcode,DKXname01)=sumList(DKXcode,DKXname01)
        ;s ^TMPYGB(DKXcode)=sumList(DKXcode)  
		//s tmp=UDRDrowid_"^"_DKXcode_"^"_DKXname_"^"_DKXname01_"^"_DKXname02_"^"_DKXname03_"^"_DKXname04_"^"_DKXname05_"^"_DKXname06_"^"_DKXname07_"^"_DKXname08_"^"_DKXname09_"^"_DKXtype_"^"_DKXisEnd_"^"_UDRDestDesc_"^"_UDRDfBDesc_"^"_UDRDUDResult_"^"_UDRsubmitState_"^"_UDRauditState_"^"_UDRupdateState_"^"_""
	    s count=count+1
		//d json.InsertRowData(tmp)
		
	}		
	
	s DKXcode="" f  s DKXcode=$O(sumList(DKXcode))  q:DKXcode=""  d
	.i $P(sumList(DKXcode),"^",14)="N"  d
	..s newDKXname01="",newDKXname02="",newDKXname03="",scount=0
	..s newDKXcode=DKXcode f  s newDKXcode=$o(sumList(newDKXcode)) q:newDKXcode=""  d
	...q:$P(sumList(newDKXcode),"^",14)'="Y"
	...s scount=scount+1
	...i scount=1 s newDKXname01=$P(sumList(newDKXcode),"^",4)
	...i scount=1 s newDKXname02=$P(sumList(newDKXcode),"^",5)
	...i scount=1 s newDKXname03=$P(sumList(newDKXcode),"^",6)
	...i scount=1 s newDKXname04=$P(sumList(newDKXcode),"^",7)
	...i scount=1 s newDKXname05=$P(sumList(newDKXcode),"^",8)
	...s $P(sumList(DKXcode),"^",4)=newDKXname01
	...s $P(sumList(DKXcode),"^",5)=newDKXname02
	...s $P(sumList(DKXcode),"^",6)=newDKXname03
	...s $P(sumList(DKXcode),"^",7)=newDKXname04
	...s $P(sumList(DKXcode),"^",8)=newDKXname05
	.s tmp=sumList(DKXcode)
	.d json.InsertRowData(tmp)
	/*s DKXcode="" f  s DKXcode=$O(sumList(DKXcode))  q:DKXcode=""  d
	.s DKXname01="" f  s DKXname01=$O(sumList(DKXcode,DKXname01))  q:DKXname01=""  d
    ..s DKXisEnd=$P(sumList(DKXcode),"^",14)
    ..i DKXisEnd="N"  d
    ...s newDKXname01=""
    ...f  s newDKXcode=$o(sumList(DKXcode,newDKXname01)) q:newDKXname01=""  d
    ....q:$P(sumList(DKXcode,newDKXname01),"^",14)'="Y" 
    ....i newDKXname01="" s newDKXname01=$P(sumList(DKXcode,newDKXname01),"^",4)
    ..s $P(sumList(DKXcode,DKXname01),"^",4)=newDKXname01 
    ..s tmp=sumList(DKXcode) 
    ..d json.InsertRowData(tmp) */                                                                                                                                                     
	s resultString = json.getJsonData(jsonTitle,count)	
 	k json
	q resultString
}

/// Creator:黄凤杰
/// CreatDate:2015-5-18                                                                                                                                                                                                                                                      
/// Description:自查明细
/// Table:dhc_pa_data.UnitDeptResultDetail
/// Input:submitState-是否提交，0:不提交，1:提交;
/// Output:
/// Return:返回评审的字符串
/// Others:w ##class(dhc.pa.udata.uSelfFillandReport).detailList("2016","M","1","1","3","1","0","0","1000")
ClassMethod detailList(year, frequency, acuttypeitem, userId, deptDr, DschemDr, parent, start, limit) As %String
{
	n (year, frequency, acuttypeitem, userId, deptDr, DschemDr, parent, start, limit)
	q:year="" "NoYear"
	q:frequency="" "Nofrequency"
	q:acuttypeitem="" "Noacuttypeitem"
	q:userId="" "NouserId"
	q:deptDr="" "NodeptDr"
	q:DschemDr="" "NoDschemDr"
	//q:parent="" "Noparent"
	//w parent
	i acuttypeitem'="" s acuttypeitem=acuttypeitem+1
	s data="00^01^02^03^04^05^06^07^08^09^10^11^12"
	s Period=year_$p(data,"^",acuttypeitem) 	//自查期间
	

	
	s sqlStr="  select UDRD_rowid,UDRD_UDResult ,UDRD_DsDetailDr,UDRD_DKPIDr,UDRD_DKPIDr->DKX_code as D_code,UDRD_DKPIDr->DKX_isEnd as D_isEnd,UDRD_DKPIDr->DKX_name as D_name,UDRD_order,UDRD_rate,UDRD_score,UDRD_estDesc,UDRD_fBDesc,UDRD_parent,UDRD_load" 
             _" FROM dhc_pa_data.UnitDeptResultDetail where UDRD_parent='"_parent_"' "
    i DschemDr'="" s sqlStr=sqlStr_" and UDRD_UDResult->UDR_DschemDr='"_DschemDr_"'"
    i Period'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_period='"_Period_"'"
    i deptDr'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_jxUnitDr='"_deptDr_"'"
    i frequency'=""  s sqlStr=sqlStr_" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_frequency_"'"
    ;i userId'=""  s sqlStr=" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_userId_"'"
	s sqlStr=sqlStr_" order by UDRD_DKPIDr->DKX_code asc"
    ;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit-1
	s resultString="["
	s result=##class(%Library.ResultSet).%New()
	;i (tmpEnd=0)||(parent=0) d
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s Rowid= result.Data("UDRD_rowid")
		s UDResult= result.Data("UDRD_UDResult")
		s DsDetailDr= result.Data("UDRD_DsDetailDr")
		s DKPIDr= result.Data("UDRD_DKPIDr")
		s code= result.Data("D_code")
		s isEnd= result.Data("D_isEnd")
		i isEnd="Y" s Flag="true"
		i isEnd="N" s Flag="false"
		s name= result.Data("D_name")
		s order= result.Data("UDRD_order")
		s rate= result.Data("UDRD_rate")
		s score= result.Data("UDRD_score")
		s estDesc= result.Data("UDRD_estDesc")
		s fBDesc= result.Data("UDRD_fBDesc")
		
		s SuperiorUnitName=""
		s parent= result.Data("UDRD_parent")
		i parent'="" d
		.i $D(^DHCCJXPAUnitDeptResultDetailD(parent)) d
		..i $G(^DHCCJXPAUnitDeptResultDetailD(parent))'="" d
		...s SuperiorUnitName=$List(^DHCCJXPAUnitDeptResultDetailD(parent),10)
		s load = result.Data("UDRD_load")
		
		s resultString=resultString_"{id:'"_DKPIDr_"',Rowid:'"_Rowid_"',name:'"_name_"',estDesc:'"_estDesc_"',fBDesc:'"_fBDesc_"',leaf:"_Flag_",uiProvider:'col'},"
		 
	}

	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator: 刘小明
/// CreatDate: 2015-6-2
/// Description: 统计第一级目录下所有id串（"^"）
/// Table：
/// Input: 
/// Output: 
/// Return: 返回末级科室id串（"^"）
/// Others: w ##class(dhc.pa.udata.uSelfFillandReport).SearchId("201501","M","4","2","0")
ClassMethod SearchId(Period, frequency, deptDr, DschemDr, parent) As %String
{
	n (Period, frequency, deptDr, DschemDr, parent)
	
	s sqlStr="SELECT UDRD_rowid,UDRD_DKPIDr"
	         _" FROM dhc_pa_data.UnitDeptResultDetail"
			 _" WHERE UDRD_UDResult->UDR_DschemDr='"_DschemDr_"' AND UDRD_UDResult->UDR_jxUnitDr='"_deptDr_"'"
			 _" AND UDRD_UDResult->UDR_period='"_Period_"' AND UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_frequency_"'"_" and UDRD_DKPIDr->DKX_isEnd='Y'"
	;w sqlStr,!

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	
	s idString="" 
		
	while(result.Next())
	{
		s UDRDrowid=result.Data("UDRD_rowid")	;自查科室明细ID		
		s UDRDDKPIDr=result.Data("UDRD_DKPIDr") ;自查项目ID			
		
		//如果不为空，第一次
		i idString="" d
		.s idString=UDRDrowid
		.s id=..SearchId(Period, frequency, deptDr, DschemDr, UDRDDKPIDr)
		.i id'="" d
		..s idString=idString_"^"_id
		e  d
		.s idString=idString_"^"_UDRDrowid
		.s id=..SearchId(Period, frequency, deptDr, DschemDr, UDRDDKPIDr)
		.i id'="" d
		..s idString=idString_"^"_id
				
	}	
	d result.Close() 
	q idString
}

/// Creator: 刘小明
/// CreatDate: 2015-6-2
/// Description: 根据自查科室明细ID查找拼接json串
/// Table：
/// Input: 
/// Output: 
/// Return: 返回前台字段串（"^"）
/// Others: w ##class(dhc.pa.udata.uSelfFillandReport).GetInfor("250")
ClassMethod GetInfor(UDRDId) As %String
{
	
	n (UDRDId)
	
	s sqlStr="SELECT UDRD_DKPIDr,UDRD_DKPIDr->DKX_name,UDRD_DKPIDr->DKX_type,UDRD_DKPIDr->DKX_level,UDRD_DKPIDr->DKX_isEnd,UDRD_estDesc,UDRD_fBDesc,UDRD_UDResult,UDRD_UDResult->UDR_submitState"
	         _" FROM dhc_pa_data.UnitDeptResultDetail"
			 _" WHERE UDRD_rowid='"_UDRDId_"' and UDRD_DKPIDr->DKX_isEnd='Y'"

	;w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s resultString=""

	d result.Next()
	
	s UDRDDKPIDr=result.Data("UDRD_DKPIDr") ;自查项目ID			
	s DKXname=result.Data("DKX_name")		;自查项目名称
	//按层次显示处理
	/*
	s DKXlevel=result.Data("DKX_level")
	if (DKXlevel=2) {
		s DKXname="- -"_DKXname
	}elseif(DKXlevel=3){
		s DKXname="- - - -"_DKXname
	}elseif(DKXlevel=4){
		s DKXname="- - - - - -"_DKXname
	}
    */
	s DKXtype=result.Data("DKX_type")
	s DKXisEnd=result.Data("DKX_isEnd")			
	s UDRDestDesc=result.Data("UDRD_estDesc")
	s UDRDfBDesc=result.Data("UDRD_fBDesc")
	s UDRDUDResult=result.Data("UDRD_UDResult")
	s UDRsubmitState=result.Data("UDR_submitState")
	i UDRsubmitState="1" s UDRsubmitState="已提交"
	i UDRsubmitState="0" s UDRsubmitState="未提交"

	
		
	i DKXname'="" s resultString=UDRDId_"^"_DKXname_"^"_DKXtype_"^"_DKXisEnd_"^"_UDRDestDesc_"^"_UDRDfBDesc_"^"_UDRDUDResult_"^"_UDRsubmitState_"^"_""
	d result.Close() 
	
	q resultString
}

///  Creator:cyl
///  CreatDate: 2015-05-30
///  Description: 根据查询条件（自查期间、用户ID、自查权限）查询自查项目、类别（1-前台显示多行文本 2-前台显示单选项）、填报内容、填报要求
///  Table: dhc_pa_data.UnitDeptResultDetail(自查科室明细表)
///  Input: 
///  Output: 
///  Return: 返回查询到的记录的Json串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).ListHNew("2016","Y","0","4","5","1")
ClassMethod ListHNew(year, frequency, period, deptDr, DschemDr, userId) As %String
{
	n (year, frequency, period,deptDr, DschemDr,userId)
	
	q:year="" "NoYear"
	q:frequency="" "Nofrequency"
	q:period="" "Noperiod"
	q:userId="" "NouserId"
	q:deptDr="" "NodeptDr"
	q:DschemDr="" "NoDschemDr"
	/*要实现动态的表头和加载级数不定的项目，则需要用临时gloabl来存储数据并拼jsonTile
	*定义：临时jsonTile：^jsonTitle
	*/
	;s ^chuchu=year_"^"_frequency_"^"_ period_"^"_deptDr_"^"_ DschemDr_"^"_userId
	i period="0" s period="00"
	s period=year_period	//自查期间
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	//初始jsonTitle中只留有填报内容^提交状态。下面还需要有项目根据level来设置jsonTile和末级项目的rowid
	s jsonTitle="URDContent^UDRsubmitState^YRowid"
	s sqlStr="SELECT UDRD_rowid,UDRD_DKPIDr,UDRD_DKPIDr->DKX_name as name,UDRD_DKPIDr->DKX_level as KPIlevel,UDRD_DKPIDr->DKX_parent as parent,UDRD_DKPIDr->DKX_isEnd as isEnd , max(UDRD_DKPIDr->DKX_level) AS maxLevel,UDRD_estDesc, UDRD_UDResult->UDR_submitState AS sumbmitState "
			_" FROM dhc_pa_data.UnitDeptResultDetail "
			_" WHERE UDRD_UDResult->UDR_jxUnitDr="_deptDr_" "
			_" and UDRD_UDResult->UDR_DschemDr='"_DschemDr_"' "
			_" and UDRD_UDResult->UDR_period='"_period_"' " 
			_" and UDRD_UDResult->UDR_DschemDr->DSC_frequency='"_frequency_"' "
			_"  AND UDRD_DKPIDr->DKX_isEnd='Y'  "
			;_" ORDER BY  UDRD_parent"
	;	s ^chuSql=sqlStr	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	d result.Next()
	s count=0,maxLevel=0
	while(result.Next()){
		s schemTemp=""
		/*sql查询出的数据前几条都是parent=0的，那么用parent=0的做global*/
		s rowid=result.Data("UDRD_rowid") 
		s DKPIDr=result.Data("UDRD_DKPIDr") 
		s name=result.Data("name") 
		s KPIlevel=result.Data("KPIlevel") 
		s parent=result.Data("parent") 
		s isEnd=result.Data("isEnd") 
		s sumbmitState=result.Data("sumbmitState")  ;提交转态
		s estDesc=result.Data("UDRD_estDesc")  ;填报内容
		s temp=estDesc_"^"_sumbmitState_"^"_rowid
		//if (count=0){
			//取最大的level,拼jsonTitle
			s maxLevel=+result.Data("maxLevel")
			;s schemCount=maxLevel+1
			for schemCount=0:1:maxLevel    d
			.;jsonTitle="URDContent^UDRsubmitState^schemLevel3^schemLevel2^schemLevel1"
			.i count=0 d
			..s jsonTitle=jsonTitle_"^schemLevel_"_schemCount
			.s schemTemp=schemTemp_"^"
			
		//}
		
		
		/*这里面要将每个叶子节点都生成一条记录，并根据level来确定是第几层的项目节点
		*思路：1、先将叶子节点的rowid和name，level放在一个global^KPILevelTemp中
		2、获得叶子节点的上一级节点：将上一级的节点放在^KPILevelTemp中
		*/
		s isExecute=..getLeafToRootByLeaf(DKPIDr,KPIlevel)
		if isExecute="execute" d
		.s schemLevelStr=$g(^leafToRootTemp("leafToRoot"))
		.k ^leafToRootTemp("leafToRoot")
		//处理项目级别：
	
		s schemLevelLen=$L(schemLevelStr,"^")
		for i=1:1:schemLevelLen  d
		.s schemStr=$p(schemLevelStr,"^",i)
		.i schemStr'=""  d
		..s schemName=$p(schemStr,"#",1)
		..s schemLevel=$p(schemStr,"#",2)
		..;根据level来确定替换那个位置的^号
		..s reposition=maxLevel-(maxLevel-schemLevel)+1
		..s $EXTRACT(schemTemp,reposition)="^"_schemName
		s temp=temp_schemTemp
		d json.InsertRowData(temp)
		s count=count+1
		
	}		
	                                                                                                                                        
	s resultString = json.getJsonDataNew(jsonTitle,count,"",maxLevel)	
 	k json
	q resultString
}

///  Creator:cyl
///  CreatDate: 2015-06-01
///  Description: 根据叶子节点找到根节点，生成一条字符串
///  Table: dhc_pa_data.UnitDeptResultDetail(自查科室明细表)
///  Input: leafRowid（叶子节点的rowid），level（叶子节点的级别）
///  Output: 从跟节点到该叶子节点的路径
///  Return: 字符串
///  Others: w ##class(dhc.pa.udata.uSelfFillandReport).getLeafToRootByLeaf("21","3")
ClassMethod getLeafToRootByLeaf(leafRowid, level) As %String
{
	n (leafRowid,level)
	/*方法中用到递归算法：用来从叶子节点找到根节点生成一条路径的Str
	*思路：1、根据leafRowid找到他的parent，
	*	   2、声明临时global ^leafToRootTemp(leafRowid,level)
	*      3、golobal中存入获得的节点的名称和level
	*/
	
	s deptKPIStr=""
	s result="execute"
	s deptKPIStr=^DHCCJXPADeptKPIIndexD(leafRowid)
	s nameKPI= $LISTGET(deptKPIStr,3)
	s levelKPI=$LISTGET(deptKPIStr,8)
	s parentKPI=$LISTGET(deptKPIStr,10)
	
	s ^leafToRootTemp("leafToRoot")=$g(^leafToRootTemp("leafToRoot"))_"^"_nameKPI_"#"_levelKPI
	
	if (parentKPI>0){
		d ..getLeafToRootByLeaf(parentKPI,levelKPI)
	}
	;k ^leafToRootTemp("leafToRoot")
	q result
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSelfFillan9D06S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
