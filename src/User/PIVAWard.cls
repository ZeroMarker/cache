Class User.PIVAWard Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PW_RowId, SqlTableName = PIVA_Ward, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTLOC  // Required,
Property PWWardDr As CTLoc [ SqlColumnNumber = 2, SqlFieldName = PW_Ward_Dr ];

/// Des Ref to CTLOC
Property PWCtlocDr As CTLoc [ SqlColumnNumber = 3, SqlFieldName = PW_Ctloc_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PIVAW(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PW_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PW_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PIVAW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PW_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCWLoc">
<Global>^PIVAW</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PW_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CWLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PW_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PW_Ward_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PW_RowId</SqlRowIdName>
<StreamLocation>^User.PIVAWardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
