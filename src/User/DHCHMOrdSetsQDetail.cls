/// Description：体检套餐与调查问卷关联子表-问题详情
/// Creator：wangguoying
Class User.DHCHMOrdSetsQDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_HM_OrdSetsQDetail ]
{

Parameter ClassName = "User.DHCHMOrdSetsQDetail";

Relationship OQDParRef As User.DHCHMOrdSetsLink [ Cardinality = parent, Inverse = OLDetail ];

Relationship OQDOption As User.DHCHMOrdSetsQDOption [ Cardinality = children, Inverse = OQDOParRef ];

Property OQDDeatilDR As User.DHCHMCQuestionsDetail [ Required, SqlColumnNumber = 2, SqlFieldName = OQD_Deatil_DR ];

/// 关联度
Property OQDRelevance As %Integer [ SqlColumnNumber = 3, SqlFieldName = OQD_Relevance ];

/// 拓展表达式
Property OQDExpression As %String [ SqlColumnNumber = 4, SqlFieldName = OQD_Expression ];

/// 更新人
Property OQDUpdateUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = OQD_UpdateUser_DR ];

/// 操作日期
Property OQDUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = OQD_UpdateDate ];

/// 更新时间
Property OQDUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = OQD_UpdateTime ];

Index ParRefDetailIndex On (OQDParRef, OQDDeatilDR) [ Unique ];

Index DetailParRefIndex On (OQDDeatilDR, OQDParRef);

Storage Default
{
<Data name="DHCHMOrdSetsQDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OQDDeatilDR</Value>
</Value>
<Value name="3">
<Value>OQDRelevance</Value>
</Value>
<Value name="4">
<Value>OQDExpression</Value>
</Value>
<Value name="5">
<Value>OQDUpdateUserDR</Value>
</Value>
<Value name="6">
<Value>OQDUpdateDate</Value>
</Value>
<Value name="7">
<Value>OQDUpdateTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OLDetail")</DataLocation>
<DefaultData>DHCHMOrdSetsQDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOrdSetsLinkC("OLDetail")</IdLocation>
<IndexLocation>^User.DHCHMOrdSetsQDetailI</IndexLocation>
<StreamLocation>^User.DHCHMOrdSetsQDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
