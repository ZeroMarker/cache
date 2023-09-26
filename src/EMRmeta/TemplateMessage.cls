/// 名称:EMRmeta.TemplateMessage
/// 描述:模板消息提示维护
/// 编写者：yejian
/// 编写日期: 2019-9-9
Class EMRmeta.TemplateMessage Extends %Persistent
{

Index IdxTemplateID On TemplateID;

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 模板名称
Property TemplateName As %String(TRUNCATE = 1);

/// 模板提示信息
Property TemMessage As %String(MAXLEN = 2000, TRUNCATE = 1);

Storage Default
{
<Data name="TemplateMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>TemplateName</Value>
</Value>
<Value name="4">
<Value>TemMessage</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateMessageD</DataLocation>
<DefaultData>TemplateMessageDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TemplateMessageD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateMessageI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
