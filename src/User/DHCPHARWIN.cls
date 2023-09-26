Class User.DHCPHARWIN Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHA_ROWID, SqlTableName = DHC_PHARWIN, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHA_PRT_DR
Property PHAPRTDR As User.DHCINVPRT [ SqlColumnNumber = 2, SqlFieldName = PHA_PRT_DR ];

/// PHA_DATE
Property PHADATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PHA_DATE ];

/// PHA_TIME
Property PHATIME As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PHA_TIME ];

/// PHA_PHW_DR
Property PHAPHWDR As User.DHCPHWINDOW [ SqlColumnNumber = 5, SqlFieldName = PHA_PHW_DR ];

/// PHA_PHL_DR
Property PHAPHLDR As User.DHCPHLOC [ SqlColumnNumber = 6, SqlFieldName = PHA_PHL_DR ];

/// PHA_FINFLAG
Property PHAFINFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHA_FINFLAG ];

/// PHA_NOUSER
Property PHANOUSER As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHA_NOUSER ];

/// PHA_PRINTFLAG
Property PHAPRINTFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHA_PRINTFLAG ];

/// PHA_ZFCL
Property PHAZFCL As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHA_ZFCL ];

/// PHA_PRINTDATE
Property PHAPRINTDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PHA_PRINTDATE ];

/// PHA_FINDATE
Property PHAFINDATE As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PHA_FINDATE ];

/// pha_lcdserialno
Property phalcdserialno As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = pha_lcdserialno ];

/// PHA_RETFLAG
Property PHARETFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHA_RETFLAG ];

/// Pha_UndsipFlag
Property PhaUndsipFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = Pha_UndsipFlag ];

/// Pha_phpy_dr
Property Phaphpydr As User.DHCPHPYWIN [ SqlColumnNumber = 16, SqlFieldName = Pha_phpy_dr ];

/// Pha_PrescNo
Property PhaPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = Pha_PrescNo ];

/// PHA_PRINTUSER_DR
Property PHAPRINTUSERDR As User.DHCPHPERSON [ SqlColumnNumber = 18, SqlFieldName = PHA_PRINTUSER_DR ];

/// PHA_PRINTTIME
Property PHAPRINTTIME As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = PHA_PRINTTIME ];

/// PHA_PAPMI_DR
Property PHAPAPMIDR As User.PAPatMas [ SqlColumnNumber = 20, SqlFieldName = PHA_PAPMI_DR ];

/// PHA_QueueNo
Property PHAQueueNo As User.DHCPHWINQUEUE [ SqlColumnNumber = 21, SqlFieldName = PHA_QueueNo ];

/// PHA_EMFLAG 应急标识
Property PHAEMFLAG As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PHA_EMFLAG ];

/// 设备唯一号
Property PHADeviceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PHA_DeviceID ];

/// 药师、医生审核状态
Property PHAChkStatus As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PHA_ChkStatus ];

/// 配药人员姓名
Property PHAConfigUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PHA_ConfigUser ];

/// 核对人员姓名
Property PHAChkUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PHA_ChkUser ];

/// 发药科室代码
Property PHALocCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PHA_LocCode ];

/// 窗口描述
Property PHAWinDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PHA_WinDesc ];

/// 配药人员代码
Property PHAConfigUserCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PHA_ConfigUserCode ];

/// 核对人员代码
Property PHAChkUserCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PHA_ChkUserCode ];

/// 审方日期
Property PHAPresChkDate As %Library.Date [ SqlColumnNumber = 31, SqlFieldName = PHA_PresChkDate ];

/// 审方时间
Property PHAPresChkTime As %Library.Time [ SqlColumnNumber = 32, SqlFieldName = PHA_PresChkTime ];

/// 打印日期
Property PHAAutoPrintDate As %Library.Date [ SqlColumnNumber = 33, SqlFieldName = PHA_AutoPrintDate ];

/// 打印时间
Property PHAAutoPrintTime As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = PHA_AutoPrintTime ];

