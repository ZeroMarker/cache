/// DHC_ANC_LaryngMaskAirway
Class User.DHCANCLaryngMaskAirway Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCLMA_RowId, SqlTableName = DHC_ANC_LaryngMaskAirway, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCLMA_Code
Property ANCLMACode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCLMA_Code ];

/// ANCLMA_Desc
Property ANCLMADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCLMA_Desc ];

Index ANCLMACodeUnqIdx1 On ANCLMACode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("LMA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCLMA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCLMA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCLMA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LMA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCLMA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCLaryngMaskAirwayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
