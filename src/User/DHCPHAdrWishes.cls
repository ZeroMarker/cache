Class User.DHCPHAdrWishes Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRW_RowID, SqlTableName = DHC_PHAdrWishes, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ADRW_Code
Property ADRWCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADRW_Code ];

/// ADRW_Desc
Property ADRWDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRW_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHADRW)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADRW_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADRW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADRW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADRW_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrWishesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
