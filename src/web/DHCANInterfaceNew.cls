Class web.DHCANInterfaceNew Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 手术记录序号
Property OperationRecordNo As %String(TRUNCATE = 1);

/// 是否有手术并发症
Property IsComplication As %String(TRUNCATE = 1);

/// 手术并发症编码
Property ComplicationCode As %String(TRUNCATE = 1);

/// 手术并发症名称
Property ComplicationName As %String(TRUNCATE = 1);

/// 手术记录
Property OperationRecord As %String(TRUNCATE = 1);

/// 手术记录医师编码
Property RecordDoctorCode As %String(TRUNCATE = 1);

/// 手术记录医师名字
Property RecordDoctorName As %String(TRUNCATE = 1);

/// 登记号
Property RegNo As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// Property OPAAdmDr As %String(TRUNCATE = 1);
/// 病案号
Property MedCareNo As %String(TRUNCATE = 1);

/// 病人姓名
Property PatName As %String(TRUNCATE = 1);

/// 病人出生日期
Property Birthday As %String(TRUNCATE = 1);

/// 病人年龄
Property Age As %String(TRUNCATE = 1);

/// 病人性别
Property Sex As %String(TRUNCATE = 1);

/// 病人类型（O门诊，E急诊，I住院）
Property PaAdmType As %String(TRUNCATE = 1);

/// 病人病区
Property Ward As %String(TRUNCATE = 1);

/// 病人床位
Property Bed As %String(TRUNCATE = 1);

/// 病人所在房间
Property BedRoom As %String(TRUNCATE = 1);

/// 病人所在科室Id
Property OPAPatDeptDr As %String(TRUNCATE = 1);

/// 病人所在科室描述
Property PatLoc As %String(TRUNCATE = 1);

/// 乙肝
Property OPAPATestHBsAg As %String(TRUNCATE = 1);

/// 丙肝
Property OPAPATestHCVAb As %String(TRUNCATE = 1);

/// HIV
Property OPAPATestHivAb As %String(TRUNCATE = 1);

/// 梅毒
Property OPAPATestTPAb As %String(TRUNCATE = 1);

/// 其它
Property OPAPATestOther As %String(TRUNCATE = 1);

/// 特殊感染
Property OPALabResult As %String(TRUNCATE = 1);

/// 手术排班表Id
Property OpaId As %String(TRUNCATE = 1);

/// 麻醉表Id
Property AnaesthesiaID As %String(TRUNCATE = 1);

/// 手术状态 A申请，R安排，D取消，I术中，L离室，P恢复室，F完成
Property OPAStatus As %String(TRUNCATE = 1);

/// 状态代码
Property StatCode As %String(TRUNCATE = 1);

/// 手术申请医生
Property OPAAppLocDr As %String(TRUNCATE = 1);

/// 手术申请日期
Property OPAAppDate As %String(TRUNCATE = 1);

/// 手术安排用户
Property OPAArrangeUser As %String(TRUNCATE = 1);

/// 手术安排日期
Property OPAArrangeDate As %String(TRUNCATE = 1);

/// 手术安排时间
Property OPAArrangeTime As %String(TRUNCATE = 1);

/// 手术开始日期时间（术前时为计划值）
Property OPAStartDateTime As %String(TRUNCATE = 1);

/// 手术结束日期时间
Property OPAEndDateTime As %String(TRUNCATE = 1);

/// 计划手术开始日期时间
Property PlanOPAStartDateTime As %String(TRUNCATE = 1);

/// 计划手术结束日期时间
Property PlanOPAEndDateTime As %String(TRUNCATE = 1);

/// 手术日期
Property OpDate As %String(TRUNCATE = 1);

/// 手术时间
Property OpTime As %String(TRUNCATE = 1);

/// 入室时间
Property InRoomTime As %String(TRUNCATE = 1);

/// 离室时间
Property LeaveRoomTime As %String(TRUNCATE = 1);

/// 麻醉开始
Property ANAStartTime As %String(TRUNCATE = 1);

/// 麻醉结束
Property ANAEndTime As %String(TRUNCATE = 1);

/// 手术医生开始手术日期
Property SurgeonStartDate As %String(TRUNCATE = 1);

/// 手术医生开始手术时间
Property SurgeonStartTime As %String(TRUNCATE = 1);

/// 手术医生结束时间
Property SurgeonEndTime As %String(TRUNCATE = 1);

/// 手术结束
/// Property OPAFinishTime As %String(TRUNCATE = 1);
/// 入恢复室时间
Property OPAPACUInTime As %String(TRUNCATE = 1);

