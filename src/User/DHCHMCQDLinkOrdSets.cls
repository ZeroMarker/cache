/// Description：调查问卷问题内容与套餐关联度表
/// Creator：wangguoying
Class User.DHCHMCQDLinkOrdSets Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQDLinkOrdSets ]
{

Parameter ClassName = "User.DHCHMCQDLinkOrdSets";

Relationship QDLSParRef As User.DHCHMCQuestionsDetail [ Cardinality = parent, Inverse = QDLOrdSets, SqlFieldName = QDLS_ParRef ];

Property QDLSOrdSetsDR As User.ARCOrdSets [ Required, SqlFieldName = QDLS_OrdSetsDR ];

Property QDLSRelevance As %Integer [ Required, SqlFieldName = QDLS_Relevance ];

Property QDLSExpression As %String(MAXLEN = 1200) [ Required, SqlFieldName = QDLS_Expression ];

Property QDLSNote As %String(MAXLEN = 2000) [ SqlFieldName = QDLS_Note ];

Index OrdSetsDRIndex On (QDLSParRef, QDLSOrdSetsDR);

Storage Default
{
<Data name="DHCHMCQDLinkOrdSetsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QDLSOrdSetsDR</Value>
</Value>
<Value name="3">
<Value>QDLSRelevance</Value>
</Value>
<Value name="4">
<Value>QDLSExpression</Value>
</Value>
<Value name="5">
<Value>QDLSNote</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OrdSetsLink")</DataLocation>
<DefaultData>DHCHMCQDLinkOrdSetsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCQuestionsDetailC("OrdSetsLink")</IdLocation>
<IndexLocation>^User.DHCHMCQDLinkOrdSetsI</IndexLocation>
<StreamLocation>^User.DHCHMCQDLinkOrdSetsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
