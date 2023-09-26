/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 化疗单模板化疗项目
Class User.ChemoTemplateItem Extends %Persistent [ SqlTableName = Chemo_TemplateItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TPGIChildSub [ IdKey, PrimaryKey, Unique ];

/// TPGI_Parref
Relationship TPGIParref As User.ChemoTemplateGroup [ Cardinality = parent, Inverse = ChildItem, Required, SqlFieldName = TPGI_Parref ];

/// TPGI_ChildSub
Property TPGIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^CF.DOC.Chemo.Template($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),0))}, Required, SqlColumnNumber = 2, SqlFieldName = TPGI_ChildSub ];

/// 医嘱项目
Property TPGIArcimDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = TPGI_ArcimDR ];

/// 剂量
Property TPGIDosage As %Float [ SqlColumnNumber = 4, SqlFieldName = TPGI_Dosage ];

/// 剂量单位
Property TPGIDosageUomDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = TPGI_DosageUomDR ];

/// 频次
Property TPGIFreqDR As User.PHCFreq [ SqlColumnNumber = 6, SqlFieldName = TPGI_FreqDR ];

/// 用法
Property TPGIInstrucDR As User.PHCInstruc [ SqlColumnNumber = 7, SqlFieldName = TPGI_InstrucDR ];

/// 疗程
Property TPGIDuratDR As User.PHCDuration [ SqlColumnNumber = 8, SqlFieldName = TPGI_DuratDR ];

/// 数量
Property TPGIQty As %Float [ SqlColumnNumber = 9, SqlFieldName = TPGI_Qty ];

/// 单位
Property TPGIUomDR As User.CTUOM [ SqlColumnNumber = 10, SqlFieldName = TPGI_UomDR ];

/// 关联
Property TPGILinkItem As %String [ SqlColumnNumber = 11, SqlFieldName = TPGI_LinkItem ];

/// 备注
Property TPGINote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = TPGI_Note ];

/// 医嘱类型
Property TPGIPriorDR As User.OECPriority [ SqlColumnNumber = 13, SqlFieldName = TPGI_PriorDR ];

/// 标本
Property TPGISimpleDR As %String [ SqlColumnNumber = 14, SqlFieldName = TPGI_SimpleDR ];

/// 附加说明
Property TPGIRemark As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = TPGI_Remark ];

/// 接受科室
Property TPGIRecLoc As User.CTLoc [ SqlColumnNumber = 16, SqlFieldName = TPGI_RecLoc ];

/// 医嘱阶段
Property TPGIStage As %String [ SqlColumnNumber = 17, SqlFieldName = TPGI_Stage ];

/// 输液流速
Property TPGIFlowRate As %String [ SqlColumnNumber = 18, SqlFieldName = TPGI_FlowRate ];

/// 流速单位
Property TPGIFlowRateDR As User.OECSpeedFlowRate [ SqlColumnNumber = 19, SqlFieldName = TPGI_FlowRateDR ];

/// 皮试
Property TPGISkinTest As %String [ SqlColumnNumber = 20, SqlFieldName = TPGI_SkinTest ];

/// 皮试备注
Property TPGISkinAction As User.OECAction [ SqlColumnNumber = 21, SqlFieldName = TPGI_SkinAction ];

/// 是否主药
Property TPGIMainDrug As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = TPGI_MainDrug ];

/// 计算公式
Property TPGIFormula As %String [ SqlColumnNumber = 23, SqlFieldName = TPGI_Formula ];

/// 标准的AUC/单位体表面积浓度值
Property TPGIBSAUnitSTD As %String [ SqlColumnNumber = 24, SqlFieldName = TPGI_BSAUnitSTD ];

/// 输入值
Property TPGIBSAUnit As %String [ SqlColumnNumber = 25, SqlFieldName = TPGI_BSAUnit ];

/// 主药备注
Property TPGIMainDrugNote As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = TPGI_MainDrugNote ];

/// 显示日期
Property TPGIShowDate As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = TPGI_ShowDate ];

/// 显示顺序
Property TPGISeqno As %String [ SqlColumnNumber = 28, SqlFieldName = TPGI_Seqno ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="TPGI_ArcimDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TPGI_BSAUnit">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="TPGI_BSAUnitSTD">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="TPGI_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TPGI_DosageUomDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TPGI_DuratDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TPGI_FlowRate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TPGI_FlowRateDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TPGI_Formula">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TPGI_FreqDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TPGI_InstrucDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TPGI_LinkItem">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TPGI_MainDrug">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TPGI_MainDrugNote">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="TPGI_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TPGI_PriorDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TPGI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TPGI_RecLoc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TPGI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TPGI_Seqno">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="TPGI_ShowDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="TPGI_SimpleDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TPGI_SkinAction">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TPGI_SkinTest">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TPGI_Stage">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TPGI_UomDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
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
<Field>Chemo_TemplateGroup.TPG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L4}</Expression>
<Field>TPGI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_Template.TP_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_TemplateStage.TS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_TemplateGroup.TPG_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TPGI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxArcimDR">
<Global>^CF.DOC.Chemo.TemplateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Chemo_Template.TP_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Chemo_TemplateStage.TS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>Chemo_TemplateGroup.TPG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>TPGI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoTemplateItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_Template.TP_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_TemplateStage.TS_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Chemo_TemplateGroup.TPG_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TPGI_ArcimDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TPGI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TPGI_ID</SqlRowIdName>
<StreamLocation>^User.ChemoTemplateItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
