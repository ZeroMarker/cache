/// 名称: 模板术语关联数据（没有用）
/// 描述: 数据组中心的电子病历共享文档队列用到EMRservice.BIEMRService类UpdateEMRDocumentQueue方法用到
/// 编写者：yejian
/// 编写日期: 2019-7-11
Class EMRmeta.TemplateGlossaryCategoryMap Extends %Persistent
{

Property TemplateID As %String;

Property TitleCode As %String;

Property GlossaryCategoryInternalID As %String;

Property MappingDesc As %String;

Index IdxMain On (TemplateID, TitleCode, GlossaryCategoryInternalID);

Storage Default
{
<Data name="TemplateGlossaryCategoryMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>TitleCode</Value>
</Value>
<Value name="4">
<Value>GlossaryCategoryInternalID</Value>
</Value>
<Value name="5">
<Value>MappingDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TempGloCateMapD</DataLocation>
<DefaultData>TemplateGlossaryCategoryMapDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TempGloCateMapD</IdLocation>
<IndexLocation>^DHCEMRM.TempGloCateMapI</IndexLocation>
<StreamLocation>^DHCEMRM.TempGloCateMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
