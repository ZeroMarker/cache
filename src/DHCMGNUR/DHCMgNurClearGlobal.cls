/// 标库
/// ClassDescription:清除表Global
/// Date：2015-03-09
Class DHCMGNUR.DHCMgNurClearGlobal Extends %RegisteredObject
{

ClassMethod ClearGlobal()
{
	k ^DHCMGNUR.CommDictionaryI
	k ^DHCMGNUR.CommDictionaryD
	k ^DHCMGNUR.CommDictionarySubI
	k ^DHCMGNUR.DHCMgNurLarNurForLocD
	k ^DHCMGNUR.GSSGRPLAYOUTI
	k ^DHCMGNUR.GSSGRPLAYOUTD
	k ^DHCMGNUR.GSSGRPLAYOUTSUBI
	k ^DHCMGNUR.CommDictionarySubD
	k ^DHCMGNUR.DHCMgNurLarNurForLocI
	k ^DHCMGNUR.GSSGRPLAYOUTSUBD
	k ^DHCMGNUR.MenuSystemI
	k ^DHCMGNUR.MenuSystemD
	k ^DHCMGNUR.MenuSystemSubI
	k ^DHCMGNUR.MenuSystemSubD
	k ^DHCMGNUR.MgCheckWardI
	k ^DHCMGNUR.MgCheckWardD
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
	k ^DHCMGNUR.MGNurFloorI
	k ^DHCMGNUR.MGNurFloorD
	k ^DHCMGNUR.MgNurHolidayI
	k ^DHCMGNUR.MgNurHolidayD
	k ^DHCMGNUR.MgNurHosBusLearingI
	k ^DHCMGNUR.MgNurHosBusLearingD
	k ^DHCMGNUR.MgNurLargeLocI
	k ^DHCMGNUR.MgNurLargeLocD
	k ^DHCMGNUR.MgNurLeaExpI
	k ^DHCMGNUR.MgNurLeaExpD
	k ^DHCMGNUR.MgNurMaCareUnitI
	k ^DHCMGNUR.MgNurMaCareUnitD
	k ^DHCMGNUR.MgNurNurseLevelI
	k ^DHCMGNUR.MgNurNurseLevelD
	k ^DHCMGNUR.MgNurPersonalBookI
	k ^DHCMGNUR.MgNurPersonalBookD
	k ^DHCMGNUR.MgNurPersonalEventI
	k ^DHCMGNUR.MgNurPersonalEventD
	k ^DHCMGNUR.MgNurPerWardI
	k ^DHCMGNUR.MgNurPerWardD
	k ^DHCMGNUR.MgNurPostI
	k ^DHCMGNUR.MgNurPostD
	k ^DHCMGNUR.MgNurProTechPositionI
	k ^DHCMGNUR.MgNurProTechPositionD
	k ^DHCMGNUR.MgNurQualRelLocI
	k ^DHCMGNUR.MgNurQualRelLocD
	k ^DHCMGNUR.MgNurResThesisI
	k ^DHCMGNUR.MgNurResThesisD
	k ^DHCMGNUR.MgNurRewardPunishI
	k ^DHCMGNUR.MgNurRewardPunishD
	k ^DHCMGNUR.MgNurRosterModelI
	k ^DHCMGNUR.MgNurRosterModelD
	k ^DHCMGNUR.MgNurseI
	k ^DHCMGNUR.MgNurseD
	k ^DHCMGNUR.MgNurseSubI
	k ^DHCMGNUR.MgNurseSubD
	k ^DHCMGNUR.MgNurTransDepI
	k ^DHCMGNUR.MgNurTransDepD
	k ^DHCMGNUR.MgNurTransPlanI
	k ^DHCMGNUR.MgNurTransPlanD
	k ^DHCMGNUR.MgNurWardI
	k ^DHCMGNUR.MgNurWardD
	k ^DHCMGNUR.MgPersonsI
	k ^DHCMGNUR.MgPersonsD
	k ^DHCMGNUR.MouldI
	k ^DHCMGNUR.MouldD
	k ^DHCMGNUR.QualCodeItemI
	k ^DHCMGNUR.QualCodeItemD
	k ^DHCMGNUR.QualCodeItemSubI
	k ^DHCMGNUR.QualCodeItemSubD
	k ^DHCMGNUR.QuCheckProjectI
	k ^DHCMGNUR.QuCheckProjectD
	k ^DHCMGNUR.QuCheckProjectChildI
	k ^DHCMGNUR.QuCheckProjectChildD
	k ^DHCMGNUR.QuCheckWardI
	k ^DHCMGNUR.QuCheckWardD
	k ^DHCMGNUR.QuCheckWardChildI
	k ^DHCMGNUR.QuCheckWardChildD
	k ^Nur.CheckRoomI
	k ^Nur.CheckRoomD
	k ^Nur.CheckRoomItemI
	k ^Nur.CheckRoomItemD
	k ^Nur.NurCheckSumLRI
	k ^Nur.NurCheckSumLRD
	k ^Nur.QualCheckRecI
	k ^Nur.QualCheckRecD
	k ^Nur.QualCheckRecChildI
	k ^Nur.QualCheckRecChildD
	k ^DHCMGNUR.MgChildPagEleC
	k ^DHCMGNUR.MgChildPagEleI
	k ^DHCMGNUR.MgChildPagEleD
	k ^DHCMGNUR.MgChildPagEleSubI
	k ^DHCMGNUR.MgNurSecGrpI
	k ^DHCMGNUR.MgNurSecGrpD
	k ^DHCMGNUR.MgNurSecLayOutC
	k ^DHCMGNUR.MgNurSecLayOutD
	k ^DHCMGNUR.MgNurSecLayOutI
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
	k ^DHCMGNUR.MgNurPostI //岗位代码
	k ^DHCMGNUR.MgNurPostD
	k ^DHCMGNUR.MgNurWardPostI // 科室岗位代码
	k ^DHCMGNUR.MgNurWardPostD
	k ^DHCMGNUR.MgNurArgJobI  // 排班主表
	k ^DHCMGNUR.MgNurArgJobD
	k ^DHCMGNUR.MgNurArgJobChildI // 排班人员顺序表
	k ^DHCMGNUR.MgNurArgJobChildD
	k ^DHCMGNUR.MgNurArrangeJobI // 排班记录表
	k ^DHCMGNUR.MgNurArrangeJobD
	k ^DHCMGNUR.MgNurArgJobNurInfoI  // 人员顺序调整记录表
	k ^DHCMGNUR.MgNurArgJobNurInfoD
	k ^DHCMGNUR.MgNurArrangeJobModelI // 排班模板表
	k ^DHCMGNUR.MgNurArrangeJobModelD
	k ^DHCMGNUR.MgNurBedGroupI  // 床位分组表
	k ^DHCMGNUR.MgNurBedGroupD
	k ^DHCMGNUR.MgNurHolidayCodeI  // 休假代码
	k ^DHCMGNUR.MgNurHolidayCodeD
	k ^DHCMGNUR.MgNurTransPlanI  // 轮转计划表
	k ^DHCMGNUR.MgNurTransPlanD
	k ^DHCMGNUR.MgNurRosterModelI //排班模板
	k ^DHCMGNUR.MgNurRosterModelD
	q 0
}

/// 清除排班数据
ClassMethod ClearArrange() As %String
{
	k ^DHCMGNUR.MgNurPostI //岗位代码
	k ^DHCMGNUR.MgNurPostD
	k ^DHCMGNUR.MgNurWardPostI // 科室岗位代码
	k ^DHCMGNUR.MgNurWardPostD
	k ^DHCMGNUR.MgNurArgJobI  // 排班主表
	k ^DHCMGNUR.MgNurArgJobD
	k ^DHCMGNUR.MgNurArgJobChildI // 排班人员顺序表
	k ^DHCMGNUR.MgNurArgJobChildD
	k ^DHCMGNUR.MgNurArrangeJobI // 排班记录表
	k ^DHCMGNUR.MgNurArrangeJobD
	k ^DHCMGNUR.MgNurArgJobNurInfoI  // 人员顺序调整记录表
	k ^DHCMGNUR.MgNurArgJobNurInfoD
	k ^DHCMGNUR.MgNurArrangeJobModelI // 排班模板表
	k ^DHCMGNUR.MgNurArrangeJobModelD
	k ^DHCMGNUR.MgNurBedGroupI  // 床位分组表
	k ^DHCMGNUR.MgNurBedGroupD
	k ^DHCMGNUR.MgNurHolidayCodeI  // 休假代码
	k ^DHCMGNUR.MgNurHolidayCodeD
	k ^DHCMGNUR.MgNurTransPlanI  // 轮转计划表
	k ^DHCMGNUR.MgNurTransPlanD
	k ^DHCMGNUR.MgNurRosterModelI //排班模板
	k ^DHCMGNUR.MgNurRosterModelD
}

}
