/// DHC RETURN ITEM
Class User.DHCINGRTITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INGRTI_RowId, SqlTableName = DHC_INGRTITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INGRTIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INGDRET Parent Reference
Relationship INGRTIINGRTParref As User.DHCINGDRET [ Cardinality = parent, Inverse = ChildDHCINGRTITM, Required, SqlFieldName = INGRTI_INGRT_Parref ];

/// CHILDSUB NO
Property INGRTIChildSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INGRTI_ChildSub ];

/// INGDRECITM ROWID
Property INGRTIINGRIDR As User.DHCINGdRecItm [ SqlColumnNumber = 4, SqlFieldName = INGRTI_INGRI_DR ];

/// RETURN QTY
Property INGRTIRetQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = INGRTI_RetQty ];

/// RETURN UOM
Property INGRTIRetUomDR As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = INGRTI_RetUom_DR ];

/// RETURN AMOUNT
Property INGRTIRetAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = INGRTI_RetAmount ];

/// RETURN REASON
Property INGRTIRetReasDR As User.INCReasonForReturn [ SqlColumnNumber = 8, SqlFieldName = INGRTI_RetReas_DR ];

/// Pointer to INC_ItmLcBt 
Property INGRTIMEDRTITMDR As User.INCItmLcBt [ Required, SqlColumnNumber = 9, SqlFieldName = INGRTI_MEDRTITM_DR ];

/// INGRTI_RealPrice
Property INGRTIRealPrice As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INGRTI_RealPrice ];

/// INGRTI_SalePrice
Property INGRTISalePrice As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INGRTI_SalePrice ];

/// INGRTI_SpAmt
Property INGRTISpAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INGRTI_SpAmt ];

/// INGRTI_PurPrice
Property INGRTIPurPrice As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INGRTI_PurPrice ];

/// INGRTI_PpAmt
Property INGRTIPpAmt As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INGRTI_PpAmt ];

/// INGRTI_InvNo
Property INGRTIInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INGRTI_InvNo ];

/// INGRTI_InvAmt
Property INGRTIInvAmt As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INGRTI_InvAmt ];

/// INGRTI_InvDate
Property INGRTIInvDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INGRTI_InvDate ];

/// INGRTI_OldSp
Property INGRTIOldSp As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = INGRTI_OldSp ];

/// INGRTI_OldSpAmt
Property INGRTIOldSpAmt As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = INGRTI_OldSpAmt ];

/// INGRTI_AspAmt
Property INGRTIAspAmt As %Library.Float [ SqlColumnNumber = 20, SqlComputeCode = {	s {INGRTI_AspAmt}={INGRTI_SpAmt}-{INGRTI_OldSpAmt}
}, SqlComputed, SqlFieldName = INGRTI_AspAmt, Transient ];

/// INGRTI_Sxno
Property INGRTISxno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INGRTI_Sxno ];

/// INGRTI_InvCode
Property INGRTIInvCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INGRTI_InvCode ];

/// INGRTI_TaxRate
Property INGRTITaxRate As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = INGRTI_TaxRate ];

/// INGRTI_Remark
Property INGRTIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INGRTI_Remark ];

/// 具体规格INGRTI_SpecList
Property INGRTISpecList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INGRTI_SpecList ];

/// 发票审核日期
Property INGRTIInvAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = INGRTI_InvAuditDate ];

/// 发票录入日期
Property INGRTIInvSetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = INGRTI_InvSetDate ];

/// 付款审批人
Property INGRTIPayAllowUser As User.SSUser [ SqlColumnNumber = 28, SqlFieldName = INGRTI_PayAllowUser ];

/// 付款审批日期
Property INGRTIPayAllowDate As %Library.Date [ SqlColumnNumber = 29, SqlFieldName = INGRTI_PayAllowDate ];

/// 付款审批时间
Property INGRTIPayAllowTime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = INGRTI_PayAllowTime ];

/// INGRTI_SynInvFlag 	平台发票同步标志
Property INGRTISynInvFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 31, SqlFieldName = INGRTI_SynInvFlag ];

/// 折扣率
Property INGRTIDisc As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = INGRTI_Disc ];

/// 第三方采购平台退货明细ID
Property INGRTIThirdDetailId As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INGRTI_ThirdDetailId ];

/// 付款方式
Property INGRTIPayModeSCDIDr As User.DHCStkComDictionary [ SqlColumnNumber = 34, SqlFieldName = INGRTI_PayMode_SCDI_Dr ];

/// 税额
Property INGRTITaxAmt As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = INGRTI_TaxAmt ];

/// 金额(用户可修改的)
Property INGRTIAmount As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = INGRTI_Amount ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterINGRTI">
<Data name="INGRTI_Amount">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INGRTI_AspAmt">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INGRTI_Disc">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INGRTI_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGRTI_InvAmt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INGRTI_InvAuditDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INGRTI_InvCode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INGRTI_InvDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INGRTI_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INGRTI_InvSetDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INGRTI_MEDRTITM_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGRTI_OldSp">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INGRTI_OldSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INGRTI_PayAllowDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INGRTI_PayAllowTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INGRTI_PayAllowUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INGRTI_PayMode_SCDI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INGRTI_PpAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INGRTI_PurPrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INGRTI_RealPrice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGRTI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INGRTI_RetAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INGRTI_RetQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGRTI_RetReas_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGRTI_RetUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGRTI_SalePrice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGRTI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INGRTI_SpecList">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INGRTI_Sxno">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INGRTI_SynInvFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INGRTI_TaxAmt">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INGRTI_TaxRate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INGRTI_ThirdDetailId">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^INGRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INGDRET.INGRT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INGRTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INGDRET.INGRT_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DHCGRR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGRTI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInclb">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGDRET.INGRT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGRTI_MEDRTITM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGRTI_INGRT_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGRTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIngri">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGDRET.INGRT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INGRI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGRTI_INGRI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGRTI_INGRT_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGRTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvSetDate">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGDRET.INGRT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvSetDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGRTI_InvSetDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGRTI_INGRT_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGRTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvno">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGDRET.INGRT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INVNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGRTI_InvNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGRTI_INGRT_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGRTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSynInvFlag">
<Global>^INGRT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INGDRET.INGRT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INGRTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SynInvFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGRTI_SynInvFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGRTI_INGRT_Parref}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGRTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINGRTITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
