/// Creator:谷雪萍
/// CreatDate:2022-11-30
/// Description：评估表字段选项表
/// Table：CT.WDT.CDSS.AssBaseFieldItem
Class CT.WDT.CDSS.AssBaseFieldItem Extends (%Persistent, User.Abstract) [ SqlTableName = AssBaseFieldItem ]
{

Relationship ABFIParRef As CT.WDT.CDSS.AssBaseField [ Cardinality = parent, Inverse = ChildItem, SqlFieldName = ABFI_ParRef ];

/// 选项描述
Property ItemValue As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = ABFI_ItemValue ];

/// 选项得分
Property ItemScore As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = ABFI_ItemScore ];

/// 互斥项
Property ItemExclusion As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = ABFI_ItemExclusion ];

/// 跳转项
Property ItemJumpOption As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = ABFI_ItemJumpOption ];

/// 顺序
Property ItemSequence As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = ABFI_ItemSequence ];

/// 规则ID
Property RuleDR As CT.WDT.CDSS.RuleDict [ SqlColumnNumber = 7, SqlFieldName = ABFI_RuleDR ];

/// 备注
Property Remarks As %String(MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = ABFI_Remarks ];

/// 父指针索引
Index ParIndex On ABFIParRef As Exact;

/// 顺序索引
Index SeqIndex On (ABFIParRef As Exact, ItemSequence As Exact);

Storage Default
{
<Data name="AssBaseFieldItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemValue</Value>
</Value>
<Value name="3">
<Value>ItemScore</Value>
</Value>
<Value name="4">
<Value>ItemExclusion</Value>
</Value>
<Value name="5">
<Value>ItemJumpOption</Value>
</Value>
<Value name="6">
<Value>ItemSequence</Value>
</Value>
<Value name="7">
<Value>RuleDR</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildItem")</DataLocation>
<DefaultData>AssBaseFieldItemDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssBaseFieldC("ChildItem")</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssBaseFieldItemI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssBaseFieldItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
