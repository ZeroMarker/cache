/// ICD诊断分类
/// add by chenying bdp
/// 2019-03-29
Class User.MRCICDDxType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ICDTYPE_RowId, SqlTableName = MRC_ICDDxType, StorageStrategy = SQLStorage ]
{

/// 代码
Property ICDTYPECode As %String(COLLATION = "Upper", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ICDTYPE_Code ];

/// 描述
Property ICDTYPEDesc As %String(COLLATION = "Upper", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ICDTYPE_Desc ];

/// 开始日期
Property ICDTYPEDateFrom As %Date [ Required, SqlColumnNumber = 4, SqlFieldName = ICDTYPE_DateFrom ];

/// 结束日期
Property ICDTYPEDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ICDTYPE_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("ICDTYPE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICDTYPE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICDTYPE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICDTYPE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICDTYPE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ICDTYPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICDTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ICDTYPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICDTYPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICDTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({ICDTYPE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICDTYPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICDTYPE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICDTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({ICDTYPE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICDTYPE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICDTYPE_RowId</SqlRowIdName>
<StreamLocation>^User.MRCICDDxTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
