Class User.DHCSOPFConfig Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPFC_RowID, SqlTableName = DHC_SOPFConfig, StorageStrategy = SQLStorage ]
{

/// Refer WebConSys
Property OPFCWebConDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = OPFC_WebConDR ];

/// OPFC_Hosp_DR
Property OPFCHospDR As User.CTHospital [ SqlColumnNumber = 3, SqlFieldName = OPFC_Hosp_DR ];

/// OPFC_ItemFlag
Property OPFCItemFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OPFC_ItemFlag ];

/// OPFC_ReclocFlag
Property OPFCReclocFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OPFC_ReclocFlag ];

/// OPFC_PresNoFlag
Property OPFCPresNoFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OPFC_PresNoFlag ];

/// OPFC_RecInvCount
Property OPFCRecInvCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OPFC_RecInvCount ];

/// OPFC_PrintCount
Property OPFCPrintCount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OPFC_PrintCount ];

/// OPFC_HerbalFlag
Property OPFCHerbalFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OPFC_HerbalFlag ];

/// OPFC_HerbalDesc
Property OPFCHerbalDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = OPFC_HerbalDesc ];

/// OPFC_HerbalNum
Property OPFCHerbalNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OPFC_HerbalNum ];

/// OP version Info
Property OPFCVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OPFC_Version ];

/// OPFC_YBConFlag
Property OPFCYBConFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = OPFC_YBConFlag ];

/// OPFC_AdmFlag
Property OPFCAdmFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = OPFC_AdmFlag ];

/// OPFC_AppFlag
Property OPFCAppFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = OPFC_AppFlag ];

/// OPFC_PRTYBConFlag
Property OPFCPRTYBConFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = OPFC_PRTYBConFlag ];

/// OPFC_RoundDownNum
Property OPFCRoundDownNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = OPFC_RoundDownNum ];

/// OPFC_OrdSIFlag
Property OPFCOrdSIFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = OPFC_OrdSIFlag ];

/// OPFC_AItmCatStr
Property OPFCAItmCatStr As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = OPFC_AItmCatStr ];

/// OPFC_Use the Fare Type
Property OPFCUseFareType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = OPFC_UseFareType ];

/// OPFC_BILL Version
Property OPFCBILLVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = OPFC_BILLVersion ];

/// OPFC_IntervalMin 异常收费提醒间隔时间
Property OPFCIntervalMin As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = OPFC_IntervalMin ];

/// OPFC_ZeroPriceChargeFlag 价格为零的医嘱结算是否进账单
Property OPFCZeroPriceChargeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = OPFC_ZeroPriceChargeFlag ];

/// OPFC_Out Patient Search flag
Property OPFCOutSearchFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = OPFC_OutSearchFlag ];

/// OPFC_Out Patient Search Time Range
Property OPFCOutTimeRange As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = OPFC_OutTimeRange ];

/// OPFC_Emergency Patient Search Flag
Property OPFCEmergencySearchFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = OPFC_EmergencySearchFlag ];

/// Emergency Patient Search Time Range
Property OPFCEmergencyTimeRange As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = OPFC_EmergencyTimeRange ];

/// OPFC_AuditSpaceTime
Property OPFCAuditSpaceTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = OPFC_AuditSpaceTime ];

/// OPFC_OESkinRtnFlag
Property OPFCOESkinRtnFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = OPFC_OESkinRtnFlag ];

/// OPFC_OEORDLimitFootFlag
Property OPFCOEORDLimitFootFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = OPFC_OEORDLimitFootFlag ];

///  OPFC_SubAvailFlag
Property OPFCSubAvailFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = OPFC_SubAvailFlag ];

/// OPFC_AccPreDepReceiptType
Property OPFCAccPreDepReceiptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = OPFC_AccPreDepReceiptType ];

/// OPFC_RegReceiptType  挂号发票类型(R:挂号小票, O:门诊发票)
Property OPFCRegReceiptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = OPFC_RegReceiptType ];

/// OPFC_StrikeRequireINV 门诊退费(红冲)是否打印负票
Property OPFCStrikeRequireINV As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = OPFC_StrikeRequireINV ];

/// OPFC_SKCFootFlag 是否选择病种结算
Property OPFCSKCFootFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = OPFC_SKCFootFlag ];

/// OPFC_NewAdmReaFootFlag 是否选择新费别结算
Property OPFCNewAdmReaFootFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = OPFC_NewAdmReaFootFlag ];

/// OPFC_UnAuditOrderCateList  免审核医嘱子类
Property OPFCUnAuditOrderCateList As %Library.String(COLLATION = "Exact", MAXLEN = 50000, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = OPFC_UnAuditOrderCateList ];

