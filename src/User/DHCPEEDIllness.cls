Class User.DHCPEEDIllness Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_EDIllness ]
{

Parameter ClassName = "User.DHCPEEDIllness";

Relationship EDIlParref As User.DHCPEEndanger [ Cardinality = parent, Inverse = EDIllnessChild ];

///  危害因素对应的目标疾病
Property EDIIllndessDR As User.DHCPEOMEIllness [ Required, SqlFieldName = EDI_IllndessDR ];

///  目标疾病的检查种类
Property EDIOMETypeDR As User.DHCPEOMEType [ SqlFieldName = EDI_OMETypeDR ];

///  激活，Y，N
Property EDIActive As %String(MAXLEN = 1) [ SqlFieldName = EDI_Active ];

///  目标疾病扩展信息 具体疾病
Property EDIExpInfo As %String(MAXLEN = 100) [ SqlFieldName = EDI_ExpInfo ];

///  备注
Property EDIRemark As %String(MAXLEN = 200) [ SqlFieldName = EDI_Remark ];

///  检查种类索引
Index EDIOMETypeDRIndex On EDIOMETypeDR As AlphaUp;

Storage Default
{
<Data name="DHCPEEDIllnessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDIIllndessDR</Value>
</Value>
<Value name="3">
<Value>EDIOMETypeDR</Value>
</Value>
<Value name="4">
<Value>EDIActive</Value>
</Value>
<Value name="5">
<Value>EDIExpInfo</Value>
</Value>
<Value name="6">
<Value>EDIRemark</Value>
</Value>
<Value name="7">
<Value>EDIIllnessDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EDIllnessChild")</DataLocation>
<DefaultData>DHCPEEDIllnessDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEEndangerC("EDIllnessChild")</IdLocation>
<IndexLocation>^User.DHCPEEDIllnessI</IndexLocation>
<StreamLocation>^User.DHCPEEDIllnessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
