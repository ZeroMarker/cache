/// 名称: 存储病历使用的用户模板ID
/// 描述: 存储病历使用的用户模板ID
/// 编写者：董璐璐
/// 编写日期: 2019-5-28
Class EMRinstance.InstancePersonalTemplate Extends (%Persistent, %XML.Adaptor)
{

/// 用户模板ID
Property PersonalTemplateID As %String;

/// 创建者UserID
Property UserID As %String;

/// 实例数据ID 关联实例表
Property InstanceID As %String;

/// 状态（创建后是否保存）
Property Status As %String(TRUNCATE = 1);

Index IdxInstanceID On InstanceID [ Unique ];

Storage Default
{
<Data name="InstancePersonalTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonalTemplateID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>InstanceID</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.InstPersonTemplateD</DataLocation>
<DefaultData>InstancePersonalTemplateDefaultData</DefaultData>
<IdLocation>^DHCEMRI.InstPersonTemplateD</IdLocation>
<IndexLocation>^DHCEMRI.InstPersonTemplateI</IndexLocation>
<StreamLocation>^DHCEMRI.InstPersonTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
