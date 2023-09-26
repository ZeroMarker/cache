/// DHC GOODS RETURN
Class User.DHCINGDRET Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHC_INGDRET, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCINGRTITM As User.DHCINGRTITM [ Cardinality = children, Inverse = INGRTIINGRTParref ];

/// DHC_INGDRET Row ID
Property INGRTRowId As %Library.Numeric(SCALE = 0, SELECTIVITY = 1) [ InitialExpression = {$i(^INGRT)}, Required, SqlFieldName = INGRT_RowId ];

/// Vendor
Property INGRTAPCVMDR As User.APCVendor [ SqlColumnNumber = 2, SqlFieldName = INGRT_APCVM_DR ];

/// Return Date
Property INGRTDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = INGRT_Date ];

/// Return tIM
Property INGRTTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = INGRT_Time ];

/// Completed Flag
Property INGRTCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = INGRT_Completed ];

/// USER
Property INGRTSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = INGRT_SSUSR_DR ];

/// RETURN NO
Property INGRTNO As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INGRT_NO ];

/// INGRT_CTLOC_DR
Property INGRTCTLOCDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = INGRT_CTLOC_DR ];

/// INGRT_SSUSR_Audit_DR
Property INGRTSSUSRAuditDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = INGRT_SSUSR_Audit_DR ];

/// INGRT_AuditDate
Property INGRTAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = INGRT_AuditDate ];

/// INGRT_AuditTime
Property INGRTAuditTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = INGRT_AuditTime ];

/// adj sale and change cheque
Property INGRTAdjCheque As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INGRT_AdjCheque ];

/// INGRT_PayAllowed
Property INGRTPayAllowed As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = INGRT_PayAllowed ];

/// INGRT_PayAllowDate
Property INGRTPayAllowDate As %Library.Date(FORMAT = 1, SELECTIVITY = "33.3333%") [ SqlColumnNumber = 14, SqlFieldName = INGRT_PayAllowDate ];

/// INGRT_SCG_DR
Property INGRTSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 15, SqlFieldName = INGRT_SCG_DR ];

/// INGRT_AuditFlag
Property INGRTAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INGRT_AuditFlag ];

/// INGRT_AuditFlag
Property INGRTStkType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 17, SqlFieldName = INGRT_StkType ];

/// 已打印标志
Property INGRTPrtFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INGRT_PrtFlag ];

/// INGRT_PayAllowTime
Property INGRTPayAllowTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = INGRT_PayAllowTime ];

/// INGRT_PayAllowUser_DR
Property INGRTPayAllowUserDR As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = INGRT_PayAllowUser_DR ];

/// INGRT_SSUSR_Purch_DR 退货采购审核人
Property INGRTSSUSRPurchDR As User.SSUser [ SqlColumnNumber = 21, SqlFieldName = INGRT_SSUSR_Purch_DR ];

/// INGRT_PurchDate  退货采购审核日期
Property INGRTPurchDate As %Library.Date [ SqlColumnNumber = 22, SqlFieldName = INGRT_PurchDate ];

/// INGRT_PurchDate  退货采购审核时间
Property INGRTPurchTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = INGRT_PurchTime ];

/// INGRT_SSUSR_Treasurer_DR 退货会计审核人
Property INGRTSSUSRTreasurerDR As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = INGRT_SSUSR_Treasurer_DR ];

/// INGRT_TreasureDate  退货会计审核日期
Property INGRTTreasureDate As %Library.Date [ SqlColumnNumber = 25, SqlFieldName = INGRT_TreasureDate ];

/// INGRT_TreasureTime  退货会计审核时间
Property INGRTTreasureTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = INGRT_TreasureTime ];

/// 退货方式
Property INGRTRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INGRT_Remarks ];

/// 赠送标志
Property INGRTGiftFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = INGRT_GiftFlag ];

/// 发送平台标志
Property INGRTSendToSCM As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = INGRT_SendToSCM ];

/// INGRT_CoverId  -封面id,pointer to DHC_INGdRec_Cover
Property INGRTCoverId As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INGRT_CoverId ];

/// 退货类型
Property INGRTType As User.DHCOperateType [ SqlColumnNumber = 31, SqlFieldName = INGRT_Type ];

/// 流水单号(付款审批)
Property INGRTApprovalNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INGRT_ApprovalNO ];

/// INGRT_HRPFlag HRP标记
Property INGRTHRPFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ InitialExpression = "0", SqlColumnNumber = 33, SqlFieldName = INGRT_HRPFlag ];

/// INGRTCanPay 是否可以挂账 for HRP
Property INGRTCanPay As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 34, SqlFieldName = INGRT_CanPay ];

/// 第三方采购平台退货单ID
Property INGRTPurPlanCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INGRT_PurPlanCode ];

/// INGRT_PSVendor_DR 货主 
Property INGRTPSVendorDR As User.APCVendor [ SqlColumnNumber = 36, SqlFieldName = INGRT_PSVendor_DR ];

/// INGRT_StkCat_DR库存分类
Property INGRTStkCatDR As User.INCStkCat [ SqlColumnNumber = 37, SqlFieldName = INGRT_StkCat_DR ];

Index RowIDBasedIDKeyIndex On INGRTRowId [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterINGRT">
<Data name="INGRT_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGRT_AdjCheque">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INGRT_ApprovalNO">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INGRT_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INGRT_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INGRT_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INGRT_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGRT_CanPay">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INGRT_Completed">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGRT_CoverId">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INGRT_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGRT_GiftFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INGRT_HRPFlag">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INGRT_NO">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGRT_PSVendor_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INGRT_PayAllowDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INGRT_PayAllowTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INGRT_PayAllowUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INGRT_PayAllowed">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INGRT_PrtFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INGRT_PurPlanCode">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INGRT_PurchDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INGRT_PurchTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INGRT_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INGRT_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INGRT_SSUSR_Audit_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGRT_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGRT_SSUSR_Purch_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INGRT_SSUSR_Treasurer_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INGRT_SendToSCM">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INGRT_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INGRT_StkType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INGRT_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INGRT_TreasureDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INGRT_TreasureTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INGRT_Type">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^INGRT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INGRT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INGRT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGRT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AUDITDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGRT_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGRT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCover">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGRT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"COVER"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGRT_CoverId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INGRT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGRT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGRT_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGRT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRetNo">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGRT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RETNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INGRT_NO})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGRT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTreaDate">
<Global>^INGRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGRT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TreaDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGRT_TreasureDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGRT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINGDRETS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^INGRT)
	s oldI = +$g(^mdata("DHCINGDRET"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^INGRT = maxI
	s ^mdata("DHCINGDRET") = maxI
}

}
