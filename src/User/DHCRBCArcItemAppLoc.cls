Class User.DHCRBCArcItemAppLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAA_RowID, SqlTableName = DHCRBC_ArcItemAppLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DAA_ArcItem_DR
Property DAAArcItemDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DAA_ArcItem_DR ];

/// DAA_AppLoc_DR
Property DAAAppLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DAA_AppLoc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCArcItemAppLoc)</SqlIdExpression>
<SQLMap name="IndexARCAPPLOC">
<Global>^DHCRBCArcItemAppLoci</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DAA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ARC-APPLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAA_ArcItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAA_AppLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DAA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMapData">
<Data name="DAA_AppLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAA_ArcItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCArcItemAppLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DAA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DAA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCArcItemAppLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
