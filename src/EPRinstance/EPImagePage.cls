Class EPRinstance.EPImagePage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EPImageID As %String(TRUNCATE = 1);

Property PageIndex As %Integer;

Property ImageData As %GlobalBinaryStream(LOCATION = "^DHCEPRI.EPImagePageS");

Index IdxForLink On (EPImageID, PageIndex) [ Unique ];

Storage Default
{
<Data name="EPImagePageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPImageID</Value>
</Value>
<Value name="3">
<Value>ImageData</Value>
</Value>
<Value name="4">
<Value>PageIndex</Value>
</Value>
<Value name="5">
<Value>ID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.EPImagePageD</DataLocation>
<DefaultData>EPImagePageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.EPImagePageD</IdLocation>
<IndexLocation>^DHCEPRI.EPImagePageI</IndexLocation>
<StreamLocation>^DHCEPRI.EPImagePageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
