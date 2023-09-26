Class User.DHCPHOperCateGory Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHOCG_RowId, SqlTableName = DHCPH_OperCateGory, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHOCG_Code  手术类别编码
Property PHOCGCode As %Library.String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHOCG_Code ];

/// PHOCG_Desc  手术类别名称
Property PHOCGDesc As %Library.String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PHOCG_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHOCG)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="PHOCG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHOCG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHOCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PHOCG_Row}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHOCG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHOperCateGoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHOCG)
	s oldI = +$g(^mdata("DHCPHOperCateGory"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHOCG = maxI
	s ^mdata("DHCPHOperCateGory") = maxI
}

}
