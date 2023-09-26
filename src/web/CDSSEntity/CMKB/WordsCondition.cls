/// Description：识别词节点内容表（触发条件类）
/// Table：CT.WDT.CDSS.WordsCondition
Class web.CDSSEntity.CMKB.WordsCondition Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.WordsCondition";

/// ConditionRowId
Property ConditionRowId As %String;

/// 流程图节点
Property NodeDR As %String;

/// 识别词项目（识别词项目-一级节点）
Property WordsItemDR As %String;

/// 父级
Property ParentDR As %String;

/// 顺序
Property Sequence As %String;

/// 条件数据类型（性别、年龄、体质、诊断、主诉、现病史、既往史、个人史、婚育史、体征、检查、检验、药物、手术等）
Property ConditionClass As %String;

/// 规则条件对应字段名称
Property ConditionItem As %String;

/// 运算符
Property ConditionItemCalculate As %String;

/// 规则条件值
Property ConditionItemValue As %String;

/// 规则条件值单位
Property ConditionItemValUnit As %String;

/// 备注
Property Remarks As %String;

}
