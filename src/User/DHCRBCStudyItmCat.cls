Class User.DHCRBCStudyItmCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSIC_RowID, SqlTableName = DHCRBC_StudyItmCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSIC_Desc
Property DSICDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DSIC_Desc ];

/// DSIC_Code
Property DSICCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DSIC_Code ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCStudyItmCat)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCStudyItmCati</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSIC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSIC_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSIC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCRBCStudyItmCati</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSIC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSIC_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSIC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DSIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCStudyItmCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSIC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DSIC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCStudyItmCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
