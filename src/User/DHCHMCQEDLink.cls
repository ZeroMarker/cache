Class User.DHCHMCQEDLink Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = DHC_HM_CQEDLink ]
{

Parameter ClassName = "User.DHCHMCQEDLink";

Relationship QEDLParRef As User.DHCHMCQuestionnaire [ Cardinality = parent, Inverse = QEDLink ];

Property QEDLEvaluationDetailDR As User.DHCHMCEvaluationDetail;

Property QEDLOrder As %Integer [ SqlFieldName = QEDL_Order ];

Property QEDLCalculateOrder As %Integer [ SqlFieldName = QEDL_CalculateOrder ];

Property QEDLActive As %String [ SqlFieldName = QEDL_Active ];

Property QEDLNote As %String [ SqlFieldName = QEDL_Note ];

Index QEDLOrderIndex On (QEDLParRef, QEDLOrder);

Index IdxOfEvalDtlDR On (QEDLParRef, QEDLEvaluationDetailDR);

Storage Default
{
<Data name="DHCHMCQEDLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QEDLActive</Value>
</Value>
<Value name="3">
<Value>QEDLCalculateOrder</Value>
</Value>
<Value name="4">
<Value>QEDLEvaluationDetailDR</Value>
</Value>
<Value name="5">
<Value>QEDLNote</Value>
</Value>
<Value name="6">
<Value>QEDLOrder</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("QEDLink")</DataLocation>
<DefaultData>DHCHMCQEDLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCQuestionnaireC("QEDLink")</IdLocation>
<IndexLocation>^User.DHCHMCQEDLinkI</IndexLocation>
<StreamLocation>^User.DHCHMCQEDLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
