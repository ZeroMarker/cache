/// Desc:通过工具补门急诊病历，关联表
/// Creator:yejian
/// CreateDate:2019-3-15
Class EMRinstance.InstanceLinkTool Extends (%Persistent, %XML.Adaptor)
{

Index IdxEpisodeID On (EpisodeID, InstanceID) [ Unique ];

/// 实例ID
Property InstanceID As %String;

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 操作者
Property UserID As %String;

Storage Default
{
<Data name="InstanceLinkToolDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.InstanceLinkToolD</DataLocation>
<DefaultData>InstanceLinkToolDefaultData</DefaultData>
<IdLocation>^DHCEMRI.InstanceLinkToolD</IdLocation>
<IndexLocation>^DHCEMRI.InstanceLinkToolI</IndexLocation>
<StreamLocation>^DHCEMRI.InstanceLinkToolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
