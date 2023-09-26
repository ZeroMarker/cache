/// Description：调查问卷问题选项与套餐关联度表
/// Creator：wangguoying
Class User.DHCHMCQDOLinkOrdSets Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQDOLinkOrdSets, StorageStrategy = CacheStorage ]
{

Parameter ClassName = "User.DHCHMCQDOLinkOrdSets";

Relationship QDOLSParRef As User.DHCHMCQDOptions [ Cardinality = parent, Inverse = QDOLinkOrdSets, SqlFieldName = QDOLS_ParRef ];

Property QDOLSOrdSetsDR As User.ARCOrdSets [ Required, SqlFieldName = QDOLS_OrdSetsDR ];

Property QDOLSRelevance As %Integer [ Required, SqlFieldName = QDOLS_Relevance ];

Property QDOLSActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlFieldName = QDOLS_Active ];

Index OrdSetsDRIndex On (QDOLSParRef, QDOLSOrdSetsDR) [ Unique ];

Index RelevanceIndex On (QDOLSParRef, QDOLSRelevance);

Storage CacheStorage
{
<Data name="DHCHMCQDOLinkOrdSetsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QDOLSOrdSetsDR</Value>
</Value>
<Value name="3">
<Value>QDOLSRelevance</Value>
</Value>
<Value name="4">
<Value>QDOLSActive</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("QDOLSOrdSets")</DataLocation>
<DefaultData>DHCHMCQDOLinkOrdSetsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCQDOptionsC("QDOLSOrdSets")</IdLocation>
<IndexLocation>^User.DHCHMCQDOLinkOrdSetsI</IndexLocation>
<StreamLocation>^User.DHCHMCQDOLinkOrdSetsD</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
