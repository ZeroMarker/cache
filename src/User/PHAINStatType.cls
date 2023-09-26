Class User.PHAINStatType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PINST_RowID, SqlTableName = PHAIN_StatType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildPHAINStatCat As User.PHAINStatCat [ Cardinality = children, Inverse = PINSCSTParref ];

/// PINST_Code
Property PINSTCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PINST_Code ];

/// PINST_Desc
Property PINSTDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PINST_Desc ];

/// PINST_Remarks
Property PINSTRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PINST_Remarks ];

Index PINSTCodeUnqIdx1 On PINSTCode;

// Unique

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CD.PHA.IN.STAT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PINST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PINST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PINST_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CD.PHA.IN.STAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PINST_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PINST_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CD.PHA.IN.STATi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PINST_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PINST_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PINST_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAINStatTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.IN.STAT)
	s oldI = +$g(^mdata("PHAINStatType"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.IN.STAT = maxI
	s ^mdata("PHAINStatType") = maxI
}

}
