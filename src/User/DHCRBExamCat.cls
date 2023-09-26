Class User.DHCRBExamCat Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowId, SqlTableName = DHCRB_ExamCat, StorageStrategy = SQLStorage ]
{

Property CatDesc As %String;

Property CatCode As %String;

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBExamCat)</SqlIdExpression>
<SQLMap name="Mapdesc">
<Global>^DHCRBExamCati</Global>
<Subscript name="1">
<Expression>"catDesc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CatDesc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="CatCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CatDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBExamCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="mapcode">
<Global>^DHCRBExamCati</Global>
<Subscript name="1">
<Expression>"catcode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CatCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBExamCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
