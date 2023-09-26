/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗项目
Class User.ChemoPlanItem Extends %Persistent [ SqlTableName = Chemo_PlanItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PGIChildSub [ IdKey, PrimaryKey, Unique ];

/// PGI_Parref
Relationship PGIParref As User.ChemoPlanGroup [ Cardinality = parent, Inverse = ChildItem, Required, SqlFieldName = PGI_Parref ];

/// PGI_ChildSub
Property PGIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.Plan($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PGI_ChildSub ];

/// 医嘱项目
Property PGIArcimDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = PGI_ArcimDR ];

/// 剂量
Property PGIDosage As %Float [ SqlColumnNumber = 4, SqlFieldName = PGI_Dosage ];

/// 剂量单位
Property PGIDosageUomDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = PGI_DosageUomDR ];

/// 频次
Property PGIFreqDR As User.PHCFreq [ SqlColumnNumber = 6, SqlFieldName = PGI_FreqDR ];

/// 用法
Property PGIInstrucDR As User.PHCInstruc [ SqlColumnNumber = 7, SqlFieldName = PGI_InstrucDR ];

/// 疗程
Property PGIDuratDR As User.PHCDuration [ SqlColumnNumber = 8, SqlFieldName = PGI_DuratDR ];

/// 数量
Property PGIQty As %Float [ SqlColumnNumber = 9, SqlFieldName = PGI_Qty ];

/// 单位
Property PGIUomDR As User.CTUOM [ SqlColumnNumber = 10, SqlFieldName = PGI_UomDR ];

/// 关联
Property PGILinkItem As %String [ SqlColumnNumber = 11, SqlFieldName = PGI_LinkItem ];

/// 备注
Property PGINote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PGI_Note ];

/// 医嘱类型
Property PGIPriorDR As User.OECPriority [ SqlColumnNumber = 13, SqlFieldName = PGI_PriorDR ];

/// 标本
Property PGISimpleDR As %String [ SqlColumnNumber = 14, SqlFieldName = PGI_SimpleDR ];

/// 附加说明
Property PGIRemark As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PGI_Remark ];

/// 接受科室
Property PGIRecLoc As User.CTLoc [ SqlColumnNumber = 16, SqlFieldName = PGI_RecLoc ];

/// 医嘱阶段
Property PGIStage As %String [ SqlColumnNumber = 17, SqlFieldName = PGI_Stage ];

/// 输液流速
Property PGIFlowRate As %String [ SqlColumnNumber = 18, SqlFieldName = PGI_FlowRate ];

/// 流速单位
Property PGIFlowRateDR As User.OECSpeedFlowRate [ SqlColumnNumber = 19, SqlFieldName = PGI_FlowRateDR ];

/// 皮试
Property PGISkinTest As %String [ SqlColumnNumber = 20, SqlFieldName = PGI_SkinTest ];

/// 皮试备注
Property PGISkinAction As User.OECAction [ SqlColumnNumber = 21, SqlFieldName = PGI_SkinAction ];

/// 模板项目ID
Property PGITplGroupItem As User.ChemoTemplateItem [ SqlColumnNumber = 22, SqlFieldName = PGI_TplGroupItem ];

/// 单位体表面积浓度
Property PGIBSAUnit As %String [ SqlColumnNumber = 23, SqlFieldName = PGI_BSAUnit ];

/// BSA(保存时的BSA)
Property PGIBSA As %String [ SqlColumnNumber = 24, SqlFieldName = PGI_BSA ];

/// 是否主药
Property PGIMainDrug As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = PGI_MainDrug ];

/// 计算公式
Property PGIFormula As %String [ SqlColumnNumber = 26, SqlFieldName = PGI_Formula ];

/// GFR(保存时的GFR)
Property PGIGFR As %String [ SqlColumnNumber = 27, SqlFieldName = PGI_GFR ];

/// 标准值
Property PGIBSAUnitSTD As %String [ SqlColumnNumber = 28, SqlFieldName = PGI_BSAUnitSTD ];

/// 顺序号
Property PGISeqno As %String [ SqlColumnNumber = 29, SqlFieldName = PGI_Seqno ];

/// 显示日期
Property PGIShowDate As %String(COLLATION = "Exact", MAXLEN = 10000, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PGI_ShowDate ];

/// 初始剂量
Property PGIInitDosage As %Float [ SqlColumnNumber = 31, SqlFieldName = PGI_InitDosage ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PGI_ArcimDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PGI_BSA">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PGI_BSAUnit">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PGI_BSAUnitSTD">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PGI_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PGI_DosageUomDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGI_DuratDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PGI_FlowRate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PGI_FlowRateDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PGI_Formula">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PGI_FreqDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PGI_GFR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PGI_InitDosage">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PGI_InstrucDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PGI_LinkItem">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PGI_MainDrug">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PGI_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PGI_PriorDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PGI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PGI_RecLoc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PGI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PGI_Seqno">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PGI_ShowDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PGI_SimpleDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PGI_SkinAction">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PGI_SkinTest">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PGI_Stage">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PGI_TplGroupItem">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PGI_UomDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
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
<Field>Chemo_PlanGroup.PG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L4}</Expression>
<Field>PGI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_Plan.PL_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_PlanStage.PS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_PlanGroup.PG_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxArcim">
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
<Expression>{L5}</Expression>
<Field>Chemo_PlanGroup.PG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>PGI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arcim"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_Plan.PL_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Chemo_PlanStage.PS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Chemo_PlanGroup.PG_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PGI_ArcimDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PGI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxSeqno">
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
<Expression>{L5}</Expression>
<Field>Chemo_PlanGroup.PG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>PGI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Seqno"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_Plan.PL_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Chemo_PlanStage.PS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Chemo_PlanGroup.PG_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PGI_Seqno}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PGI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PGI_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
