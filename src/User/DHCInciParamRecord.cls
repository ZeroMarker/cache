Class User.DHCInciParamRecord Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = INCIP_RowId, SqlTableName = DHC_InciParamRecord, StorageStrategy = SQLStorage ]
{

/// 表结构字段描述
Property INCIPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INCIP_Desc ];

/// 表结构字段
Property INCIPParamName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INCIP_ParamName ];

Property INCIPActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 4, SqlFieldName = INCIP_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINCIP)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="INCIP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCIP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCIP_ParamName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINCIP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCIP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INCIP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ParamIndex">
<Global>^DHCINCIP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCIP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"param"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCIP_ParamName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCIP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCIP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCInciParamRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINCIP)
	s oldI = +$g(^mdata("DHCInciParamRecord"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINCIP = maxI
	s ^mdata("DHCInciParamRecord") = maxI
}

}
