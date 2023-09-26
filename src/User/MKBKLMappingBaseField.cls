/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：知识点映射字段表
/// Table：User.MKBKLMappingBaseField
Class User.MKBKLMappingBaseField Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_KLMappingBaseField ]
{

Relationship ParRef As User.MKBKLMappingBase [ Cardinality = parent, Inverse = ChildField ];

/// 代码
Property MKBKMBFCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBKMBF_Code ];

/// 展示名
Property MKBKMBFDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBKMBF_Desc ];

/// 字段类型
Property MKBKMBFType As %String(DISPLAYLIST = ",文本,单选框,复选框,下拉框,多行文本框,知识点1,知识点2,引用术语", VALUELIST = ",TX,R,CB,C,TA,K1,K2,TP") [ SqlColumnNumber = 4, SqlFieldName = MKBKMBF_Type ];

/// 字段配置项
Property MKBKMBFConfig As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBKMBF_Config ];

/// 顺序
Property MKBKMBFSequence As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBKMBF_Sequence ];

/// 代码索引
Index CodeIndex On (ParRef As Exact, MKBKMBFCode);

/// 描述索引
Index DescIndex On (ParRef As Exact, MKBKMBFDesc);

/// 顺序索引
Index SeqIndex On (ParRef As Exact, MKBKMBFSequence As Exact);

/// 父指针索引
Index ParIndex On ParRef As Exact;

Storage Default
{
<Data name="MKBKLMappingBaseFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBKMBFCode</Value>
</Value>
<Value name="3">
<Value>MKBKMBFDesc</Value>
</Value>
<Value name="4">
<Value>MKBKMBFType</Value>
</Value>
<Value name="5">
<Value>MKBKMBFConfig</Value>
</Value>
<Value name="6">
<Value>MKBKMBFSequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildField")</DataLocation>
<DefaultData>MKBKLMappingBaseFieldDefaultData</DefaultData>
<IdLocation>^User.MKBKLMappingBaseC("ChildField")</IdLocation>
<IndexLocation>^User.MKBKLMappingBaseFieldI</IndexLocation>
<StreamLocation>^User.MKBKLMappingBaseFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
