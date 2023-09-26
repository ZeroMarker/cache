Class User.ARCSKTINFO Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SKT_ROWID, SqlTableName = ARC_SKTINFO, StorageStrategy = SQLStorage ]
{

/// $i(^mdata("ARCSKTINFO"))
Parameter EXTENTSIZE = 250;

/// SKT_ARCIM_DR
Property SKTARCIMDR As ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = SKT_ARCIM_DR ];

/// SKT_REARCIM_DR
Property SKTREARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = SKT_REARCIM_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^ARCSKT)</SqlIdExpression>
<SQLMap name="IndexSKT">
<Global>^ARCSKTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SKT_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SKINTEST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SKT_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SKT_REARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SKT_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="SKT_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SKT_REARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARCSKT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SKT_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SKT_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>User.ARCSKTINFOS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^ARCSKT)
	s oldI = +$g(^mdata("ARCSKTINFO"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^ARCSKT = maxI
	s ^mdata("ARCSKTINFO") = maxI
}

}
