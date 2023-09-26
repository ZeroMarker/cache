/// CTOR: QP
/// DATE: 2020-01-07
/// DESC: 临床药理模块功能扩展类1
Class web.PilotProject.Extend.E1 Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-01-07
/// DESC: 导出
/// IN  : 
/// OUT : 
/// TABL: 
/// INDE: 
/// EXEC: d ##class(%ResultSet).RunQuery("web.PilotProject.Extend.E1","Export","","","Other","","","","","","","","","","","","","^^^^2")
Query Export(PPCode As %String = "", PPDesc As %String = "", Flag As %String = "", PlanNo As %String = "", PlanName As %String = "", ApplicationUnit As %String = "", PilotCategoryDr As %String = "", ApprovalNo As %String = "", ApplyMatterDr As %String = "", ApplyStageDr As %String = "", IsHeadmanDr As %String = "", PPCreateDepartmentDr As %String = "", PPStartUserDr As %String = "", Indication = "", ArchivesFilesNo = "", Exp As %String = "") As %Library.Query(ROWSPEC = "TPPCode:%String:项目编号,TPPDesc:%String:药物/医疗器械名称,PorCreateDate:%String:立项日期,TPPCreateDepartment:%String:立项科室,TPPStartUser:%String:负责人,TPPBudget:%String:项目预算,TPPState:%String:当前状态,PPSUpdateReason:%String:状态变更过程,ArchivesFilesNo:%String:档案文件夹编号,PlanNamenow:%String:方案名称,ApplicationUnitnow:%String:申请人,CPRCApproveDate:%String:CPRC审查日期,EthicsMeetDate:%String:伦理委员会上会日期,TEthicsMeetAduitDate:%String:伦理委员会批准日期,PPAccount:%String:账户,CPRCApproveResult:%String:CPRC审查意见,TApproveResult:%String:预审结果,TPPStartDate:%String:项目开始日期,TEndDate:%String:项目结束日期")
{
}

