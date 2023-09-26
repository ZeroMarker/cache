Class User.DHCPHACollected Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHC_PHACollect_RowID, SqlTableName = DHC_PHACollected, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHACollectItm As User.DHCPHACollectItm [ Cardinality = children, Inverse = PHACIPHACParRef ];

/// Pharmacy
Property DHCPHALocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DHC_PHALoc_DR ];

/// Collect Date
Property DHCPHACollectDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHC_PHACollectDate ];

/// Collect Time
Property DHCPHACollectTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = DHC_PHACollectTime ];

/// Wards
Property DHCPHAWardDR As User.PACWard [ SqlColumnNumber = 5, SqlFieldName = DHC_PHAWard_DR ];

/// Operator
Property DHCPHAOperator As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DHC_PHAOperator ];

/// DHC_PHACollectStatus
Property DHCPHACollectStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHC_PHACollectStatus ];

/// DHC_PHAPrintDate
Property DHCPHAPrintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DHC_PHAPrintDate ];

/// DHC_PHAPrintTime
Property DHCPHAPrintTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DHC_PHAPrintTime ];

/// DHC_PHACounts
Property DHCPHACounts As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DHC_PHACounts ];

/// DHC_PHADateFrom
Property DHCPHADateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = DHC_PHADateFrom ];

/// DHC_PHADateTo
Property DHCPHADateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DHC_PHADateTo ];

/// DHC_PHAOrdType
Property DHCPHAOrdType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHC_PHAOrdType ];

/// DHC_PHACollectUser
Property DHCPHACollectUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = DHC_PHACollectUser ];

/// DHC_PHADispNo
Property DHCPHADispNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHC_PHADispNo ];

/// DHC_SendAutoFlag
Property DHCSendAutoFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DHC_SendAutoFlag ];

/// DHC_PHAPrintFlag
Property DHCPHAPrintFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHC_PHAPrintFlag ];

/// DHC_PHASend_User
Property DHCPHASendUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHC_PHASendUser ];

/// DHC_PHAOperateDate
Property DHCPHAOperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = DHC_PHAOperateDate ];

/// DHC_PHAOperateTime
Property DHCPHAOperateTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = DHC_PHAOperateTime ];

/// DHC_PHAStkFlag
Property DHCPHAStkFlag As %Library.String [ SqlColumnNumber = 21, SqlFieldName = DHC_PHAStkFlag ];

/// DHC_PHAUrgentFlag
Property DHCPHAUrgentFlag As %Library.String [ SqlColumnNumber = 22, SqlFieldName = DHC_PHAUrgentFlag ];

/// DHC_PHADeliveryman_DR
Property DHCPHADeliverymanDR As User.DHCPhaDeliveryman [ SqlColumnNumber = 23, SqlFieldName = DHC_PHADeliveryman_DR ];

/// 摆药机发送次数
Property DHCPHASendMedNum As %Library.Integer [ SqlColumnNumber = 24, SqlFieldName = DHC_PHASendMedNum ];

/// 核对或者签收人
Property DHCPHAAuditor As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = DHC_PHAAuditor ];

/// 核对或者签收标志
Property DHCPHAAuditFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 26, SqlFieldName = DHC_PHAAuditFlag ];

/// 核对或者签收日期
Property DHCPHAAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = DHC_PHAAuditDate ];

/// 核对或者签收时间
Property DHCPHAAuditTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = DHC_PHAAuditTime ];

/// 病区专业组
Property DHCPHAWardGroupDR As User.DHCWardProGroup [ SqlColumnNumber = 29, SqlFieldName = DHC_PHAWardGroup_DR ];

/// 复核日期(抓/包药完成日期)
Property DHCPHACheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = DHC_PHACheckDate ];

/// 复核时间(抓/包药完成时间)
Property DHCPHACheckTime As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = DHC_PHACheckTime ];

/// 复核人
Property DHCPHAChecker As User.SSUser [ SqlColumnNumber = 32, SqlFieldName = DHC_PHAChecker ];

/// 非HIS系统发药日期
Property DHCPHAOthDispDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = DHC_PHAOthDispDate ];

