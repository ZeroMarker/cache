/// 事件目录表
Class EMRmeta.Events.EventCategory Extends %Persistent
{

Index IdxEventType On EventType;

/// 事件Code
Property EventCode As %String;

/// 事件描述
Property EventDesc As %String;

/// 事件类型
Property EventType As %String;

Storage Default
{
<Data name="EventCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventCode</Value>
</Value>
<Value name="3">
<Value>EventDesc</Value>
</Value>
<Value name="4">
<Value>EventType</Value>
</Value>
<Value name="5">
<Value>TypeFlag</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Events.EventCategoryD</DataLocation>
<DefaultData>EventCategoryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.Events.EventCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.Events.EventCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.Events.EventCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
