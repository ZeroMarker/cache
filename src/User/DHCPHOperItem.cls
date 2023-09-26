Class User.DHCPHOperItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHOI_RowId, SqlTableName = DHCPH_OperItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHOI_Code  手术编码[唯一标示手术,必填]
Property PHOICode As %Library.String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHOI_Code ];

/// PHOI_Desc  手术名称
Property PHOIDesc As %Library.String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHOI_Desc ];

/// PHOI_CateGroy_Dr  手术分类
Property PHOICateGroyDr As User.DHCPHOperCateGory [ SqlColumnNumber = 4, SqlFieldName = PHOI_CateGroy_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHOI)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="PHOI_CateGroy_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHOI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHOI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHOI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PHOI_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHOI_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHOperItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHOI)
	s oldI = +$g(^mdata("DHCPHOperItem"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHOI = maxI
	s ^mdata("DHCPHOperItem") = maxI
}

}
