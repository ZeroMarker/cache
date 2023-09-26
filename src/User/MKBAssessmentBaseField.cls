/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：知识点映射字段表
/// Table：User.MKBKLMappingBaseField
Class User.MKBAssessmentBaseField Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_AssessmentBaseField ]
{

Relationship MKBABFParRef As User.MKBAssessmentBase [ Cardinality = parent, Inverse = ChildField, Required, SqlFieldName = MKBABF_ParRef ];

/// 代码
Property MKBABFCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBABF_Code ];

/// 展示名
Property MKBABFDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBABF_Desc ];

/// 字段类型
Property MKBABFType As %String(DISPLAYLIST = ",文本,单选框,复选框,下拉框,多行文本框", VALUELIST = ",TX,R,CB,C,TA") [ SqlColumnNumber = 4, SqlFieldName = MKBABF_Type ];

/// 字段配置项
Property MKBABFConfig As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBABF_Config ];

/// 顺序
Property MKBABFSequence As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBABF_Sequence ];

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
<Data name="MKBAssessmentBaseFieldDefaultData">
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
</Data>
<DataLocation>{%%PARENT}("ChildField")</DataLocation>
<DefaultData>MKBAssessmentBaseFieldDefaultData</DefaultData>
<IdLocation>^User.MKBAssessmentBaseC("ChildField")</IdLocation>
<IndexLocation>^User.MKBAssessmentBaseFieldI</IndexLocation>
<StreamLocation>^User.MKBAssessmentBaseFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
