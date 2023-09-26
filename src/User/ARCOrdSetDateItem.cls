/// ARC Order Set Item(1210)
Class User.ARCOrdSetDateItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetDateItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARCOrdSetDateItemPrice As ARCOrdSetDateItemPrice [ Cardinality = children, Inverse = PRICEParRef ];

/// ARC_OrdSetDate Parent Reference
Relationship ITMParRef As ARCOrdSetDate [ Cardinality = parent, Inverse = ChildARCOrdSetDateItem, Required, SqlFieldName = ITM_ParRef ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^ARCOS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Des Ref ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ITM_ARCIM_DR ];

/// Quantity
Property ITMQty As %Float [ SqlColumnNumber = 4, SqlFieldName = ITM_Qty ];

/// Line No
Property ITMLine As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ITM_Line ];

/// Conditional
Property ITMConditional As %String(DISPLAYLIST = ",Adult Only,Child Only", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",A,C") [ SqlColumnNumber = 6, SqlFieldName = ITM_Conditional ];

/// Visible
Property ITMVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Yes", Required, SqlColumnNumber = 7, SqlFieldName = ITM_Visible ];

/// Linked To Visible Item
Property ITMLinkToVisibleItem As %Float [ SqlColumnNumber = 8, SqlFieldName = ITM_LinkToVisibleItem ];

/// Des Ref Freq
Property ITMFreqDR As PHCFreq [ SqlColumnNumber = 9, SqlFieldName = ITM_Freq_DR ];

/// Des Ref Duration
Property ITMDuratDR As PHCDuration [ SqlColumnNumber = 10, SqlFieldName = ITM_Durat_DR ];

/// Des Ref Instruc
Property ITMInstrucDR As PHCInstruc [ SqlColumnNumber = 11, SqlFieldName = ITM_Instruc_DR ];

/// Des Ref UOM
Property ITMUOMDR As CTUOM [ SqlColumnNumber = 12, SqlFieldName = ITM_UOM_DR ];

/// Des Ref NeedleGauge
Property ITMNeedleGaugeDR As OECNeedleGauge [ SqlColumnNumber = 13, SqlFieldName = ITM_NeedleGauge_DR ];

/// Des Ref NeedleType
Property ITMNeedleTypeDR As OECNeedleType [ SqlColumnNumber = 14, SqlFieldName = ITM_NeedleType_DR ];

/// Dose Qty
Property ITMDoseQty As %Float [ SqlColumnNumber = 15, SqlFieldName = ITM_DoseQty ];

/// Link for Doctor
Property ITMLinkDoctor As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ITM_LinkDoctor ];

/// Des Ref InsType
Property ITMInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 17, SqlFieldName = ITM_InsType_DR ];

/// Des Ref AuxInsType
Property ITMAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 18, SqlFieldName = ITM_AuxInsType_DR ];

/// Add Up To Qty
Property ITMAddUpToQty As %Float [ SqlColumnNumber = 19, SqlFieldName = ITM_AddUpToQty ];

/// Start date increment
Property ITMDayIncrement As %Numeric(SCALE = 0) [ SqlColumnNumber = 20, SqlFieldName = ITM_DayIncrement ];

/// Notes
Property ITMNotes As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 21, SqlFieldName = ITM_Notes, SqlListType = SUBNODE ];

/// Price
Property ITMPrice As %Float [ SqlColumnNumber = 22, SqlFieldName = ITM_Price ];

/// Itemserialnumber序列码用于输出
Property ITMSerialNo As %Float [ SqlColumnNumber = 23, SqlFieldName = ITM_SerialNo ];

/// 接收科室
Property ITMRecLocDR As CTLoc [ SqlColumnNumber = 24, SqlFieldName = ITM_RecLoc_DR ];

/// 医嘱阶段
Property ITMStage As %String [ SqlColumnNumber = 25, SqlFieldName = ITM_Stage ];

/// 整包装单位
Property ITMPackQtyUomDR As CTUOM [ SqlColumnNumber = 26, SqlFieldName = ITM_PackQtyUom_DR ];

/// 皮试
Property ITMSkinTest As %String [ SqlColumnNumber = 27, SqlFieldName = ITM_SkinTest ];

/// 皮试备注
Property ITMSkinTestAction As OECAction [ SqlColumnNumber = 28, SqlFieldName = ITM_SkinTestAction ];

/// 医嘱类型
Property ITMPriorityDR As OECPriority [ SqlColumnNumber = 29, SqlFieldName = ITM_Priority_DR ];

/// 标本
Property ITMSampleId As %String [ SqlColumnNumber = 30, SqlFieldName = ITM_SampleId ];

/// 医嘱附加说明
Property ITMPriorRemarksDR As %String [ SqlColumnNumber = 31, SqlFieldName = ITM_PriorRemarksDR ];

/// 是否必开
Property ITMMustEnter As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = ITM_MustEnter ];

/// 输液流速
Property ITMSpeedFlowRate As %String [ SqlColumnNumber = 33, SqlFieldName = ITM_SpeedFlowRate ];

/// 流速单位
Property ITMFlowRateUnitDR As OECSpeedFlowRate [ SqlColumnNumber = 34, SqlFieldName = ITM_FlowRateUnit_DR ];

/// 检查部位串
Property ITMOrderBodyPartLabel As %String [ SqlColumnNumber = 35, SqlFieldName = ITM_OrderBodyPartLabel ];

/// 是否加急
Property ITMNotifyClinician As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = ITM_NotifyClinician ];

/// 是否快速例外
Property ITMRemoveCeler As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = ITM_RemoveCeler ];

/// 同频次不同剂量串
Property ITMFreqTimeDoseQtyStr As %String [ SqlColumnNumber = 38, SqlFieldName = ITM_FreqTimeDoseQtyStr ];

/// 周频次选择星期串
Property ITMFreqWeekStr As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = ITM_FreqWeekStr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_AddUpToQty">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ITM_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ITM_Conditional">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_DayIncrement">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ITM_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ITM_Durat_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ITM_FlowRateUnit_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="ITM_FreqTimeDoseQtyStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="ITM_FreqWeekStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="ITM_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ITM_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ITM_Instruc_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ITM_Line">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_LinkDoctor">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ITM_LinkToVisibleItem">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ITM_MustEnter">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="ITM_NeedleGauge_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ITM_NeedleType_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ITM_Notes">
<Node>"NOTES"</Node>
</Data>
<Data name="ITM_NotifyClinician">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="ITM_OrderBodyPartLabel">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="ITM_PackQtyUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ITM_Price">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ITM_PriorRemarksDR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="ITM_Priority_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="ITM_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ITM_RemoveCeler">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="ITM_SampleId">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="ITM_SerialNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ITM_SkinTest">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ITM_SkinTestAction">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ITM_SpeedFlowRate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="ITM_Stage">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ITM_UOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ITM_Visible">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARCOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARC_OrdSetDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARC_OrdSetDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetDateItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
