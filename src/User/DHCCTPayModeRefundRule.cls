Class User.DHCCTPayModeRefundRule Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_CTPayModeRefundRule ]
{

Relationship PRRPERParRef As User.DHCCTPayModeExp [ Cardinality = parent, Inverse = ChildRefundRule ];

Property PRRPayModeDR As %String(TRUNCATE = 1) [ Required, SqlFieldName = PRR_PayMode_DR ];

Storage Default
{
<Data name="DHCCTPayModeRefundRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PRRPayModeDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildRefundRule")</DataLocation>
<DefaultData>DHCCTPayModeRefundRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCTPayModeExpC("ChildRefundRule")</IdLocation>
<IndexLocation>^User.DHCCTPayModeRefundRuleI</IndexLocation>
<StreamLocation>^User.DHCCTPayModeRefundRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
