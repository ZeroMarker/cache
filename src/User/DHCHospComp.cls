/// 医院对照表
Class User.DHCHospComp Extends (%Persistent, User.Abstract) [ SqlRowIdName = HospComp_RowId, SqlTableName = DHC_HospComp, StorageStrategy = SQLStorage ]
{

/// 医院id
Property HospCompHospIdDR As User.CTHospital [ Required, SqlColumnNumber = 2, SqlFieldName = HospComp_HospId_DR ];

/// 第三方医院代码
Property HospCompCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = HospComp_Code ];

/// 第三方医院名称
Property HospCompDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = HospComp_Desc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCHOSPCOMP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HospComp_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HospComp_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HospComp_HospId_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCHOSPCOMP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HospComp_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HospComp_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HospComp_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHospCompS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHOSPCOMP)
	s oldI = +$g(^mdata("DHCHOSPCOMP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHOSPCOMP = maxI
	s ^mdata("DHCHOSPCOMP") = maxI
}

}
