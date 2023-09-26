/// linshi rukoudan zibiao 
Class User.DHCINGdRecItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INGRI_RowId, SqlTableName = DHC_INGdRecItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INGRIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INGdRec Parent Reference
Relationship INGRIINGRParRef As User.DHCINGdRec [ Cardinality = parent, Inverse = ChildDHCINGdRecItm, Required, SqlFieldName = INGRI_INGR_ParRef ];

/// Batch No
Property INGRIBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INGRI_BatchNo ];

/// Base Net Amount
Property INGRIBNetAmt As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INGRI_BNetAmt ];

/// INGRI Childsub
Property INGRIChildSub As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = INGRI_ChildSub ];

/// Des Ref to CTLOC
Property INGRICTLOCDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = INGRI_CTLOC_DR ];

/// UOM
Property INGRICTUOMDR As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = INGRI_CTUOM_DR ];

/// Discount Rate
Property INGRIDisc As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = INGRI_Disc ];

/// Expiry Date
Property INGRIExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = INGRI_ExpDate ];

/// Gross Amount
Property INGRIGrossAmt As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INGRI_GrossAmt ];

/// Share of Handling Charges
Property INGRIHandChargeShare As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INGRI_HandChargeShare ];

/// Des Ref to INC_GdRecType
Property INGRIINCGRDR As User.INCGdRecType [ SqlColumnNumber = 11, SqlFieldName = INGRI_INCGR_DR ];

/// Des Ref To INCLB
Property INGRIINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 12, SqlFieldName = INGRI_INCLB_DR ];

/// Des Ref INPOI
Property INGRIINPOIDR As User.INPOItm [ SqlColumnNumber = 13, SqlFieldName = INGRI_INPOI_DR ];

/// Margin
Property INGRIMargin As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INGRI_Margin ];

/// Net Amount in foreign currency
Property INGRINetAmt As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INGRI_NetAmt ];

/// Share of the Overall Discount
Property INGRIOverallDiscShare As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INGRI_OverallDiscShare ];

/// PreVATAmt
Property INGRIPreVATAmt As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INGRI_PreVATAmt ];

/// Receiving Quantity
Property INGRIRecQty As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = INGRI_RecQty ];

/// Remarks
Property INGRIRemarks As list Of %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INGRI_Remarks, SqlListType = SUBNODE ];

/// Des Ref To Service Tax
Property INGRIServiceTaxDR As User.ARCServTax [ SqlColumnNumber = 20, SqlFieldName = INGRI_ServiceTax_DR ];

/// Stock Description
Property INGRIStkDesc As %Library.String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INGRI_StkDesc ];

/// Tax Amount
Property INGRITaxAmount As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = INGRI_TaxAmount ];

/// UnitCost
Property INGRIUnitCost As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = INGRI_UnitCost ];

/// initm_buyer
Property initmbuyer As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = initm_buyer ];

/// initm_CheckAudit
Property initmCheckAudit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = initm_CheckAudit ];

/// initm_CheckPack
Property initmCheckPack As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = initm_CheckPack ];

/// initm_diff
Property initmdiff As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = initm_diff ];

/// initm_INCI_DR
Property initmINCIDR As User.INCItm [ SqlColumnNumber = 28, SqlFieldName = initm_INCI_DR ];

/// initm_invmoney
Property initminvmoney As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = initm_invmoney ];

/// initm_invno
Property initminvno As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = initm_invno ];

/// initm_payno
Property initmpayno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = initm_payno ];

/// initm_phmnf_dr
Property initmphmnfdr As User.PHManufacturer [ SqlColumnNumber = 32, SqlFieldName = initm_phmnf_dr ];

/// initm_realprice
Property initmrealprice As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = initm_realprice ];

/// initm_realtotal
Property initmrealtotal As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = initm_realtotal ];

/// initm_saleprice
Property initmsaleprice As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = initm_saleprice ];

/// initm_checkdate
Property initmcheckdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = initm_checkdate ];

/// initm_invdate
Property initminvdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = initm_invdate ];

/// initm_BatPrice
Property initmBatPrice As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = initm_BatPrice ];

/// initm_INGRI_DR
Property initmINGRIDR As User.INGdRecItm [ SqlColumnNumber = 39, SqlFieldName = initm_INGRI_DR ];

