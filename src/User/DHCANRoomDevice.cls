Class User.DHCANRoomDevice Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_AN_RoomDevice ]
{

Property RoomId As User.DHCANCOperRoom [ Required ];

Property DeviceId As User.DHCANDevice [ Required ];

Property Note As %String;

Storage Default
{
<Data name="DHCANRoomDeviceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoomId</Value>
</Value>
<Value name="3">
<Value>DeviceId</Value>
</Value>
<Value name="4">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^User.DHCANRoomDeviceD</DataLocation>
<DefaultData>DHCANRoomDeviceDefaultData</DefaultData>
<IdLocation>^User.DHCANRoomDeviceD</IdLocation>
<IndexLocation>^User.DHCANRoomDeviceI</IndexLocation>
<StreamLocation>^User.DHCANRoomDeviceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
