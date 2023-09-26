Class User.DHCEQQType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = T_RowID, SqlTableName = DHC_EQQType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// T_Desc
Property TDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = T_Desc ];

/// T_InvaildFlag
Property TInvaildFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = T_InvaildFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQQ("DHCEQQType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="T_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="T_InvaildFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQQ</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQQType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{T_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQQTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
