/// Creator:Guozj
/// Desctiptions:清除护理管理业务数据
/// Date:2017-06-27
Class web.DHCMgNurClearGlobal Extends %RegisteredObject
{

/// Creator:Guozj
/// CreateDate:2017-06-27
/// Description:清除护理管理业务数据
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:
ClassMethod ClearNMGlobal() As %String
{
		k ^DHCMGNUR.MgNurChiefPositionI
		k ^DHCMGNUR.MgNurChiefPositionD
		k ^DHCMGNUR.MgNurContactI
		k ^DHCMGNUR.MgNurContactD
		k ^DHCMGNUR.MgNurDepartLearningI
		k ^DHCMGNUR.MgNurDepartLearningD
		k ^DHCMGNUR.MgNurDepartmentWorkI
		k ^DHCMGNUR.MgNurDepartmentWorkD
		k ^DHCMGNUR.MgNurEduTraI
		k ^DHCMGNUR.MgNurEduTraD
		k ^DHCMGNUR.MgNurExamineI
		k ^DHCMGNUR.MgNurExamineD
		k ^DHCMGNUR.MgNurFamilyRelationI
		k ^DHCMGNUR.MgNurFamilyRelationD
		k ^DHCMGNUR.MgNurHolidayI
		k ^DHCMGNUR.MgNurHolidayD
		k ^DHCMGNUR.MgNurHosBusLearingI
		k ^DHCMGNUR.MgNurHosBusLearingD
		k ^DHCMGNUR.MgNurLeaExpI
		k ^DHCMGNUR.MgNurLeaExpD
		k ^DHCMGNUR.MgNurNurseLevelI
		k ^DHCMGNUR.MgNurNurseLevelD
		k ^DHCMGNUR.MgNurPersonalBookI
		k ^DHCMGNUR.MgNurPersonalBookD
		k ^DHCMGNUR.MgNurPersonalEventI
		k ^DHCMGNUR.MgNurPersonalEventD
		k ^DHCMGNUR.MgNurProTechPositionI
		k ^DHCMGNUR.MgNurProTechPositionD
		k ^DHCMGNUR.MgNurResThesisI
		k ^DHCMGNUR.MgNurResThesisD
		k ^DHCMGNUR.MgNurRewardPunishI
		k ^DHCMGNUR.MgNurRewardPunishD
		k ^DHCMGNUR.MgNurTransDepI
		k ^DHCMGNUR.MgNurTransDepD
		k ^DHCMGNUR.MgNurTransPlanI
		k ^DHCMGNUR.MgNurTransPlanD
		k ^DHCMGNUR.MgPersonsI
		k ^DHCMGNUR.MgPersonsD
		k ^DHCMGNUR.MgCheckWardI
		k ^DHCMGNUR.MgCheckWardD
		k ^Nur.CheckRoomI
		k ^Nur.CheckRoomD
		k ^DHCMGNUR.QuCheckWardI
		k ^DHCMGNUR.QuCheckWardD
		k ^DHCMGNUR.QuCheckWardChildI
		k ^DHCMGNUR.QuCheckWardChildD
		k ^Nur.CheckRoomItemI
		k ^Nur.CheckRoomItemD
		k ^Nur.NurCheckSumLRI
		k ^Nur.NurCheckSumLRD
		k ^Nur.QualCheckRecI
		k ^Nur.QualCheckRecD
		k ^Nur.QualCheckRecChildI
		k ^Nur.QualCheckRecChildD
		k ^DHCMGNUR.MgNurTmpTransDepI
		k ^DHCMGNUR.MgNurTmpTransDepD
		k ^DHCMGNUR.MgNurQuarterExamI
		k ^DHCMGNUR.MgNurQuarterExamD
		k ^DHCMGNUR.MgNurResProManI
		k ^DHCMGNUR.MgNurResProManD
		k ^DHCMGNUR.MgNurResearchAwardI
		k ^DHCMGNUR.MgNurResearchAwardD
		k ^DHCMGNUR.MgNurOperationExamI
		k ^DHCMGNUR.MgNurOperationExamD
		k ^DHCMGNUR.MgNurArgJobI  // 排班主表
		k ^DHCMGNUR.MgNurArgJobD
		k ^DHCMGNUR.MgNurArgJobChildI // 排班人员顺序表
		k ^DHCMGNUR.MgNurArgJobChildD
		k ^DHCMGNUR.MgNurArrangeJobI // 排班记录表
		k ^DHCMGNUR.MgNurArrangeJobD
		k ^DHCMGNUR.MgNurArgJobNurInfoI  // 人员顺序调整记录表
		k ^DHCMGNUR.MgNurArgJobNurInfoD
		k ^DHCMGNUR.MgNurTransPlanI  // 轮转计划表
		k ^DHCMGNUR.MgNurTransPlanD
		q 0
}

/// Creator:Guozj
/// CreateDate:2017-06-27
/// Description:清除护理管理配置
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:
ClassMethod ClearSetSys() As %String
{
	k ^DHCMGNUR.DHCMgNurLarNurForLocD
	k ^DHCMGNUR.DHCMgNurLarNurForLocI
	k ^DHCMGNUR.GSSGRPLAYOUTI
	k ^DHCMGNUR.GSSGRPLAYOUTD
	k ^DHCMGNUR.GSSGRPLAYOUTSUBI
	k ^DHCMGNUR.GSSGRPLAYOUTSUBD
	k ^DHCMGNUR.MGNurFloorI
	k ^DHCMGNUR.MGNurFloorD
	k ^DHCMGNUR.MgNurLargeLocI
	k ^DHCMGNUR.MgNurLargeLocD
	k ^DHCMGNUR.MgNurMaCareUnitI
	k ^DHCMGNUR.MgNurMaCareUnitD
	k ^DHCMGNUR.MgNurPerWardI
	k ^DHCMGNUR.MgNurPerWardD
	k ^DHCMGNUR.MgNurPostI //岗位代码
	k ^DHCMGNUR.MgNurPostD
	k ^DHCMGNUR.MgNurseI
	k ^DHCMGNUR.MgNurseD
	k ^DHCMGNUR.MgNurseSubI
	k ^DHCMGNUR.MgNurseSubD
	k ^DHCMGNUR.MgNurWardI
	k ^DHCMGNUR.MgNurWardD
	k ^DHCMGNUR.QuCheckProjectI
	k ^DHCMGNUR.QuCheckProjectD
	k ^DHCMGNUR.QuCheckProjectChildI
	k ^DHCMGNUR.QuCheckProjectChildD
	k ^DHCMGNUR.MgNurWardPostI // 科室岗位代码
	k ^DHCMGNUR.MgNurWardPostD
	k ^DHCMGNUR.MgNurRosterModelI //排班模板
	k ^DHCMGNUR.MgNurRosterModelD
	k ^DHCMGNUR.MgNurHolidayCodeI  // 休假代码
	k ^DHCMGNUR.MgNurHolidayCodeD
	k ^DHCMGNUR.MgNurBedGroupI  // 床位分组表
	k ^DHCMGNUR.MgNurBedGroupD
	k ^DHCMGNUR.MgNurArrangeJobModelI // 排班模板表
	k ^DHCMGNUR.MgNurArrangeJobModelD
	k ^DHCMGNUR.MgNurQualRelLocI
	k ^DHCMGNUR.MgNurQualRelLocD
	k ^DHCMGNUR.MgNurRosterModelI
	k ^DHCMGNUR.MgNurRosterModelD
	q 0
}

/// Creator:nw
/// CreateDate:2020-04-14
/// Description:清除护理病历配置
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:
ClassMethod ClearNurTempSet()
{
	;1、功能开关配置
	k ^NurMp.NursingRecordsConfigD
	k ^NurMp.NursingRecordsConfigI
	k ^NurMp.ConfigD
	k ^NurMp.ConfigI
 
	;2、科室显示模板配置
	k ^NurMp.TemplatesFilterD
	k ^NurMp.TemplatesFilterI
	k ^NurMp.TemplatesDirectoryD
	k ^NurMp.TemplatesDirectoryI
	k ^NurMp.TemplatesDirectorySubD
	k ^NurMp.TemplatesDirectorySubI
	k ^NurMp.TemplatesTabsD
	k ^NurMp.TemplatesTabsI
	k ^NurMp.TemplateMenuD
	k ^NurMp.TemplateMenuI
	k ^DHCNurDepTemplateSet
	
	;4、科室空白栏标题
	k ^NurMp.DHCNurChangeLableRecD
	k ^NurMp.DHCNurChangeLableRecI
 
	;5、内部数据源配置
	;k ^NurMp.DHCNurEmrBindD
	;k ^NurMp.DHCNurEmrBindI
 
	;6、CA配置
	;k ^NurMp.CA.CertificationD
	;k ^NurMp.CA.CertificationI
	
	;出入液量属性字典配置
	k ^NurMp.InOutVolume.PropertyMapD
	k ^NurMp.InOutVolume.PropertyMapI
	
	
	;7、互联互通共享数据源
	;k ^Nur.DHCNurTerminologySetSubD
    ;k ^Nur.DHCNurTerminologySetSubI
	;k ^Nur.DHCNurTerminologySetD
	;k ^Nur.DHCNurTerminologySetII
	
	;8、ftp配置
	k ^NurMp.RecordsBrowserFtpInfoD
	k ^NurMp.RecordsBrowserFtpInfoI
	
	;9、时间设置
	k ^NurMp.DHCNurEmrConfigD
	k ^NurMp.DHCNurEmrConfigI
	
	;10、高危预报
	k ^NurMp.DHCNurAdverseEventD
	k ^NurMp.DHCNurAdverseEventI
	k ^NurMp.DHCNurAdverseElementD
	k ^NurMp.DHCNurAdverseElementI
	k ^NurMp.DHCNurAdverseAdiutflowD
	k ^NurMp.DHCNurAdverseAdiutflowI
	k ^NurMp.DHCNurAdverseMultAdiutD
	k ^NurMp.DHCNurAdverseMultAdiutI
	k ^NurMp.DHCNurAdversePerSetflowD
	k ^NurMp.DHCNurAdversePerSetflowI
	k ^NurMp.DHCNurAdverseWorkflowD
	k ^NurMp.DHCNurAdverseWorkflowI
		
	q "清除完毕"
}

/// Creator:nw
/// CreateDate:2020-04-14
/// Description:清除护理病历业务数据
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:
ClassMethod ClearTemplateS() As %String
{
		
    //业务数据表
	k ^NurMp.DHCTempMultDataD
	k ^NurMp.DHCTempMultDataI
	
	//续打留痕、图片留痕
	k ^NurMp.DHCNurRecorderPrintinfoD
	k ^NurMp.DHCNurRecorderPrintinfoI
	k ^NurMp.DHCNurRecor481EI
	k ^NurMp.DHCNurRecor481ED
	
    //图片路径
	k ^NurMp.DHCNurHLBLPicD8D
	k ^NurMp.DHCNurHLBLPicD8I
	
	//CA、手写板
	k ^NurMp.CA.DHCNurRecSignLogD
	k ^NurMp.CA.DHCNurRecSignLogI
	k ^NurMp.CA.DHCNurRecSignD
	k ^NurMp.CA.DHCNurRecSignI
	k ^NurMp.CA.DHCNurPatRecSignLogD
	k ^NurMp.CA.DHCNurPatRecSignLogI
	k ^NurMp.CA.DHCNurPatRecSignD
	k ^NurMp.CA.DHCNurPatRecSignI
	
	q "清除完毕"
}

/// Creator:nw
/// CreateDate:2017-06-30
/// Description:清除护理病历配置
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:
ClassMethod ClearNurEmr()
{
	;1、不良事件维护（可以不清除，数据固定）
	k ^User.DHCNurblsjflwhD
	k ^User.DHCNurblsjflwhI
 
	;2、科室显示模板配置（清科室（全院）授权模板、清已筛选的可用模板、清目录、清弹出式列表配置，清子目录）
	;①清科室（全院）授权模板/清已筛选的可用模板
	k ^DHCNurDepModelSet
	;②清目录
	;k ^User.DHCNURMenuD
	;k ^User.DHCNURMenuI
	;③清子目录
	;k ^User.DHCNURMenuSubD
	;k ^User.DHCNURMenuSubI
	;④清弹出式列表配置
	k ^User.DHCNURListLinkD
	k ^User.DHCNURListLinkI
 
	;3、护理病历配置
	;k ^Nur.DHCMGNurseSetD
 
	;4、评估单必填项维护
	k ^Nur.DHCNUREMRQCD
	k ^Nur.DHCNUREMRQCI
 
	;5、界面打印模板关联
	;k ^User.DHCNURMoudelLinkD
	;k ^User.DHCNURMoudelLinkI
 
	;6、科室空白栏标题
	k ^Nur.DHCNurChangeLableRecD
	k ^Nur.DHCNurChangeLableRecI
	
	;7、大科护士长维护
	k ^Nur.DHCNURLocDataD
	k ^Nur.DHCNURLocDataI
	
	;8、大科护士长负责科室维护
	k ^Nur.DHCNURLocDataSubD
	k ^Nur.DHCNURLocDataSubI
	
	q "清除完毕"
}

/// Creator:nw
/// CreateDate:2019-01-29
/// Description:清除护理病历业务数据
/// Table:
/// Input:
/// Output:
/// return: 
/// Others:
ClassMethod ClearTables() As %String
{
	
	//生成图片
	k ^Nur.DHCNurHLBLPictureFilePathI
	k ^Nur.DHCNurHLBLPictureFilePathD
	k ^Nur.DHCNurHLBLPictureFilePathS
    k ^Nur.DHCNurMakePictureHistoryI
	k ^Nur.DHCNurMakePictureHistoryD
	k ^Nur.DHCNurMakePictureHistoryS
    //表头变更
	k ^Nur.DHCNurRecHeadChangeRecI
	k ^Nur.DHCNurRecHeadChangeRecD
	k ^Nur.DHCNurRecHeadChangeRecS
    //出入液量
	k ^Nur.DHCNurPatSumInOutI
	k ^Nur.DHCNurPatSumInOutD
	k ^Nur.DHCNurPatSumInOutS
	k ^Nur.DHCNurPatSumInOutSubI
	k ^Nur.DHCNurPatSumInOutSubD
	k ^Nur.DHCNurPatSumInOutSubS
    //打印
	k ^Nur.DHCNurRecPrintI
	k ^Nur.DHCNurRecPrintD
	k ^Nur.DHCNurRecPrintS
	k ^Nur.DHCNurRecPrintStPosI
	k ^Nur.DHCNurRecPrintStPosD
	k ^Nur.DHCNurRecPrintStPosS
	//不良事件
	k ^Nur.DHCNurSBDataI
	k ^Nur.DHCNurSBDataD
	k ^Nur.DHCNurSBDataS
	k ^Nur.DHCNurSBDataSubI
	k ^Nur.DHCNurSBDataSubD
	k ^Nur.DHCNurSBDataSubS
    //护理记录单
	k ^Nur.DHCNurseRecParentI
	k ^Nur.DHCNurseRecParentD
	k ^Nur.DHCNurseRecParentS
	k ^Nur.DHCNurseRecSubI
	k ^Nur.DHCNurseRecSubD
	k ^Nur.DHCNurseRecSubS
	//护理评估单（包含多次）
	k ^Nur.DHCMoudDataI
	k ^Nur.DHCMoudDataD
	k ^Nur.DHCMoudDataS
	k ^Nur.DHCMoudDataSubI
	k ^Nur.DHCMoudDataSubD
	k ^Nur.DHCMoudDataSubS
	
	
	
	//交班本
	&sql(delete from SQLUser.DHCNurShiftExchage)
	//&sql(delete from SQLUser.DHC_NurSignVerifyLog) // 有ca才用
	//&sql(delete from SQLUser.DHC_NurExecSign)
	q "清除完毕"
}

}
