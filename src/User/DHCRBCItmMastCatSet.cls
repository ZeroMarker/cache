Class User.DHCRBCItmMastCatSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DICS_RowID, SqlTableName = DHCRBC_ItmMastCatSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DICS_StudyItmCat_DR
Property DICSStudyItmCatDR As User.DHCRBCStudyItmCat [ SqlColumnNumber = 2, SqlFieldName = DICS_StudyItmCat_DR ];

/// DICS_ArcItemMast_DR
Property DICSArcItemMastDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DICS_ArcItemMast_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCItmMastCatSet)</SqlIdExpression>
<SQLMap name="IndexArcItmMast">
<Global>^DHCRBCItmMastCatSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DICS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ITM-MAST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DICS_ArcItemMast_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DICS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyItmCat">
<Global>^DHCRBCItmMastCatSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DICS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StudyItmCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DICS_StudyItmCat_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DICS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DICS_ArcItemMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DICS_StudyItmCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCItmMastCatSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DICS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DICS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCItmMastCatSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
