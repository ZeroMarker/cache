Class EPRservice.Util.CdataAggr Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property CdataCount As %Integer;

//Relationship CDataItems As EPRservice.Util.CdataItem [ Cardinality = children, Inverse = TheCdataAggr ];

Property PatientID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CdataAggrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CdataCount</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.CdataAggrD</DataLocation>
<DefaultData>CdataAggrDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.CdataAggrD</IdLocation>
<IndexLocation>^DHCEPRI.CdataAggrI</IndexLocation>
<StreamLocation>^DHCEPRI.CdataAggrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