/// initm_QualityNo
Property initmQualityNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = initm_QualityNo ];

/// import suixing dan
Property initmsxno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = initm_sxno ];

///  
Property initmCheckRepNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = initm_CheckRepNo ];

/// initm_CheckRepDate
Property initmCheckRepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 43, SqlFieldName = initm_CheckRepDate ];

/// initm_CheckPort
Property initmCheckPort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = initm_CheckPort ];

/// initm_AdmNo
Property initmAdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = initm_AdmNo ];

/// initm_AdmExpdate
Property initmAdmExpdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 46, SqlFieldName = initm_AdmExpdate ];

/// initm_Remark
Property initmRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = initm_Remark ];

/// initm_newSp
Property initmnewSp As %Library.Float [ SqlColumnNumber = 48, SqlFieldName = initm_newSp ];

/// initm_newSpAmt
Property initmnewSpAmt As %Library.Float [ SqlColumnNumber = 49, SqlFieldName = initm_newSpAmt ];

/// initm_MT_Dr
Property initmMTDr As User.DHCMarkType [ SqlColumnNumber = 50, SqlFieldName = initm_MT_Dr ];

/// initm_PubBL
Property initmPubBL As User.DHCPublicBiddingList [ SqlColumnNumber = 51, SqlFieldName = initm_PubBL ];

/// INGRI_INCIB_DR
Property INGRIINCIBDR As User.INCItmBat [ SqlColumnNumber = 52, SqlComputeCode = {	i {INGRI_INCLB_DR}="" s {INGRI_INCIB_DR}="" q
	s {INGRI_INCIB_DR}=$$CIBrow^at299({INGRI_INCLB_DR})
}, SqlComputed, SqlFieldName = INGRI_INCIB_DR, Transient ];

/// initm_produceDate
Property initmProduceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 53, SqlFieldName = initm_ProduceDate ];

/// initm_SpAmt
Property initmSpAmt As %Library.Float [ SqlColumnNumber = 54, SqlFieldName = initm_SpAmt ];

/// initm_InvCode
Property initmInvCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = initm_InvCode ];

/// initm_TaxRate
Property initmTaxRate As %Library.Float [ SqlColumnNumber = 56, SqlFieldName = initm_TaxRate ];

/// 灭菌批号
Property initmSterilizedBat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = initm_SterilizedBat ];

/// 招标平台采购单号
Property initmOnlineOrderNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = initm_OnlineOrderNo ];

/// 招标采购模式，竞价、议标
Property initmOnlineOderMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = initm_OnlineOderMode ];

/// 产地
Property INITMOrigDR As User.DHCSTOrigin [ SqlColumnNumber = 60, SqlFieldName = INITM_Orig_DR ];

/// initm_CheckRepTime  验收报告时间
Property initmCheckRepTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 61, SqlFieldName = initm_CheckRepTime ];

/// 具体规格SpecList
Property initmSpecList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = initm_SpecList ];

/// initm_InvSetDate
Property initmInvSetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 63, SqlFieldName = initm_InvSetDate ];

/// 赠送比例
Property initmgiftrec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = initm_giftrec ];

/// 拒付价格
Property initmunpay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = initm_unpay ];

/// 赠送入库完成标志
Property initmgiftrecadd As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = initm_giftrecadd ];

/// initm_GRI_DR
Property initmGRIDR As User.DHCINGdRecItm [ SqlColumnNumber = 67, SqlFieldName = initm_GRI_DR ];

/// initm_OrderDetailSubId 平台订单子表ID
Property initmOrderDetailSubId As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = initm_OrderDetailSubId ];

/// initm_SynInvFlag 	平台发票同步标志
Property initmSynInvFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 69, SqlFieldName = initm_SynInvFlag ];

/// initm_InvAuditDate 	发票审核日期
Property initmInvAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 70, SqlFieldName = initm_InvAuditDate ];

/// initm_FirstInvNo	第一票票号
Property initmFirstInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = initm_FirstInvNo ];

/// 两票制标志
Property initmTwoTicketFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 72, SqlFieldName = initm_TwoTicketFlag ];

/// Tax 单品税额
Property INGRITax As %Library.Float [ SqlColumnNumber = 73, SqlFieldName = INGRI_Tax ];

