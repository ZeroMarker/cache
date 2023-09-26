Class User.DHCRBDocExamCapSet Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DECS_RowId, SqlTableName = DHCRB_DocExamCapSet, StorageStrategy = SQLStorage ]
{

Property UserRowid As %String;

Property UserCode As %String;

Property ExamNum1 As %String;

Property ExamNum2 As %String;

Property ExamNum3 As %String;

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBDocExamCapSet)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="ExamNum1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ExamNum2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ExamNum3">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UserCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UserRowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBDocExamCapSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DECS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DECS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexUserInit">
<Global>^DHCRBDocExamCapSeti</Global>
<Subscript name="1">
<Expression>"userRowid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{UserRowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DECS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBDocExamCapSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
