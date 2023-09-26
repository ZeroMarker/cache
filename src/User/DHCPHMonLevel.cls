Class User.DHCPHMonLevel Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHML_RowID, SqlTableName = DHC_PHMonLevel, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHML_Code  代码
Property PHMLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHML_Code ];

/// PHML_Desc  描述
Property PHMLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHML_Desc ];

/// PHML_Color 颜色
Property PHMLColor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHML_Color ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHML)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHML_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHML_Color">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHML_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHML</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHML_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHML_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHML)
	s oldI = +$g(^mdata("DHCPHMONLEVEL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHML = maxI
	s ^mdata("DHCPHMONLEVEL") = maxI
}

}
