Class User.PIVAWorkType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIVAWT_Rowid, SqlTableName = PIVA_WorkType, StorageStrategy = SQLStorage ]
{

Relationship ChildPIVAWorkTypeItm As User.PIVAWorkTypeItm [ Cardinality = children, Inverse = PIVAWTIParref ];

/// 科室Id
Property PIVAWTLOCDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = PIVAWT_LOC_DR ];

/// 代码
Property PIVAWTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PIVAWT_Code ];

/// 名称
Property PIVAWTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PIVAWT_Desc ];

/// 打印方式
Property PIVAWTPrtWay As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PIVAWT_PrtWay ];

/// 是否在用
Property PIVAWTUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PIVAWT_UseFlag ];

/// 默认
Property PIVAWTDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PIVAWT_Default ];

/// 优先级
Property PIVAWTOrdNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PIVAWT_OrdNum ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PIVAWT)</SqlIdExpression>
<SQLMap name="DataMasterPIVAWT">
<Data name="PIVAWT_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIVAWT_Default">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIVAWT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIVAWT_LOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIVAWT_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIVAWT_PrtWay">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIVAWT_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PIVAWT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVAWT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVAWT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PIVAWTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVAWT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIVAWT_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVAWT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVAWT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PIVAWTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIVAWT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIVAWT_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVAWT_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVAWT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^PIVAWTi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIVAWT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIVAWT_LOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVAWT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVAWorkTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PIVAWT)
	s oldI = +$g(^mdata("PIVAWorkType"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PIVAWT = maxI
	s ^mdata("PIVAWorkType") = maxI
}

}
