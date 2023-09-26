Class User.PHAINMobMenu Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIMM_RowID, SqlTableName = PHAIN_MobMenu, StorageStrategy = SQLStorage ]
{

Property PIMMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PIMM_Code ];

Property PIMMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PIMM_Desc ];

Property PIMMProDr As User.DHCStkSysPro [ SqlColumnNumber = 4, SqlFieldName = PIMM_Pro_Dr ];

Property PIMMIcon As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5, SqlFieldName = PIMM_Icon ];

Property PIMMGroupName As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 6, SqlFieldName = PIMM_GroupName ];

Property PIMMGoPage As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7, SqlFieldName = PIMM_GoPage ];

Property PIMMActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PIMM_ActiveFlag ];

Property PIMMSort As %Library.Integer [ SqlColumnNumber = 9, SqlFieldName = PIMM_Sort ];

Storage SQLStorage
{
<ExtentSize>85</ExtentSize>
<SqlIdExpression>$i(^CD.PHA.IN.MobMenu)</SqlIdExpression>
<SQLMap name="DataMaster">
<BlockCount>-4</BlockCount>
<Data name="PIMM_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIMM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIMM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIMM_GoPage">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIMM_GroupName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIMM_Icon">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIMM_Pro_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIMM_Sort">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CD.PHA.IN.MobMenu</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIMM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIMM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPro">
<BlockCount>-4</BlockCount>
<Global>^CD.PHA.IN.MobMenui</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIMM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Pro"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIMM_Pro_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIMM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PIMM_RowID</SqlRowIdName>
<StreamLocation>^User.PHAINMobMenuS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.IN.MobMenu)
	s oldI = +$g(^mdata("^CD.PHA.IN.MobMenu"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.IN.MobMenu = maxI
	s ^mdata("^CD.PHA.IN.MobMenu") = maxI
}

}
