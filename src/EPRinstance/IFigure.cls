Class EPRinstance.IFigure Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property FigureCode As %String(TRUNCATE = 1);

Property FigureGUID As %String(TRUNCATE = 1);

Property RowNumber As %String(TRUNCATE = 1);

Property FigureDesc As %String(TRUNCATE = 1);

Property FigureData As %GlobalCharacterStream(LOCATION = "^DHCEPRI.IFigureS");

Property AnnoData As %GlobalCharacterStream(LOCATION = "^DHCEPRI.IFigureS");

Property FigureType As %String(TRUNCATE = 1);

Property FigureID As %String(TRUNCATE = 1);

Index IdxForLink On (EpisodeID, TemplateID, FigureCode, InstanceDataID, RowNumber) [ Unique ];

Index IdxForUpdate On (InstanceDataID, FigureCode, RowNumber) [ Unique ];

Storage Default
{
<Data name="IFigureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChartItemID</Value>
</Value>
<Value name="3">
<Value>Data</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>FigureCode</Value>
</Value>
<Value name="6">
<Value>FigureDesc</Value>
</Value>
<Value name="7">
<Value>FigureGUID</Value>
</Value>
<Value name="8">
<Value>InstanceDataID</Value>
</Value>
<Value name="9">
<Value>ListNo</Value>
</Value>
<Value name="10">
<Value>PatientID</Value>
</Value>
<Value name="11">
<Value>RowNumber</Value>
</Value>
<Value name="12">
<Value>TemplateID</Value>
</Value>
<Value name="13">
<Value>TemplateVersion</Value>
</Value>
<Value name="14">
<Value>FiugreData</Value>
</Value>
<Value name="15">
<Value>FigureData</Value>
</Value>
<Value name="16">
<Value>AnnoData</Value>
</Value>
<Value name="17">
<Value>FigureType</Value>
</Value>
<Value name="18">
<Value>FigureID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.IFigureD</DataLocation>
<DefaultData>IFigureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.IFigureD</IdLocation>
<IndexLocation>^DHCEPRI.IFigureI</IndexLocation>
<StreamLocation>^DHCEPRI.IFigureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
