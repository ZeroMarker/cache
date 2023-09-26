Class EPRinstance.ISegmentSimple Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxForLink On (EpisodeID, TemplateID, SegmentCode, SimpleItemCode, InstanceDataID) [ Unique ];

Index IdxForUpdate On (InstanceDataID, SegmentCode, SimpleItemCode) [ Unique ];

Property ChartItemID As %String(TRUNCATE = 1);

Property DataValue As %String(MAXLEN = 32000, TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property SegmentCode As %String(TRUNCATE = 1);

Property SimpleItemCode As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property ValueCode As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="ISegmentSimpleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceDataID</Value>
</Value>
<Value name="3">
<Value>SegmentCode</Value>
</Value>
<Value name="4">
<Value>TemplateID</Value>
</Value>
<Value name="5">
<Value>SimpleItemCode</Value>
</Value>
<Value name="6">
<Value>ChartItemID</Value>
</Value>
<Value name="7">
<Value>DataValue</Value>
</Value>
<Value name="8">
<Value>ListNo</Value>
</Value>
<Value name="9">
<Value>PatientID</Value>
</Value>
<Value name="10">
<Value>TemplateVersion</Value>
</Value>
<Value name="11">
<Value>ValueCode</Value>
</Value>
<Value name="12">
<Value>EpisodeID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.ISegmentSimpleD</DataLocation>
<DefaultData>ISegmentSimpleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.ISegmentSimpleD</IdLocation>
<IndexLocation>^DHCEPRI.ISegmentSimpleI</IndexLocation>
<StreamLocation>^DHCEPRI.ISegmentSimpleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
