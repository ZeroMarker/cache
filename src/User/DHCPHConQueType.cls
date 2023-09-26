Class User.DHCPHConQueType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCONQT_RowID, SqlTableName = DHC_PHConQueType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHCONT_Code
Property PHCONQTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHCONQT_Code ];

/// PHCONT_Desc
Property PHCONQTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHCONQT_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCONQT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHCONQT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCONQT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHCONQT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCONQT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHCONQT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHConQueTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCONQT)
	s oldI = +$g(^mdata("DHCPHCONQUETYPE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCONQT = maxI
	s ^mdata("DHCPHCONQUETYPE") = maxI
}

}
