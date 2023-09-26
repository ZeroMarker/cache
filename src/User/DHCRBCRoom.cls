Class User.DHCRBCRoom Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCRM_RowID, SqlTableName = DHCRBC_Room, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBCRoomEquipment As User.DHCRBCRoomEquipment [ Cardinality = children, Inverse = DCRMEParRef ];

/// DCRM_RoomCode
Property DCRMRoomCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DCRM_RoomCode ];

/// DCRM_RoomName
Property DCRMRoomName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DCRM_RoomName ];

/// DCRM_Loc_DR
Property DCRMLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = DCRM_Loc_DR ];

/// DCRM_Address
Property DCRMAddress As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DCRM_Address ];

/// DCIM_ComputerName
Property DCIMComputerName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DCIM_ComputerName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("Room"))</SqlIdExpression>
<SQLMap name="IndexComputer">
<Global>^DHCRBCRoom</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCRM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IndexComputer"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCIM_ComputerName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDR">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCRM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCRM_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCRM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DCIM_ComputerName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCRM_Address">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCRM_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCRM_RoomCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCRM_RoomName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DCRM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Room"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCRM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
