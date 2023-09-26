Class User.DHCEQBUBuilding Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = B_RowID, SqlTableName = DHC_EQBUBuilding, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// B_AccountNo
Property BAccountNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = B_AccountNo ];

/// B_AccountShape
Property BAccountShape As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = B_AccountShape ];

/// B_AddDate
Property BAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = B_AddDate ];

/// B_AddTime
Property BAddTime As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = B_AddTime ];

/// B_AddUserDR
Property BAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = B_AddUserDR ];

/// B_AbnormalType
Property BAbnormalType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = B_AbnormalType ];

/// B_AppendFeeTotalFee
Property BAppendFeeTotalFee As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = B_AppendFeeTotalFee ];

/// B_BuyTypeDR
Property BBuyTypeDR As User.DHCEQCBuyType [ SqlColumnNumber = 15, SqlFieldName = B_BuyTypeDR ];

/// B_CheckDate
Property BCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = B_CheckDate ];

/// B_Code
Property BCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = B_Code ];

/// B_CommonageFlag
Property BCommonageFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = B_CommonageFlag ];

/// B_ContractListDR
Property BContractListDR As User.DHCEQContractList [ SqlColumnNumber = 22, SqlFieldName = B_ContractListDR ];

/// B_ContractNo
Property BContractNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = B_ContractNo ];

/// B_CurrencyDR
Property BCurrencyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = B_CurrencyDR ];

/// B_DepreMethodDR
Property BDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 23, SqlFieldName = B_DepreMethodDR ];

/// B_DepreRate
Property BDepreRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = B_DepreRate ];

/// B_DepreTotalFee
Property BDepreTotalFee As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = B_DepreTotalFee ];

/// B_DirectionsUse
Property BDirectionsUse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 75, SqlFieldName = B_DirectionsUse ];

/// B_DisuseDate
Property BDisuseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 68, SqlFieldName = B_DisuseDate ];

/// B_EquiCatDR
Property BEquiCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 3, SqlFieldName = B_EquiCatDR ];

/// B_EquipTypeDR
Property BEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 48, SqlFieldName = B_EquipTypeDR ];

/// B_FaultStatus
Property BFaultStatus As %Library.String(DISPLAYLIST = ",完好,可用,不可用", MAXLEN = 3, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 67, SqlFieldName = B_FaultStatus ];

/// B_FileNo
Property BFileNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = B_FileNo ];

/// B_FromDeptDR
Property BFromDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 13, SqlFieldName = B_FromDeptDR ];

/// B_GuaranteeEndDate
Property BGuaranteeEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 37, SqlFieldName = B_GuaranteeEndDate ];

/// B_GuaranteeFlag
Property BGuaranteeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = B_GuaranteeFlag ];

/// B_GuaranteePeriodNum
Property BGuaranteePeriodNum As %Library.Float [ SqlColumnNumber = 56, SqlFieldName = B_GuaranteePeriodNum ];

/// B_GuaranteeStartDate
Property BGuaranteeStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = B_GuaranteeStartDate ];

/// B_HasDepreFlag
Property BHasDepreFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = B_HasDepreFlag ];

/// B_AbnormalRemark
Property BAbnormalRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = B_AbnormalRemark ];

/// B_InputFlag
Property BInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = B_InputFlag ];

/// B_InstallDate
Property BInstallDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = B_InstallDate ];

/// B_InvalidFlag
Property BInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = B_InvalidFlag ];

/// B_KeeperDR
Property BKeeperDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = B_KeeperDR ];

/// B_LimitYearsNum
Property BLimitYearsNum As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = B_LimitYearsNum ];

/// B_MaintUserDR
Property BMaintUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = B_MaintUserDR ];

/// B_MakeDate
Property BMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = B_MakeDate ];

/// B_ManageLevelDR
Property BManageLevelDR As User.DHCEQCManageLevel [ SqlColumnNumber = 10, SqlFieldName = B_ManageLevelDR ];

/// B_ManageLocDR
Property BManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = B_ManageLocDR ];

/// B_ManageUserDR
Property BManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = B_ManageUserDR ];

/// B_ManuFactoryDR
Property BManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 17, SqlFieldName = B_ManuFactoryDR ];

/// B_MemoryCode
Property BMemoryCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = B_MemoryCode ];

/// B_Name
Property BName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = B_Name ];

/// B_NetFee
Property BNetFee As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = B_NetFee ];

/// B_NetRemainFee
Property BNetRemainFee As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = B_NetRemainFee ];