/// initm_InvSupplyDate发票提供日期
Property initmInvSupplyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 74, SqlFieldName = initm_InvSupplyDate ];

/// 冷链温度
Property initmColdChainTemp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 75, SqlFieldName = initm_ColdChainTemp ];

/// 是否连包（草药小包装）
Property initmDrugPackFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 76, SqlFieldName = initm_DrugPackFlag ];

/// 招标级别
Property initmPBLEVELDR As User.DHCItmPBLevel [ SqlColumnNumber = 77, SqlFieldName = initm_PBLEVEL_DR ];

/// 包装方式
Property INGRIPackWaysDR As User.INCPackInstructions [ SqlColumnNumber = 78, SqlFieldName = INGRI_PackWays_DR ];

/// 质检报告（有/无）
Property INGRIQualityReport As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 79, SqlFieldName = INGRI_QualityReport ];

/// 质量情况
Property INGRIQualitySit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = INGRI_QualitySit ];

/// 验收结果（合格/不合格）
Property INGRIAcceptResult As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 81, SqlFieldName = INGRI_AcceptResult ];

/// 外观形状
Property INGRIAppearShape As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 82, SqlFieldName = INGRI_AppearShape ];

/// 标签（有/无）
Property INGRIExistLabel As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 83, SqlFieldName = INGRI_ExistLabel ];

/// 说明书（有/无）
Property INGRIExistInstr As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = INGRI_ExistInstr ];

/// 付款审批人
Property INGRIPayAllowUser As User.SSUser [ SqlColumnNumber = 85, SqlFieldName = INGRI_PayAllowUser ];

/// 付款审批日期
Property INGRIPayAllowDate As %Library.Date [ SqlColumnNumber = 86, SqlFieldName = INGRI_PayAllowDate ];

/// 付款审批时间
Property INGRIPayAllowTime As %Library.Time [ SqlColumnNumber = 87, SqlFieldName = INGRI_PayAllowTime ];

/// 随行单日期
Property INGRIsxnoDate As %Library.Date [ SqlColumnNumber = 88, SqlFieldName = INGRI_sxnoDate ];

/// INGRI_TDPi_Dr  临购药品子表id
Property INGRITDPiDr As BS.PHA.IN.TmpDrugPurItm [ SqlColumnNumber = 89, SqlFieldName = INGRI_TDPi_Dr ];

/// INGRI_DeliveryDate 送货时间
Property INGRIDeliveryDate As %Library.Date [ SqlColumnNumber = 90, SqlFieldName = INGRI_DeliveryDate ];

/// INGRI_OriginalCode 追溯码
Property INGRIOriginalCode As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = INGRI_OriginalCode ];

/// 核对标识
Property INGRICheckStatus As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 92, SqlFieldName = INGRI_CheckStatus ];

Property INGRIPurSourceDr As User.DHCStkComDictionary [ SqlColumnNumber = 93, SqlFieldName = INGRI_PurSource_Dr ];

/// 符合效期
Property INGRIFitExpDateFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 94, SqlFieldName = INGRI_FitExpDateFlag ];

/// 依据标准
Property INGRIAccStandFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 95, SqlFieldName = INGRI_AccStandFlag ];

/// 合格标识
Property INGRIQualFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 96, SqlFieldName = INGRI_QualFlag ];

/// 付款方式
Property INGRIPayModeSCDIDr As User.DHCStkComDictionary [ SqlColumnNumber = 97, SqlFieldName = INGRI_PayMode_SCDI_Dr ];

/// INGRI_HRPBatCode
Property INGRIHRPBatCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 98, SqlFieldName = INGRI_HRPBatCode ];

/// INGRI_GoodsInvoStatus
Property INGRIGoodsInvoStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 99, SqlFieldName = INGRI_GoodsInvoStatus ];

/// INGRI_FactoryNo出厂编号
Property INGRIFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 100, SqlFieldName = INGRI_FactoryNo ];

Property INGRICheckUser As User.SSUser [ SqlColumnNumber = 101, SqlFieldName = INGRI_CheckUser ];

Property INGRICheckTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 102, SqlFieldName = INGRI_CheckTime ];

