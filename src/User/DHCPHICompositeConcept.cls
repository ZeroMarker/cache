/// 名称:     User.DHCPHICompositeConcept  -----  EMRinstance.ICompositeConcept
/// 描述:     实例数据-医学元素打散表
/// 编写者：  Candyxu
/// 编写日期: 2016-09-08
Class User.DHCPHICompositeConcept Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

Index IdxForUpdate On (InstanceDataID, SectionCode, CompositeCode, ConceptCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, CompositeCode, ConceptCode, InstanceDataID) [ Unique ];

Property BindKBCode As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property KBNodeID As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property CompositeCode As %String(TRUNCATE = 1);

Property ConceptCode As %String(TRUNCATE = 1);

Property Text As %GlobalCharacterStream(LOCATION = "^DHCPHI.IConceptS");

Property StyleText As %GlobalCharacterStream(LOCATION = "^DHCPHI.IIConceptS");

Storage Default
{
<Data name="ICompositeConceptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BindKBCode</Value>
</Value>
<Value name="3">
<Value>ChartItemID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>InstanceDataID</Value>
</Value>
<Value name="6">
<Value>KBNodeID</Value>
</Value>
<Value name="7">
<Value>PatientID</Value>
</Value>
<Value name="8">
<Value>TemplateID</Value>
</Value>
<Value name="9">
<Value>TemplateVersion</Value>
</Value>
<Value name="10">
<Value>SectionCode</Value>
</Value>
<Value name="11">
<Value>CompositeCode</Value>
</Value>
<Value name="12">
<Value>ConceptCode</Value>
</Value>
<Value name="13">
<Value>Text</Value>
</Value>
<Value name="14">
<Value>StyleText</Value>
</Value>
</Data>
<DataLocation>^DHCPHI.ICompositeConceptD</DataLocation>
<DefaultData>ICompositeConceptDefaultData</DefaultData>
<IdLocation>^DHCPHI.ICompositeConceptD</IdLocation>
<IndexLocation>^DHCPHI.ICompositeConceptI</IndexLocation>
<StreamLocation>^DHCPHI.ICompositeConceptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