/// B_NewOldPercent
Property BNewOldPercent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = B_NewOldPercent ];

/// B_No
Property BNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = B_No ];

/// B_OldLoc
Property BOldLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = B_OldLoc ];

/// B_OldNo
Property BOldNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = B_OldNo ];

/// B_OpenCheckListDR
Property BOpenCheckListDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = B_OpenCheckListDR ];

/// B_OriginDR
Property BOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 12, SqlFieldName = B_OriginDR ];

/// B_OriginalFee
Property BOriginalFee As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = B_OriginalFee ];

/// B_ProjectNo
Property BProjectNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = B_ProjectNo ];

/// B_ProviderDR
Property BProviderDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = B_ProviderDR ];

/// B_ProviderHandler
Property BProviderHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = B_ProviderHandler ];

/// B_ProviderTel
Property BProviderTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = B_ProviderTel ];

/// B_PurchaseTypeDR
Property BPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 49, SqlFieldName = B_PurchaseTypeDR ];

/// B_PurposeTypeDR
Property BPurposeTypeDR As User.DHCEQCPurposeType [ SqlColumnNumber = 50, SqlFieldName = B_PurposeTypeDR ];

/// B_Remark
Property BRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = B_Remark ];

/// B_RentLocDR
Property BRentLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = B_RentLocDR ];

/// B_RentStatus
Property BRentStatus As %Library.String(DISPLAYLIST = ",在库,借出", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 66, SqlFieldName = B_RentStatus ];

/// B_ServiceDR
Property BServiceDR As User.DHCEQCVendor [ SqlColumnNumber = 54, SqlFieldName = B_ServiceDR ];

/// B_StartDate
Property BStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = B_StartDate ];

/// B_StartDepreMonth
Property BStartDepreMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = B_StartDepreMonth ];

/// B_StatCatDR
Property BStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 58, SqlFieldName = B_StatCatDR ];

/// B_Status
Property BStatus As %Library.String(DISPLAYLIST = ",在库,启用,停用,报废,其他", MAXLEN = 2, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 26, SqlFieldName = B_Status ];

/// B_StockStatus
Property BStockStatus As %Library.String(DISPLAYLIST = ",新增,入库,转移出库,出库", MAXLEN = 4, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 46, SqlFieldName = B_StockStatus ];

/// B_StoreLocDR
Property BStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = B_StoreLocDR ];

/// B_ToDeptDR
Property BToDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 14, SqlFieldName = B_ToDeptDR ];

/// B_TransAssetDate
Property BTransAssetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = B_TransAssetDate ];

/// B_UnitDR
Property BUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = B_UnitDR ];

/// B_UpdateDate
Property BUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = B_UpdateDate ];

/// B_UpdateTime
Property BUpdateTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = B_UpdateTime ];

/// B_UpdateUserDR
Property BUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = B_UpdateUserDR ];

/// B_UseLocDR
Property BUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = B_UseLocDR ];

/// B_UserDR
Property BUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = B_UserDR ];

/// B_ValueType
Property BValueType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = B_ValueType ];

/// B_ServiceHandler
Property BServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = B_ServiceHandler ];

/// B_ServiceTel
Property BServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = B_ServiceTel ];

/// B_ParentDR
Property BParentDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = B_ParentDR ];

/// B_StructDR
Property BStructDR As User.DHCEQCBuildingStruct [ SqlColumnNumber = 82, SqlFieldName = B_StructDR ];

/// B_BuildingArea
Property BBuildingArea As %Library.Float [ SqlColumnNumber = 83, SqlFieldName = B_BuildingArea ];

/// B_UtilizationArea
Property BUtilizationArea As %Library.Float [ SqlColumnNumber = 84, SqlFieldName = B_UtilizationArea ];

/// B_SubArea
Property BSubArea As %Library.Float [ SqlColumnNumber = 85, SqlFieldName = B_SubArea ];

/// B_Place
Property BPlace As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = B_Place ];

/// B_OwnerFlag
Property BOwnerFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 87, SqlFieldName = B_OwnerFlag ];

/// B_SelfUseArea
Property BSelfUseArea As %Library.Float [ SqlColumnNumber = 88, SqlFieldName = B_SelfUseArea ];

/// B_LendingArea
Property BLendingArea As %Library.Float [ SqlColumnNumber = 89, SqlFieldName = B_LendingArea ];

/// B_RentArea
Property BRentArea As %Library.Float [ SqlColumnNumber = 90, SqlFieldName = B_RentArea ];

