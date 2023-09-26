Class User.PHAHERBSupplyReq Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHSR_RowID, SqlTableName = PHAHERB_SupplyReq, StorageStrategy = SQLStorage ]
{

/// 药品
Property PHSRINCIDr As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = PHSR_INCI_Dr ];

/// 申请人
Property PHSRReqUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PHSR_ReqUser_Dr ];

/// 申请日期
Property PHSRReqDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = PHSR_ReqDate ];

/// 申请时间
Property PHSRReqTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PHSR_ReqTime ];

/// 紧急标记
Property PHSRUrgentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = PHSR_UrgentFlag ];

/// 状态
Property PHSRStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHSR_Status ];

/// 确认人
Property PHSRConfirmUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PHSR_ConfirmUser_Dr ];

/// 确认日期
Property PHSRConfirmDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = PHSR_ConfirmDate ];

/// 确认时间
Property PHSRConfirmTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PHSR_ConfirmTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.PHA.HERB.SupplyReq)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHSR_ConfirmDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHSR_ConfirmTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHSR_ConfirmUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHSR_INCI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHSR_ReqDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHSR_ReqTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHSR_ReqUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHSR_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHSR_UrgentFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BS.PHA.HERB.SupplyReq</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHSR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInciUserStatus">
<Global>^BS.PHA.HERB.SupplyReqi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"InciUserStatus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHSR_INCI_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSR_ReqUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSR_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHSR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusDate">
<Global>^BS.PHA.HERB.SupplyReqi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"StatusDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHSR_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSR_ReqDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAHERBSupplyReqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^BS.PHA.HERB.SupplyReq)
	s oldI = +$g(^mdata("PHAHERBSUPPLYREQ"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^BS.PHA.HERB.SupplyReq = maxI
	s ^mdata("PHAHERBSUPPLYREQ") = maxI
}

}
