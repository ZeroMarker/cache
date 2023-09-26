/// Post Analgesia Drug
Class User.DHCANOPAnalgesiaDrug Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPPD_RowId, SqlTableName = DHC_AN_OPAnalgesiaDrug, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHC_AN_OPAnalgesia RowID
Property OPPDOPPDR As User.DHCANOPAnalgesia [ SqlColumnNumber = 2, SqlFieldName = OPPD_OPP_DR ];

/// Arcitem RowId
Property OPPDDrugDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = OPPD_Drug_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANOPAnalgesiaDrug)</SqlIdExpression>
<SQLMap name="IndexOPPRowId">
<Global>^DHCANOPAnalgesiaDrug</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPPD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPPRowId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPPD_OPP_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPPD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="OPPD_Drug_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPPD_OPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCANOPAnalgesiaDrug</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPPD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OPPD_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANOPAnalgesiaDrugS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
