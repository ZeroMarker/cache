Class User.DHCVideo Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = V_Rowid, SqlTableName = DHC_Video, StorageStrategy = SQLStorge ]
{

Property VApp As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = V_App ];

Property VName As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = V_Name ];

Storage SQLStorge
{
<SqlIdExpression>$i(^DHCVIDEO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="V_App">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="V_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCVIDEO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>V_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{V_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>V_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCVideoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCVIDEO)
	s oldI = +$g(^mdata("DHCVIDEO"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCVIDEO = maxI
	s ^mdata("DHCVIDEO") = maxI
}

}
