Class User.DHCSourceOfFund Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SOF_RowId, SqlTableName = DHC_SourceOfFund, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SOF_Code
Property SOFCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SOF_Code ];

/// SOF_Desc
Property SOFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SOF_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSOUROFFUND)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SOF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SOF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSOUROFFUND</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SOF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SOF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSourceOfFundS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSOUROFFUND)
	s oldI = +$g(^mdata("DHCSOUROFFUND"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSOUROFFUND = maxI
	s ^mdata("DHCSOUROFFUND") = maxI
}

}
