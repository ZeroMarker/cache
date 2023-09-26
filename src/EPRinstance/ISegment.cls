Class EPRinstance.ISegment Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxForLink On (EpisodeID, TemplateID, SegmentCode, InstanceDataID) [ Unique ];

Index IdxForUpdate On (InstanceDataID, SegmentCode) [ Unique ];

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property FormateInfo As %GlobalCharacterStream(LOCATION = "^DHCEPRI.ISegmentS");

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property SegmentCode As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property Text As %GlobalCharacterStream(LOCATION = "^DHCEPRI.ISegmentS");

Storage Default
{
<Data name="ISegmentDefaultData">
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
<Value>ChartItemID</Value>
</Value>
<Value name="6">
<Value>EpisodeID</Value>
</Value>
<Value name="7">
<Value>FormateInfo</Value>
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
<Value>Text</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.ISegmentD</DataLocation>
<DefaultData>ISegmentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.ISegmentD</IdLocation>
<IndexLocation>^DHCEPRI.ISegmentI</IndexLocation>
<StreamLocation>^DHCEPRI.ISegmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
