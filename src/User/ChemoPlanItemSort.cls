/// CTOR: QP
/// DATE: 2021-01-08
/// DESC: 化疗项目日期排序表
Class User.ChemoPlanItemSort Extends %Persistent [ SqlTableName = Chemo_PlanItemSort, StorageStrategy = SQLStorage ]
{

/// 化疗日期
Property ISChemoDate As %Date [ SqlColumnNumber = 2, SqlFieldName = IS_ChemoDate ];

/// 顺序
Property ISSeqno As %String [ SqlColumnNumber = 3, SqlFieldName = IS_Seqno ];

/// 周期ID
Property ISPSID As User.ChemoPlanStage [ SqlColumnNumber = 4, SqlFieldName = IS_PSID ];

/// 化疗项目ID
Property ISItemID As User.ChemoPlanItem [ SqlColumnNumber = 5, SqlFieldName = IS_ItemID ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoPlanItemSort"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IS_ChemoDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IS_ItemID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IS_PSID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IS_Seqno">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanItemSortD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IS_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{IS_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxChemoDate">
<Global>^BS.DOC.Chemo.PlanItemSortI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>IS_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IS_ChemoDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxItemChemoDate">
<Global>^BS.DOC.Chemo.PlanItemSortI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IS_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ItemChemoDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IS_ItemID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_ChemoDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IS_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPSChemoDate">
<Global>^BS.DOC.Chemo.PlanItemSortI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IS_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PSChemoDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IS_PSID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IS_ChemoDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IS_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IS_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanItemSortS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
