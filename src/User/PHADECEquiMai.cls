/// 煎药设备维护表 2019-05-30 hulihua 
/// d ##Class(User.PHADECEquiMai).%BuildIndices()
Class User.PHADECEquiMai Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PDEM_RowId, SqlTableName = PHA_DECEquiMai, StorageStrategy = SQLStorage ]
{

/// 设备代码
Property PDEMCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PDEM_Code ];

/// 设备名称
Property PDEMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PDEM_Desc ];

/// 是否使用
Property PDEMActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PDEM_ActiveFlag ];

/// 煎药室ID
Property PDEMLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PDEM_Loc_Dr ];

/// 设备状态(R-维修，S-报废，T-暂停，Y-正常)
Property PDEMStatus As %Library.String(DISPLAYLIST = ",Repair,Scrap,Timeout,Yes", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",R,S,T,Y") [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = PDEM_Status ];

/// 是否空闲
Property PDEMFreeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 7, SqlFieldName = PDEM_FreeFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.DEC.EM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDEM_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDEM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDEM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDEM_FreeFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDEM_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDEM_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CF.PHA.DEC.EM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDEM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDEM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDecLocActive">
<Global>^CF.PHA.DEC.EMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDEM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DECLOCACTIVE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDEM_Loc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDEM_ActiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDEM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocStatusCode">
<Global>^CF.PHA.DEC.EMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDEM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LocStatusCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDEM_Loc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDEM_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDEM_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDEM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHADECEquiMaiS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.DEC.EM)
	s oldI = +$g(^mdata("PHADECEquiMai"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.DEC.EM = maxI
	s ^mdata("PHADECEquiMai") = maxI
}

}
