/// 名称: EMRmeta.TemplateContrast
/// 描述: 病历模板对比数据项维护表
/// 编写者：叶剑
/// 编写日期: 2018-5-24
Class EMRmeta.TemplateContrast Extends (%Persistent, %XML.Adaptor)
{

Index IndexTemplateVersion On (TemplateID, TemplateVersion);

Index IndexTemVerPCode On (TemplateID, TemplateVersion, PathCode);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property Author As %String(TRUNCATE = 1);

Property LastSaveDate As %Date;

Property PathCode As %String(TRUNCATE = 1);

/// PathCode有效
Property isValid As %Boolean;

Property ItemCode As %String(MAXLEN = 500, TRUNCATE = 1);

Property Text As %GlobalCharacterStream(LOCATION = "^DHCEMRM.TemplateContrastS");

Property StyleText As %GlobalCharacterStream(LOCATION = "^DHCEMRM.TemplateContrastS");

Storage Default
{
<Data name="TemplateContrastDefaultData">
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
<Value>Author</Value>
</Value>
<Value name="5">
<Value>LastSaveDate</Value>
</Value>
<Value name="6">
<Value>PathCode</Value>
</Value>
<Value name="7">
<Value>Text</Value>
</Value>
<Value name="8">
<Value>isValid</Value>
</Value>
<Value name="9">
<Value>StyleText</Value>
</Value>
<Value name="10">
<Value>ItemCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateContrastD</DataLocation>
<DefaultData>TemplateContrastDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TemplateContrastD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateContrastI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
