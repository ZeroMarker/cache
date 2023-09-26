Class User.PHAHERBDistPres Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDP_RowID, SqlTableName = PHAHERB_DistPres, StorageStrategy = sqlStorage ]
{

Property PHDPWHInterface As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHDP_WHInterface ];

Property PHDPPTDr As User.PHAHERBPresType [ SqlColumnNumber = 3, SqlFieldName = PHDP_PT_Dr ];

Storage sqlStorage
{
<SqlIdExpression>$i(^CF.PHA.HERB.DistPres(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHDP_PT_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDP_WHInterface">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.PHA.HERB.DistPres</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHDP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHDP_RowID</SqlRowIdName>
<StreamLocation>^User.PHAHERBDistPresS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
