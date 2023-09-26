Class User.DHCRBCEquipmentAddress Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DEA_RowID, SqlTableName = DHCRBC_Equipment_Address, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DEA_Equipment_DR
Property DEAEquipmentDR As User.RBCEquipment [ SqlColumnNumber = 2, SqlFieldName = DEA_Equipment_DR ];

/// DEA_Address
Property DEAAddress As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DEA_Address ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCEquipmentAddress)</SqlIdExpression>
<SQLMap name="IndexEq">
<Global>^DHCRBCEquipmentAddressi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DEA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEA_Equipment_DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMapData">
<Data name="DEA_Address">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEA_Equipment_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCEquipmentAddress</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DEA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCEquipmentAddressS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
