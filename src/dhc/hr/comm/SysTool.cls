/// 用于上线初期写一些批量处理数据的m
Class dhc.hr.comm.SysTool Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: chinaway
/// CreatDate: 2020-09-29
/// Description: 清空数据库（仅限上线前，慎用！！！）
/// Others: w ##class(dhc.hr.comm.SysTool).EmptyDataBase()
ClassMethod EmptyDataBase()
{
	;组织模块
	k ^HISHR.OrgInfoD
	k ^HISHR.DeptInfoI
	k ^HISHR.DeptInfoD
	k ^HISHR.DeptChangeHistoryInfoI
	k ^HISHR.DeptChangeHistoryInfoD
	k ^HISHR.DeptChangeLogInfoI
	k ^HISHR.DeptChangeLogInfoD
	k ^HISHR.StationDutyInfoI
	k ^HISHR.StationDutyInfoD
	k ^HISHR.StationTrainRequirInfoI 
	k ^HISHR.StationTrainRequirInfoD
	k ^HISHR.StationQualifyI
	k ^HISHR.StationQualifyD
	k ^HISHR.StationJurisdictionInfoI
	k ^HISHR.StationJurisdictionInfoD
	k ^HISHR.StationDefineInfoI
	k ^HISHR.StationDefineInfoD
	k ^HISHR.VirtualDeptInfoI
	k ^HISHR.VirtualDeptInfoD
	k ^HISHR.VirtualPersonInfoI
	k ^HISHR.VirtualPersonInfoD
	k ^HISHR.HISVSHRDeptInfoI
	k ^HISHR.HISVSHRDeptInfoD
	;日志
	k ^HISHR.LogInfoInfoI
	k ^HISHR.LogInfoInfoD
	k ^HISHR.LoginLogDetailInfoI
	k ^HISHR.LoginLogDetailInfoD
	k ^HISHR.LoginLogInfoI
	k ^HISHR.LoginLogInfoD
	;人事模块
	k ^HISHR.PersonInfoI
	k ^HISHR.PersonInfoD
	k ^HISHR.PSFamilyInfoI
	k ^HISHR.PSFamilyInfoD
	k ^HISHR.PSHarmInfoI
	k ^HISHR.PSHarmInfoD
	k ^HISHR.PSBaseCollectInfoI
	k ^HISHR.PSBaseCollectInfoD
	k ^HISHR.PSAbroadInfoI
	k ^HISHR.PSAbroadInfoD
	k ^HISHR.PSEducateInfoI
	k ^HISHR.PSEducateInfoD
	k ^HISHR.PSExperienceInfoI
	k ^HISHR.PSExperienceInfoD
	k ^HISHR.PSPostionInfoI
	k ^HISHR.PSPostionInfoD
	k ^HISHR.PSHonorInfoD
	k ^HISHR.PSCharterInfoD
	k ^HISHR.PSAbroadInfoD
	k ^HISHR.PSItemChangeInfoD
	k ^HISHR.PSOccupationInfoI
	k ^HISHR.PSOccupationInfoD
	k ^HISHR.PSTrainInfoI
	k ^HISHR.PSTrainInfoD
	k ^HISHR.PSWorkCheckInfoI
	k ^HISHR.PSWorkCheckInfoD
	k ^HISHR.PSSkillDutyInfoI
	k ^HISHR.PSSkillDutyInfoD
	k ^HISHR.PSLanguageInfoI
	k ^HISHR.PSLanguageInfoD
	k ^HISHR.PSPaperInfoI
	k ^HISHR.PSPaperInfoD
	k ^HISHR.PSPictureInfoI
	k ^HISHR.PSPictureInfoD
	k ^HISHR.PSDeathInfoI
	k ^HISHR.PSDeathInfoD
	k ^HISHR.DimissionInfoI
	k ^HISHR.DimissionInfoD
	k ^HISHR.PSRetireInfoI
	k ^HISHR.PSRetireInfoD
	k ^HISHR.PersonHistoryInfoI
	k ^HISHR.PersonHistoryInfoD
	k ^HISHR.SelfDefineFieldInfoI
	k ^HISHR.SelfDefineFieldInfoD
	k ^HISHR.SelfDefineFilterInfoI
	k ^HISHR.SelfDefineFilterInfoD
	k ^HISHR.SelfDefineFormulaInfoI
	k ^HISHR.SelfDefineFormulaInfoD
	k ^HISHR.SelfDefineSchemeInfoI
	k ^HISHR.SelfDefineSchemeInfoD
	k ^HISHR.PersonHistoryInfoI
	k ^HISHR.PersonHistoryInfoD
	k ^HISHR.AutoTaskInfoI
	k ^HISHR.AutoTaskInfoD
	&SQL(DELETE FROM HISHR.UserInfo WHERE UserLogionName!='0001')
	&SQL(DELETE FROM HISHR.UserRoleMapInfo WHERE UserPREnId!='UI000009')
   	&SQL(UPDATE hishr.sysiniinfo SET CONTEXT='PS0000001' WHERE Flag='PersonInfo')
   	&SQL(UPDATE hishr.sysiniinfo SET CONTEXT='UI000007' WHERE Flag='UserInfo')
   	&SQL(UPDATE hishr.sysiniinfo SET CONTEXT='URM000009' WHERE Flag='UserRoleMapInfo')
   	&SQL(DELETE FROM HISHR.ConfigInfo WHERE Flag='PERSONMANAGE_PERSONINFO_VISIBLE')
  	;工资模块
  	k ^HISHR.PSWageChangeInfoD
  	k ^HISHR.WagesSchemeInfoI
  	k ^HISHR.WagesSchemeInfoD
  	k ^HISHR.WagesItemSchemeInfoI
  	k ^HISHR.WagesItemSchemeInfoD
  	k ^HISHR.FormulaInfoI
  	k ^HISHR.FormulaInfoD
  	k ^HISHR.WagesSchemeFormulaInfoI
  	k ^HISHR.WagesSchemeFormulaInfoD
  	k ^HISHR.PSWageImpInfoI
  	k ^HISHR.PSWageImpInfoD
  	k ^HISHR.PSWagesInfoI
  	k ^HISHR.PSWagesInfoD
  	k ^HISHR.PSWagesHistoryInfoI
  	k ^HISHR.PSWagesHistoryInfoD
  	k ^HISHR.SkillWageInfoI
  	k ^HISHR.SkillWageInfoD
  	k ^HISHR.PositionWageInfoI
  	k ^HISHR.PositionWageInfoD
  	k ^HISHR.KaoQinStandardInfoI
  	k ^HISHR.KaoQinStandardInfoD
  	k ^HISHR.KQStandardDetailInfoI
  	k ^HISHR.KQStandardDetailInfoD
  	k ^HISHR.WageStandardChangeLogI
  	k ^HISHR.WageStandardChangeLogD
  	k ^HISHR.TaxStandardInfoI
  	k ^HISHR.TaxStandardInfoD
  	k ^HISHR.WagesStandardInfoI
  	k ^HISHR.WagesStandardInfoD
  	k ^HISHR.WageImportInfoI
  	k ^HISHR.WageImportInfoD
  	k ^HISHR.WageStatusChangeLogInfoI
  	k ^HISHR.WageStatusChangeLogInfoD
  	k ^HISHR.WageStatusChangeLogDetailInfoI
  	k ^HISHR.WageStatusChangeLogDetailInfoD
  	k ^HISHR.WagesAdjustLogInfoI
  	k ^HISHR.WagesAdjustLogInfoD
  	k ^HISHR.WagesAdjustDetailsLogInfI
  	k ^HISHR.WagesAdjustDetailsLogInfD
  	k ^HISHR.PSDeptWagesInfoI
  	k ^HISHR.PSDeptWagesInfoD
  	k ^HISHR.PSWageImpLogInfoI
  	k ^HISHR.PSWageImpLogInfoD
  	;考勤模块
  	k ^HISHR.WXTimeAttendanceInfoI  
  	k ^HISHR.WXTimeAttendanceInfoD   
  	k ^HISHR.TimeAttendanceInfoI
  	k ^HISHR.TimeAttendanceInfoD
  	k ^HISHR.TimeCycleDeptInfoI
  	k ^HISHR.TimeCycleDeptInfoD
  	k ^HISHR.TimeMonthReportInfoI
  	k ^HISHR.TimeMonthReportInfoD
  	k ^HISHR.TimePSAccountInfoI  
  	k ^HISHR.TimePSAccountInfoD  
  	k ^HISHR.HolidayInfoI
  	k ^HISHR.HolidayInfoD
  	k ^HISHR.VTMIntervalI
  	k ^HISHR.VTMIntervalD
  	k ^HISHR.TimeRemarkInfoI
  	k ^HISHR.TimeRemarkInfoD
  	;合同模块
  	k ^HISHR.LaborContractInfoS
  	k ^HISHR.LaborContractInfoI
  	k ^HISHR.LaborContractInfoD
  	k ^HISHR.LCChangeLogInfoI
  	k ^HISHR.LCChangeLogInfoD
  	; 继续教育
  	k ^HISHR.AbilityTestPSInfoI
  	k ^HISHR.AbilityTestPSInfoD
  	k ^HISHR.ConEduPSInfoI
  	k ^HISHR.ConEduPSInfoD
  	k ^HISHR.ConEduTypeInfoI
  	k ^HISHR.ConEduTypeInfoD
  	k ^HISHR.ConEduPlanInfoI
  	k ^HISHR.ConEduPlanInfoD
  	k ^HISHR.AbilityTestPlanInfoI
  	k ^HISHR.AbilityTestPlanInfoD
  	k ^HISHR.PSTestLogInfoI
  	k ^HISHR.PSTestLogInfoD
  	k ^HISHR.PSTestLogDetailInfoI
  	k ^HISHR.PSTestLogDetailInfoD
  	k ^HISHR.QuestionTypeInfoI
  	k ^HISHR.QuestionTypeInfoD
  	k ^HISHR.QuestionInfoI
  	k ^HISHR.QuestionInfoD
  	k ^HISHR.QuestionDetailMapInfoI
  	k ^HISHR.QuestionDetailMapInfoD
  	k ^HISHR.QuestionDetailInfoI
  	k ^HISHR.QuestionDetailInfoD
  	;招聘
  	k ^HISHR.WantRequireInfoI
  	k ^HISHR.WantRequireInfoD
  	k ^HISHR.WantPersonAttachInfoI
  	k ^HISHR.WantPersonAttachInfoD
  	k ^HISHR.WantPersonInfoI
  	k ^HISHR.WantPersonInfoD
  	k ^HISHR.WantPersonInfoS
  	k ^HISHR.WantProjectInfoI
  	k ^HISHR.WantProjectInfoD
  	k ^HISHR.WantPSAwardInfoI
  	k ^HISHR.WantPSAwardInfoD
  	k ^HISHR.WantPSDisquisitionInfoI
  	k ^HISHR.WantPSDisquisitionInfoD
  	k ^HISHR.WantPSEducateInfoI
  	k ^HISHR.WantPSEducateInfoD
  	k ^HISHR.WantPSExperienceInfoI
  	k ^HISHR.WantPSExperienceInfoD
  	k ^HISHR.WantPSLanguageInfoI
  	k ^HISHR.WantPSLanguageInfoD
  	k ^HISHR.WantPSFamilyInfoI
  	k ^HISHR.WantPSFamilyInfoD
  	k ^HISHR.WantPSTrainInfoI
  	k ^HISHR.WantPSTrainInfoD
  	k ^HISHR.WantApplySkillInfoI
  	k ^HISHR.WantApplySkillInfoD
  	k ^HISHR.WantInfoI
  	k ^HISHR.WantInfoD
  	k ^HISHR.CandidateInfoI
  	k ^HISHR.CandidateInfoD
  	k ^HISHR.OutUserInfoI
  	k ^HISHR.OutUserInfoD
  	k ^HISHR.InterviewTotalScoreInfoI
  	k ^HISHR.InterviewTotalScoreInfoD
  	k ^HISHR.JudgesScoreInfoI
  	k ^HISHR.JudgesScoreInfoD
  	;流程
  	k ^HISHR.WFTemplateI
  	k ^HISHR.WFTemplateD
  	k ^HISHR.WFTemplateDetailsI
  	k ^HISHR.WFTemplateDetailsD
  	;k ^HISHR.WFFormInfoI
  	;k ^HISHR.WFFormInfoD
  	;k ^HISHR.WFFormDetailInfoI
  	;k ^HISHR.WFFormDetailInfoD
  	k ^HISHR.WFRealWorkFlowI
  	k ^HISHR.WFRealWorkFlowD
  	k ^HISHR.WFTimeMiddleInfoI
  	k ^HISHR.WFTimeMiddleInfoD
  	k ^HISHR.WFApplicationI
  	k ^HISHR.WFApplicationD
  	k ^HISHR.TimeLeaveStandardInfoI
  	k ^HISHR.TimeLeaveStandardInfoD
  	;提醒
  	k ^HISHR.MessageAlarmInfoI
  	k ^HISHR.MessageAlarmInfoD
  	&SQL(UPDATE HISHR.MessageAlarmSetInfo SET PersonNum='0')
  	;HCP
  	k ^HISHR.HCPLeaderI
  	k ^HISHR.HCPLeaderD
  	k ^HISHR.HCPLeaderBakD
  	k ^HISHR.HCPOrgHonorD
	k ^HISHR.HCPOrgLocationD
	k ^HISHR.HCPOrgQualifyD
	k ^HISHR.HCPOrgRulesD
	k ^HISHR.HCPStationContextD
	k ^HISHR.HCPStationDutyD
	k ^HISHR.HCPStationDutyStandardD
	k ^HISHR.HCPStationFlowD
	k ^HISHR.HCPStationInstitutionD
	k ^HISHR.HCPWorkGroupBakD
	k ^HISHR.HCPWorkGroupD
  	
  	q "0"
}

/// 上线初始化报表对应的tomcat url	
/// w ##class(dhc.hr.Report.ReportManage).InitReportUrl("http://10.1.5.87:8081/runqianReport/report/jsp/dhccpmrunqianreport.jsp?report=")
ClassMethod InitReportUrl(url As %Text) As %String [ SqlProc ]
{
	s sql="SELECT ID,PageAddress FROM hishr.functioninfo WHERE FuncDesc LIKE '%raq'"
	s result=##Class(%Library.ResultSet).%New()
		d result.Prepare(sql)
		d result.Execute()
		while(result.Next())
		{
			s rid=result.Data("ID")
			s name=result.Data("PageAddress")
			s name=$p(name,"=",2)
			s addr=url_name
			&SQL(update hishr.functioninfo set pageaddress=:addr where id=:rid)
		}
		d result.Close()
	q "1"
}

Storage Default
{
<Data name="SysToolDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.hr.comm.SysToolD</DataLocation>
<DefaultData>SysToolDefaultData</DefaultData>
<IdLocation>^dhc.hr.comm.SysToolD</IdLocation>
<IndexLocation>^dhc.hr.comm.SysToolI</IndexLocation>
<StreamLocation>^dhc.hr.comm.SysToolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