/// 折后价格
Property INGRIDiscRp As %Library.Float [ SqlColumnNumber = 103, SqlFieldName = INGRI_DiscRp ];

/// INGRI_PurWithQtyType 采购类型
Property INGRIPurWithQtyType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 104, SqlFieldName = INGRI_PurWithQtyType ];

/// 检查库存项是否是麻醉精一药品
ClassMethod CheckPoison(Inci)
{
	s MTIfExist = ##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCST.Common.DrugInfoCommon||CheckPoisonForVendor")
	q:MTIfExist=0 "N"
	q ##Class(web.DHCST.Common.DrugInfoCommon).CheckPoisonForVendor(Inci)
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INGRI_AccStandFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="INGRI_AcceptResult">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="INGRI_AppearShape">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="INGRI_BNetAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGRI_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INGRI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGRI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INGRI_CheckStatus">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="INGRI_CheckTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Data name="INGRI_CheckUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="INGRI_DeliveryDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="INGRI_Disc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGRI_DiscRp">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="INGRI_ExistInstr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="INGRI_ExistLabel">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="INGRI_ExpDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INGRI_FactoryNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="INGRI_FitExpDateFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="INGRI_GoodsInvoStatus">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="INGRI_GrossAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGRI_HRPBatCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="INGRI_HandChargeShare">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INGRI_INCGR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGRI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGRI_INPOI_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INGRI_Margin">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INGRI_NetAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INGRI_OriginalCode">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="INGRI_OverallDiscShare">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INGRI_PackWays_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="INGRI_PayAllowDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="INGRI_PayAllowTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="INGRI_PayAllowUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="INGRI_PayMode_SCDI_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="INGRI_PreVATAmt">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INGRI_PurSource_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="INGRI_PurWithQtyType">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="INGRI_QualFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="INGRI_QualityReport">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="INGRI_QualitySit">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="INGRI_RecQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INGRI_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INGRI_ServiceTax_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INGRI_StkDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGRI_TDPi_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="INGRI_Tax">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="INGRI_TaxAmount">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INGRI_UnitCost">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INGRI_sxnoDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="INITM_Orig_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="initm_AdmExpdate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="initm_AdmNo">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="initm_BatPrice">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="initm_CheckAudit">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="initm_CheckPack">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="initm_CheckPort">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="initm_CheckRepDate">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="initm_CheckRepNo">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="initm_CheckRepTime">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="initm_ColdChainTemp">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="initm_DrugPackFlag">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="initm_FirstInvNo">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="initm_GRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="initm_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="initm_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="initm_InvAuditDate">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="initm_InvCode">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="initm_InvSetDate">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="initm_InvSupplyDate">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="initm_MT_Dr">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="initm_OnlineOderMode">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="initm_OnlineOrderNo">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="initm_OrderDetailSubId">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="initm_PBLEVEL_DR">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="initm_ProduceDate">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="initm_PubBL">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="initm_QualityNo">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="initm_Remark">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="initm_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="initm_SpecList">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="initm_SterilizedBat">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="initm_SynInvFlag">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="initm_TaxRate">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="initm_TwoTicketFlag">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="initm_buyer">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="initm_checkdate">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="initm_diff">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="initm_giftrec">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="initm_giftrecadd">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="initm_invdate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="initm_invmoney">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="initm_invno">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="initm_newSp">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="initm_newSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="initm_payno">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="initm_phmnf_dr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="initm_realprice">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="initm_realtotal">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="initm_saleprice">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="initm_sxno">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="initm_unpay">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Global>^DHCINGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"GRI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDetailSubId">
<Global>^DHCINGR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DetailSubId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{initm_OrderDetailSubId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{initm_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIB">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"GRI_INCIB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRI_INCIB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRI">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INGDRECITM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{initm_INGRI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvDate">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INVDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{initm_invdate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvNo">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INVNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({initm_invno})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvSetDate">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INVSETDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{initm_InvSetDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPODR">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PODR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRI_INPOI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPoison">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POISON"</Expression>
</Subscript>
<Subscript name="3">
<Expression>..CheckPoison({initm_INCI_DR})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSXINCI">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SXINCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{initm_sxno}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{initm_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSynInvFlag">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SynInvFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{initm_SynInvFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTDPI">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TDPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGRI_TDPi_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_INGdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINGdRecItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
