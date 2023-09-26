Class User.DHCRBCRetinueWardSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRWS_RowID, SqlTableName = DHCRBC_RetinueWardSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRWS_Retinue_DR
Property DRWSRetinueDR As User.DHCRBCOutWorkerSet [ SqlColumnNumber = 2, SqlFieldName = DRWS_Retinue_DR ];

/// DRWS_Ward_DR
Property DRWSWardDR As User.PACWard [ SqlColumnNumber = 3, SqlFieldName = DRWS_Ward_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCRetinueWardSet)</SqlIdExpression>
<SQLMap name="IndexRetinue">
<Global>^DHCRBCRetinueWardSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRWS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Retinue-Ward"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRWS_Retinue_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRWS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DRWS_Retinue_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRWS_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCRetinueWardSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRWS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRWS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCRetinueWardSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
