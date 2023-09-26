/// 名称:EMRinstance.ECRecord
/// 描述:实例数据-外部图表记录
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRinstance.ECRecord Extends %Persistent
{

Index IdxEpisodeIDCategoryID On (EpisodeID, CategoryID);

Index IdxEpisodeIDChartItemID On (EpisodeID, ChartItemID) [ Unique ];

Relationship Instances As EMRinstance.InstanceData [ Cardinality = children, Inverse = TheECRecord ];

Property CategoryID As EMRmeta.TemplateCategory;

Property CategoryType As %String(TRUNCATE = 1);

Property ChartItemID As EMRmeta.EMRTemplateCategory;

Property ChartItemType As %String(TRUNCATE = 1);

Property EpisodeID As User.PAAdm;

Property EpisodeType As %String(TRUNCATE = 1);

Property GroupCategoryID As %String(TRUNCATE = 1);

Property InstanceCount As %Integer;

/// the rowid of papatmas
Property PatientID As %String(TRUNCATE = 1);

/// 文档使编辑器类型 DOC GRID
Property DocumentType As %String(TRUNCATE = 1);

/// 文档特性 0单文档显示 1多个文档连续显示
Property DocumentCharacteristic As %String(TRUNCATE = 1);

Property RealCategoryID As %String [ Calculated, Private ];

Property RealChartItemID As %String [ Calculated, Private ];

Property RealEpisodeID As %String [ Calculated, Private ];

Method RealCategoryIDGet() As %String
{
	if (..CategoryID="") q ""
	q ..CategoryID.%Id()
}

Method RealChartItemIDGet() As %String
{
	if (..ChartItemID="") q ""
	q ..ChartItemID.%Id()
}

Method RealEpisodeIDGet() As %String
{
	if (..EpisodeID="") q ""
	q ..EpisodeID.%Id()
}

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
<Value>EditType</Value>
</Value>
<Value name="13">
<Value>DocumentCharacteristic</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ECRecordD</DataLocation>
<DefaultData>ECRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.ECRecordD</IdLocation>
<IndexLocation>^DHCEMRI.ECRecordI</IndexLocation>
<StreamLocation>^DHCEMRI.ECRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
