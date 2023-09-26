/// Description:新建咨询身份表
/// Creator:lbb
Class User.PHACPWConsIden Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CI_RowID, SqlTableName = PHACPW_ConsIden, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CI_Code
Property CICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CI_Code ];

/// CI_Desc
Property CIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CI_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CD.PHA.CPW.ConsIden)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="CI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CD.PHA.CPW.ConsIden</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHACPWConsIdenS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.CPW.ConsIden)
	s oldI = +$g(^mdata("PHACPWCONSIDEN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.CPW.ConsIden = maxI
	s ^mdata("PHACPWCONSIDEN") = maxI
}

}
