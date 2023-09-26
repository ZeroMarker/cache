Class User.DHCEQQUser Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = U_RowID, SqlTableName = DHC_EQQUser, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// U_Desc
Property UDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = U_Desc ];

/// U_InvaildFlag
Property UInvaildFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = U_InvaildFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQQ("DHCEQQUSER",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="U_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="U_InvaildFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQQ</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>U_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQQUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{U_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQQUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
