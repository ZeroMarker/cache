Class EMRmeta.Events.EventType Extends (%Persistent, %XML.Adaptor)
{

Index IdxTypeCode On TypeCode;

/// 事件类型
Property TypeCode As %String;

/// 事件类型
Property TypeDesc As %String;

Storage Default
{
<Data name="EventTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeCode</Value>
</Value>
<Value name="3">
<Value>TypeDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Events.EventTypeD</DataLocation>
<DefaultData>EventTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.Events.EventTypeD</IdLocation>
<IndexLocation>^DHCEMRM.Events.EventTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.Events.EventTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
