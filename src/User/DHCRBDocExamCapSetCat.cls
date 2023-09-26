Class User.DHCRBDocExamCapSetCat Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CSC_RowId, SqlTableName = DHCRB_DocExamCapSetCat, StorageStrategy = SQLStorage ]
{

Property DocCapSetRowid As %String [ Required ];

Property ExamCatRowid As %String [ Required ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBDocExamCapSetCat)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="DocCapSetRowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ExamCatRowid">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBDocExamCapSetCat</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CSC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CSC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDocCapSet">
<Global>^DHCRBDocExamCapSetCati</Global>
<Subscript name="1">
<Expression>"indexDocCapSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DocCapSetRowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CSC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBDocExamCapSetCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
