Class User.PHAINMenuConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIMC_RowID, SqlTableName = PHAIN_MenuConfig, StorageStrategy = SQLStorage ]
{

Relationship ChildPHAINMenuConfigItm As User.PHAINMenuConfigItm [ Cardinality = children, Inverse = PIMCIPIMCParRef ];

Property PIMCType As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PIMC_Type ];

Property PIMCPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PIMC_Pointer ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.MenuConfig)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PIMC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIMC_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.PHA.IN.MenuConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIMC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIMC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^CF.PHA.IN.MenuConfig</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PIMC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIMC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIMC_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIMC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PIMC_RowID</SqlRowIdName>
<StreamLocation>^User.PHAINMenuConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.MenuConfig)
	s oldI = +$g(^mdata("^CF.PHA.IN.MenuConfig"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.MenuConfig = maxI
	s ^mdata("^CF.PHA.IN.MenuConfig") = maxI
}

}
