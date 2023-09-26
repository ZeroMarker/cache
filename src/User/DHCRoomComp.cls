Class User.DHCRoomComp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCRoomComp ]
{

/// [ Unique ]
Index RoomcCodeIndex On RoomcCode;

/// [ Unique ]
Index RoomcIpIndex On RoomcIp;

/// [ Unique ]
Index RoomcNameIndex On RoomcName;

Property RoomcCode As %String(TRUNCATE = 1) [ SqlFieldName = RoomcCode ];

Property RoomcIp As %String(TRUNCATE = 1) [ SqlFieldName = RoomcIp ];

Property RoomcName As %String(TRUNCATE = 1) [ SqlFieldName = RoomcName ];

Property RoomcRoomDr As User.CTLoc [ SqlFieldName = RoomcRoomDr ];

Storage Default
{
<Data name="DHCRoomCompDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoomcCode</Value>
</Value>
<Value name="3">
<Value>RoomcIp</Value>
</Value>
<Value name="4">
<Value>RoomcName</Value>
</Value>
<Value name="5">
<Value>RoomcRoomDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCRoomCompD</DataLocation>
<DefaultData>DHCRoomCompDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRoomCompD</IdLocation>
<IndexLocation>^User.DHCRoomCompI</IndexLocation>
<StreamLocation>^User.DHCRoomCompS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
