Class User.PHACPWConsWays Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CW_RowID, SqlTableName = PHACPW_ConsWays, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CW_Code
Property CWCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CW_Code ];

/// CW_Desc
Property CWDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CW_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CD.PHA.CPW.ConsWays)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="CW_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CD.PHA.CPW.ConsWays</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CW_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHACPWConsWaysS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.CPW.ConsWays)
	s oldI = +$g(^mdata("PHACPWCONSWAYS"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.CPW.ConsWays = maxI
	s ^mdata("PHACPWCONSWAYS") = maxI
}

}