/// B_WorkArea
Property BWorkArea As %Library.Float [ SqlColumnNumber = 91, SqlFieldName = B_WorkArea ];

/// B_IdleArea
Property BIdleArea As %Library.Float [ SqlColumnNumber = 92, SqlFieldName = B_IdleArea ];

/// B_OtherArea
Property BOtherArea As %Library.Float [ SqlColumnNumber = 93, SqlFieldName = B_OtherArea ];

/// B_LendCompany
Property BLendCompany As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = B_LendCompany ];

/// B_RentCompany
Property BRentCompany As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 95, SqlFieldName = B_RentCompany ];

/// B_OwnerCertificate
Property BOwnerCertificate As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 96, SqlFieldName = B_OwnerCertificate ];

/// B_CertificateNo
Property BCertificateNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 97, SqlFieldName = B_CertificateNo ];

/// B_CertificateDate
Property BCertificateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 98, SqlFieldName = B_CertificateDate ];

/// B_FloorNum
Property BFloorNum As %Library.Float [ SqlColumnNumber = 99, SqlFieldName = B_FloorNum ];

/// B_UnderFloorNum
Property BUnderFloorNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 100, SqlFieldName = B_UnderFloorNum ];

/// B_BuildName
Property BBuildName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 101, SqlFieldName = B_BuildName ];

/// B_BuildKey
Property BBuildKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 102, SqlFieldName = B_BuildKey ];

/// B_UseState
Property BUseState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 103, SqlFieldName = B_UseState ];

/// B_FunctionCat
Property BFunctionCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 104, SqlFieldName = B_FunctionCat ];

/// B_FunctionSub
Property BFunctionSub As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 105, SqlFieldName = B_FunctionSub ];

/// B_OwnerKind 权属性质
Property BOwnerKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 106, SqlFieldName = B_OwnerKind ];

/// B_OwnershipYear 权属年限
Property BOwnershipYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 107, SqlFieldName = B_OwnershipYear ];

/// B_Owner 房屋所有人
Property BOwner As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 108, SqlFieldName = B_Owner ];

/// B_CompletionDate 竣工日期
Property BCompletionDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 109, SqlFieldName = B_CompletionDate ];

/// B_SelfUseFee 自用价值
Property BSelfUseFee As %Library.Float [ SqlColumnNumber = 110, SqlFieldName = B_SelfUseFee ];

/// B_LendingFee 出借价值
Property BLendingFee As %Library.Float [ SqlColumnNumber = 111, SqlFieldName = B_LendingFee ];

/// B_RentFee 出租价值
Property BRentFee As %Library.Float [ SqlColumnNumber = 112, SqlFieldName = B_RentFee ];

/// B_WorkFee 经营价值
Property BWorkFee As %Library.Float [ SqlColumnNumber = 113, SqlFieldName = B_WorkFee ];

/// B_IdleFee 闲置价值
Property BIdleFee As %Library.Float [ SqlColumnNumber = 114, SqlFieldName = B_IdleFee ];

/// B_OtherFee 其他价值
Property BOtherFee As %Library.Float [ SqlColumnNumber = 115, SqlFieldName = B_OtherFee ];

/// B_EquipDR 设备
Property BEquipDR As %Library.Float [ SqlColumnNumber = 116, SqlFieldName = B_EquipDR ];

