Class User.DHCEQQCustorm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = C_RowID, SqlTableName = DHC_EQQCustorm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// C_Desc
Property CDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = C_Desc ];

/// C_InvaildFlag
Property CInvaildFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = C_InvaildFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQQ("DHCEQQCustorm",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="C_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="C_InvaildFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQQ</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQQCustorm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{C_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQQCustormS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
