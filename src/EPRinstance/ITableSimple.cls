Class EPRinstance.ITableSimple Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxForLink On (EpisodeID, TemplateID, TableCode, SimpleItemCode, InstanceDataID, RowNumber) [ Unique ];

Index IdxForUpdate On (InstanceDataID, TableCode, SimpleItemCode, RowNumber) [ Unique ];

Property ChartItemID As %String(TRUNCATE = 1);

Property DataValue As %String(MAXLEN = 32000, TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property RowNumber As %String(TRUNCATE = 1);

Property SimpleItemCode As %String(TRUNCATE = 1);

Property TableCode As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property ValueCode As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="ITableSimpleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceDataID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>TemplateID</Value>
</Value>
<Value name="6">
<Value>TableCode</Value>
</Value>
<Value name="7">
<Value>TemplateVersion</Value>
</Value>
<Value name="8">
<Value>RowNumber</Value>
</Value>
<Value name="9">
<Value>SimpleItemCode</Value>
</Value>
<Value name="10">
<Value>ChartItemID</Value>
</Value>
<Value name="11">
<Value>DataValue</Value>
</Value>
<Value name="12">
<Value>ListNo</Value>
</Value>
<Value name="13">
<Value>ValueCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.ITableSimpleD</DataLocation>
<DefaultData>ITableSimpleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.ITableSimpleD</IdLocation>
<IndexLocation>^DHCEPRI.ITableSimpleI</IndexLocation>
<StreamLocation>^DHCEPRI.ITableSimpleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