/// B_BuildingDR 设备建筑表
Property BBuildingDR As User.DHCEQBuilding [ SqlColumnNumber = 117, SqlFieldName = B_BuildingDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBUBuilding("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="B_AbnormalRemark">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>2</Piece>
</Data>
<Data name="B_AbnormalType">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="B_AccountNo">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="B_AccountShape">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>6</Piece>
</Data>
<Data name="B_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="B_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="B_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="B_AppendFeeTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="B_BuildKey">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>21</Piece>
</Data>
<Data name="B_BuildName">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>20</Piece>
</Data>
<Data name="B_BuildingArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>2</Piece>
</Data>
<Data name="B_BuildingDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>36</Piece>
</Data>
<Data name="B_BuyTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="B_CertificateDate">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>17</Piece>
</Data>
<Data name="B_CertificateNo">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>16</Piece>
</Data>
<Data name="B_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="B_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="B_CommonageFlag">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="B_CompletionDate">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>28</Piece>
</Data>
<Data name="B_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="B_ContractNo">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="B_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="B_DepreMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="B_DepreRate">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="B_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="B_DirectionsUse">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>4</Piece>
</Data>
<Data name="B_DisuseDate">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="B_EquiCatDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="B_EquipDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>35</Piece>
</Data>
<Data name="B_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="B_FaultStatus">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="B_FileNo">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="B_FloorNum">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>18</Piece>
</Data>
<Data name="B_FromDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="B_FunctionCat">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>23</Piece>
</Data>
<Data name="B_FunctionSub">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>24</Piece>
</Data>
<Data name="B_GuaranteeEndDate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="B_GuaranteeFlag">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="B_GuaranteePeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="B_GuaranteeStartDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="B_HasDepreFlag">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="B_IdleArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>11</Piece>
</Data>
<Data name="B_IdleFee">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>33</Piece>
</Data>
<Data name="B_InputFlag">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="B_InstallDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="B_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="B_KeeperDR">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="B_LendCompany">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>13</Piece>
</Data>
<Data name="B_LendingArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>8</Piece>
</Data>
<Data name="B_LendingFee">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>30</Piece>
</Data>
<Data name="B_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="B_MaintUserDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="B_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="B_ManageLevelDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="B_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="B_ManageUserDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="B_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="B_MemoryCode">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="B_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="B_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="B_NetRemainFee">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="B_NewOldPercent">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>1</Piece>
</Data>
<Data name="B_No">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="B_OldLoc">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="B_OldNo">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="B_OpenCheckListDR">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="B_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="B_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="B_OtherArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>12</Piece>
</Data>
<Data name="B_OtherFee">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>34</Piece>
</Data>
<Data name="B_Owner">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>27</Piece>
</Data>
<Data name="B_OwnerCertificate">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>15</Piece>
</Data>
<Data name="B_OwnerFlag">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>6</Piece>
</Data>
<Data name="B_OwnerKind">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>25</Piece>
</Data>
<Data name="B_OwnershipYear">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>26</Piece>
</Data>
<Data name="B_ParentDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>10</Piece>
</Data>
<Data name="B_Place">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>5</Piece>
</Data>
<Data name="B_ProjectNo">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>7</Piece>
</Data>
<Data name="B_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="B_ProviderHandler">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="B_ProviderTel">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="B_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="B_PurposeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="B_Remark">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="B_RentArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>9</Piece>
</Data>
<Data name="B_RentCompany">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>14</Piece>
</Data>
<Data name="B_RentFee">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>31</Piece>
</Data>
<Data name="B_RentLocDR">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="B_RentStatus">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="B_SelfUseArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>7</Piece>
</Data>
<Data name="B_SelfUseFee">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>29</Piece>
</Data>
<Data name="B_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="B_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>8</Piece>
</Data>
<Data name="B_ServiceTel">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>9</Piece>
</Data>
<Data name="B_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="B_StartDepreMonth">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="B_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="B_Status">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="B_StockStatus">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="B_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="B_StructDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>1</Piece>
</Data>
<Data name="B_SubArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>4</Piece>
</Data>
<Data name="B_ToDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="B_TransAssetDate">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="B_UnderFloorNum">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>19</Piece>
</Data>
<Data name="B_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="B_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="B_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="B_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="B_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="B_UseState">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>22</Piece>
</Data>
<Data name="B_UserDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>5</Piece>
</Data>
<Data name="B_UtilizationArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>3</Piece>
</Data>
<Data name="B_ValueType">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>3</Piece>
</Data>
<Data name="B_WorkArea">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>10</Piece>
</Data>
<Data name="B_WorkFee">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfoB"</Node>
<Piece>32</Piece>
</Data>
<Global>^DHCEQBUBuilding</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuildKey">
<Global>^DHCEQBUBuilding</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{B_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuildKey"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_BuildKey}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{B_RowID}</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCommonageFlag">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CommonageFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{B_CommonageFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContractList">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ContractList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ContractListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisuseDate">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DisuseDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{B_DisuseDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{B_StoreLocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGuarantee">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Guarantee"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{B_GuaranteePeriodNum}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHasDepreFlag">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HasDepreFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_HasDepreFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocCatDR">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StoreLocEquipCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{B_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{B_EquiCatDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexManuFactory">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ManuFactory"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ManuFactoryDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpenCheckList">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OpenCheckList"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{B_OpenCheckListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ParentDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Provider"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ProviderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Service"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_ServiceDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStockStatus">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StockStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_StockStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreEquipType">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreEquipType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_StockStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_StoreLocDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{B_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLoc">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLocStatCat">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreLocStatCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{B_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseLoc">
<Global>^DHCEQBUBuilding</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>B_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UseLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{B_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{B_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBUBuildingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
