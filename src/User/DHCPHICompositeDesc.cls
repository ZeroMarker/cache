/// 名称:EMRinstance.ICompositeDesc
/// 描述:实例数据-复合单元打散表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class User.DHCPHICompositeDesc Extends (%Persistent, User.Abstract)
{

Index IdxForUpdate On (InstanceDataID, SectionCode, CompositeCode) [ Unique ];

Index IdxForGetSection On (InstanceDataID, CompositeCode, SectionCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, CompositeCode, InstanceDataID) [ Unique ];

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property CompositeCode As %String(TRUNCATE = 1);

Property Text As %GlobalCharacterStream(LOCATION = "^DHCPHI.ICompositeS");

Property StyleText As %GlobalCharacterStream(LOCATION = "^DHCPHI.ICompositeS");

Storage Default
{
<Data name="ICompositeDescDefaultData">
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
<Value>SectionCode</Value>
</Value>
<Value name="9">
<Value>CompositeCode</Value>
</Value>
<Value name="10">
<Value>Text</Value>
</Value>
<Value name="11">
<Value>StyleText</Value>
</Value>
</Data>
<DataLocation>^DHCPHI.ICompositeDescD</DataLocation>
<DefaultData>ICompositeDescDefaultData</DefaultData>
<IdLocation>^DHCPHI.ICompositeDescD</IdLocation>
<IndexLocation>^DHCPHI.ICompositeDescI</IndexLocation>
<StreamLocation>^DHCPHI.ICompositeDescS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
