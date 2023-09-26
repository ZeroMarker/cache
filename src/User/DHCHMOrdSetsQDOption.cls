/// Description：体检套餐与调查问卷关联-问题详情子表-选项
/// Creator：wangguoying
Class User.DHCHMOrdSetsQDOption Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_HM_OrdSetsQDOption ]
{

Parameter ClassName = "User.DHCHMOrdSetsQDOption";

Relationship OQDOParRef As User.DHCHMOrdSetsQDetail [ Cardinality = parent, Inverse = OQDOption ];

Property OQDOOptionDR As User.DHCHMCQDOptions [ Required, SqlColumnNumber = 2, SqlFieldName = OQDO_Option_DR ];

/// 关联度
Property OQDORelevance As %Integer [ SqlColumnNumber = 3, SqlFieldName = OQDO_Relevance ];

/// 更新人
Property OQDOUpdateUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = OQDO_UpdateUser_DR ];

/// 操作日期
Property OQDOUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = OQDO_UpdateDate ];

/// 更新时间
Property OQDOUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = OQDO_UpdateTime ];

Index ParRefOptionIndex On (OQDOParRef, OQDOOptionDR) [ Unique ];

Index OptionParRefIndex On (OQDOOptionDR, OQDOParRef);

Storage Default
{
<Data name="DHCHMOrdSetsQDOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OQDOOptionDR</Value>
</Value>
<Value name="3">
<Value>OQDORelevance</Value>
</Value>
<Value name="4">
<Value>OQDUpdateUserDR</Value>
</Value>
<Value name="5">
<Value>OQDOUpdateDate</Value>
</Value>
<Value name="6">
<Value>OQDOUpdateTime</Value>
</Value>
<Value name="7">
<Value>OQDOUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OLOption")</DataLocation>
<DefaultData>DHCHMOrdSetsQDOptionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOrdSetsQDetailC("OLOption")</IdLocation>
<IndexLocation>^User.DHCHMOrdSetsQDOptionI</IndexLocation>
<StreamLocation>^User.DHCHMOrdSetsQDOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
