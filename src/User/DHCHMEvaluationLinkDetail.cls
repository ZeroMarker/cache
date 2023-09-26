/// Description：问卷评估内容与问卷内容关联表
/// Creator：wangguoying
Class User.DHCHMEvaluationLinkDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_HM_EvaluationLinkDetail ]
{

Parameter ClassName = "User.DHCHMEvaluationLinkDetail";

Relationship ELDOption As User.DHCHMEvaluationLinkOption [ Cardinality = children, Inverse = ELOParRef ];

/// 评估内容
Property ELDEvaluationDR As User.DHCHMCEvaluationDetail [ Required, SqlColumnNumber = 2, SqlFieldName = ELD_Evaluation_DR ];

/// 问卷基本内容
Property ELDQustionDetailDR As User.DHCHMCQuestionsDetail [ Required, SqlColumnNumber = 3, SqlFieldName = ELD_QustionDetail_DR ];

/// 得分
Property ELDScore As %Integer [ SqlColumnNumber = 4, SqlFieldName = ELD_Score ];

/// 拓展表达式
Property ELDExpression As %String [ SqlColumnNumber = 5, SqlFieldName = ELD_Expression ];

/// 更新人
Property ELDUpdateUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = ELD_UpdateUser_DR ];

/// 更新日期
Property ELDUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ELD_UpdateDate ];

/// 更新时间
Property ELDUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = ELD_UpdateTime ];

Index EvaluationDetailIndex On (ELDEvaluationDR, ELDQustionDetailDR) [ Unique ];

Storage Default
{
<Data name="DHCHMEvaluationLinkDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ELDEvaluationDR</Value>
</Value>
<Value name="3">
<Value>ELDQustionDetailDR</Value>
</Value>
<Value name="4">
<Value>ELDScore</Value>
</Value>
<Value name="5">
<Value>ELDExpression</Value>
</Value>
<Value name="6">
<Value>ELDUpdateUserDR</Value>
</Value>
<Value name="7">
<Value>ELDUpdateDate</Value>
</Value>
<Value name="8">
<Value>ELDUpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMEvaluationLinkDetailD</DataLocation>
<DefaultData>DHCHMEvaluationLinkDetailDefaultData</DefaultData>
<IdLocation>^User.DHCHMEvaluationLinkDetailD</IdLocation>
<IndexLocation>^User.DHCHMEvaluationLinkDetailI</IndexLocation>
<StreamLocation>^User.DHCHMEvaluationLinkDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
