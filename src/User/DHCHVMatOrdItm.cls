Class User.DHCHVMatOrdItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = ORI_RowId, SqlTableName = DHC_HVMat_OrdItm, StorageStrategy = SQLStorage ]
{

Property ORIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = ORI_OEORI_DR ];

Property ORIOEORIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = ORI_OEORI_Date ];

Property ORIOEORITime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = ORI_OEORI_Time ];

Property ORIOEORIUserAdd As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = ORI_OEORI_UserAdd ];

Property ORIFeeStatus As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ORI_FeeStatus ];

Property ORIFeeAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ORI_FeeAmt ];

Property ORIAdmLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = ORI_AdmLoc_DR ];

Property ORIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = ORI_Date ];

Property ORITime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = ORI_Time ];

Property ORISSUSRDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = ORI_SSUSR_DR ];

Property ORISCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 12, SqlFieldName = ORI_SCG_DR ];

Property ORIINGRIDR As User.DHCINGdRecItm [ SqlColumnNumber = 13, SqlFieldName = ORI_INGRI_DR ];

Property ORIBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 240, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ORI_BatNo ];

Property ORIExpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = ORI_ExpDate ];

Property ORIDateOfManu As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = ORI_DateOfManu ];

Property ORIMANFDR As User.PHManufacturer [ SqlColumnNumber = 17, SqlFieldName = ORI_MANF_DR ];

Property ORIAPCVMDR As User.APCVendor [ SqlColumnNumber = 18, SqlFieldName = ORI_APCVM_DR ];

Property ORIUnitDR As User.CTUOM [ SqlColumnNumber = 19, SqlFieldName = ORI_Unit_DR ];

Property ORIQty As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = ORI_Qty ];

Property ORIRp As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = ORI_Rp ];

Property ORISp As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = ORI_Sp ];

Property ORIRpAmt As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = ORI_RpAmt ];

Property ORISpAmt As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = ORI_SpAmt ];

Property ORIBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ORI_BarCode ];

Property ORIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = ORI_Remark ];

Property ORICanceled As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = ORI_Canceled ];

Property ORIUserCanceledDR As User.SSUser [ SqlColumnNumber = 28, SqlFieldName = ORI_UserCanceled_DR ];

Property ORIDateCanceled As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = ORI_DateCanceled ];

Property ORITimeCanceled As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = ORI_TimeCanceled ];

Property ORIINGRTIDR As User.DHCINGRTITM [ SqlColumnNumber = 31, SqlFieldName = ORI_INGRTI_DR ];

Property ORIInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = ORI_InvNo ];

Property ORIInvDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = ORI_InvDate ];

Property ORIInvAmt As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = ORI_InvAmt ];

Property ORIINCIDR As User.INCItm [ SqlColumnNumber = 35, SqlFieldName = ORI_INCI_DR ];

/// 病人登记号
Property ORIPatientNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = ORI_PatientNo ];

/// 病人姓名
Property ORIPatientName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = ORI_PatientName ];

/// 病人DOB
Property ORIPatientDOB As %Library.Date [ SqlColumnNumber = 38, SqlFieldName = ORI_PatientDOB ];

/// 病人性别
Property ORIPatientSex As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = ORI_PatientSex ];

/// 病人身份证号
Property ORIPersonID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = ORI_PersonID ];

/// 医嘱项目代码
Property ORIItmMastCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = ORI_ItmMastCode ];

/// 医嘱项目名称
Property ORIItmMastDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = ORI_ItmMastDesc ];

/// 医生姓名
Property ORIUserAddName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = ORI_UserAddName ];

/// 医生工号
Property ORIUserAddId As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = ORI_UserAddId ];

/// 医嘱科室代码
Property ORILocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = ORI_LocCode ];

/// 医嘱科室名称
Property ORILocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = ORI_LocDesc ];

/// 收费日期
Property ORIChargeDate As %Library.Date [ SqlColumnNumber = 47, SqlFieldName = ORI_ChargeDate ];

/// 收费时间
Property ORIChargeTime As %Library.Time [ SqlColumnNumber = 48, SqlFieldName = ORI_ChargeTime ];

/// 收费人姓名
Property ORIChargeUserName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = ORI_ChargeUserName ];

/// 收费人工号
Property ORIChargeUserId As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = ORI_ChargeUserId ];

/// 收费单据号
Property ORIChargeBillNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = ORI_ChargeBillNo ];

/// 收费单价 
Property ORIChargePrice As %Library.Float [ SqlColumnNumber = 52, SqlFieldName = ORI_ChargePrice ];

/// 收费金额   
Property ORIChargeAmt As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = ORI_ChargeAmt ];

/// 医嘱号               
Property ORIItmMastStr As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = ORI_ItmMastStr ];

/// 供应商代码
Property ORIVendorCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = ORI_VendorCode ];

/// 生产厂家代码
Property ORIManufacturerCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = ORI_ManufacturerCode ];

/// 补录入库单标志
Property ORIIngrFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = ORI_IngrFlag ];

/// 补录入库子表DR
Property ORIIngriModifyDR As User.DHCINGdRecItm [ SqlColumnNumber = 58, SqlFieldName = ORI_Ingri_Modify_DR ];

Property ORIOEORIExeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 59, SqlFieldName = ORI_OEORIExe_Date ];

Property ORIOEORIExeTime As %Library.Time [ SqlColumnNumber = 60, SqlFieldName = ORI_OEORIExe_Time ];

Property ORIPlatSentFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 61, SqlFieldName = ORI_PlatSentFlag ];

Property ORISynInvFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 62, SqlFieldName = ORI_SynInvFlag ];

