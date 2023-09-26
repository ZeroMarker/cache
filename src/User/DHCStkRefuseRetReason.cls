Class User.DHCStkRefuseRetReason Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_StkRefuseRetReason, StorageStrategy = SQLStorage ]
{

/// RefRet_Code
Property RefRetCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RefRet_Code ];

/// RefRet_Desc
Property RefRetDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RefRet_Desc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCRFRETREASON)</SqlIdExpression>
<SQLMap name="DHCRFRETREASON">
<Data name="RefRet_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RefRet_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRFRETREASON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RefRet_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RefRet_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RefRet_ROWID</SqlRowIdName>
<StreamLocation>^User.DHCStkRefuseRetReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCRFRETREASON)
	s oldI = +$g(^mdata("DHCSTKREFUSERETREASON"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCRFRETREASON = maxI
	s ^mdata("DHCSTKREFUSERETREASON") = maxI
}

}
