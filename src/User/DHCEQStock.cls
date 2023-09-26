Class User.DHCEQStock Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = S_RowID, SqlTableName = DHC_EQStock, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// S_LocDR
Property SLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = S_LocDR ];

/// S_EquipDR
Property SEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = S_EquipDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQStock("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="S_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="S_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQStock</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQStock</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{S_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQStockS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
