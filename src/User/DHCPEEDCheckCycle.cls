Class User.DHCPEEDCheckCycle Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_EDCheckCycle ]
{

Parameter ClassName = "User.DHCPEEDCheckCycle";

Relationship EDCParref As User.DHCPEEndanger [ Cardinality = parent, Inverse = EDCheckCycleChild ];

/// 检查周期代码
Property EDCCode As %String(MAXLEN = 20) [ Required, SqlFieldName = EDC_Code ];

///  检查周期描述
Property EDCDesc As %String(MAXLEN = 200) [ Required, SqlFieldName = EDC_Desc ];

///  检查种类
Property EDCOMETypeDR As User.DHCPEOMEType [ SqlFieldName = EDC_OMETypeDR ];

///  激活，Y，N
Property EDCActive As %String(MAXLEN = 1) [ SqlFieldName = EDC_Active ];

///  检查周期扩展信息
Property EDCExpInfo As %String(MAXLEN = 100) [ SqlFieldName = EDC_ExpInfo ];

///  备注
Property EDCRemark As %String(MAXLEN = 200) [ SqlFieldName = EDC_Remark ];

/// 检查周期代码索引
Index EDCCodeIndex On EDCCode [ Unique ];

/// 检查周期描述索引
Index EDCDescIndex On EDCDesc [ Unique ];

///  检查种类索引
Index EDCOMETypeDRIndex On EDCOMETypeDR As AlphaUp;

Storage Default
{
<Data name="DHCPEEDCheckCycleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDCCode</Value>
</Value>
<Value name="3">
<Value>EDCDesc</Value>
</Value>
<Value name="4">
<Value>EDCOMETypeDR</Value>
</Value>
<Value name="5">
<Value>EDCActive</Value>
</Value>
<Value name="6">
<Value>EDCExpInfo</Value>
</Value>
<Value name="7">
<Value>EDCRemark</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EDCheckCycleChild")</DataLocation>
<DefaultData>DHCPEEDCheckCycleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEEndangerC("EDCheckCycleChild")</IdLocation>
<IndexLocation>^User.DHCPEEDCheckCycleI</IndexLocation>
<StreamLocation>^User.DHCPEEDCheckCycleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
