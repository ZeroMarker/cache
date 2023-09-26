Class User.DHCDocPatGuide Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_DocPatGuide, StorageStrategy = SQLStorage ]
{

/// PG_Type 类型
Property PGType As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PG_Type ];

/// PG_PrjDR 项目
Property PGPrjDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PG_PrjDR ];

/// PG_OrdLoc 开单科室
Property PGOrdLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PG_OrdLoc ];

/// PG_AcceptLoc 接受科室
Property PGAcceptLoc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PG_AcceptLoc ];

/// PG_STime 开单时间
Property PGSTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PG_STime ];

/// PG_ETime 结束时间
Property PGETime As %Time [ SqlColumnNumber = 7, SqlFieldName = PG_ETime ];

/// PG_Site 导诊位置
Property PGSite As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PG_Site ];

/// PG_IsDetail 是否显示明显
Property PGIsDetail As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PG_IsDetail ];

/// PG_HospDr 使用院区
Property PGHospDr As CTHospital [ SqlColumnNumber = 10, SqlFieldName = PG_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.DOC.PatGuide(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PG_AcceptLoc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PG_ETime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PG_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PG_IsDetail">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PG_OrdLoc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PG_PrjDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PG_STime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PG_Site">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PG_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.DOC.PatGuide</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPGType">
<Global>^CF.DOC.PatGuideI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PGType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeAcceptLoc">
<Global>^CF.DOC.PatGuideI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TypeAcceptLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PG_AcceptLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeOrdLoc">
<Global>^CF.DOC.PatGuideI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TypeOrdLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PG_OrdLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePrj">
<Global>^CF.DOC.PatGuideI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TypePrj"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PG_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PG_PrjDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocPatGuideS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
