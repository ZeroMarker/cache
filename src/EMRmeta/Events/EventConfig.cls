/// 事件配置
Class EMRmeta.Events.EventConfig Extends (%Persistent, %XML.Adaptor)
{

Index IdxEventType On EventType;

/// 事件类型
Property EventType As %String;

/// 关联模板
Property LinkDocID As %String;

/// 关联标题代码 多个以","分隔
Property LinkTitleCode As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 提示信息
Property PromptMessage As %String;

/// 内容插入位置
Property Location As %String;

/// 内容插入位置
Property Scheme As %String(MAXLEN = 10000, TRUNCATE = 1);

Storage Default
{
<Data name="EventConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EventType</Value>
</Value>
<Value name="3">
<Value>LinkDocID</Value>
</Value>
<Value name="4">
<Value>LinkTitleCode</Value>
</Value>
<Value name="5">
<Value>PromptMessage</Value>
</Value>
<Value name="6">
<Value>Location</Value>
</Value>
<Value name="7">
<Value>Scheme</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Events.EventConfigD</DataLocation>
<DefaultData>EventConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.Events.EventConfigD</IdLocation>
<IndexLocation>^DHCEMRM.Events.EventConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.Events.EventConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
