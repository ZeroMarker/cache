Class User.DHCPHMedAndLifeTips Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PHMed_RowID, SqlTableName = DHC_PHMedAndLifeTips, StorageStrategy = NewStorage1 ]
{

Property PHMedPHCDDR As PHCDrgMast [ SqlColumnNumber = 2, SqlFieldName = PHMed_PHCD_DR ];

Property PHMedCode As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHMed_Code ];

Property PHMedDesc As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHMed_Desc ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCPHMLT)</SqlIdExpression>
<SQLMap name="Data">
<Data name="PHMed_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMed_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMed_PHCD_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHMLT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMed_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMed_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCPHMLT</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHMed_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"M"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMed_PHCD_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMed_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHMed_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPHMedAndLifeTipsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHMLT)
	s oldI = +$g(^mdata("^DHCPHMLT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHMLT = maxI
	s ^mdata("^DHCPHMLT") = maxI
}

}
