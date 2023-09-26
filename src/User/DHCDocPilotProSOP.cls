Class User.DHCDocPilotProSOP Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPSOP_RowId, SqlTableName = DHC_DocPilotProSOP, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SOP主题
Property SOPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PPSOP_Desc ];

/// 最早制定日期
Property SOPFirstDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PPSOP_FirstDate ];

/// 更新次数
Property SOPUpdateCount As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PPSOP_UpdateCount ];

/// 最新跟新日期
Property SOPNewDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PPSOP_NewDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDocPPSOP)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PPSOP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPSOP_FirstDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPSOP_NewDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPSOP_UpdateCount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocPPSOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPSOP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPSOP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProSOPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
