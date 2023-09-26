/// 煎药流程定制表 2019-05-30 hulihua 
/// d ##Class(User.PHADECProSto).%BuildIndices()
Class User.PHADECProSto Extends %Persistent [ ClassType = persistent, SqlRowIdName = PDPS_RowId, SqlTableName = PHA_DECProSto, StorageStrategy = SQLStorage ]
{

/// 流程字典外键
Property PDPSProDictDr As User.PHADECProDict [ SqlColumnNumber = 2, SqlFieldName = PDPS_ProDict_Dr ];

/// 是否使用
Property PDPSActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = PDPS_ActiveFlag ];

/// 定制类型
Property PDPSType As %Library.String(DISPLAYLIST = ",In,Out", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 4, SqlFieldName = PDPS_Type ];

/// 煎药室ID
Property PDPSLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PDPS_Loc_Dr ];

/// 流程顺序号
Property PDPSSeqNo As %Library.Integer [ SqlColumnNumber = 6, SqlFieldName = PDPS_SeqNo ];

/// 是否自动执行此流程
Property PDPSExeNextFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PDPS_ExeNextFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.DEC.PS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDPS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDPS_ExeNextFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDPS_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDPS_ProDict_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDPS_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDPS_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.DEC.PS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDPS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDPS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocTypeDict">
<Global>^CF.PHA.DEC.PSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDPS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOCTYPEDICT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPS_Loc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPS_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDPS_ProDict_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDPS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTypeSeqNo">
<Global>^CF.PHA.DEC.PSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PDPS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOCTYPEDEQNO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPS_Loc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPS_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDPS_ActiveFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDPS_SeqNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PDPS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHADECProStoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.DEC.PS)
	s oldI = +$g(^mdata("PHADECProSto"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.DEC.PS = maxI
	s ^mdata("PHADECProSto") = maxI
}

}
