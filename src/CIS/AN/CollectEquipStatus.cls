Class CIS.AN.CollectEquipStatus Extends %Persistent [ Final, Owner = {_Public}, SqlRowIdName = RowId, SqlTableName = CollectEquipStatus ]
{

Property Equip As CF.AN.DeptEquip [ Required, SqlColumnNumber = 2 ];

Property LastRecvPacketDataTime As %TimeStamp [ SqlColumnNumber = 3 ];

Property LastRecvValidDataTime As %TimeStamp [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="CollectEquipStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Equip</Value>
</Value>
<Value name="3">
<Value>LastRecvPacketDataTime</Value>
</Value>
<Value name="4">
<Value>LastRecvValidDataTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.CollectEquipStatusD</DataLocation>
<DefaultData>CollectEquipStatusDefaultData</DefaultData>
<IdLocation>^CIS.AN.CollectEquipStatusD</IdLocation>
<IndexLocation>^CIS.AN.CollectEquipStatusI</IndexLocation>
<StreamLocation>^CIS.AN.CollectEquipStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
