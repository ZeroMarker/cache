/// Description：治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
/// Table：CT.WDT.CDSS.RuleDetail
Class web.CDSSEntity.CMKB.RuleDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.RuleDetail";

/// DetailRowId
Property DetailRowId As %String;

/// 流程图节点
Property NodeDR As %String;

/// 顺序
Property Sequence As %String;

/// 药品名/手术名CT.WDT.CDSS.DrugDict或者CT.WDT.CDSS.OperationDict
Property DrugDR As %String;

/// 给药途径/手术方式CT.WDT.CDSS.UsageDict
Property DrugUse As %String;

/// 最小剂量
Property DosageMIN As %String;

/// 最小剂量单位
Property DosageMINUnit As %String;

/// 最大剂量
Property DosageMAX As %String;

/// 最大剂量单位
Property DosageMAXUnit As %String;

/// 频率
Property Frequency As %String;

/// 备注
Property Remarks As %String;

/// 上级节点
Property LastLevel As %String;

}
