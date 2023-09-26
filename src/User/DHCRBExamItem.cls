Class User.DHCRBExamItem Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EI_RowId, SqlTableName = DHCRB_ExamItem, StorageStrategy = SQLStorage ]
{

Property ItemDesc As %String;

Property ItemRowid As %String [ Required ];

Property ItemCode As %String;

Property ExamCatRowid As %String [ Required ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBExamItem)</SqlIdExpression>
<SQLMap name="Map1">
<Global>^DHCRBExamItemi</Global>
<Subscript name="1">
<Expression>"arcItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ItemRowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapCatId">
<Global>^DHCRBExamItemi</Global>
<Subscript name="1">
<Expression>"catRowid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ExamCatRowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="ExamCatRowid">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ItemCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ItemDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ItemRowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBExamItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EI_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBExamItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
