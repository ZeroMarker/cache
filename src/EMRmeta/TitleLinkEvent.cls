/// 名称:EMRmeta.TitleLinkEvent
/// 描述:标题关联事件类型
/// 编写者：Donglulu
/// 编写日期: 2021-04-08
Class EMRmeta.TitleLinkEvent Extends (%Persistent, %XML.Adaptor)
{

/// 标题代码
Property TitleCode As %String(TRUNCATE = 1);

/// 事件类型Code(EMRmeta.Events.EventType表的TypeCode)
Property EventCode As %String;

Index IdxTitleCode On TitleCode [ Unique ];

Storage Default
{
<Data name="TitleLinkEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TitleCode</Value>
</Value>
<Value name="3">
<Value>EventCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TitleLinkEventD</DataLocation>
<DefaultData>TitleLinkEventDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TitleLinkEventD</IdLocation>
<IndexLocation>^DHCEMRM.TitleLinkEventI</IndexLocation>
<StreamLocation>^DHCEMRM.TitleLinkEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
