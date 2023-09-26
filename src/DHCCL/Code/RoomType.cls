/// 病房类型
Class DHCCL.Code.RoomType Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = RoomType ]
{

Property Code As %String [ SqlColumnNumber = 2 ];

Property Description As %String [ SqlColumnNumber = 3 ];

Property ActiveDate As %Date [ SqlColumnNumber = 4 ];

Property ExpireDate As %Date [ SqlColumnNumber = 5 ];

Property ExternalID As %String [ SqlColumnNumber = 6 ];

Index Ext On ExternalID;

Index Code On Code [ Unique ];

Storage Default
{
<Data name="RoomTypeDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ActiveDate</Value>
</Value>
<Value name="4">
<Value>ExpireDate</Value>
</Value>
<Value name="5">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.RoomTypeD</DataLocation>
<DefaultData>RoomTypeDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.RoomTypeD</IdLocation>
<IndexLocation>^DHCCL.Code.RoomTypeI</IndexLocation>
<StreamLocation>^DHCCL.Code.RoomTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
