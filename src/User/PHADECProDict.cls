/// 煎药流程字典表 2019-05-30 hulihua 
/// d ##Class(User.PHADECProDict).%BuildIndices()
Class User.PHADECProDict Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDPD_RowId, SqlTableName = PHA_DECProDict, StorageStrategy = SQLStorage ]
{

/// 代码
Property PDPDCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PDPD_Code ];

/// 名称
Property PDPDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PDPD_Desc ];

/// 标志号
Property PDPDGID As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = PDPD_GID ];

/// 系统流程标志
Property PDPDSysFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = PDPD_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CD.PHA.DEC.PD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDPD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDPD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDPD_GID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDPD_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CD.PHA.DEC.PD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDPD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDPD_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CD.PHA.DEC.PDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PDPD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PDPD_Code})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGid">
<Global>^CD.PHA.DEC.PDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PDPD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"GID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPD_GID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHADECProDictS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.DEC.PD)
	s oldI = +$g(^mdata("PHADECProDict"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.DEC.PD = maxI
	s ^mdata("PHADECProDict") = maxI
}

}
