Class User.DHCMatAuditLevel Extends (%Persistent, User.Abstract) [ SqlRowIdName = DMAL_RowId, SqlTableName = DHC_MatAuditLevel, StorageStrategy = SQLStorage ]
{

Property DMALType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DMAL_Type ];

Property DMALLevel As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DMAL_Level ];

Property DMALActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DMAL_ActiveFlag ];

Property DMALSSGroup As User.SSGroup [ SqlColumnNumber = 5, SqlFieldName = DMAL_SSGroup ];

Property STALItmLocDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = DMAL_Loc_Dr ];

Property DMALSSuserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DMAL_SSuser_Dr ];

Property DMALSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 8, SqlFieldName = DMAL_SCG_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DMALM)</SqlIdExpression>
<SQLMap name="IndexTypeLevel">
<Global>^DMALM</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DMAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"typelevel"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DMAL_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DMAL_Level}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DMAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeScgLevel">
<Global>^DMALM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DMAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"typesgclevel"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DMAL_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DMAL_SCG_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DMAL_Level}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{DMAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeUser">
<Global>^DMALM</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DMAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMAL_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DMAL_SSuser_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DMAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DMAL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DMAL_Level">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMAL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DMAL_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DMAL_SSGroup">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DMAL_SSuser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DMAL_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DMALM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DMAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DMAL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DMAL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMatAuditLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DMALM)
	s oldI = +$g(^mdata("DHCMatAuditLevel"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DMALM = maxI
	s ^mdata("DHCMatAuditLevel") = maxI
}

}
