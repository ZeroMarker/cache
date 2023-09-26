/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗节点内容表V2.0（触发条件类）
/// Table：CT.WDT.CDSS.RuleCondition
Class CT.WDT.CDSS.RuleCondition Extends (%Persistent, User.Abstract)
{

/// 流程图节点
Property NodeDR As CT.WDT.CDSS.RuleNode [ Required ];

/// 条件数据类型（性别、年龄、体质、诊断、主诉、现病史、既往史、个人史、婚育史、体征、检查、检验、药物、手术等）
Property ConditionClass As %String;

/// 规则条件对应字段名称
Property ConditionItem As %String;

/// 运算符
Property ConditionItemCalculate As %String;

/// 规则条件值
Property ConditionItemValue As %String(MAXLEN = 200);

/// 规则条件值单位
Property ConditionItemValUnit As CT.WDT.CDSS.UnitDict;

/// 特殊标签（new/all/orlg）
Property SpecialConfig As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 项目类别（中医/西医）
Property ConditionItemCategory As %String;

Index NodeDRIndex On NodeDR As Exact;

Index ValueIndex On ConditionItemValue As Exact;

Index NodeCondiIndex On (NodeDR, ConditionItemValue As Exact);

/// add by ZWW 2022-08-05
Index NodeItemCateIndex On (NodeDR, ConditionItemValue As Exact, ConditionItemCategory As Exact);

Storage Default
{
<Data name="RuleConditionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NodeDR</Value>
</Value>
<Value name="3">
<Value>ConditionClass</Value>
</Value>
<Value name="4">
<Value>ConditionItem</Value>
</Value>
<Value name="5">
<Value>ConditionItemCalculate</Value>
</Value>
<Value name="6">
<Value>ConditionItemValue</Value>
</Value>
<Value name="7">
<Value>ConditionItemValUnit</Value>
</Value>
<Value name="8">
<Value>SpecialConfig</Value>
</Value>
<Value name="9">
<Value>Remarks</Value>
</Value>
<Value name="10">
<Value>ConditionItemCategory</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleConditionD</DataLocation>
<DefaultData>RuleConditionDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleConditionD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleConditionI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleConditionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
