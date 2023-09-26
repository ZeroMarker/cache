/// 常量
Class CIS.AN.BL.Constant Extends %RegisteredObject
{

/// 入手术室
Parameter AreaIn As %String = "AreaIn";

/// 离手术室
Parameter AreaOut As %String = "AreaOut";

/// 完成状态
Parameter Finish As %String = "Finish";

/// 腕带扫描顺序
Parameter ScanSeq As %String = "SurgicalProcedureStatusSeq";

/// 启用医生关联手术
Parameter EnableSurgeonOperation As %String = "EnableSurgeonOperation";

/// 启用科室关联手术
Parameter EnableDeptOperation As %String = "EnableDeptOperation";

/// 启用职称关联手术
Parameter EnableCPTypeOperation As %String = "EnableCPTypeOperation";

/// 分号
Parameter Semicolon As %String = ";";

/// 未排手术状态配置代码
Parameter NeedArrangeOperStatus As %String = "NeedArrangeOperStatus";

/// 已排班的手术状态
Parameter ArrangedStatusList As %String = "Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut";

/// 排班时需更改状态未安排的手术状态
Parameter CanArrangeStatusList As %String = "Application^Audit^Receive";

/// 可发布的手术状态
Parameter CanSubmitStatusList As %String = "Receive^Arrange";

/// 患者交接模块代码
Parameter PatTransRecord As %String = "AN_OPS_002";

/// 手术风险评估模块代码
Parameter OperRiskAssessment As %String = "AN_OPS_003";

/// 手术安全核查模块代码
Parameter OperSafetyCheck As %String = "AN_OPS_004";

/// 手术清点模块代码
Parameter OperCount As %String = "AN_OPS_005";

/// 术前麻醉访视模块代码
Parameter PrevAnaVisit As %String = "AN_ANS_004";

/// 术后麻醉访视模块代码
Parameter PostAnaVisit As %String = "AN_ANS_012";

/// 审核手术配置代码
Parameter NeedAuditOperation As %String = "NeedAuditOperation";

}
