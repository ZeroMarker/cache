/// 名称:EMRmeta.TemplateUseNumber
/// 描述:文档模板使用次数
/// 编写者：yejain
/// 编写日期: 2021-4-12
Class EMRmeta.TemplateUseNumber Extends %Persistent
{

Index IndexTemplate On TemplateID;

Index IndexTVersion On (TemplateID, TemplateVersion);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 模板版本ID
Property TemplateVersion As %Integer;

/// 使用次数
Property UseNumber As %Integer;

Storage Default
{
<Data name="TemplateUseNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>TemplateVersion</Value>
</Value>
<Value name="4">
<Value>UseNumber</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateUseNumberD</DataLocation>
<DefaultData>TemplateUseNumberDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TemplateUseNumberD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateUseNumberI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateUseNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
