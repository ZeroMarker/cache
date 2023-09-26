/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 化疗单模板化疗组
Class User.ChemoTemplateGroup Extends (%Persistent, User.Abstract) [ SqlTableName = Chemo_TemplateGroup, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TPGChildSub [ IdKey, PrimaryKey, Unique ];

/// TPG_Parref
Relationship TPGParref As User.ChemoTemplateStage [ Cardinality = parent, Inverse = ChildGroup, Required, SqlFieldName = TPG_Parref ];

Relationship ChildItem As User.ChemoTemplateItem [ Cardinality = children, Inverse = TPGIParref ];

/// TPG_ChildSub
Property TPGChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.Chemo.Template($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),0))}, Required, SqlColumnNumber = 2, SqlFieldName = TPG_ChildSub ];

/// 组编号
Property TPGCode As %String [ SqlColumnNumber = 3, SqlFieldName = TPG_Code ];

/// 组描述
Property TPGDesc As User.DHCDocCTDefineData [ SqlColumnNumber = 4, SqlFieldName = TPG_Desc ];

/// 化疗日期(多选）
Property TPGPlanDate As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TPG_PlanDate ];

/// 组备注
Property TPGNote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = TPG_Note ];

/// 静脉通道标志
Property TPGVeinFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = TPG_VeinFlag ];

/// 是否主药组
Property TPGMainDrug As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = TPG_MainDrug ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="TPG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TPG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TPG_MainDrug">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TPG_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TPG_PlanDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TPG_VeinFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CF.DOC.Chemo.TemplateD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Chemo_Template.TP_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>Chemo_TemplateStage.TS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>TPG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_Template.TP_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_TemplateStage.TS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TPG_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxCode">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Chemo_Template.TP_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>Chemo_TemplateStage.TS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TPG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplateGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_Template.TP_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Chemo_TemplateStage.TS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TPG_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TPG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxMainDrug">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Chemo_Template.TP_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>Chemo_TemplateStage.TS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TPG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplateGroup"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MainDrug"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_Template.TP_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Chemo_TemplateStage.TS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TPG_MainDrug}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TPG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TPG_ID</SqlRowIdName>
<StreamLocation>^User.ChemoTemplateGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