/// 停医嘱判断
Property ORIRetOriFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = ORI_RetOriFlag ];

/// 发送给平台后停医嘱
Property ORIRetAfterPlatSentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 64, SqlFieldName = ORI_RetAfterPlatSentFlag ];

/// 补录入库科室
Property ORIMainLocDR As User.CTLoc [ SqlColumnNumber = 65, SqlFieldName = ORI_MainLoc_DR ];

/// 审核标志
Property ORIAuditFlag As %String [ SqlColumnNumber = 66, SqlFieldName = ORI_AuditFlag ];

/// 审核人
Property ORIAuditUserDR As User.SSUser [ SqlColumnNumber = 67, SqlFieldName = ORI_AuditUserDR ];

/// 审核时间
Property ORIAuditDate As %Library.TimeStamp [ SqlColumnNumber = 68, SqlFieldName = ORI_AuditDate ];

/// 同步8.4标识
Property ORISendHRPFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 69, SqlFieldName = ORI_SendHRPFlag ];

/// 发票代码
Property ORIInvCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = ORI_InvCode ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCHVMORI)</SqlIdExpression>
<SQLMap name="DataMasterHVM">
<Data name="ORI_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="ORI_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="ORI_AuditDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>45</Piece>
</Data>
<Data name="ORI_AuditFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>43</Piece>
</Data>
<Data name="ORI_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>44</Piece>
</Data>
<Data name="ORI_BarCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="ORI_BatNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="ORI_Canceled">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>26</Piece>
</Data>
<Data name="ORI_ChargeAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>18</Piece>
</Data>
<Data name="ORI_ChargeBillNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>16</Piece>
</Data>
<Data name="ORI_ChargeDate">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>12</Piece>
</Data>
<Data name="ORI_ChargePrice">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>17</Piece>
</Data>
<Data name="ORI_ChargeTime">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>13</Piece>
</Data>
<Data name="ORI_ChargeUserId">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>15</Piece>
</Data>
<Data name="ORI_ChargeUserName">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>14</Piece>
</Data>
<Data name="ORI_Date">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="ORI_DateCanceled">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>28</Piece>
</Data>
<Data name="ORI_DateOfManu">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="ORI_ExpDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="ORI_FeeAmt">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="ORI_FeeStatus">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="ORI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>34</Piece>
</Data>
<Data name="ORI_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="ORI_INGRTI_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>30</Piece>
</Data>
<Data name="ORI_IngrFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>35</Piece>
</Data>
<Data name="ORI_Ingri_Modify_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>36</Piece>
</Data>
<Data name="ORI_InvAmt">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>33</Piece>
</Data>
<Data name="ORI_InvCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>46</Piece>
</Data>
<Data name="ORI_InvDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>32</Piece>
</Data>
<Data name="ORI_InvNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>31</Piece>
</Data>
<Data name="ORI_ItmMastCode">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="ORI_ItmMastDesc">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="ORI_ItmMastStr">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>19</Piece>
</Data>
<Data name="ORI_LocCode">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="ORI_LocDesc">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>11</Piece>
</Data>
<Data name="ORI_MANF_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="ORI_MainLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>42</Piece>
</Data>
<Data name="ORI_ManufacturerCode">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>21</Piece>
</Data>
<Data name="ORI_OEORIExe_Date">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>37</Piece>
</Data>
<Data name="ORI_OEORIExe_Time">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>38</Piece>
</Data>
<Data name="ORI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="ORI_OEORI_Date">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="ORI_OEORI_Time">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="ORI_OEORI_UserAdd">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="ORI_PatientDOB">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="ORI_PatientName">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="ORI_PatientNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="ORI_PatientSex">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="ORI_PersonID">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="ORI_PlatSentFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>39</Piece>
</Data>
<Data name="ORI_Qty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="ORI_Remark">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>25</Piece>
</Data>
<Data name="ORI_RetAfterPlatSentFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>41</Piece>
</Data>
<Data name="ORI_RetOriFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>22</Piece>
</Data>
<Data name="ORI_Rp">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="ORI_RpAmt">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="ORI_SCG_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="ORI_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="ORI_SendHRPFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>23</Piece>
</Data>
<Data name="ORI_Sp">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="ORI_SpAmt">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Data name="ORI_SynInvFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>40</Piece>
</Data>
<Data name="ORI_Time">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="ORI_TimeCanceled">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>29</Piece>
</Data>
<Data name="ORI_Unit_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="ORI_UserAddId">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>9</Piece>
</Data>
<Data name="ORI_UserAddName">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="ORI_UserCanceled_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>27</Piece>
</Data>
<Data name="ORI_VendorCode">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>20</Piece>
</Data>
<Global>^DHCHVMORI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ORI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarcode">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BARCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORI_BarCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ORI_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRI">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INGRI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ORI_INGRI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRIModify">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INGRIModify"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ORI_Ingri_Modify_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItmMastStr">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ITMMASTSTR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ORI_ItmMastStr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocOrdDate">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LOCORDDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ORI_AdmLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ORI_OEORI_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ORI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeORIExe">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORIEXE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORI_OEORIExe_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOroriDate">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORIDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORI_OEORI_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlatFlag">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PlatFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORI_PlatSentFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSendHRPFlag">
<Global>^DHCHVMORI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SendFourFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORI_SendHRPFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSynInvFlag">
<Global>^DHCHVMORI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ORI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SynInvFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORI_SynInvFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ORI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCHVMatOrdItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCHVMORI)
	s oldI = +$g(^mdata("DHCHVMATORDITM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCHVMORI = maxI
	s ^mdata("DHCHVMATORDITM") = maxI
}

}
