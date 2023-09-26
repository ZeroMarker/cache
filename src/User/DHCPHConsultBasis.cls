Class User.DHCPHConsultBasis Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCONTB_RowID, SqlTableName = DHC_PHConsultBasis, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHCONTB_Code
Property PHCONTBCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHCONTB_Code ];

/// PHCONTB_Desc
Property PHCONTBDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHCONTB_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCONTB)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHCONTB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCONTB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHCONTB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PHCCONTN_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHCONTB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHConsultBasisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCONTB)
	s oldI = +$g(^mdata("DHCPHCONSULTBASIS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCONTB = maxI
	s ^mdata("DHCPHCONSULTBASIS") = maxI
}

}
