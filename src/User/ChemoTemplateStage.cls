/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 化疗单模板周期
Class User.ChemoTemplateStage Extends (%Persistent, User.Abstract) [ SqlTableName = Chemo_TemplateStage, StorageStrategy = SQLStorage ]
{

Relationship ChildGroup As User.ChemoTemplateGroup [ Cardinality = children, Inverse = TPGParref ];

Relationship TSParRef As User.ChemoTemplate [ Cardinality = parent, Inverse = ChildDetail, Required, SqlFieldName = TS_ParRef ];

Index RowIDBasedIDKeyIndex On TSChildSub [ IdKey, PrimaryKey, Unique ];

/// TSChildSub
Property TSChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.Chemo.Template(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = TS_ChildSub ];

/// 周期代码
Property TSStage As %String [ SqlColumnNumber = 3, SqlFieldName = TS_Stage ];

/// 周期描述
Property TSDesc As %String [ SqlColumnNumber = 4, SqlFieldName = TS_Desc ];

/// 周期开始日期
Property TSStartDate As %String [ SqlColumnNumber = 5, SqlFieldName = TS_StartDate ];

/// 周期结束日期
Property TSEndDate As %String [ SqlColumnNumber = 6, SqlFieldName = TS_EndDate ];

/// 周期数
Property TSNextNum As %String [ SqlColumnNumber = 7, SqlFieldName = TS_NextNum ];

// Property TSChemoDate As %String [ SqlColumnNumber = 8, SqlFieldName = TS_ChemoDate ];

/// 化疗日期
Property TSChemoDate As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TS_ChemoDate ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="TS_ChemoDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TS_NextNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TS_Stage">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.DOC.Chemo.TemplateD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Chemo_Template.TP_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>TS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_Template.TP_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxStage">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Chemo_Template.TP_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplateStage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Stage"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_Template.TP_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TS_Stage}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TS_ID</SqlRowIdName>
<StreamLocation>^User.ChemoTemplateStageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
