Class User.DHCPHDrgSugDic Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSD_RowID, SqlTableName = DHC_PHDrgSugDic, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSD_Code
Property DSDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DSD_Code ];

/// DSD_Desc
Property DSDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DSD_Desc ];

/// CR - CareRemark，关注备注 , AD - Adivce，用药建议
Property DSDType As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DSD_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHDSD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DSD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSD_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHDSD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DSD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCPHDSDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSD_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDrgSugDicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHDSD)
	s oldI = +$g(^mdata("DHCPHDRGSUGDIC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHDSD = maxI
	s ^mdata("DHCPHDRGSUGDIC") = maxI
}

}
