/// CTOR: QP
/// DATE: 2019-01-18
/// DESC: 医生班次表
Class User.DHCDocPassWorkBcs Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_DocPassWorkBcs, StorageStrategy = SQLStorage ]
{

/// BC_Code 班次代码
Property BCCode As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BC_Code ];

/// BC_Name 班次名称
Property BCName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BC_Name ];

/// BC_STime 开始时间
Property BCSTime As %Time [ SqlColumnNumber = 4, SqlFieldName = BC_STime ];

/// BC_ETime 结束时间
Property BCETime As %Time [ SqlColumnNumber = 5, SqlFieldName = BC_ETime ];

/// BC_IsNextDay 是否跨日
Property BCIsNextDay As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = BC_IsNextDay ];

/// BC_Note 备注
Property BCNote As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = BC_Note ];

/// BC_Active 是否激活
Property BCActive As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = BC_Active ];

/// BC_Seqno 第几班
Property BCSeqno As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = BC_Seqno ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.Doc.PWBC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BC_Active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BC_ETime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BC_IsNextDay">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BC_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BC_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BC_STime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BC_Seqno">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CF.Doc.PWBC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBCCode">
<Global>^CF.Doc.PWBCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BCCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BC_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSeqno">
<Global>^CF.Doc.PWBCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Seqno"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BC_Seqno}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocPassWorkBcsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
