/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：识别词节点内容表V2.0（触发条件类）
/// Table：CT.WDT.CDSS.WordsCondition
Class CT.WDT.CDSS.WordsCondition Extends (%Persistent, User.Abstract)
{

/// 流程图节点
Property NodeDR As CT.WDT.CDSS.WordsNode [ Required ];

/// 识别词项目（识别词项目-一级节点）
Property WordsItemDR As CT.WDT.CDSS.WordsItem;

/// 父级
Property ParentDR As CT.WDT.CDSS.WordsCondition;

/// 顺序
Property Sequence As %Integer;

/// 条件类型（年龄/性别/诊断/手术/检查/检验/护理/输血/症状/体征/等）
Property ConditionClass As %String;

/// 规则条件对应字段名称
Property ConditionItem As %String;

/// 运算符
Property ConditionItemCalculate As %String;

/// 规则条件值
Property ConditionItemValue As %String(MAXLEN = "");

/// 规则条件值单位
Property ConditionItemValUnit As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index NodeDRIndex On NodeDR As Exact;

Index ParentIndex On ParentDR;

Index NodeParentIndex On (NodeDR, ParentDR);

Index ItemDRConditionIndex On (WordsItemDR, ConditionItemValue As Exact);

Index ItemValueIndex On ConditionItemValue As Exact;

Index NodeItemIndex On (NodeDR, ConditionItemValue As Exact);

Index NodeItemParentIndex On (NodeDR, ConditionItemValue As Exact, ParentDR);

Storage Default
{
<Data name="WordsConditionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NodeDR</Value>
</Value>
<Value name="3">
<Value>WordsItemDR</Value>
</Value>
<Value name="4">
<Value>ParentDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>ConditionClass</Value>
</Value>
<Value name="7">
<Value>ConditionItem</Value>
</Value>
<Value name="8">
<Value>ConditionItemCalculate</Value>
</Value>
<Value name="9">
<Value>ConditionItemValue</Value>
</Value>
<Value name="10">
<Value>ConditionItemValUnit</Value>
</Value>
<Value name="11">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.WordsConditionD</DataLocation>
<DefaultData>WordsConditionDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.WordsConditionD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.WordsConditionI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.WordsConditionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
