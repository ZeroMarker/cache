Class User.DHCPhaLocation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PL_Rowid, SqlTableName = DHC_PhaLocation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPhaLocDisType As User.DHCPhaLocDisType [ Cardinality = children, Inverse = PLDPPLParref ];

/// PL_CTLOC_DR
Property PLCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PL_CTLOC_DR ];

/// PL_WardRequired
Property PLWardRequired As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = PL_WardRequired ];

/// PL_CYDYFlag
Property PLCYDYFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PL_CYDYFlag ];

/// PL_DispStartDate
Property PLDispStartDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PL_DispStartDate ];

/// PL_DispEndDate
Property PLDispEndDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PL_DispEndDate ];

/// PL_DispStartTime
Property PLDispStartTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PL_DispStartTime ];

/// PL_DispEndTime
Property PLDispEndTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PL_DispEndTime ];

/// PL_StatStartDate
Property PLStatStartDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PL_StatStartDate ];

/// PL_StatEndDate
Property PLStatEndDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PL_StatEndDate ];

/// PL_StatEndTime
Property PLStatStartTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PL_StatStartTime ];

/// PL_StatEndTime
Property PLStatEndTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PL_StatEndTime ];

/// PL_CountNum
Property PLCountNum As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PL_CountNum ];

/// PL_CountPrefix
Property PLCountPrefix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PL_CountPrefix ];

/// PL_AuditNeed_Flag
Property PLAuditNeedFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = PL_AuditNeed_Flag ];

/// PL_CountFinalDate
Property PLCountFinalDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = PL_CountFinalDate ];

/// PL_WardReserveFlag
Property PLReserveRetFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = PL_ReserveRetFlag ];

/// PL_PrtRetFlag
Property PLPrtRetFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = PL_PrtRetFlag ];

/// PL_DispUserFlag
Property PLDispUserFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = PL_DispUserFlag ];

/// PL_RetStDate
Property PLRetStDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PL_RetStDate ];

/// PL_RetEndDate
Property PLRetEndDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PL_RetEndDate ];

/// PL_RetAllFlag
Property PLRetAllFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = PL_RetAllFlag ];

/// PL_OperaterFlag
Property PLOperaterFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = PL_OperaterFlag ];

/// PL_AduitBillFlag
Property PLAduitBillFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = PL_AduitBillFlag ];

/// PL_DispTypeLocalFlag
Property PLDispTypeLocalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = PL_DispTypeLocalFlag ];

/// PL_DisplayEmyFlag
Property PLDisplayEmyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = PL_DisplayEmyFlag ];

/// PL_DisplayOutFlag 20141218 zhouyg 原功能不用,改为判断是否默认选择发药类别
Property PLDisplayOutFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = PL_DisplayOutFlag ];

/// PL_LSFlag
Property PLLSFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = PL_LSFlag ];

/// PL_ReqWardFlag
Property PLReqWardFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = PL_ReqWardFlag ];

/// PL_DispDefaultFlag
Property PLDispDefaultFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PL_DispDefaultFlag ];

/// PL_OutPrint
Property PLOutPrint As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PL_OutPrint ];

/// PL_ReqWardFlag
Property PLSendMachine As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = PL_SendMachine ];

/// PL_OrdAuditFlag
Property PLOrdAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = PL_OrdAuditFlag ];

/// PL_OrdAuditStartTime
Property PLOrdAuditStartTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = PL_OrdAuditStartTime ];

/// PL_OrdAuditEndTime
Property PLOrdAuditEndTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PL_OrdAuditEndTime ];

/// 是否给第三方发信息标记
Property PLSendMsgFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = PL_SendMsgFlag ];

/// 是否自动审核
Property PLAutoAuditFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = PL_AutoAuditFlag ];

/// 发药前是否需要护士医嘱处理
Property PLDealOrdFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = PL_DealOrdFlag ];

/// 发药是否录入核对人
Property PLAuditUserFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = PL_AuditUserFlag ];

/// 病区结余药冲减标识
Property PLBalReserveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = PL_BalReserveFlag ];

/// 出院带药发药前是否需要护士领药审核
Property PLOutOrdNeedNurAudit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = PL_OutOrdNeedNurAudit ];

/// 基数发药默认开始日期
Property PLBaseDispStartDate As %Library.String [ SqlColumnNumber = 42, SqlFieldName = PL_BaseDispStartDate ];

/// 基数发药默认开始时间
Property PLBaseDispEndDate As %Library.String [ SqlColumnNumber = 43, SqlFieldName = PL_BaseDispEndDate ];

/// 基数发药默认结束日期
Property PLBaseDispStartTime As %Library.String [ SqlColumnNumber = 44, SqlFieldName = PL_BaseDispStartTime ];

/// 基数发药默认结束时间
Property PLBaseDispEndTime As %Library.String [ SqlColumnNumber = 45, SqlFieldName = PL_BaseDispEndTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPL)</SqlIdExpression>
<SQLMap name="DataMasterPharmacyLoc">
<Data name="PL_AduitBillFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PL_AuditNeed_Flag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PL_AuditUserFlag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PL_AutoAuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PL_BalReserveFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PL_BaseDispEndDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="PL_BaseDispEndTime">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="PL_BaseDispStartDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="PL_BaseDispStartTime">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="PL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PL_CYDYFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PL_CountFinalDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PL_CountNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PL_CountPrefix">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PL_DealOrdFlag">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PL_DispDefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PL_DispEndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PL_DispEndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PL_DispStartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PL_DispStartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PL_DispTypeLocalFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PL_DispUserFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PL_DisplayEmyFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PL_DisplayOutFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PL_LSFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PL_OperaterFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PL_OrdAuditEndTime">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PL_OrdAuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PL_OrdAuditStartTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PL_OutOrdNeedNurAudit">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="PL_OutPrint">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PL_PrtRetFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PL_ReqWardFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PL_ReserveRetFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PL_RetAllFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PL_RetEndDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PL_RetStDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PL_SendMachine">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PL_SendMsgFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PL_StatEndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PL_StatEndTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PL_StatStartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PL_StatStartTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PL_WardRequired">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCPL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
    s newI = +$g(^DHCPL)
    s oldI = +$g(^mdata("DHCPHALOC"))
    s maxI = $s(newI > oldI : newI, 1 : oldI)
    s ^DHCPL = maxI
    s ^mdata("DHCPHALOC") = maxI
}

}
