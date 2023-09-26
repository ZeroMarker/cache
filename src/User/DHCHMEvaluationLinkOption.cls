/// Description：问卷评估内容与问卷内容选项关联表
/// Creator：wangguoying
Class User.DHCHMEvaluationLinkOption Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_HM_EvaluationLinkOption ]
{

Parameter ClassName = "User.DHCHMEvaluationLinkOption";

Relationship ELOParRef As User.DHCHMEvaluationLinkDetail [ Cardinality = parent, Inverse = ELDOption ];

/// 评估内容选项
Property ELOOptionDR As User.DHCHMCQDOptions [ Required, SqlColumnNumber = 2, SqlFieldName = ELO_Option_DR ];

/// 得分
Property ELOScore As %Integer [ SqlColumnNumber = 3, SqlFieldName = ELO_Score ];

/// 更新人
Property ELOUpdateUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = ELO_UpdateUser_DR ];

/// 更新日期
Property ELOUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ELO_UpdateDate ];

/// 更新时间
Property ELOUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ELO_UpdateTime ];

Index ParRefOptionIndex On (ELOParRef, ELOOptionDR) [ Unique ];

Storage Default
{
<Data name="DHCHMEvaluationLinkOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ELOOptionDR</Value>
</Value>
<Value name="3">
<Value>ELOScore</Value>
</Value>
<Value name="4">
<Value>ELOUpdateUserDR</Value>
</Value>
<Value name="5">
<Value>ELOUpdateDate</Value>
</Value>
<Value name="6">
<Value>ELOUpdateTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ELDOption")</DataLocation>
<DefaultData>DHCHMEvaluationLinkOptionDefaultData</DefaultData>
<IdLocation>^User.DHCHMEvaluationLinkOptionC("ELDOption")</IdLocation>
<IndexLocation>^User.DHCHMEvaluationLinkOptionI</IndexLocation>
<StreamLocation>^User.DHCHMEvaluationLinkOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
