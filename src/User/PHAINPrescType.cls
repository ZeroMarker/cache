Class User.PHAINPrescType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIPT_RowID, SqlTableName = PHAIN_PrescType, StorageStrategy = sqlStorage ]
{

Property PIPTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PIPT_Code ];

Property PIPTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PIPT_Desc ];

Storage sqlStorage
{
<SqlIdExpression>$i(^CD.PHA.IN.PrescType(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PIPT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIPT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CD.PHA.IN.PrescType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIPT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CD.PHA.IN.PrescType</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIPT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIPT_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIPT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PIPT_RowID</SqlRowIdName>
<StreamLocation>^User.PHAINPrescTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
