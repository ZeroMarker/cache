Class User.DHCPayMode Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = PayMode_RowID, SqlTableName = DHC_PayMode, StorageStrategy = SQLStorage ]
{

Property PayModeCode As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PayMode_Code ];

Property PayModeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PayMode_Desc ];

Property PayModeDefaultFlage As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PayMode_DefaultFlage ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPAYMODE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PayMode_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PayMode_DefaultFlage">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PayMode_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPAYMODE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PayMode_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PayMode_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PayMode_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPAYMODE)
	s oldI = +$g(^mdata("DHCPAYMODE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPAYMODE = maxI
	s ^mdata("DHCPAYMODE") = maxI
}

}
