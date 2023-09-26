/// 名称:     User.DHCPHECRecord 参考 EMRinstance.ECRecord
/// 描述:     实例数据-外部图表记录
/// 编写者：  bianshuai
/// 编写日期: 2016-09-08
Class User.DHCPHECRecord Extends (%Persistent, User.Abstract)
{

Index IdxEpisodeIDCategoryID On (EpisodeID, CategoryID);

Index IdxEpisodeIDChartItemID On (EpisodeID, ChartItemID) [ Unique ];

Relationship Instances As User.DHCPHInstanceData [ Cardinality = children, Inverse = TheECRecord ];

Property CategoryID As %String(TRUNCATE = 1);

Property CategoryType As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property EpisodeType As %String(TRUNCATE = 1);

Property GroupCategoryID As %String(TRUNCATE = 1);

Property InstanceCount As %Integer;

/// the rowid of papatmas
Property PatientID As %String(TRUNCATE = 1);

/// 文档使编辑器类型 DOC GRID
Property DocumentType As %String(TRUNCATE = 1);

/// 文档特性 0单文档显示 1多个文档连续显示
Property DocumentCharacteristic As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ECRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>CategoryType</Value>
</Value>
<Value name="4">
<Value>ChartItemID</Value>
</Value>
<Value name="5">
<Value>ChartItemType</Value>
</Value>
<Value name="6">
<Value>EpisodeID</Value>
</Value>
<Value name="7">
<Value>EpisodeType</Value>
</Value>
<Value name="8">
<Value>GroupCategoryID</Value>
</Value>
<Value name="9">
<Value>InstanceCount</Value>
</Value>
<Value name="10">
<Value>PatientID</Value>
</Value>
<Value name="11">
<Value>DocumentType</Value>
</Value>
<Value name="12">
<Value>DocumentCharacteristic</Value>
</Value>
</Data>
<DataLocation>^DHCPHI.ECRecordD</DataLocation>
<DefaultData>ECRecordDefaultData</DefaultData>
<IdLocation>^DHCPHI.ECRecordD</IdLocation>
<IndexLocation>^DHCPHI.ECRecordI</IndexLocation>
<StreamLocation>^DHCPHI.ECRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
