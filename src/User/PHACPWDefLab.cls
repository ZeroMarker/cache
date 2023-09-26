Class User.PHACPWDefLab Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DL_RowID, SqlTableName = PHACPW_DefLab, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DL_Code  代码
Property DLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DL_Code ];

/// DL_Desc  描述
Property DLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DL_Desc ];

Storage SQLStorage
{
<Data name="PHACPWDefLabDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DLCode</Value>
</Value>
<Value name="3">
<Value>DLDesc</Value>
</Value>
</Data>
<DataLocation>^User.PHACPWDefLabD</DataLocation>
<DefaultData>PHACPWDefLabDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.PHACPWDefLabD</IdLocation>
<IndexLocation>^User.PHACPWDefLabI</IndexLocation>
<SqlIdExpression>$i(^CD.PHA.CPW.DefLab)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CD.PHA.CPW.DefLab</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHACPWDefLabS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.CPW.DefLab)
	s oldI = +$g(^mdata("PHACPWDefLab"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.CPW.DefLab = maxI
	s ^mdata("PHACPWDefLab") = maxI
}

}
