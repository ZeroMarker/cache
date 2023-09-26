/// 病房
Class DHCCL.Config.Room Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Room ]
{

Property Code As %String [ SqlColumnNumber = 2 ];

Property Description As %String [ SqlColumnNumber = 3 ];

Property RoomType As DHCCL.Code.RoomType [ SqlColumnNumber = 4 ];

Property ActiveDate As %Date [ SqlColumnNumber = 5 ];

Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

Index Code On Code [ Unique ];

Index Type On RoomType;

Storage Default
{
<Data name="RoomDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>RoomType</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.RoomD</DataLocation>
<DefaultData>RoomDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.RoomD</IdLocation>
<IndexLocation>^DHCCL.Config.RoomI</IndexLocation>
<StreamLocation>^DHCCL.Config.RoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
