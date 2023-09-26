Class User.DHCPhaDeliveryman Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHC_PhaRowID, SqlTableName = DHC_PhaDeliveryman, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHC_PhaUserCode
Property DHCPhaUserCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHC_PhaUserCode ];

/// DHC_PhaUserName
Property DHCPhaUserName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHC_PhaUserName ];

/// DHC_PhaDateTo
Property DHCPhaDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHC_PhaDateTo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHADEM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHC_PhaDateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHC_PhaUserCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_PhaUserName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaDeliverymanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