/// 非HIS系统发药时间
Property DHCPHAOthDispTime As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = DHC_PHAOthDispTime ];

/// 非HIS系统发药人
Property DHCPHAOthDispUser As User.SSUser [ SqlColumnNumber = 35, SqlFieldName = DHC_PHAOthDispUser ];

/// 数据来源
Property DHCPHADataSource As %Library.String [ SqlColumnNumber = 36, SqlFieldName = DHC_PHADataSource ];

/// 第三方机器号
Property DHCPHAMachNo As %Library.String [ SqlColumnNumber = 37, SqlFieldName = DHC_PHAMachNo ];

/// 住院发药打印流水号
Property DHCPHAPrintNo As %Library.String [ SqlColumnNumber = 38, SqlFieldName = DHC_PHAPrintNo ];

/// 查询开始时间
Property DHCPHATimeFrom As %Library.Time [ SqlColumnNumber = 39, SqlFieldName = DHC_PHATimeFrom ];

/// 查询开始时间
Property DHCPHATimeTo As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = DHC_PHATimeTo ];

/// 处方号
Property DHCPHAPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = DHC_PHAPrescNo ];

/// 可退药标志
Property DHCPHAAgreeRetFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = DHC_PHAAgreeRetFlag ];

/// 可退药操作人
Property DHCPHAAgreeRetUserDr As User.SSUser [ SqlColumnNumber = 43, SqlFieldName = DHC_PHAAgreeRetUser_Dr ];

/// 可退药日期
Property DHCPHAAgreeRetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = DHC_PHAAgreeRetDate ];

/// 可退药时间
Property DHCPHAAgreeRetTime As %Library.Time [ SqlColumnNumber = 45, SqlFieldName = DHC_PHAAgreeRetTime ];

/// 可退药备注
Property DHCPHAAgreeRetRemark As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = DHC_PHAAgreeRetRemark ];

/// 第一配药审核人
Property DHCPHAAuditUser As User.SSUser [ SqlColumnNumber = 47, SqlFieldName = DHC_PHAAuditUser ];

/// 第二配药审核人
Property DHCPHAReAuditUser As User.SSUser [ SqlColumnNumber = 48, SqlFieldName = DHC_PHAReAuditUser ];

/// 代煎人
Property DHCPHADefeatedUser As User.SSUser [ SqlColumnNumber = 49, SqlFieldName = DHC_PHADefeatedUser ];

/// 科室
Property DHCPHADocLocDR As User.CTLoc [ SqlColumnNumber = 50, SqlFieldName = DHC_PHADocLoc_DR ];

/// 打印人
Property DHCPHAPrintUser As User.SSUser [ SqlColumnNumber = 51, SqlFieldName = DHC_PHAPrintUser ];

/// 备药单ID
Property DHCPHADrawDR As User.DHCPHDraw [ SqlColumnNumber = 52, SqlFieldName = DHC_PHADraw_DR ];

/// 第二配药人
Property DHCPHASecOperator As User.SSUser [ SqlColumnNumber = 53, SqlFieldName = DHC_PHASecOperator ];

/// 点击发药的核对人, 双人核对
Property DHCPHACollateUser As User.SSUser [ SqlColumnNumber = 54, SqlFieldName = DHC_PHACollateUser ];

/// 楼层
Property DHCPHABuildFloorDR As User.CTLocBuildingFloor [ SqlColumnNumber = 55, SqlFieldName = DHC_PHABuildFloor_DR ];

/// 备注
Property DHCPHARemark As %Library.String [ SqlColumnNumber = 56, SqlFieldName = DHC_PHARemark ];

/// 患者领药信息, 领药人身份证等
Property DHCPHAPatGetInfo As %String [ SqlColumnNumber = 57, SqlFieldName = DHC_PHAPatGetInfo ];

/// 患者领药日期
Property DHCPHAPatGetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 58, SqlFieldName = DHC_PHAPatGetDate ];

/// 患者领药时间
Property DHCPHAPatGetTime As %Library.Time [ SqlColumnNumber = 59, SqlFieldName = DHC_PHAPatGetTime ];

/// 配送交接日期
Property DHCPHASendDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 60, SqlFieldName = DHC_PHASendDate ];

