/// DHC_ANC_OPCount
Class User.DHCANCOPCount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCOPC_RowId, SqlTableName = DHC_ANC_OPCount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCOPC_Code
Property ANCOPCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCOPC_Code ];

/// ANCOPC_Desc
Property ANCOPCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCOPC_Desc ];

/// ANCOPC_CountType_Dr
Property ANCOPCCountTypeDr As User.DHCANCOPCountType [ SqlColumnNumber = 4, SqlFieldName = ANCOPC_CountType_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("OPC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCOPC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCOPC_CountType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCOPC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCOPC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCOPC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCOPCountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
