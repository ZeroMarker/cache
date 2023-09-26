Class User.DHCINGdRec Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INGR_RowId, SqlTableName = DHC_INGdRec, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCINGdRecItm As User.DHCINGdRecItm [ Cardinality = children, Inverse = INGRIINGRParRef ];

/// Des Ref to APCVM
Property INGRAPCVMDR As User.APCVendor [ SqlColumnNumber = 2, SqlFieldName = INGR_APCVM_DR ];

/// Completed Flag
Property INGRCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = INGR_Completed ];

/// Des Ref to CTCUR
Property INGRCTCURDR As User.CTCurrency [ SqlColumnNumber = 4, SqlFieldName = INGR_CTCUR_DR ];

/// Date Of Delivery (DO Date)
Property INGRDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = INGR_Date ];

/// Delivery Order No
Property INGRDONo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INGR_DO_No ];

/// Exchange Rate
Property INGRExRate As %Library.Float [ SqlColumnNumber = 7, SqlComputeCode = {	s {INGR_ExRate}=$$COFO08^at297({INGR_Date},{INGR_CTCUR_DR},{INGR_ExRate})
}, SqlComputed, SqlFieldName = INGR_ExRate, Transient ];

/// Handling Charges
Property INGRHandChg As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INGR_HandChg ];

/// Purchase Order
Property INGRINPODR As User.INPO [ SqlColumnNumber = 9, SqlFieldName = INGR_INPO_DR ];

/// Goods Receive Note No
Property INGRNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INGR_No ];

/// Overall Discount
Property INGROverallDiscount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INGR_OverallDiscount ];

/// Remarks
Property INGRRemarks As list Of %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INGR_Remarks, SqlListType = SUBNODE ];

/// Des Ref to SSUSR
Property INGRSSUSRDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = INGR_SSUSR_DR ];

/// Time of Delivery
Property INGRTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = INGR_Time ];

/// recive Loc DR
Property INGRLocDr As User.CTLoc [ SqlColumnNumber = 15, SqlFieldName = INGR_Loc_Dr ];

/// INGR_CreateUser
Property INGRCreateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = INGR_CreateUser ];

/// INGR_CreateDate
Property INGRCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INGR_CreateDate ];

/// INGR_CreateTime
Property INGRCreateTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INGR_CreateTime ];

/// INGR_Backup1
Property INGRBackup1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INGR_Backup1 ];

/// INGR_Backup2
Property INGRBackup2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INGR_Backup2 ];

/// INGR_Backup3
Property INGRBackup3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INGR_Backup3 ];

/// Pointer to IN_GdRec
Property INGRGdRecDR As User.INGdRec [ SqlColumnNumber = 22, SqlFieldName = INGR_GdRec_DR ];

/// INGR_PayAllowed
Property INGRPayAllowed As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = INGR_PayAllowed ];

/// INGR_Type
Property INGRType As User.DHCOperateType [ SqlColumnNumber = 24, SqlFieldName = INGR_Type ];

/// INGR_SSUSR_Purch_DR
Property INGRSSUSRPurchDR As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = INGR_SSUSR_Purch_DR ];

/// INGR_ReqLoc_Dr
Property INGRReqLocDr As User.CTLoc [ SqlColumnNumber = 26, SqlFieldName = INGR_ReqLoc_Dr ];

/// INGR_SSUSR_Accept_DR
Property INGRSSUSRAcceptDR As User.SSUser [ SqlColumnNumber = 27, SqlFieldName = INGR_SSUSR_Accept_DR ];

/// INGR_SSUSR_Treasurer_DR
Property INGRSSUSRTreasurerDR As User.SSUser [ SqlColumnNumber = 28, SqlFieldName = INGR_SSUSR_Treasurer_DR ];

/// INGR_StkCat_DR
Property INGRSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 29, SqlFieldName = INGR_SCG_DR ];

/// INGR_AuditFlag
Property INGRAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = INGR_AuditFlag ];

/// INGR_StkType
Property INGRStkType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 31, SqlFieldName = INGR_StkType ];

/// INGR_GiftFlag
Property INGRGiftFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = INGR_GiftFlag ];

/// INGR_AdjCheque
Property INGRAdjCheque As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = INGR_AdjCheque ];

/// INGR_PayAllowUser
Property INGRPayAllowUser As User.SSUser [ SqlColumnNumber = 34, SqlFieldName = INGR_PayAllowUser ];

/// INGR_PayAllowDate
Property INGRPayAllowDate As %Library.Date [ SqlColumnNumber = 35, SqlFieldName = INGR_PayAllowDate ];

/// INGR_PayAllowTime
Property INGRPayAllowTime As %Library.Date [ SqlColumnNumber = 36, SqlFieldName = INGR_PayAllowTime ];

/// INGR_SourceOfFund
Property INGRSourceOfFund As User.DHCSourceOfFund [ SqlColumnNumber = 37, SqlFieldName = INGR_SourceOfFund ];

/// INGR_PurchDate
Property INGRPurchDate As %Library.Date [ SqlColumnNumber = 38, SqlFieldName = INGR_PurchDate ];

/// INGR_PurchTime
Property INGRPurchTime As %Library.Time [ SqlColumnNumber = 39, SqlFieldName = INGR_PurchTime ];

/// INGR_TreasureDate
Property INGRTreasureDate As %Library.Date [ SqlColumnNumber = 40, SqlFieldName = INGR_TreasureDate ];

