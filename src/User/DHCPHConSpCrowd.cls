Class User.DHCPHConSpCrowd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHConSpCd_RowID, SqlTableName = DHC_PHConSpCrowd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHConSpCd_Code
Property PHConSpCdCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHConSpCd_Code ];

/// PHConSpCd_Desc
Property PHConSpCdDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHConSpCd_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCONSC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHConSpCd_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHConSpCd_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHCONSC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PHConSpCd_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHConSpCd_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHConSpCrowdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCONSC)
	s oldI = +$g(^mdata("DHCPHCONSPCROWD"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCONSC = maxI
	s ^mdata("DHCPHCONSPCROWD") = maxI
}

}
