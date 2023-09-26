Class User.DHCPHProfDirection Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPD_RowID, SqlTableName = DHC_PHProfDirection, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHPD_Code
Property PHPDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHPD_Code ];

/// PHPD_Desc
Property PHPDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHPD_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHPDT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHPD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHPD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHPDT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHPD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHPD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHProfDirectionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHPDT)
	s oldI = +$g(^mdata("DHCPHPROFDIRECTION"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHPDT = maxI
	s ^mdata("DHCPHPROFDIRECTION") = maxI
}

}
