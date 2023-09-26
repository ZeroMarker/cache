Class User.DHCPEGFOGChild Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ProcedureBlock ]
{

Parameter ClassName = "User.DHCPEGFOGChild";

Relationship GFOGParRef As User.DHCPEGenForOP [ Cardinality = parent, Inverse = GFOChild ];

/// 建议ID
Property GFOGEDDR As User.DHCPEExpertDiagnosis;

/// 结论
Property GFOEGEDesc As %String(MAXLEN = 500);

/// 建议
Property GFOEGAdvice As %String(MAXLEN = 1000);

/// 状态
Property GFOEGStatus As %String;

/// 创建人
Property GFOGEAddUserDR As User.SSUser;

/// 创建时间
Property GFOGEAddDate As %Date;

/// 创建时间
Property GFOGEAddTime As %Time;

/// 删除人
Property GFOGEDeleteUserDR As User.SSUser;

Index EDIndex On GFOGEDDR;

Storage Default
{
<Data name="DHCPEGFOGChildDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GFOGEDDR</Value>
</Value>
<Value name="3">
<Value>GFOEGEDesc</Value>
</Value>
<Value name="4">
<Value>GFOEGAdvice</Value>
</Value>
<Value name="5">
<Value>GFOEGStatus</Value>
</Value>
<Value name="6">
<Value>GFOGEAddUserDR</Value>
</Value>
<Value name="7">
<Value>GFOGEAddDate</Value>
</Value>
<Value name="8">
<Value>GFOGEAddTime</Value>
</Value>
<Value name="9">
<Value>GFOGEDeleteUserDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("GFOChild")</DataLocation>
<DefaultData>DHCPEGFOGChildDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEGenForOPC("GFOChild")</IdLocation>
<IndexLocation>^User.DHCPEGFOGChildI</IndexLocation>
<StreamLocation>^User.DHCPEGFOGChildS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
