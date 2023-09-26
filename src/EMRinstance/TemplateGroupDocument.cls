/// 模版组关联病历
Class EMRinstance.TemplateGroupDocument Extends (%Persistent, %XML.Adaptor)
{

Index IdxMain On (EpisodeID, GroupCode, InstanceID) [ Unique ];

Property EpisodeID As %String(TRUNCATE = 1);

/// EMRmeta.EMRTemplateGroup 表的TemplateGroupCode字段
Property GroupCode As %String(TRUNCATE = 1);

Property InstanceID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="TemplateGroupDocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>GroupCode</Value>
</Value>
<Value name="4">
<Value>InstanceID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.TemplateGroupDocD</DataLocation>
<DefaultData>TemplateGroupDocumentDefaultData</DefaultData>
<IdLocation>^DHCEMRI.TemplateGroupDocD</IdLocation>
<IndexLocation>^DHCEMRI.TemplateGroupDocI</IndexLocation>
<StreamLocation>^DHCEMRI.TemplateGroupDocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
