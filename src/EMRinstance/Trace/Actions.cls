/// Desc:          用户行为Action码表
/// Creator:       Candy
/// CreateDate:2015-1-30
Class EMRinstance.Trace.Actions Extends (%Persistent, %XML.Adaptor)
{

/// 代码
Property ActionCode As %String;

/// 描述
Property ActionDesc As %String;

Storage Default
{
<Data name="ActionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCode</Value>
</Value>
<Value name="3">
<Value>ActionDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRT.ActionsD</DataLocation>
<DefaultData>ActionsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRT.ActionsD</IdLocation>
<IndexLocation>^DHCEMRT.ActionsI</IndexLocation>
<StreamLocation>^DHCEMRT.ActionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