/// 打印机器IP
Property PHAAutoPrintIP As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PHA_AutoPrintIP ];

/// 配发状态
Property PHAStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PHA_Status ];

/// 可以开始配药标志 10-可以开始配 20-已配
Property PHAStartPyFlag As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = PHA_StartPyFlag ];

/// 优先调配
Property PHAPriorFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 38, SqlFieldName = PHA_PriorFlag ];

/// 最近操作日期
Property PHALastDate As %Library.Date [ SqlColumnNumber = 39, SqlFieldName = PHA_LastDate ];

/// 最近操作时间
Property PHALastTime As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = PHA_LastTime ];

/// 发药机是否已经收到
Property PHASendToMachine As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 41, SqlFieldName = PHA_SendToMachine ];

/// 配送日期
Property PHADeliveryDate As %Library.Date [ SqlColumnNumber = 42, SqlFieldName = PHA_DeliveryDate ];

/// 配送地址
Property PHADeliveryAddress As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = PHA_DeliveryAddress ];

/// 发药方式(1院内 2快递)
Property PHADjType As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = PHA_DjType ];

/// 快递单号
Property PHAExpressNo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = PHA_ExpressNo ];

/// 配送收货人
Property PHADeliveryConsignee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = PHA_DeliveryConsignee ];

Property PHADeliveryTelephone As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = PHA_DeliveryTelephone ];

/// 配药单号
Property PHAPydNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = PHA_PydNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHARW)</SqlIdExpression>
<SQLMap name="IndexCommonUser">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CommonUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHA_PRINTUSER_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_PRINTDATE}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHA_PRINTTIME}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDev">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"WINDEV"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PHA_PHW_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHA_DeviceID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PHA_DATE}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPUser">
<Global>^DHCPHARi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHA_PRINTUSER_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_PHW_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_DATE}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPmiDev">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PmiDev"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHA_DATE}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_DeviceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexQueueNo">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHA_ROWI</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"QueueNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHA_QueueNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStart">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"START"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHA_LastDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_PHL_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_StartPyFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHAINDEX">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PRT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHA_PRT_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHAMASTER">
<Data name="PHA_AutoPrintDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PHA_AutoPrintIP">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PHA_AutoPrintTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PHA_ChkStatus">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHA_ChkUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PHA_ChkUserCode">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PHA_ConfigUser">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHA_ConfigUserCode">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PHA_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHA_DeliveryAddress">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="PHA_DeliveryConsignee">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="PHA_DeliveryDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="PHA_DeliveryTelephone">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="PHA_DeviceID">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHA_DjType">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="PHA_EMFLAG">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHA_ExpressNo">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="PHA_FINDATE">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHA_FINFLAG">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHA_LastDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PHA_LastTime">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PHA_LocCode">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PHA_NOUSER">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHA_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHA_PHL_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHA_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHA_PRINTDATE">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHA_PRINTFLAG">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHA_PRINTTIME">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHA_PRINTUSER_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHA_PRT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHA_PresChkDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PHA_PresChkTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PHA_PriorFlag">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PHA_PydNo">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="PHA_QueueNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHA_RETFLAG">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHA_SendToMachine">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="PHA_StartPyFlag">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PHA_Status">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PHA_TIME">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHA_WinDesc">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PHA_ZFCL">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Pha_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Pha_UndsipFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Pha_phpy_dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="pha_lcdserialno">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPHARW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHA_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PHAPAPMI">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHA_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHA_DATE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHA_PHL_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHAPHLINDEX">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHA_PHL_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHAPHW">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"WIN"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHA_PHW_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHA_DATE}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHAPRESCNO">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{Pha_PrescNo}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHAPRTDATE">
<Global>^DHCPHARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PRTDATE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHA_PRINTDATE}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Pha_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="phaindexdate">
<Global>^DHCPHARWi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHA_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHA_DATE}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHA_PHL_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHA_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHARWINS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHARW)
	s oldI = +$g(^mdata("DHCPHARWIN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHARW = maxI
	s ^mdata("DHCPHARWIN") = maxI
}

}
