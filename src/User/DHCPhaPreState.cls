/// hulihua 2017-12-22 新疆中医院 处方追踪状态字典表
/// d ##Class(User.DHCPhaPreState).%BuildIndices()
Class User.DHCPhaPreState Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PREST_RowId, SqlTableName = DHC_PhaPreState, StorageStrategy = SQLStorage ]
{

/// 代码
Property PRESTCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PREST_Code ];

/// 描述
Property PRESTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PREST_Desc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHAPSTATE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PREST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PREST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHAPSTATE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PREST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PREST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPHAPSTATEi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"STATECODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PREST_Code})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHAPSTATEi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PREST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"STATEDESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PREST_Desc})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PREST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaPreStateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
