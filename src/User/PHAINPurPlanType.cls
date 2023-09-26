Class User.PHAINPurPlanType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPT_RowId, SqlTableName = PHAIN_PurPlanType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 代码
Property PPTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PPT_Code ];

/// 描述
Property PPTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPT_Desc ];

/// 激活标志
Property PPTActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PPT_ActiveFlag ];

/// G/M 药品/材料
Property PPTStkType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPT_StkType ];

/// 备注
Property PPTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPT_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PINPPT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PPT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPT_StkType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PINPPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^PINPPTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ACTIVE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPT_ActiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PINPPTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PINPPTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPT_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAINPurPlanTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PINPPT)
	s oldI = +$g(^mdata("PHAINPPT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PINPPT = maxI
	s ^mdata("PHAINPPT") = maxI
}

}