ClassMethod ExportExecute(ByRef qHandle As %Library.Binary, PPCode As %String = "", PPDesc As %String = "", Flag As %String = "", PlanNo As %String = "", PlanName As %String = "", ApplicationUnit As %String = "", PilotCategoryDr As %String = "", ApprovalNo As %String = "", ApplyMatterDr As %String = "", ApplyStageDr As %String = "", IsHeadmanDr As %String = "", PPCreateDepartmentDr As %String = "", PPStartUserDr As %String = "", Indication = "", ArchivesFilesNo = "", Exp As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TEMP("QP","PARA",1)=$LB(PPCode,PPDesc,Flag,PlanNo,PlanName,ApplicationUnit,PilotCategoryDr,ApprovalNo,ApplyMatterDr,ApplyStageDr,IsHeadmanDr,PPCreateDepartmentDr,PPStartUserDr,Indication,ArchivesFilesNo,Exp)
	s rsy=##class(%Library.ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindProject")
	d rsy.Execute(PPCode,PPDesc,Flag,PlanNo,PlanName,ApplicationUnit,PilotCategoryDr,ApprovalNo,ApplyMatterDr,ApplyStageDr,IsHeadmanDr,PPCreateDepartmentDr,PPStartUserDr,Indication,ArchivesFilesNo,Exp)
	if rsy.QueryIsValid() {
		s seqno=0
		s columns=rsy.GetColumnCount()
		while rsy.Next() {
			s (TPPCode,TPPDesc,TEndDate,TPPCreateDepartment,TPPStartUser,TPPBudget,TPPState,PPSUpdateReason,ArchivesFilesNo,PlanNamenow,ApplicationUnitnow,CPRCApproveDate,EthicsMeetDate,EMADate,PPAccount,TEthicsMeetAduitDate,CPRCApproveResult,TApproveResult,TPPStartDate)=""
			for i=1:1:columns {
				s colName = rsy.GetColumnHeader(i)
				i colName="TPPCode" s TPPCode=rsy.GetData(i)
				i colName="TPPDesc" s TPPDesc=rsy.GetData(i)
				i colName="TEndDate" s TEndDate=rsy.GetData(i)
				i colName="TPPCreateDepartment" d
				.s TPPCreateDepartment=rsy.GetData(i)
				.s TPPCreateDepartment=..FilterValue(TPPCreateDepartment)
				i colName="TPPStartUser" d
				.s TPPStartUser=rsy.GetData(i)
				.s TPPStartUser=..FilterValue(TPPStartUser)
				i colName="TPPBudget" s TPPBudget=rsy.GetData(i)
				i colName="TPPState" s TPPState=rsy.GetData(i)
				i colName="PPSUpdateReason" s PPSUpdateReason=rsy.GetData(i)
				i colName="ArchivesFilesNo" s ArchivesFilesNo=rsy.GetData(i)
				i colName="PlanNamenow" s PlanNamenow=rsy.GetData(i)
				i colName="ApplicationUnitnow" s ApplicationUnitnow=rsy.GetData(i)
				i colName="CPRCApproveDate" s CPRCApproveDate=rsy.GetData(i)
				i colName="EthicsMeetDate" s EthicsMeetDate=rsy.GetData(i)
				//i colName="EMADate" s EMADate=rsy.GetData(i)
				i colName="PPAccount" s PPAccount=rsy.GetData(i)
				i colName="TEthicsMeetAduitDate" s TEthicsMeetAduitDate=rsy.GetData(i)
				i colName="CPRCApproveResult" s CPRCApproveResult=rsy.GetData(i)
				i colName="TApproveResult" s TApproveResult=rsy.GetData(i)
				i colName="TPPStartDate" s TPPStartDate=rsy.GetData(i)
				i colName="PorCreateDate" s PorCreateDate=rsy.GetData(i)
				
			}
			s seqno=seqno+1
			s OutputList=$lb(TPPCode,TPPDesc,PorCreateDate,TPPCreateDepartment,TPPStartUser,TPPBudget,TPPState,PPSUpdateReason,ArchivesFilesNo,PlanNamenow,ApplicationUnitnow,CPRCApproveDate,EthicsMeetDate,TEthicsMeetAduitDate,PPAccount,CPRCApproveResult,TApproveResult,TPPStartDate,TEndDate)
			d OutputRow1
		}
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2022-03-22
/// DESC: 获取总记录数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.E1).GetTotal("N")
ClassMethod GetTotal(PPCode As %String = "", PPDesc As %String = "", Flag As %String = "", PlanNo As %String = "", PlanName As %String = "", ApplicationUnit As %String = "", PilotCategoryDr As %String = "", ApprovalNo As %String = "", ApplyMatterDr As %String = "", ApplyStageDr As %String = "", IsHeadmanDr As %String = "", PPCreateDepartmentDr As %String = "", PPStartUserDr As %String = "", Indication = "", ArchivesFilesNo = "", Exp As %String = "")
{
	s mRtn=0
	s rsy=##class(%Library.ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindProject")
	d rsy.Execute(PPCode,PPDesc,Flag,PlanNo,PlanName,ApplicationUnit,PilotCategoryDr,ApprovalNo,ApplyMatterDr,ApplyStageDr,IsHeadmanDr,PPCreateDepartmentDr,PPStartUserDr,Indication,ArchivesFilesNo,Exp)
	if rsy.QueryIsValid() {
		s seqno=0
		s columns=rsy.GetColumnCount()
		while rsy.Next() {
			s mRtn=mRtn+1
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-01-07
/// DESC: 根据代码获取项目状态描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.E1).GetProjectDesc("N")
ClassMethod GetProjectDesc(ProCode As %String)
{
	s mRtn=""
	i ProCode="N" s mRtn="立项"
	i ProCode="H" s mRtn="未进行"
	i ProCode="V" s mRtn="在研"
	i ProCode="P" s mRtn="发补后在研"
	i ProCode="F" s mRtn="已完成"
	i ProCode="A" s mRtn="暂停"
	i ProCode="S" s mRtn="终止"
	i ProCode="B" s mRtn="中止"
	i ProCode="I" s mRtn="审批中"
	i ProCode="U" s mRtn="未批准"
	i ProCode="D" s mRtn="上会未通过"
	i ProCode="E" s ProState="非大表项目，财务专用"
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-01-10
/// DESC: 删除汇款记录
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Extend.E1).DeleteProjectRem("147||4")
ClassMethod DeleteProjectRem(PPRemId As %String)
{
	Q:PPRemId="" 0
	&SQL(DELETE FROM SQLUser.DHC_DocPilotProRem WHERE PPR_RowId=:PPRemId)
	
	Q SQLCODE
}

/// QP
/// DATE: 2020-01-21
/// DESC: 过滤字符
ClassMethod FilterValue(value) As %String
{
	s value=..ReplaceStr(value,",","，")
	s value=..ReplaceStr(value,$C(10),"")
	q value
}

/// QP
/// DATE: 2020-01-21
ClassMethod ReplaceStr(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

}
