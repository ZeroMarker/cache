Class User.DHCRBCStudyCategory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSC_RowID, SqlTableName = DHCRBC_StudyCategory, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSC_Desc
Property DSCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DSC_Desc ];

/// DSC_Code
Property DSCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DSC_Code ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCStudyCategory)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCStudyCategoryi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSC_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCRBCStudyCategoryi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSC_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DSC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCStudyCategory</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DSC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCStudyCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
