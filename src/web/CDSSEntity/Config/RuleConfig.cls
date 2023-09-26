/// 名称：特殊诊疗规则配置V2.0
/// 描述：实体类
/// 编写者：基础数据平台组_Xuwenhu
/// 编写日期：2022-01-22
Class web.CDSSEntity.Config.RuleConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.Config.RuleConfig";

Property RowId As %String;

/// 合理性规则id
Property RationalityDR As %String;

/// 预警等级（阻断开立/弹窗提醒/辅助预警）
Property AlertLevel As %String;

/// 规则id
Property RuleDr As %String;

/// 流程图顺序号
Property FlowChartNum As %String;

/// 预警规则类型
Property RuleType As %String;

/// 备注
Property Remarks As %String;

}
