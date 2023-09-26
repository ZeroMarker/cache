/// 名称: 存储病历使用的科室模板ID
/// 描述: 存储病历使用的科室模板ID
/// 编写者：董璐璐
/// 编写日期: 2019-5-17
Class EMRinstance.InstanceUserTemplate Extends (%Persistent, %XML.Adaptor)
{

/// 科室模板ID
Property UserTemplateID As %String;

/// 创建者UserID
Property UserID As %String;

/// 实例数据ID 关联实例表
Property InstanceID As %String;

/// 状态（创建后是否保存）
Property Status As %String(TRUNCATE = 1);

Index IdxInstanceID On InstanceID [ Unique ];

Storage Default
{
<Data name="InstanceUserTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>UserTemplateID</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>InstanceID</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.InstanceUserTemplateD</DataLocation>
<DefaultData>InstanceUserTemplateDefaultData</DefaultData>
<IdLocation>^DHCEMRI.InstanceUserTemplateD</IdLocation>
<IndexLocation>^DHCEMRI.InstanceUserTemplateI</IndexLocation>
<StreamLocation>^DHCEMRI.InstanceUserTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
