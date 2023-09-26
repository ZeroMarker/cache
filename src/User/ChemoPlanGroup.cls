/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗组
Class User.ChemoPlanGroup Extends %Persistent [ SqlTableName = Chemo_PlanGroup, StorageStrategy = SQLStorage ]
{

Relationship ChildItem As User.ChemoPlanItem [ Cardinality = children, Inverse = PGIParref ];

/// PG_Parref
Relationship PGParref As User.ChemoPlanStage [ Cardinality = parent, Inverse = ChildGroup, Required, SqlFieldName = PG_Parref ];

Index RowIDBasedIDKeyIndex On PGChildSub [ IdKey, PrimaryKey, Unique ];

/// PG_ChildSub
Property PGChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.Plan($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PG_ChildSub ];

/// 组编号
Property PGCode As %String [ SqlColumnNumber = 3, SqlFieldName = PG_Code ];

/// 组描述
Property PGDesc As User.DHCDocCTDefineData [ SqlColumnNumber = 4, SqlFieldName = PG_Desc ];

/// 化疗日期(多选）
Property PGPlanDate As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PG_PlanDate ];

/// 组备注
Property PGNote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PG_Note ];

/// 静脉通道标志
Property PGVeinFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PG_VeinFlag ];

/// 模板化疗组
Property PGTplGrop As User.ChemoTemplateGroup [ SqlColumnNumber = 8, SqlFieldName = PG_TplGrop ];

/// 组状态Y(有效)、N(作废)、S(停止)
Property PGStatus As %String [ SqlColumnNumber = 9, SqlFieldName = PG_Status ];

/// 是否主药组
Property PGMainDrug As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PG_MainDrug ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PG_MainDrug">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PG_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PG_PlanDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PG_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PG_TplGrop">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PG_VeinFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Chemo_Plan.PL_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>Chemo_PlanStage.PS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>PG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_Plan.PL_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_PlanStage.PS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PG_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxCode">
<Global>^BS.DOC.Chemo.PlanI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Chemo_Plan.PL_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>Chemo_PlanStage.PS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_Plan.PL_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Chemo_PlanStage.PS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PG_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxMainDrug">
<Global>^BS.DOC.Chemo.PlanI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Chemo_Plan.PL_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>Chemo_PlanStage.PS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MainDrug"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_Plan.PL_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Chemo_PlanStage.PS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PG_MainDrug}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PG_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
