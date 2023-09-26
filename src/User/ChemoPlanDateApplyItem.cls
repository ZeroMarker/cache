/// CTOR: QP
/// DATE: 2020-08-12
/// DESC: 化疗日期申请化疗项目表
Class User.ChemoPlanDateApplyItem Extends %Persistent [ SqlTableName = Chemo_PlanDateApplyItem, StorageStrategy = SQLStorage ]
{

Relationship PDAIParRef As User.ChemoPlanDateApply [ Cardinality = parent, Inverse = ChildItem, Required, SqlFieldName = PDAI_ParRef ];

Index RowIDBasedIDKeyIndex On PDAIChildSub [ IdKey, PrimaryKey, Unique ];

/// PDAI_ChildSub
Property PDAIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.PlanDate($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"A",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PDAI_ChildSub ];

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
Property PGIFlowRate As %Float [ SqlColumnNumber = 18, SqlFieldName = PGI_FlowRate ];

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

/// PGI_ItemDR
Property PGIItemDR As User.ChemoPlanItem [ SqlColumnNumber = 30, SqlFieldName = PGI_ItemDR ];

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
<Data name="PGI_InstrucDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PGI_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
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
<Global>^BS.DOC.Chemo.PlanDateD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Chemo_PlanDate.PD_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Chemo_PlanDateApply.PDA_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PDAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_PlanDateApply.PDA_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDAI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxItemDR">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Chemo_PlanDate.PD_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Chemo_PlanDateApply.PDA_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PDAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanDateApplyItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_PlanDateApply.PDA_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGI_ItemDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDAI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDAI_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanDateApplyItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