/// OPFC_OneToManyFlag 集中打印发票:小条对应关系
Property OPFCOneToManyFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = OPFC_OneToManyFlag ];

/// OPFC_RegInvFlag    挂号票是否使用门诊发票
Property OPFCRegInvFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = OPFC_RegInvFlag ];

/// OPFC_InvDateFlag   集中打印发票是否按自然日拆分
Property OPFCInvDateFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = OPFC_InvDateFlag ];

/// OPFC_RcptUserFlag  收费员补录医嘱是否需要停医嘱退费(0:不需要停 1:需要停)
Property OPFCRcptUserFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = OPFC_RcptUserFlag ];

/// OPFC_SuperAuthGrp 超级权限安全组
Property OPFCSuperAuthGrp As %Library.String(COLLATION = "Exact", MAXLEN = 50000, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = OPFC_SuperAuthGrp ];

/// OPFC_SuperAuthLoc 超级权限科室 $(2)用于审核退费
Property OPFCSuperAuthLoc As %Library.String(COLLATION = "Exact", MAXLEN = 50000, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = OPFC_SuperAuthLoc ];

/// OPFC_PrtGuideFlag 打印导诊单权限
Property OPFCPrtGuideFlag As %Library.String [ SqlColumnNumber = 44, SqlFieldName = OPFC_PrtGuideFlag ];

/// OPFC_StayChargeMode 急诊留观收费模式
Property OPFCStayChargeMode As %Library.String [ SqlColumnNumber = 45, SqlFieldName = OPFC_StayChargeMode ];

/// OPFC_OPTransferFlag  门诊账户转住院押金
Property OPFCOPTransferFlag As %Library.String [ SqlColumnNumber = 46, SqlFieldName = OPFC_OPTransferFlag ];

/// OPFC_IPTransferFlag  住院押金转门诊账户
Property OPFCIPTransferFlag As %Library.String [ SqlColumnNumber = 47, SqlFieldName = OPFC_IPTransferFlag ];

/// OPFC_ICDXFlag  按病种拆分标识
Property OPFCICDXFlag As %Library.String [ SqlColumnNumber = 48, SqlFieldName = OPFC_ICDXFlag ];

/// OPFC_RegOrdFlag 挂号医嘱单独拆票
Property OPFCRegOrdFlag As %Library.String [ SqlColumnNumber = 49, SqlFieldName = OPFC_RegOrdFlag ];

/// OPFC_TreatItmReqMode 检查、治疗医嘱审核模式
Property OPFCTreatItmReqMode As %Library.String [ SqlColumnNumber = 50, SqlFieldName = OPFC_TreatItmReqMode ];

/// OPFC_ZeroAmtUseYBFlag 零费用结算是否调用调用医保
Property OPFCZeroAmtUseYBFlag As %Library.String [ SqlColumnNumber = 51, SqlFieldName = OPFC_ZeroAmtUseYBFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSOPFCON)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OPFC_AItmCatStr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OPFC_AccPreDepReceiptType">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OPFC_AdmFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OPFC_AppFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OPFC_AuditSpaceTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OPFC_BILLVersion">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OPFC_EmergencySearchFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OPFC_EmergencyTimeRange">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OPFC_HerbalDesc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPFC_HerbalFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPFC_HerbalNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OPFC_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPFC_ICDXFlag">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="OPFC_IPTransferFlag">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="OPFC_IntervalMin">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OPFC_InvDateFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="OPFC_ItemFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPFC_NewAdmReaFootFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OPFC_OEORDLimitFootFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OPFC_OESkinRtnFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OPFC_OPTransferFlag">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="OPFC_OneToManyFlag">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OPFC_OrdSIFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OPFC_OutSearchFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OPFC_OutTimeRange">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OPFC_PRTYBConFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OPFC_PresNoFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPFC_PrintCount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPFC_PrtGuideFlag">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="OPFC_RcptUserFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OPFC_RecInvCount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPFC_ReclocFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPFC_RegInvFlag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OPFC_RegOrdFlag">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="OPFC_RegReceiptType">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OPFC_RoundDownNum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OPFC_SKCFootFlag">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OPFC_StayChargeMode">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="OPFC_StrikeRequireINV">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OPFC_SubAvailFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OPFC_SuperAuthGrp">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="OPFC_SuperAuthLoc">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OPFC_TreatItmReqMode">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="OPFC_UnAuditOrderCateList">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OPFC_UseFareType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OPFC_Version">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OPFC_WebConDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPFC_YBConFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OPFC_ZeroAmtUseYBFlag">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="OPFC_ZeroPriceChargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Global>^DHCSOPFCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPFC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{OPFC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSOPFConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
