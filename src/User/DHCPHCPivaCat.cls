Class User.DHCPHCPivaCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHCPivaCat_RowId, SqlTableName = DHC_PHCPivaCat, StorageStrategy = SQLStorage ]
{

/// Code
Property PHCPivaCatCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHCPivaCat_Code ];

/// Description
Property PHCPivaCatDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PHCPivaCat_Desc ];

/// 输液注意事项
Property PHCPivaCatAttention As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHCPivaCat_Attention ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PHCPIVACAT)</SqlIdExpression>
<SQLMap name="IndexPHCPCode">
<Global>^PHCPIVACAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCPivaCat_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PHCPivaCat_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCPivaCat_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCPDesc">
<Global>^PHCPIVACAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCPivaCat_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PHCPivaCat_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCPivaCat_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHCPivaCat_Attention">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCPivaCat_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCPivaCat_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCPIVACAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCPivaCat_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHCPivaCat_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCPivaCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PHCPIVACAT)
	s oldI = +$g(^mdata("DHCPHCPivaCat"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PHCPIVACAT = maxI
	s ^mdata("DHCPHCPivaCat") = maxI
}

}
