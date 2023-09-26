Class User.DHCRBCCategoryAndCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCAC_RowID, SqlTableName = DHCRBC_CategoryAndCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCAC_StudyCategory_DR
Property DCACStudyCategoryDR As User.DHCRBCStudyCategory [ SqlColumnNumber = 2, SqlFieldName = DCAC_StudyCategory_DR ];

/// DCAC_StudyItmCat_DR
Property DCACStudyItmCatDR As User.DHCRBCStudyItmCat [ SqlColumnNumber = 3, SqlFieldName = DCAC_StudyItmCat_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCCategoryAndCat)</SqlIdExpression>
<SQLMap name="IndexStudyCategory">
<Global>^DHCRBCCategoryAndCati</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCAC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STUDY-CATEGORY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCAC_StudyCategory_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStudyItmCat">
<Global>^DHCRBCCategoryAndCati</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCAC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STUDY-ItmCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCAC_StudyItmCat_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DCAC_StudyCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCAC_StudyItmCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCCategoryAndCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCAC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DCAC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCCategoryAndCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
