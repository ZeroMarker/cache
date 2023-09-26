/// Description： 结构化数据子表
/// Creator：李得原
/// Date： 2018-11-22
Class User.MKBStructuredDataResult Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_StructuredDataResult ]
{

/// 子表指向父表字段
Relationship MKBSDStructData As User.MKBStructuredData [ Cardinality = parent, Inverse = MKBSDStructResult ];

/// 结构化结果ID
Property MKBSDStructResultID As %String(MAXLEN = "") [ SqlFieldName = MKBSD_StructResultID ];

/// 结构化结果描述
Property MKBSDStructResult As %String(MAXLEN = "") [ SqlFieldName = MKBSD_StructResult ];

/// 诊断模板ID 
Property MKBSDTermDR As User.MKBTerm [ SqlFieldName = MKBSD_TermDR ];

/// 补充诊断
Property MKBSDSupplement As %String [ SqlFieldName = MKBSD_Supplement ];

/// 顺序
Property MKBSDSequence As %String [ SqlFieldName = MKBSD_Sequence ];

Index MKBSDStructDataIndex On MKBSDStructData As Exact;

Index TermIndex On MKBSDTermDR As Exact;

Index SortIndex On (MKBSDTermDR As Exact, MKBSDStructResultID As Exact);

Index ResultIndex On MKBSDStructResultID As Exact;

Index SeqIndex On (MKBSDStructData As Exact, MKBSDSequence As Exact);

Storage Default
{
<Data name="MKBStructuredDataResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBSDStructResultID</Value>
</Value>
<Value name="3">
<Value>MKBSDStructResult</Value>
</Value>
<Value name="4">
<Value>MKBSDTermDR</Value>
</Value>
<Value name="5">
<Value>MKBSDSupplement</Value>
</Value>
<Value name="6">
<Value>MKBSDSequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MKBSDStructResult")</DataLocation>
<DefaultData>MKBStructuredDataResultDefaultData</DefaultData>
<IdLocation>^User.MKBStructuredDataC("MKBSDStructResult")</IdLocation>
<IndexLocation>^User.MKBStructuredDataResultI</IndexLocation>
<StreamLocation>^User.MKBStructuredDataResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
