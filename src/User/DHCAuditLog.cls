Class User.DHCAuditLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = MALG_RowId, SqlTableName = DHC_AuditLog, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAuditLogINCI As User.DHCAuditLogINCI [ Cardinality = children, Inverse = MALGINCIParref ];

Property MALGDate As %Library.Date [ SqlColumnNumber = 2, SqlFieldName = MALG_Date ];

Property MALGTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = MALG_Time ];

Property MALGUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = MALG_User_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMALG)</SqlIdExpression>
<SQLMap name="IndexDate">
<Global>^DHCMALG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MALG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MALG_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MALG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MALG_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MALG_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MALG_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMALG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MALG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MALG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MALG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAuditLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMALG)
	s oldI = +$g(^mdata("DHCAuditLog"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMALG = maxI
	s ^mdata("DHCAuditLog") = maxI
}

}
