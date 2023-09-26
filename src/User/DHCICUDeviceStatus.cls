Class User.DHCICUDeviceStatus Extends %Persistent [ Final, Owner = {_Public}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_DeviceStatus ]
{

Property Equip As User.DHCICUDevice [ Required, SqlColumnNumber = 2 ];

Property LastRecvPacketDataTime As %TimeStamp [ SqlColumnNumber = 3 ];

Property LastRecvValidDataTime As %TimeStamp [ SqlColumnNumber = 4 ];

Index EquipIndex On Equip As Exact;

Storage Default
{
<Data name="DHCICUDeviceStatusDefaultData">
<Value name="1">
<Value>Equip</Value>
</Value>
<Value name="2">
<Value>LastRecvPacketDataTime</Value>
</Value>
<Value name="3">
<Value>LastRecvValidDataTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUDeviceStatusD</DataLocation>
<DefaultData>DHCICUDeviceStatusDefaultData</DefaultData>
<IdLocation>^User.DHCICUDeviceStatusD</IdLocation>
<IndexLocation>^User.DHCICUDeviceStatusI</IndexLocation>
<StreamLocation>^User.DHCICUDeviceStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
