Class User.DHCVISRoom Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_RoomId, SqlTableName = DHC_VIS_Room, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 房间代码
Property VISRoomCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_RoomCode ];

/// 房间描述
Property VISRoomName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VIS_RoomName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISRoom)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_RoomCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_RoomName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVISRoom</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_RoomId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_RoomId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRoomName">
<Global>^DHCVISRoomi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VIS_RoomId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RoomName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIS_RoomName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VIS_RoomId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
