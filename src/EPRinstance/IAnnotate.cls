Class EPRinstance.IAnnotate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property ImageAnnotateCode As %String(TRUNCATE = 1);

Property AnnoData As %GlobalCharacterStream(LOCATION = "^DHCEPRI.IAnnoDataS");

Index IdxForLink On (EpisodeID, TemplateID, ImageAnnotateCode, InstanceDataID) [ Unique ];

Index IdxForUpdate On (InstanceDataID, ImageAnnotateCode) [ Unique ];

Storage Default
{
<Data name="IAnnotateDefaultData">
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
<Value>TemplateID</Value>
</Value>
<Value name="5">
<Value>AnnoData</Value>
</Value>
<Value name="6">
<Value>ChartItemID</Value>
</Value>
<Value name="7">
<Value>ImageAnnotateCode</Value>
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
</Data>
<DataLocation>^DHCEPRI.IAnnotateD</DataLocation>
<DefaultData>IAnnotateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.IAnnotateD</IdLocation>
<IndexLocation>^DHCEPRI.IAnnotateI</IndexLocation>
<StreamLocation>^DHCEPRI.IAnnotateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
