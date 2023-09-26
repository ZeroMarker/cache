Class User.DHCRBCItemGroupLocSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIGS_RowID, SqlTableName = DHCRBC_ItemGroupLocSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DIGS_Desc
Property DIGSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DIGS_Desc ];

/// DIGS_Code
Property DIGSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DIGS_Code ];

/// DIGS_RecLoc_DR
Property DIGSRecLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = DIGS_RecLoc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCItemGroupLocSet("ItmGroup-Loc"))</SqlIdExpression>
<SQLMap name="IndexAppLoc">
<Global>^DHCRBCItemGroupLocSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DIGS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AppLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIGS_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIGS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCRBCItemGroupLocSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DIGS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIGS_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIGS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCRBCItemGroupLocSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DIGS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIGS_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIGS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DIGS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIGS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIGS_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCItemGroupLocSet</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DIGS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItmGroup-Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIGS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItemGroupLocSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
