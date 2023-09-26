Class User.DHCStandardName Extends (%Persistent, User.Abstract) [ SqlRowIdName = Standard_RowId, SqlTableName = DHC_StandardName, StorageStrategy = SQLStorage ]
{

Property StandardCode As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Standard_Code ];

Property StandardDesc As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Standard_Desc ];

Property StandardAlias As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Standard_Alias ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^STDNAME)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Standard_Alias">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Standard_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Standard_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^STDNAME</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Standard_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{Standard_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^STDNAME</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Standard_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Standard_Alias}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Standard_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^STDNAME</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Standard_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({Standard_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Standard_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Standard_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStandardNameS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^STDNAME)
	s oldI = +$g(^mdata("DHCSTANDARDNAME"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^STDNAME = maxI
	s ^mdata("DHCSTANDARDNAME") = maxI
}

}
