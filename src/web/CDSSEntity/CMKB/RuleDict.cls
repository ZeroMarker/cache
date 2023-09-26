/// Description：诊疗规则表
/// Table：CT.WDT.CDSS.RuleDict
Class web.CDSSEntity.CMKB.RuleDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.RuleDict";

/// RuleRowId
Property RuleRowId As %String;

/// 规则编码
Property RuleCode As %String;

/// 规则概述
Property RuleDesc As %String;

/// 科室
Property RuleLoc As %String;

/// 来源
Property RuleSource As %String;

/// 规则流程类型（辅助诊疗规则/诊断预警规则/检验检查预警规则/手术并发症规则/输血合理性规则/手术合理性规则/过敏合理性规则/护理合理性规则）
Property RuleType As %String;

/// 批次号
Property BatchNum As %String;

/// 规则状态（0新增、1审核、2启用、3停用）
Property RuleStatus As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 审核人员
Property AuditUser As %String;

/// 审核时间
Property AuditDate As %String;

/// 备注
Property Remarks As %String;

/// 规则来源（dhcc或者医院名称）
Property RuleProvision As %String;

}
