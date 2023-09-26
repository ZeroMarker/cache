Class dhc.pa.udata.uirsea Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:黄凤杰
/// CreatDate:2015-5-18
/// Description:查询报告
/// Table:dhc_pa_data.UnitDeptResult
/// Input:CycleDr-年度，period-期间，name-自查名称，userId-用户ID
/// Output:
/// Return:返回报告的字符串
/// Others:w ##class(dhc.pa.udata.uirsea).List(0, 25, "2015", "01","01","M", "2", "3901")
ClassMethod List(start, limit, CycleDr, startperiod, endperiod, periodType, name, userID) As %String
{
	n (  start, limit,CycleDr, startperiod, endperiod, periodType,name,userID)
	
	
	
	s sqlStr="select DISTINCT  UDR_rowid,UDR_jxUnitDr->JXUnit_name as deptname,UDR_jxUnitDr->JXUnit_rowid as cmd,UDR_period,UDR_DschemDr->DSC_code as code,UDR_DschemDr->DSC_name as name,UDR_DschemDr->DSC_frequency as periodType,UDR_submitState,UDR_submiDr,UDR_submiDate,UDR_auditState,UDR_auditDr,UDR_auditDate ,UDR_updateDr, UDR_updateDate, UDR_updateState  "
	s sqlStr=sqlStr_" from dhc_pa_data.UnitDeptResult  a  join dhc_pa_data.DeptSchem b on a.UDR_DschemDr = b.DSC_rowid"
	s sqlStr=sqlStr_" and DSC_frequency ='"_periodType_"' and UDR_period between'"_CycleDr_startperiod_"'and '"_CycleDr_endperiod_"' "
	i name '="" s sqlStr=sqlStr_"and UDR_DschemDr ='"_name_"'"
	s sqlStr=sqlStr_" left join dhc_pa_data.JXUnit c  on a.UDR_jxUnitDr = c.JXUnit_rowid "
	s sqlStr=sqlStr_" left join dhc_pa_data.JXUnitAudit e  on  a.UDR_jxUnitDr = e.JXUnitAudit_jxUnitDr "
	s sqlStr=sqlStr_" and e.JXUnitAudit_userDr= '"_userID_"'"
	s sqlStr=sqlStr_" left  join dhc_pa_data.DeptSchemAudit d  on a.UDR_DschemDr = d.DSA_DSchemDr  "
	s sqlStr=sqlStr_" and d.DSA_userDr= '"_userID_"'"
	
   
			
	;w sqlStr,!
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle=" rowid^deptname^cmd^period^periodType^periodTypeName^code^name^submitState^submitStateName^submiDr^submiUserName^submiDate^auditState^auditStateName^auditDr^auditUserName^auditDate^updateState^updateStateName^updateDr^updateUserName^updateDate"
	
	While(result.Next()){
		s rowid=result.Data("UDR_rowid")
		s deptname=result.Data("deptname")
		s cmd=result.Data("cmd")
		s period=result.Data("UDR_period")
		s code=result.Data("code")
		s name=result.Data("name")
		
		s submitState=result.Data("UDR_submitState")
		
		i submitState=0 s submitStateName="未提交"
		i submitState=1 s submitStateName="已提交"
		//i submitState="" s submitStateName=""
		
		s submiDr=result.Data("UDR_submiDr")
		i submiDr="" d
		.s submiUserName=""
		i submiDr'="" d
		.i $D(^SSU("SSUSR",submiDr)) d
		..i $G(^SSU("SSUSR",submiDr))'="" d
		...s submiUserName=$P(^SSU("SSUSR",submiDr),"^",2)
		s submiDate=result.Data("UDR_submiDate")
		s submiDate=##class(websys.Conversions).DateLogicalToHtml($ZDH(submiDate,3))
		//if submiDate'="" s submiDate=$ZDT(submiDate,3)
		s auditState=result.Data("UDR_auditState")
		
		i auditState=0 s auditStateName="未审核"
		i auditState=1 s auditStateName="审核通过"
		//i auditState="" s auditStateName=""
		s auditDr=result.Data("UDR_auditDr")
		i auditDr="" d
		.s auditUserName=""
		i auditDr'="" d
		.i $D(^SSU("SSUSR",auditDr)) d
		..i $G(^SSU("SSUSR",auditDr))'="" d
		...s auditUserName=$P(^SSU("SSUSR",auditDr),"^",2)
		s auditDate=result.Data("UDR_auditDate")
		;W auditDate,!
		s auditDate=##class(websys.Conversions).DateLogicalToHtml($ZDH(auditDate,3))
		w auditDate,!
		//if auditDate'="" s auditDate=$ZDT(auditDate,3)
		//期间类型
		s periodType=result.Data("periodType")
		i periodType="M" s periodTypeName="月份"
		i periodType="Q" s periodTypeName="季度"
		i periodType="H" s periodTypeName="半年"
		i periodType="Y" s periodTypeName="年度"
		//i periodType="" s periodTypeName=""
		s updateState=result.Data("UDR_updateState")
		
		i updateState=0  s updateStateName="不许修改"
		
		i updateState=1 s updateStateName="允许修改"
		i updateState="" s updateStateName=""
		
		s updateDr=result.Data("UDR_updateDr")
		i updateDr="" d
		.s updateUserName=""
		i updateDr'="" d
		.i $D(^SSU("SSUSR",updateDr)) d
		..i $G(^SSU("SSUSR",updateDr))'="" d
		...s updateUserName=$P(^SSU("SSUSR",updateDr),"^",2)
		s updateDate=result.Data("UDR_updateDate")
	
		
		
		
	s tmp=rowid_"^"_deptname_"^"_cmd_"^"_period_"^"_periodType_"^"_periodTypeName_"^"_code_"^"_name_"^"_submitState_"^"_submitStateName_"^"_submiDr_"^"_submiUserName_"^"_submiDate_"^"_auditState_"^"_auditStateName_"^"_auditDr_"^"_auditUserName_"^"_auditDate_"^"_updateState_"^"_updateStateName_"^"_updateDr_"^"_updateUserName_"^"_updateDate
	
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:黄凤杰
/// CreatDate:2015-5-18
/// Description:评审报告
/// Table:dhc_pa_data.UnitDeptResult
/// Input:rowid-主键;IsAuditing-是否审核，0:不审核，1:审核;
/// Output:
/// Return:返回评审的字符串
/// Others:w ##class(dhc.pa.udata.uirsea).Auditing(8, 0)
ClassMethod Auditing(rowid, userID, IsAuditing) As %String
{
		
	n (rowid,userID,IsAuditing)
	;w rowid_":"_IsAuditing,!
	//k PLIST
	q:rowid="" "EmptyRecData"
	q:IsAuditing="" "EmptyRecData"
	
	s auditState=IsAuditing
	s auditData=$ZD($H,3)
	;w auditData,!
	&SQL(update dhc_pa_data.UnitDeptResult set UDR_auditDate=:auditData,UDR_auditDr=:userID,UDR_auditState=:auditState,UDR_updateState=0 where UDR_rowid=:rowid)
	q SQLCODE
}

/// Creator:黄凤杰
/// CreatDate:2015-5-18
/// Description:自查明细
/// Table:dhc_pa_data.UnitDeptResultDetail
/// Input:submitState-是否提交，0:不提交，1:提交;
/// Output:
/// Return:返回评审的字符串
/// Others:w ##class(dhc.pa.udata.uirsea).detailList("","",0,25,"已提交",41,0)
ClassMethod detailList(sortField, sortDir, start, limit, submitStateName, rowid, parent) As %String
{
	n (sortField,sortDir,start,limit,submitStateName,rowid,parent)
	
	
	s sqlStr="select UDRD_rowid,UDRD_UDResult ,UDRD_DsDetailDr,UDRD_DKPIDr,UDRD_DKPIDr->DKX_code as D_code,UDRD_DKPIDr->DKX_isEnd as D_isEnd,UDRD_DKPIDr->DKX_name as D_name,UDRD_order,UDRD_rate,UDRD_score,UDRD_estDesc,UDRD_fBDesc,UDRD_parent,UDRD_load  from dhc_pa_data.UnitDeptResultDetail  where '"_submitStateName_"'='已提交' and UDRD_UDResult='"_rowid_"'and UDRD_parent='"_parent_"' "
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
		
		s resultString=resultString_"{id:'"_DKPIDr_"',Rowid:'"_Rowid_"',ufn:'"_name_"',mid:'"_estDesc_"',mn:'"_fBDesc_"',cd:'"_load_"',leaf:"_Flag_",uiProvider:'col'},"
		 
	}

	s resultString=resultString_"]"
	d result.Close()
	q resultString
}

/// Creator:黄凤杰
/// CreatDate:2015-5-18
/// Description:自查名称
/// Table:dhc_pa_data.DeptSchem
/// Output:
/// Return:返回评审的字符串
/// Others:w ##class(dhc.pa.udata.uirsea).nameList("","",0,25)
ClassMethod nameList(userID, periodType, shortCutStr, start, limit) As %String
{
	n (userID,periodType,shortCutStr,start,limit)	
		
	s sqlStr="select DSC_rowid,DSC_name from dhc_pa_data.DeptSchem"
			 _" where DSC_rowid in (select DSA_DSchemDr from dhc_pa_data.DeptSchemAudit where DSA_userDr='"_userID_"') and DSC_frequency='"_periodType_"'" 
	;w sqlStr,!		 
	i shortCutStr'="" d
	.s sqlStr=sqlStr_" and DSC_shortcut like '%"_shortCutStr_"%'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s count=0
	s resultString="" 
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()  
	s jsonTitle="groupRowid^groupName" 
	while(result.Next())
	{
		s groupRowid=result.Data("DSC_rowid")
		s groupName=result.Data("DSC_name")	
		s tem=groupRowid_"^"_groupName
		i (count>=start)&(count<=limit) d
		.d json.InsertRowData(tem)
		s count=count+1
	}
	d result.Close()
	s resultString=json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

/// Creator：黄凤杰
/// CreatDate：2015-6-12
/// Description: 修改记录
/// Table： dhc_qm_data.uitem3
/// Input: rowId-数据行号，Cyclecode-年度code，Cyclename-年度名称，Cycleactive-是否有效
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uirsea).Update("95","3901")
ClassMethod Update(rowId, userID) As %String
{
	n (rowId,userID)
	s date=$ZDT($H,3)
	&SQL(UPDATE dhc_pa_data.UnitDeptResult set UDR_updateState=1,UDR_submitState=0,UDR_updateDate=:date,UDR_updateDr=:userID  where %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uirseaS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
