/// 对门诊患者添加建议
Class User.DHCPEGenForOP Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract)
{

Parameter ClassName = "User.DHCPEGenForOP";

/// paadm
Property GFOAdmDR As PAAdm;

/// 创建日期
Property GFOCreateDate As %Date;

/// 创建时间
Property GFOCreateTime As %Time;

/// 创建人
Property GFOCreateUserDR As User.SSUser;

Property GFOAuditDate As %Date;

Property GFOAduitTime As %Time;

Property GFOAuditUserDR As User.SSUser;

Property GFOStatus As %String;

Relationship GFOChild As User.DHCPEGFOGChild [ Cardinality = children, Inverse = GFOGParRef ];

Index AdmIndex On GFOAdmDR;

Storage Default
{
<Data name="DHCPEGenForOPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GFOAdmDR</Value>
</Value>
<Value name="3">
<Value>GFOCreateDate</Value>
</Value>
<Value name="4">
<Value>GFOCreateTime</Value>
</Value>
<Value name="5">
<Value>GFOCreateUserDR</Value>
</Value>
<Value name="6">
<Value>GFOAuditDate</Value>
</Value>
<Value name="7">
<Value>GFOAduitTime</Value>
</Value>
<Value name="8">
<Value>GFOAudituUserDR</Value>
</Value>
<Value name="9">
<Value>GFOStatus</Value>
</Value>
<Value name="10">
<Value>GFOAuditUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEGenForOPD</DataLocation>
<DefaultData>DHCPEGenForOPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEGenForOPD</IdLocation>
<IndexLocation>^User.DHCPEGenForOPI</IndexLocation>
<StreamLocation>^User.DHCPEGenForOPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
