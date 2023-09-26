Class EPRinstance.ITextDescSimple Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property BindKBCode As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property DataValue As %String(MAXLEN = 32000, TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property KBNodeID As %String(TRUNCATE = 1);

Property KBPartNo As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property SimpleItemCode As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property TextDescCode As %String(TRUNCATE = 1);

Property ValueCode As %String(MAXLEN = 500, TRUNCATE = 1);

Index IdxForLink On (EpisodeID, TemplateID, TextDescCode, KBNodeID, KBPartNo, SimpleItemCode, InstanceDataID) [ Unique ];

Index IdxForUpdate On (InstanceDataID, TextDescCode, KBNodeID, KBPartNo, SimpleItemCode) [ Unique ];

Storage Default
{
<Data name="ITextDescSimpleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceDataID</Value>
</Value>
<Value name="3">
<Value>SimpleItemCode</Value>
</Value>
<Value name="4">
<Value>TemplateID</Value>
</Value>
<Value name="5">
<Value>SegmentCode</Value>
</Value>
<Value name="6">
<Value>KBID</Value>
</Value>
<Value name="7">
<Value>TextDescCode</Value>
</Value>
<Value name="8">
<Value>KBPartNo</Value>
</Value>
<Value name="9">
<Value>KBNodeID</Value>
</Value>
<Value name="10">
<Value>BindKBCode</Value>
</Value>
<Value name="11">
<Value>ChartItemID</Value>
</Value>
<Value name="12">
<Value>DataValue</Value>
</Value>
<Value name="13">
<Value>EpisodeID</Value>
</Value>
<Value name="14">
<Value>ListNo</Value>
</Value>
<Value name="15">
<Value>PatientID</Value>
</Value>
<Value name="16">
<Value>TemplateVersion</Value>
</Value>
<Value name="17">
<Value>ValueCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.ITextDescSimpleD</DataLocation>
<DefaultData>ITextDescSimpleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.ITextDescSimpleD</IdLocation>
<IndexLocation>^DHCEPRI.ITextDescSimpleI</IndexLocation>
<StreamLocation>^DHCEPRI.ITextDescSimpleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
