/// 名称：		EMRmeta.EMRTemplateItem
/// 描述：		病历分组子项
/// 编写者：	yejian
/// 编写时间：	2017-5-6
Class EMRmeta.EMRTemplateItem Extends %Persistent
{

/// EMRmeta.EMRTemplateGroup 表的TemplateGroupCode字段
Property TemplateGroupCode As %String(TRUNCATE = 1);

/// EMRmeta.EMRTemplate表的ID
Property EMRTemplateID As %String(TRUNCATE = 1);

/// EMRmeta.EMRTemplate表的TemplateName字段
Property EMRTemplateName As %String(TRUNCATE = 1);

/// 类型(基础模板 BASETEM/空,科室模板 USERTEM)
Property TemplateType As %String(TRUNCATE = 1);

/// 科室模板编码(科室模板 EMRmeta.UserTemplate表的Code,基础模板 空值)
Property UserTemplateCode As %String(TRUNCATE = 1);

/// 标题编码
Property TitleCode As %String(TRUNCATE = 1);

/// 排序
Property TemplateSeq As %Integer;

Index IdxItemCode On (TemplateGroupCode, EMRTemplateID) [ Unique ];

Index IdxItemSeq On (TemplateGroupCode, TemplateSeq);

Storage Default
{
<Data name="EMRTemplateItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateGroupCode</Value>
</Value>
<Value name="3">
<Value>TemplateID</Value>
</Value>
<Value name="4">
<Value>TemplateName</Value>
</Value>
<Value name="5">
<Value>TemplateSeq</Value>
</Value>
<Value name="6">
<Value>EMRTemplateID</Value>
</Value>
<Value name="7">
<Value>EMRTemplateName</Value>
</Value>
<Value name="8">
<Value>TemplateType</Value>
</Value>
<Value name="9">
<Value>UserTemplateCode</Value>
</Value>
<Value name="10">
<Value>TitleCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRTemplateItemD</DataLocation>
<DefaultData>EMRTemplateItemDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRTemplateItemD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemplateItemI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemplateItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
