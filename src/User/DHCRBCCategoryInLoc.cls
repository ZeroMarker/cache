Class User.DHCRBCCategoryInLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCIL_RowID, SqlTableName = DHCRBC_CategoryInLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCIL_StudyCategory_DR
Property DCILStudyCategoryDR As User.DHCRBCStudyCategory [ SqlColumnNumber = 2, SqlFieldName = DCIL_StudyCategory_DR ];

/// DCIL_LOC_DR
Property DCILLOCDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DCIL_LOC_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCCategoryInLoc)</SqlIdExpression>
<SQLMap name="IndexCategory">
<Global>^DHCRBCCategoryInLoci</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CATEGORY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCIL_StudyCategory_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCRBCCategoryInLoci</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCIL_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocCate">
<Global>^DHCRBCCategoryInLoci</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOC-Category"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCIL_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCIL_StudyCategory_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DCIL_LOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCIL_StudyCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBCCategoryInLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DCIL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCCategoryInLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
