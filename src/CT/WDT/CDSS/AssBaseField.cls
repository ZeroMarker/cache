/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：知识点映射字段表
/// Table：CT.WDT.CDSS.AssBaseField
Class CT.WDT.CDSS.AssBaseField Extends (%Persistent, User.Abstract) [ SqlTableName = AssBaseField ]
{

Relationship MKBABFParRef As CT.WDT.CDSS.AssBase [ Cardinality = parent, Inverse = ChildField, Required, SqlFieldName = MKBABF_ParRef ];

Relationship ChildItem As CT.WDT.CDSS.AssBaseFieldItem [ Cardinality = children, Inverse = ABFIParRef ];

/// 代码
Property MKBABFCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBABF_Code ];

/// 展示名
Property MKBABFDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBABF_Desc ];

/// 字段类型
Property MKBABFType As %String(DISPLAYLIST = ",文本,单选框,复选框,下拉框,多行文本框,多次评分,纯文本", VALUELIST = ",TX,R,CB,C,TA,M,P") [ SqlColumnNumber = 4, SqlFieldName = MKBABF_Type ];

/// 字段配置项
Property MKBABFConfig As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBABF_Config ];

/// 顺序
Property MKBABFSequence As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBABF_Sequence ];

/// 互斥项
Property MKBABFExclusion As %String [ SqlColumnNumber = 7, SqlFieldName = MKBABF_Exclusion ];

/// 跳转项
Property MKBABFJumpOption As %String [ SqlColumnNumber = 8, SqlFieldName = MKBABF_JumpOption ];

/// 字段关联规则
Property MKBABFJoinRule As %String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = MKBABF_JoinRule ];

/// 关联识别词
Property MKBABFIdentifyWords As %String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = MKBABF_IdentifyWords ];

/// 代码索引
Index CodeIndex On (MKBABFParRef As Exact, MKBABFCode);

/// 描述索引
Index DescIndex On (MKBABFParRef As Exact, MKBABFDesc);

/// 顺序索引
Index SeqIndex On (MKBABFParRef As Exact, MKBABFSequence As Exact);

/// 父指针索引
Index ParIndex On MKBABFParRef As Exact;

Storage Default
{
<Data name="AssBaseFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBABFCode</Value>
</Value>
<Value name="3">
<Value>MKBABFDesc</Value>
</Value>
<Value name="4">
<Value>MKBABFType</Value>
</Value>
<Value name="5">
<Value>MKBABFConfig</Value>
</Value>
<Value name="6">
<Value>MKBABFSequence</Value>
</Value>
<Value name="7">
<Value>MKBABFExclusion</Value>
</Value>
<Value name="8">
<Value>MKBABFJumpOption</Value>
</Value>
<Value name="9">
<Value>MKBABFJoinRule</Value>
</Value>
<Value name="10">
<Value>MKBABFIdentifyWords</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildField")</DataLocation>
<DefaultData>AssBaseFieldDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssBaseC("ChildField")</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssBaseFieldI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssBaseFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
