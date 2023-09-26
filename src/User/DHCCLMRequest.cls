Class User.DHCCLMRequest Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

Property userName As %String(TRUNCATE = 1);

Property password As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCCLMRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>userName</Value>
</Value>
<Value name="3">
<Value>password</Value>
</Value>
</Data>
<DataLocation>^User.DHCCLMRequestD</DataLocation>
<DefaultData>DHCCLMRequestDefaultData</DefaultData>
<IdLocation>^User.DHCCLMRequestD</IdLocation>
<IndexLocation>^User.DHCCLMRequestI</IndexLocation>
<StreamLocation>^User.DHCCLMRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
