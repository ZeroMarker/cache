/// DHC_ANC_Floor
Class User.DHCANCFloor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCF_RowId, SqlTableName = DHC_ANC_Floor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCF_Code
Property ANCFCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCF_Code ];

/// ANCF_Desc
Property ANCFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCF_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("Floor",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Floor"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCFloorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