/// 配送交接时间
Property DHCPHASendTime As %Library.Time [ SqlColumnNumber = 61, SqlFieldName = DHC_PHASendTime ];

/// 第一配药审核人审核日期
Property DHCPHAAuditUserDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 62, SqlFieldName = DHC_PHAAuditUserDate ];

/// 第一配药审核人审核时间
Property DHCPHAAuditUserTime As %Library.Time [ SqlColumnNumber = 63, SqlFieldName = DHC_PHAAuditUserTime ];

/// 配送人配送日期
Property DHCPHADeliveryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 64, SqlFieldName = DHC_PHADeliveryDate ];

/// 配送人配送时间
Property DHCPHADeliveryTime As %Library.Time [ SqlColumnNumber = 65, SqlFieldName = DHC_PHADeliveryTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHAC)</SqlIdExpression>
<SQLMap name="DHCPHACollectMaster">
<Data name="DHC_PHAAgreeRetDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="DHC_PHAAgreeRetFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="DHC_PHAAgreeRetRemark">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="DHC_PHAAgreeRetTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="DHC_PHAAgreeRetUser_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="DHC_PHAAuditDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHC_PHAAuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHC_PHAAuditTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHC_PHAAuditUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="DHC_PHAAuditUserDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="DHC_PHAAuditUserTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Data name="DHC_PHAAuditor">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHC_PHABuildFloor_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="DHC_PHACheckDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHC_PHACheckTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHC_PHAChecker">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHC_PHACollateUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="DHC_PHACollectDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHC_PHACollectStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHC_PHACollectTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHC_PHACollectUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHC_PHACounts">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHC_PHADataSource">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DHC_PHADateFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHC_PHADateTo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHC_PHADefeatedUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="DHC_PHADeliveryDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="DHC_PHADeliveryTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>25</Piece>
</Data>
<Data name="DHC_PHADeliveryman_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHC_PHADispNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHC_PHADocLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="DHC_PHADraw_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="DHC_PHALoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_PHAMachNo">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DHC_PHAOperateDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHC_PHAOperateTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHC_PHAOperator">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHC_PHAOrdType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHC_PHAOthDispDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHC_PHAOthDispTime">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHC_PHAOthDispUser">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DHC_PHAPatGetDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="DHC_PHAPatGetInfo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="DHC_PHAPatGetTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="DHC_PHAPrescNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="DHC_PHAPrintDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHC_PHAPrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHC_PHAPrintNo">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DHC_PHAPrintTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHC_PHAPrintUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="DHC_PHAReAuditUser">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="DHC_PHARemark">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="DHC_PHASecOperator">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="DHC_PHASendDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="DHC_PHASendMedNum">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHC_PHASendTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="DHC_PHASendUser">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHC_PHAStkFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHC_PHATimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DHC_PHATimeTo">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DHC_PHAUrgentFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHC_PHAWardGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHC_PHAWard_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHC_SendAutoFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCPHAC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHACollect_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollect_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXPHACollectedDate">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_PHACollect_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHALoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PHACollectDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_PHACollect_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXPHAPrintDate">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_PHACollect_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PHALoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PHAPrintDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHC_PHACollect_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateAuditFlag">
<Global>^DHCPHACi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHACollect_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DateAuditFlag"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_PHACollectDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHAAuditFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHACollect_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateWard">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATEWARD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHALoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHAPrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PHAWard_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_PHACollect_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DHC_PHADispNo})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHACollect_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHALocOperDate">
<Global>^DHCPHACi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHACollect_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHALocOperDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_PHALoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHAOperateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHACollect_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCPHACi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PHACollect_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_PHAPrescNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHACollect_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrintNO">
<Global>^DHCPHAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PHACollect_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrintNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DHC_PHAPrintNo})</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DHC_PHADispNo})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PHACollect_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHACollectedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
    s newI = +$g(^DHCPHAC)
    s oldI = +$g(^mdata("DHCPHACOLLECTED"))
    s maxI = $s(newI > oldI : newI, 1 : oldI)
    s ^DHCPHAC = maxI
    s ^mdata("DHCPHACOLLECTED") = maxI
}

}
