Class User.PHAINPrintLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPL_RowId, SqlTableName = PHAIN_PrintLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 打印日期
Property PPLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PPL_Date ];

/// 打印时间
Property PPLTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PPL_Time ];

/// G/M 药品/材料
Property PPLStkType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PPL_StkType ];

/// 打印人
Property PPLUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PPL_User_Dr ];

/// 单据类型(业务主表类名称,如:DHCINGdRec)
Property PPLType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPL_Type ];

/// 打印单据id
Property PPLPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPL_Pointer ];

/// 打印次数
Property PPLPrintTimes As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PPL_PrintTimes ];

/// 打印MAC地址
Property PPLMACAdd As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PPL_MACAdd ];

/// 打印IP地址
Property PPLIPAdd As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PPL_IPAdd ];

/// 备注
Property PPLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PPT_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^BS.ST.PHAIN.PLOG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PPL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPL_IPAdd">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPL_MACAdd">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPL_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPL_PrintTimes">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPL_StkType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPL_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPL_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^BS.ST.PHAIN.PLOG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^BS.ST.PHAIN.PLOGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPL_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^BS.ST.PHAIN.PLOGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PPL_Type})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPL_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PPL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAINPrintLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^BS.ST.PHAIN.PLOG)
	s oldI = +$g(^mdata("^BS.ST.PHAIN.PLOG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^BS.ST.PHAIN.PLOG = maxI
	s ^mdata("^BS.ST.PHAIN.PLOG") = maxI
}

}
