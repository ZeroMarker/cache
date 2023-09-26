Class User.DHCPHAdrPatImpoInfo Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRII_RowID, SqlTableName = DHC_PHAdrPatImpoInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ADRII_Code
Property ADRIICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADRII_Code ];

/// ADRII_Desc
Property ADRIIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRII_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHADRII)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADRII_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRII_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADRII</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADRII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADRII_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrPatImpoInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
