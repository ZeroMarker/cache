Class User.DHCDocErrCodeRegister Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ECR_RowID, SqlTableName = DHCDoc_ErrCodeRegister, StorageStrategy = NewStorage1 ]
{

/// ECR_Code
Property ECRClassName As %String [ SqlColumnNumber = 2, SqlFieldName = ECR_ClassName ];

/// ECR_Code
Property ECRCode As %String [ SqlColumnNumber = 3, SqlFieldName = ECR_Code ];

/// ECR_Desc
Property ECRDesc As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = ECR_Desc ];

/// ECR_Notes
Property ECRNotes As %String [ SqlColumnNumber = 5, SqlFieldName = ECR_Notes ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDocErrCodeRegister(0))</SqlIdExpression>
<SQLMap name="IndexErrCode">
<Global>^DHCDocErrCodeRegisterI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ECR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ERRCODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ECR_ClassName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ECR_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ECR_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ECR_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ECR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ECR_Notes">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDocErrCodeRegister</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ECR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ECR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ECR_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocErrCodeRegisterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
