/// DHC_ANC_OPCountType
Class User.DHCANCOPCountType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCOPCT_RowId, SqlTableName = DHC_ANC_OPCountType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCOPCT_Code
Property ANCOPCTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCOPCT_Code ];

/// ANCOPCT_Desc
Property ANCOPCTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCOPCT_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("OPCT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCOPCT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCOPCT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCOPCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCOPCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCOPCountTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
