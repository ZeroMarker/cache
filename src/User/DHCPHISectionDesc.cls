/// 名称:     EMRinstance.ICompositeDesc
/// 描述:     实例数据-章节打散表
/// 编写者：  Guozongtao
/// 编写日期: 2014-01-03
Class User.DHCPHISectionDesc Extends (%Persistent, User.Abstract) [ StorageStrategy = Default ]
{

Index IdxForUpdate On (InstanceDataID, SectionCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, InstanceDataID) [ Unique ];

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property Text As %GlobalCharacterStream(LOCATION = "^DHCPHI.ISectionDescS");

Property StyleText As %GlobalCharacterStream(LOCATION = "^DHCPHI.ISectionDescS");

Property SectionCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ISectionDescDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChartItemID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>InstanceDataID</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>TemplateID</Value>
</Value>
<Value name="7">
<Value>TemplateVersion</Value>
</Value>
<Value name="8">
<Value>Text</Value>
</Value>
<Value name="9">
<Value>SectionCode</Value>
</Value>
<Value name="10">
<Value>StyleText</Value>
</Value>
</Data>
<DataLocation>^DHCPHI.ISectionDescD</DataLocation>
<DefaultData>ISectionDescDefaultData</DefaultData>
<IdLocation>^DHCPHI.ISectionDescD</IdLocation>
<IndexLocation>^DHCPHI.ISectionDescI</IndexLocation>
<StreamLocation>^DHCPHI.ISectionDescS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
