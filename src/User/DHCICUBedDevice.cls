Class User.DHCICUBedDevice Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_BedDevice ]
{

Property BedId As User.PACBed [ Required ];

Property DeviceId As User.DHCICUDevice [ Required ];

Property Note As %String;

Storage Default
{
<Data name="DHCICUBedDeviceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BedId</Value>
</Value>
<Value name="3">
<Value>DeviceId</Value>
</Value>
<Value name="4">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUBedDeviceD</DataLocation>
<DefaultData>DHCICUBedDeviceDefaultData</DefaultData>
<IdLocation>^User.DHCICUBedDeviceD</IdLocation>
<IndexLocation>^User.DHCICUBedDeviceI</IndexLocation>
<StreamLocation>^User.DHCICUBedDeviceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
