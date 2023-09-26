/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：评分表（评分型）注册表
/// Table：User.MKBAssessmentBase
Class User.MKBAssessmentBase Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_AssessmentBase ]
{

Relationship ChildField As User.MKBAssessmentBaseField [ Cardinality = children, Inverse = MKBABFParRef ];

Relationship ChildRules As User.MKBAssessmentScoringRules [ Cardinality = children, Inverse = MKBASRParRef ];

/// 代码
Property MKBABCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBAB_Code ];

/// 标题
Property MKBABDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBAB_Desc ];

/// 备注
Property MKBABNote As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBAB_Note ];

/// 代码索引
Index CodeIndex On MKBABCode [ Unique ];

/// 标题索引
Index DescIndex On MKBABDesc [ Unique ];

Storage Default
{
<Data name="MKBAssessmentBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBABCode</Value>
</Value>
<Value name="3">
<Value>MKBABDesc</Value>
</Value>
<Value name="4">
<Value>MKBABNote</Value>
</Value>
</Data>
<DataLocation>^User.MKBAssessmentBaseD</DataLocation>
<DefaultData>MKBAssessmentBaseDefaultData</DefaultData>
<IdLocation>^User.MKBAssessmentBaseD</IdLocation>
<IndexLocation>^User.MKBAssessmentBaseI</IndexLocation>
<StreamLocation>^User.MKBAssessmentBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
