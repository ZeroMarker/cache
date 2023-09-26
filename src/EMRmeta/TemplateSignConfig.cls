/// 名称:EMRmeta.TemplateSign
/// 描述:模板版本签名配置表
/// 编写者：yejian
/// 编写日期: 2022-8-22
Class EMRmeta.TemplateSignConfig Extends %Persistent
{

Index IndexTIDVersion On (TemplateID, TemplateVersion);

Index IndexTIDHasSign On (TemplateID, TemplateVersion, HasSign);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 模板版本ID
Property TemplateVersion As %Integer;

/// 是否有签名单元（1 有签名单元，0 无签名单元） 
Property HasSign As %String(TRUNCATE = 1) [ InitialExpression = "1" ];

Storage Default
{
<Data name="TemplateSignConfigDefaultData">
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
<Value>HasSign</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateSignConfigD</DataLocation>
<DefaultData>TemplateSignConfigDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TemplateSignConfigD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateSignConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateSignConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