/// INGR_TreasureTime
Property INGRTreasureTime As %Library.Time [ SqlColumnNumber = 41, SqlFieldName = INGR_TreasureTime ];

/// INGR_Red - 红冲标志
Property INGRRed As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = INGR_Red ];

/// INGR_GR_Red - 被红冲的入库单
Property INGRGRRed As User.DHCINGdRec [ SqlColumnNumber = 43, SqlFieldName = INGR_GR_Red ];

/// INGR_PrintFlag
Property INGRPrintFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = INGR_PrintFlag ];

/// INGR_INIsTrf_DR - 根据出库单生成入库单
Property INGRINIsTrfDR As User.DHCInIsTrf [ SqlColumnNumber = 45, SqlFieldName = INGR_INIsTrf_DR ];

/// INGR_OeoriRecFlag  高值医嘱补录标志
Property INGROeoriRecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = INGR_OeoriRecFlag ];

/// 流水单号(付款审批)
Property INGRApprovalNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = INGR_ApprovalNO ];

/// INGR_CompleteDate完成日期
Property INGRCompleteDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 48, SqlFieldName = INGR_CompleteDate ];

/// INGR_StkCat_DR库存分类
Property INGRStkCatDR As User.INCStkCat [ SqlColumnNumber = 49, SqlFieldName = INGR_StkCat_DR ];

/// Des Ref to Carrier
Property INGRCarrierDR As User.DHCCarrier [ SqlColumnNumber = 50, SqlFieldName = INGR_Carrier_DR ];

Property INGRHRPFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = INGR_HRPFlag ];

/// INGRCanPay 是否可以挂账 for HRP
Property INGRCanPay As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 52, SqlFieldName = INGR_CanPay ];

/// INGR_SSUSR_Receive_DR  入库单制单记录接收人带到自动生成的库存转移制单
Property INGRSSUSRReceiveDR As User.SSUser [ SqlColumnNumber = 53, SqlFieldName = INGR_SSUSR_Receive_DR ];

/// 供应商送货联系人
Property INGRDeliveryMan As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = INGR_DeliveryMan ];

/// 医共体主院入库单id
Property INGRHDCMIngdId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = INGR_HDCMIngdId ];

/// INGR_PSVendor_DR 货主 
Property INGRPSVendorDR As User.APCVendor [ SqlColumnNumber = 56, SqlFieldName = INGR_PSVendor_DR ];

/// INGR_Director_DR 科室主任
Property INGRDirectorDR As User.SSUser [ SqlColumnNumber = 57, SqlFieldName = INGR_Director_DR ];

/// INGR_ExcessFlag - 合同超量标志
Property INGRExcessFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = INGR_ExcessFlag ];

/// INGR_Contract_DR 关联的合同表 
Property INGRContractDR As BS.PHA.IN.Contract [ SqlColumnNumber = 59, SqlFieldName = INGR_Contract_DR ];

/// INGR_FixedFlag  固定标识(明细不可编辑)
Property INGRFixedFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = INGR_FixedFlag ];

/// INGR_EinvnoFlag电子发票标志
Property INGREinvnoFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = INGR_EinvnoFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINGR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INGR_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGR_AdjCheque">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INGR_ApprovalNO">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INGR_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INGR_Backup1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INGR_Backup2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INGR_Backup3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INGR_CTCUR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGR_CanPay">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INGR_Carrier_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INGR_CompleteDate">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INGR_Completed">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INGR_Contract_DR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="INGR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INGR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INGR_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INGR_DO_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGR_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INGR_DeliveryMan">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="INGR_Director_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="INGR_EinvnoFlag">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="INGR_ExRate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGR_ExcessFlag">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="INGR_FixedFlag">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="INGR_GR_Red">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INGR_GdRec_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INGR_GiftFlag">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INGR_HDCMIngdId">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="INGR_HRPFlag">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INGR_HandChg">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGR_INIsTrf_DR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INGR_INPO_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INGR_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INGR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGR_OeoriRecFlag">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INGR_OverallDiscount">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INGR_PSVendor_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="INGR_PayAllowDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INGR_PayAllowTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INGR_PayAllowUser">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INGR_PayAllowed">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INGR_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INGR_PurchDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INGR_PurchTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INGR_Red">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INGR_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INGR_ReqLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INGR_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INGR_SSUSR_Accept_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INGR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGR_SSUSR_Purch_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INGR_SSUSR_Receive_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INGR_SSUSR_Treasurer_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INGR_SourceOfFund">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INGR_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INGR_StkType">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INGR_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INGR_TreasureDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INGR_TreasureTime">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INGR_Type">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCINGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INGR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCreateDateLOC">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INGR_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INGR_Loc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDONo">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INGR_DO_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateGdrecdr">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateGdDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_GdRec_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRDate">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DODate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRNO">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INGR_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINIsTrfDR">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INIsTrf"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGR_INIsTrf_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINPODR">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGR_INPO_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTrakINGR">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INGR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGR_GdRec_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTreasureDate">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TreaDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGR_TreasureDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexAPCVMDR">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INGR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGR_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexContractDR">
<Global>^DHCINGR</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Contract"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INGR_Contract_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INGR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINGdRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINGR)
	s oldI = +$g(^mdata("DHCINGDREC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINGR = maxI
	s ^mdata("DHCINGDREC") = maxI
}

}