/// 离开恢复室时间
Property OPAPACUOutTime As %String(TRUNCATE = 1);

/// 手术类型（择期，急诊）
Property ANASourceTypeDesc As %String(TRUNCATE = 1);

/// 手术码表Id
Property OperId As %String(TRUNCATE = 1);

/// 麻醉方法
Property AnaMethod As %String(TRUNCATE = 1);

/// 麻醉方法ID
Property AnaMethodId As %String(TRUNCATE = 1);

/// 手术等级
Property AnaLevel As %String(TRUNCATE = 1);

/// 手术等级ID
Property AnaLevelId As %String(TRUNCATE = 1);

/// ASA分级
Property ASA As %String(TRUNCATE = 1);

/// 手术名称
Property OpName As %String(TRUNCATE = 1);

/// 切口类型Id
Property ANAOPBladeTypeId As %String(TRUNCATE = 1);

/// 切口类型
Property ANAOPBladeType As %String(TRUNCATE = 1);

/// 手术部位
Property BodsDesc As %String(TRUNCATE = 1);

/// 术前诊断ID
Property ANAOPPreopDiagDR As %String(TRUNCATE = 1);

/// 术前诊断
Property ANAOPPreopDiag As %String(TRUNCATE = 1);

/// Property Prediag As %String(TRUNCATE = 1);
/// 手术科室Id
Property OPAOperLocDr As %String(TRUNCATE = 1);

/// 手术间Id
Property OPAOpRoomDr As %String(TRUNCATE = 1);

/// 手术间
Property OPAOpRoom As %String(TRUNCATE = 1);

/// 手术台次
Property OPASeq As %String(TRUNCATE = 1);

/// 手术医师Id
Property ANAOPSurgeonDR As %String(TRUNCATE = 1);

/// Property OpDocCtcpId As %String(TRUNCATE = 1);
/// 手术医师
Property ANAOPSurgeon As %String(TRUNCATE = 1);

/// Property OpDoctor As %String(TRUNCATE = 1);
/// 一助Id
Property AssistantFirstCtcpId As %String(TRUNCATE = 1);

/// 一助
Property AssistantFirstCtcp As %String(TRUNCATE = 1);

/// 二助Id
Property AssistantSecondCtcpId As %String(TRUNCATE = 1);

/// 二助
Property AssistantSecondCtcp As %String(TRUNCATE = 1);

/// 麻醉医生Id
Property AnaDocCtcpId As %String(TRUNCATE = 1);

/// 麻醉医生
Property AnaDoctor As %String(TRUNCATE = 1);

/// 器械护士一Id
Property ScrubNurFirstCtcpId As %String(TRUNCATE = 1);

/// Property OPSCNScrubNurseDR As %String(TRUNCATE = 1);
/// 器械护士一
Property ScrubNurFirstCtcp As %String(TRUNCATE = 1);

/// 器械护士二Id
Property ScrubNurSecondCtcpId As %String(TRUNCATE = 1);

/// 器械护士二
Property ScrubNurSecondCtcp As %String(TRUNCATE = 1);

/// 器械护士三Id
Property ScrubNurThirdCtcpId As %String(TRUNCATE = 1);

/// 器械护士三
Property ScrubNurThirdCtcp As %String(TRUNCATE = 1);

/// 巡回护士一Id
Property CirculNurFirstCtcpId As %String(TRUNCATE = 1);

/// Property ANAOPCirculNurseDR As %String(TRUNCATE = 1);
/// 巡回护士一
Property CirculNurFirstCtcp As %String(TRUNCATE = 1);

/// 巡回护士二Id
Property CirculNurSecondCtcpId As %String(TRUNCATE = 1);

/// 巡回护士二
Property CirculNurSecondCtcp As %String(TRUNCATE = 1);

/// 巡回护士三Id
Property CirculNurThirdCtcpId As %String(TRUNCATE = 1);

/// 巡回护士三
Property CirculNurThirdCtcp As %String(TRUNCATE = 1);

/// 麻醉开始日期
Property ANAStartDate As %String(TRUNCATE = 1);

/// 麻醉结束日期
Property ANAEndDate As %String(TRUNCATE = 1);

/// 手术医生结束日期
Property SurgeonEndDate As %String(TRUNCATE = 1);

/// 手术体位
Property OperPosition As %String(TRUNCATE = 1);

/// 手术明细列表
Property OperationDetail As list Of web.DHCANOperationInfo;

}
