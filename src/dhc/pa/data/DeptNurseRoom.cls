Class dhc.pa.data.DeptNurseRoom Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DeptNurseRoom_rowid, SqlTableName = DeptNurseRoom, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DNR_DeptDr
Property DNRDeptDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 2, SqlFieldName = DNR_DeptDr ];

/// DNR_RoomDr
Property DNRRoomDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = DNR_RoomDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPADEPTNURSEROOM)</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DNR_DeptDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DNR_RoomDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPADEPTNURSEROOM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DeptNurseRoom_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DeptNurseRoom_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.DeptNurseRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
