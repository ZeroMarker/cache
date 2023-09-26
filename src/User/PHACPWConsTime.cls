/// Description:新建服务时间
/// Creator:lbb
Class User.PHACPWConsTime Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CT_RowID, SqlTableName = PHACPW_ConsTime, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CT_Code
Property CTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CT_Code ];

/// CT_Desc
Property CTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CT_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CD.PHA.CPW.ConsTime)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CD.PHA.CPW.ConsTime</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHACPWConsTimeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.CPW.ConsTime)
	s oldI = +$g(^mdata("PHACPWCONSTIME"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.CPW.ConsTime = maxI
	s ^mdata("PHACPWCONSTIME") = maxI
}

}
