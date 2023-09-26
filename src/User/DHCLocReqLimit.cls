Class User.DHCLocReqLimit Extends (%Persistent, User.Abstract) [ SqlRowIdName = LRL_RowId, SqlTableName = DHC_LocReqLimit, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCLocItmLimitAmt As User.DHCLocItmLimitAmt [ Cardinality = children, Inverse = LRLIParrfe ];

/// 科室
Property LRLCTLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = LRL_CTLoc_DR ];

/// 起始日期
Property LRLStartDate As %Library.Date [ SqlColumnNumber = 3, SqlFieldName = LRL_StartDate ];

/// 截止日期
Property LRLEndDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = LRL_EndDate ];

/// 限额
Property LRLReqAmt As %Library.Float(MAXVAL = 999999999999) [ SqlColumnNumber = 5, SqlFieldName = LRL_ReqAmt ];

/// 已用额度
Property LRLUsedAmt As %Library.Float(MAXVAL = 999999999999) [ SqlColumnNumber = 6, SqlFieldName = LRL_UsedAmt ];

/// 汇总限定类型(未使用)
Property LRLLimitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = LRL_LimitType ];

/// 汇总周期
Property LRLPeriodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = LRL_PeriodType ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCLRL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LRL_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LRL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LRL_LimitType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LRL_PeriodType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LRL_ReqAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LRL_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LRL_UsedAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCLRL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LRL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LRL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCLRL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LRL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRL_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LRL_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LRL_EndDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LRL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocId">
<Global>^DHCLRL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LRL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LRL_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LRL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LRL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLocReqLimitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCLRL)
	s oldI = +$g(^mdata("DHCLOCREQLIMIT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCLRL = maxI
	s ^mdata("DHCLOCREQLIMIT") = maxI
}

}
