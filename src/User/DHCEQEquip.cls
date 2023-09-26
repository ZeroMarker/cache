Class User.DHCEQEquip Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EQ_RowID, SqlTableName = DHC_EQEquip, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index EQNoUnqIdx1 On EQNo [ Unique ];

/// EQ_ABCType
Property EQABCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EQ_ABCType ];

/// EQ_AccountNo
Property EQAccountNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = EQ_AccountNo ];

/// EQ_AccountShape
Property EQAccountShape As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 112, SqlFieldName = EQ_AccountShape ];

/// EQ_AddDate
Property EQAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 54, SqlFieldName = EQ_AddDate ];

/// EQ_AddTime
Property EQAddTime As %Library.Time [ SqlColumnNumber = 55, SqlFieldName = EQ_AddTime ];

/// EQ_AddUserDR
Property EQAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = EQ_AddUserDR ];

/// EQ_AdvanceDisFlag
Property EQAdvanceDisFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = EQ_AdvanceDisFlag ];

/// EQ_AppendFeeTotalFee
Property EQAppendFeeTotalFee As %Library.Float [ SqlColumnNumber = 44, SqlFieldName = EQ_AppendFeeTotalFee ];

/// EQ_ClassFlag
Property EQClassFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = EQ_ClassFlag ];

/// EQ_BenefitAnalyFlag
Property EQBenefitAnalyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 82, SqlFieldName = EQ_BenefitAnalyFlag ];

/// EQ_Brand
Property EQBrand As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 95, SqlFieldName = EQ_Brand ];

/// EQ_BuyTypeDR
Property EQBuyTypeDR As User.DHCEQCBuyType [ SqlColumnNumber = 24, SqlFieldName = EQ_BuyTypeDR ];

/// EQ_CheckDate
Property EQCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = EQ_CheckDate ];

/// EQ_Code
Property EQCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EQ_Code ];

/// EQ_CommonageFlag
Property EQCommonageFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 83, SqlFieldName = EQ_CommonageFlag ];

/// EQ_ComputerFlag
Property EQComputerFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = EQ_ComputerFlag ];

/// EQ_ConfigLicense
Property EQConfigLicense As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 98, SqlFieldName = EQ_ConfigLicense ];

/// EQ_ContractListDR
Property EQContractListDR As User.DHCEQContractList [ SqlColumnNumber = 33, SqlFieldName = EQ_ContractListDR ];

/// EQ_ContractNo
Property EQContractNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = EQ_ContractNo ];

/// EQ_CountryDR
Property EQCountryDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EQ_CountryDR ];

/// EQ_CurrencyDR
Property EQCurrencyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = EQ_CurrencyDR ];

/// EQ_DepreMethodDR
Property EQDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 34, SqlFieldName = EQ_DepreMethodDR ];

/// EQ_DepreRate
Property EQDepreRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = EQ_DepreRate ];

/// EQ_DepreTotalFee
Property EQDepreTotalFee As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = EQ_DepreTotalFee ];

/// EQ_DesignWorkLoadNum
Property EQDesignWorkLoadNum As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = EQ_DesignWorkLoadNum ];

/// EQ_DirectionsUse
Property EQDirectionsUse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 110, SqlFieldName = EQ_DirectionsUse ];

/// EQ_DisuseDate
Property EQDisuseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 90, SqlFieldName = EQ_DisuseDate ];

/// EQ_Electriccurrent
Property EQElectriccurrent As %Library.Float [ SqlColumnNumber = 102, SqlFieldName = EQ_Electriccurrent ];

/// EQ_EquiCatDR
Property EQEquiCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 5, SqlFieldName = EQ_EquiCatDR ];

/// EQ_EquipTechLevelDR
Property EQEquipTechLevelDR As User.DHCEQCTechLevel [ SqlColumnNumber = 25, SqlFieldName = EQ_EquipTechLevelDR ];

/// EQ_EquipTypeDR
Property EQEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 64, SqlFieldName = EQ_EquipTypeDR ];

/// EQ_FaultStatus
Property EQFaultStatus As %Library.String(DISPLAYLIST = ",完好,可用,不可用", MAXLEN = 3, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 89, SqlFieldName = EQ_FaultStatus ];

/// EQ_FileNo
Property EQFileNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = EQ_FileNo ];

/// EQ_FromDeptDR
Property EQFromDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 22, SqlFieldName = EQ_FromDeptDR ];

/// EQ_GroupDR
Property EQGroupDR As User.DHCEQGroup [ SqlColumnNumber = 31, SqlFieldName = EQ_GroupDR ];

/// EQ_GuaranteeEndDate
Property EQGuaranteeEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 52, SqlFieldName = EQ_GuaranteeEndDate ];

/// EQ_GuaranteeFlag
Property EQGuaranteeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = EQ_GuaranteeFlag ];

/// EQ_GuaranteePeriodNum
Property EQGuaranteePeriodNum As %Library.Float [ SqlColumnNumber = 74, SqlFieldName = EQ_GuaranteePeriodNum ];

/// EQ_GuaranteeStartDate
Property EQGuaranteeStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 51, SqlFieldName = EQ_GuaranteeStartDate ];

/// EQ_HasDepreFlag
Property EQHasDepreFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 75, SqlFieldName = EQ_HasDepreFlag ];

/// EQ_Hold1
Property EQHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 105, SqlFieldName = EQ_Hold1 ];

/// EQ_Hold10
Property EQHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 96, SqlFieldName = EQ_Hold10 ];

/// EQ_Hold2
Property EQHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 106, SqlFieldName = EQ_Hold2 ];

/// EQ_Hold3
Property EQHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 107, SqlFieldName = EQ_Hold3 ];

/// EQ_Hold4
Property EQHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 108, SqlFieldName = EQ_Hold4 ];

/// EQ_Hold5
Property EQHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = EQ_Hold5 ];

/// EQ_InStockListDR
Property EQInStockListDR As User.DHCEQInStockList [ SqlColumnNumber = 71, SqlFieldName = EQ_InStockListDR ];

/// EQ_InputFlag
Property EQInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = EQ_InputFlag ];

/// EQ_InstallDate
Property EQInstallDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = EQ_InstallDate ];

/// EQ_InstallLocDR
Property EQInstallLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EQ_InstallLocDR ];

/// EQ_InvalidFlag
Property EQInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = EQ_InvalidFlag ];

/// EQ_ItemDR
Property EQItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 8, SqlFieldName = EQ_ItemDR ];

/// EQ_KeeperDR
Property EQKeeperDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = EQ_KeeperDR ];

/// EQ_LeaveFactoryDate
Property EQLeaveFactoryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = EQ_LeaveFactoryDate ];

/// EQ_LeaveFactoryNo
Property EQLeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EQ_LeaveFactoryNo ];

/// EQ_LimitYearsNum
Property EQLimitYearsNum As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = EQ_LimitYearsNum ];

/// EQ_LocationDR
Property EQLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 73, SqlFieldName = EQ_LocationDR ];

/// EQ_MaintUserDR
Property EQMaintUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = EQ_MaintUserDR ];

/// EQ_MakeDate
Property EQMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = EQ_MakeDate ];

/// EQ_ManageLevelDR
Property EQManageLevelDR As User.DHCEQCManageLevel [ SqlColumnNumber = 19, SqlFieldName = EQ_ManageLevelDR ];

/// EQ_ManageLocDR
Property EQManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = EQ_ManageLocDR ];

/// EQ_ManageUserDR
Property EQManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = EQ_ManageUserDR ];

/// EQ_ManuFactoryDR
Property EQManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 27, SqlFieldName = EQ_ManuFactoryDR ];

/// EQ_MedicalFlag
Property EQMedicalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = EQ_MedicalFlag ];

/// EQ_MemoryCode
Property EQMemoryCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = EQ_MemoryCode ];

/// EQ_ModelDR
Property EQModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = EQ_ModelDR ];

/// EQ_Name
Property EQName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EQ_Name ];

/// EQ_NetFee
Property EQNetFee As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = EQ_NetFee ];

/// EQ_NetRemainFee
Property EQNetRemainFee As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = EQ_NetRemainFee ];

/// EQ_NewOldPercent
Property EQNewOldPercent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 99, SqlFieldName = EQ_NewOldPercent ];

/// EQ_No
Property EQNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = EQ_No ];

/// EQ_OldLoc
Property EQOldLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = EQ_OldLoc ];

/// EQ_OldNo
Property EQOldNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 92, SqlFieldName = EQ_OldNo ];

/// EQ_OpenCheckDate
Property EQOpenCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = EQ_OpenCheckDate ];

/// EQ_OpenCheckListDR
Property EQOpenCheckListDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = EQ_OpenCheckListDR ];

/// EQ_OriginDR
Property EQOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 21, SqlFieldName = EQ_OriginDR ];

/// EQ_OriginalFee
Property EQOriginalFee As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = EQ_OriginalFee ];

/// EQ_Power
Property EQPower As %Library.Float [ SqlColumnNumber = 100, SqlFieldName = EQ_Power ];

/// EQ_ProjectNo
Property EQProjectNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 113, SqlFieldName = EQ_ProjectNo ];

/// EQ_ProviderDR
Property EQProviderDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = EQ_ProviderDR ];

/// EQ_ProviderHandler
Property EQProviderHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = EQ_ProviderHandler ];

/// EQ_ProviderTel
Property EQProviderTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = EQ_ProviderTel ];

/// EQ_PurchaseTypeDR
Property EQPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 65, SqlFieldName = EQ_PurchaseTypeDR ];

/// EQ_PurposeTypeDR
Property EQPurposeTypeDR As User.DHCEQCPurposeType [ SqlColumnNumber = 66, SqlFieldName = EQ_PurposeTypeDR ];

/// EQ_RaditionFlag
Property EQRaditionFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 103, SqlFieldName = EQ_RaditionFlag ];

/// EQ_ReciveDate
Property EQReciveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 104, SqlFieldName = EQ_ReciveDate ];

/// EQ_RegistrationNo
Property EQRegistrationNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 93, SqlFieldName = EQ_RegistrationNo ];

/// EQ_Remark
Property EQRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = EQ_Remark ];

/// EQ_RentLocDR
Property EQRentLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 87, SqlFieldName = EQ_RentLocDR ];

/// EQ_RentStatus
Property EQRentStatus As %Library.String(DISPLAYLIST = ",在库,借出", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 88, SqlFieldName = EQ_RentStatus ];

/// EQ_RunStatus
Property EQRunStatus As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 97, SqlFieldName = EQ_RunStatus ];

/// EQ_ServiceDR
Property EQServiceDR As User.DHCEQCVendor [ SqlColumnNumber = 70, SqlFieldName = EQ_ServiceDR ];

/// EQ_StartDate
Property EQStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 45, SqlFieldName = EQ_StartDate ];

/// EQ_StartDepreMonth
Property EQStartDepreMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = EQ_StartDepreMonth ];

/// EQ_StatCatDR
Property EQStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 76, SqlFieldName = EQ_StatCatDR ];

/// EQ_Status
Property EQStatus As %Library.String(DISPLAYLIST = ",在库,启用,停用,报废,其他", MAXLEN = 2, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 39, SqlFieldName = EQ_Status ];

/// EQ_StockStatus
Property EQStockStatus As %Library.String(DISPLAYLIST = ",新增,入库,转移出库,出库", MAXLEN = 4, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 61, SqlFieldName = EQ_StockStatus ];

/// EQ_StoreLocDR
Property EQStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = EQ_StoreLocDR ];

/// EQ_TestFlag
Property EQTestFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = EQ_TestFlag ];

/// EQ_ToDeptDR
Property EQToDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 23, SqlFieldName = EQ_ToDeptDR ];

/// EQ_TransAssetDate
Property EQTransAssetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 46, SqlFieldName = EQ_TransAssetDate ];

/// EQ_UnitDR
Property EQUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EQ_UnitDR ];

/// EQ_UpdateDate
Property EQUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 57, SqlFieldName = EQ_UpdateDate ];

/// EQ_UpdateTime
Property EQUpdateTime As %Library.Time [ SqlColumnNumber = 58, SqlFieldName = EQ_UpdateTime ];

/// EQ_UpdateUserDR
Property EQUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = EQ_UpdateUserDR ];

/// EQ_UrgencyFlag
Property EQUrgencyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = EQ_UrgencyFlag ];

/// EQ_UseLocDR
Property EQUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = EQ_UseLocDR ];

/// EQ_UserDR
Property EQUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 111, SqlFieldName = EQ_UserDR ];

/// EQ_ValueType
Property EQValueType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 109, SqlFieldName = EQ_ValueType ];

/// EQ_Voltage
Property EQVoltage As %Library.Float [ SqlColumnNumber = 101, SqlFieldName = EQ_Voltage ];

/// EQ_WorkLoadPerMonth
Property EQWorkLoadPerMonth As %Library.Float(SELECTIVITY = "33.3333%") [ SqlColumnNumber = 85, SqlFieldName = EQ_WorkLoadPerMonth ];

/// EQ_WorkLoadUnitDR
Property EQWorkLoadUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = EQ_WorkLoadUnitDR ];

/// EQ_ServiceHandler
Property EQServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 114, SqlFieldName = EQ_ServiceHandler ];

/// EQ_ServiceTel
Property EQServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 115, SqlFieldName = EQ_ServiceTel ];

/// EQ_FileCat
Property EQFileCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 116, SqlFieldName = EQ_FileCat ];

/// EQ_SpecialFlag
Property EQSpecialFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 117, SqlFieldName = EQ_SpecialFlag ];

/// EQ_SalesManager
Property EQSalesManager As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 118, SqlFieldName = EQ_SalesManager ];

/// EQ_SalesManagerTel
Property EQSalesManagerTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 119, SqlFieldName = EQ_SalesManagerTel ];

/// EQ_ParentDR
Property EQParentDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 120, SqlFieldName = EQ_ParentDR ];

/// EQ_Spec
Property EQSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 121, SqlFieldName = EQ_Spec ];

/// EQ_Hold13  附属设备ID
Property EQHold13 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 122, SqlFieldName = EQ_Hold13 ];

/// EQ_Hold14
Property EQHold14 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 123, SqlFieldName = EQ_Hold14 ];

/// EQ_Hold15  采购科室
Property EQHold15 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 124, SqlFieldName = EQ_Hold15 ];

/// EQ_Note 注意事项
Property EQNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 125, SqlFieldName = EQ_Note ];

/// EQ_MaintNote 保养要点
Property EQMaintNote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 126, SqlFieldName = EQ_MaintNote ];

/// EQ_Hold16
Property EQHold16 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 127, SqlFieldName = EQ_Hold16 ];

/// EQ_Hold17
Property EQHold17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 128, SqlFieldName = EQ_Hold17 ];

/// EQ_Hold18
Property EQHold18 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 129, SqlFieldName = EQ_Hold18 ];

/// EQ_Hold19
Property EQHold19 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 130, SqlFieldName = EQ_Hold19 ];

/// EQ_Hold20
Property EQHold20 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 131, SqlFieldName = EQ_Hold20 ];

/// EQ_AuthorizeDeptDR
Property EQAuthorizeDeptDR As User.DHCEQCAuthorizeDept [ SqlColumnNumber = 132, SqlFieldName = EQ_AuthorizeDeptDR ];

/// EQ_UseSubjectDR
Property EQUseSubjectDR As User.DHCEQCUseSubject [ SqlColumnNumber = 133, SqlFieldName = EQ_UseSubjectDR ];

/// EQ_BuyModeDR
Property EQBuyModeDR As User.DHCEQCBuyMode [ SqlColumnNumber = 134, SqlFieldName = EQ_BuyModeDR ];

/// EQ_AccountDate
Property EQAccountDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 135, SqlFieldName = EQ_AccountDate ];

/// EQ_IdleFlag
Property EQIdleFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 136, SqlFieldName = EQ_IdleFlag ];

/// EQ_ManageCat 管理类别
Property EQManageCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 137, SqlFieldName = EQ_ManageCat ];

Trigger AfterDelete [ Event = DELETE, Time = AFTER ]
{
	Set id = {EQ_RowID}
	set depremethod={EQ_DepreMethodDR}
	set originalfee={EQ_OriginalFee}
	set invalidflag={EQ_InvalidFlag}
	d ##Class(web.DHCEQEquip).AfterDelete(id, depremethod, originalfee, invalidflag)
}

Trigger AfterInsert [ Event = INSERT, Time = AFTER ]
{
	Set id = {EQ_RowID}
	set depremethod={EQ_DepreMethodDR}
	set originalfee={EQ_OriginalFee}
	set invalidflag={EQ_InvalidFlag}
	set limityears={EQ_LimitYearsNum}
	//if (invalidflag="Y") q			//czf 1759001 2021-02-19
	d ##Class(web.DHCEQEquip).AfterInsert(id, depremethod, originalfee, invalidflag,limityears)
}

Trigger AfterUpdate [ Event = UPDATE, Time = AFTER ]
{
	Set id = {EQ_RowID}
	set depremethod={EQ_DepreMethodDR}
	set originalfee={EQ_OriginalFee}
	set invalidflag={EQ_InvalidFlag}
	set limityears={EQ_LimitYearsNum}
	//if (invalidflag="Y") q			//czf 1759001 2021-02-19 删除简易台账记录时查询界面不更新
	d ##Class(web.DHCEQEquip).AfterUpdate(id, depremethod, originalfee, invalidflag,limityears)
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquip("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EQ_ABCType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EQ_AccountDate">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>39</Piece>
</Data>
<Data name="EQ_AccountNo">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="EQ_AccountShape">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>16</Piece>
</Data>
<Data name="EQ_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="EQ_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="EQ_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="EQ_AdvanceDisFlag">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="EQ_AppendFeeTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="EQ_AuthorizeDeptDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>36</Piece>
</Data>
<Data name="EQ_BenefitAnalyFlag">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="EQ_Brand">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="EQ_BuyModeDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>38</Piece>
</Data>
<Data name="EQ_BuyTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="EQ_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EQ_ClassFlag">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="EQ_Code">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EQ_CommonageFlag">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="EQ_ComputerFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EQ_ConfigLicense">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>2</Piece>
</Data>
<Data name="EQ_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="EQ_ContractNo">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="EQ_CountryDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EQ_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="EQ_DepreMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="EQ_DepreRate">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="EQ_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="EQ_DesignWorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="EQ_DirectionsUse">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>14</Piece>
</Data>
<Data name="EQ_DisuseDate">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="EQ_Electriccurrent">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>6</Piece>
</Data>
<Data name="EQ_EquiCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EQ_EquipTechLevelDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="EQ_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="EQ_FaultStatus">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="EQ_FileCat">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>20</Piece>
</Data>
<Data name="EQ_FileNo">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="EQ_FromDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EQ_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="EQ_GuaranteeEndDate">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="EQ_GuaranteeFlag">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="EQ_GuaranteePeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="EQ_GuaranteeStartDate">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="EQ_HasDepreFlag">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="EQ_Hold1">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>9</Piece>
</Data>
<Data name="EQ_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="EQ_Hold13">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>26</Piece>
</Data>
<Data name="EQ_Hold14">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>27</Piece>
</Data>
<Data name="EQ_Hold15">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>28</Piece>
</Data>
<Data name="EQ_Hold16">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>31</Piece>
</Data>
<Data name="EQ_Hold17">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>32</Piece>
</Data>
<Data name="EQ_Hold18">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>33</Piece>
</Data>
<Data name="EQ_Hold19">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>34</Piece>
</Data>
<Data name="EQ_Hold2">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>10</Piece>
</Data>
<Data name="EQ_Hold20">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>35</Piece>
</Data>
<Data name="EQ_Hold3">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>11</Piece>
</Data>
<Data name="EQ_Hold4">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>12</Piece>
</Data>
<Data name="EQ_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="EQ_IdleFlag">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>40</Piece>
</Data>
<Data name="EQ_InStockListDR">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="EQ_InputFlag">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="EQ_InstallDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EQ_InstallLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EQ_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="EQ_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EQ_KeeperDR">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="EQ_LeaveFactoryDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EQ_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EQ_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="EQ_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="EQ_MaintNote">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>30</Piece>
</Data>
<Data name="EQ_MaintUserDR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="EQ_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EQ_ManageCat">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>41</Piece>
</Data>
<Data name="EQ_ManageLevelDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EQ_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EQ_ManageUserDR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="EQ_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="EQ_MedicalFlag">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="EQ_MemoryCode">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="EQ_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EQ_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EQ_NetFee">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="EQ_NetRemainFee">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="EQ_NewOldPercent">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>3</Piece>
</Data>
<Data name="EQ_No">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="EQ_Note">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>29</Piece>
</Data>
<Data name="EQ_OldLoc">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="EQ_OldNo">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="EQ_OpenCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EQ_OpenCheckListDR">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="EQ_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EQ_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="EQ_ParentDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>24</Piece>
</Data>
<Data name="EQ_Power">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>4</Piece>
</Data>
<Data name="EQ_ProjectNo">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>17</Piece>
</Data>
<Data name="EQ_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="EQ_ProviderHandler">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="EQ_ProviderTel">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="EQ_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="EQ_PurposeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="EQ_RaditionFlag">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>7</Piece>
</Data>
<Data name="EQ_ReciveDate">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>8</Piece>
</Data>
<Data name="EQ_RegistrationNo">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="EQ_Remark">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="EQ_RentLocDR">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="EQ_RentStatus">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="EQ_RunStatus">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>1</Piece>
</Data>
<Data name="EQ_SalesManager">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>22</Piece>
</Data>
<Data name="EQ_SalesManagerTel">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>23</Piece>
</Data>
<Data name="EQ_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="EQ_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>18</Piece>
</Data>
<Data name="EQ_ServiceTel">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>19</Piece>
</Data>
<Data name="EQ_Spec">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>25</Piece>
</Data>
<Data name="EQ_SpecialFlag">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>21</Piece>
</Data>
<Data name="EQ_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="EQ_StartDepreMonth">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="EQ_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="EQ_Status">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="EQ_StockStatus">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="EQ_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="EQ_TestFlag">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="EQ_ToDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="EQ_TransAssetDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="EQ_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EQ_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="EQ_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="EQ_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="EQ_UrgencyFlag">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="EQ_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EQ_UseSubjectDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>37</Piece>
</Data>
<Data name="EQ_UserDR">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>15</Piece>
</Data>
<Data name="EQ_ValueType">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>13</Piece>
</Data>
<Data name="EQ_Voltage">
<Delimiter>"^"</Delimiter>
<Node>"OtherInfo"</Node>
<Piece>5</Piece>
</Data>
<Data name="EQ_WorkLoadPerMonth">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="EQ_WorkLoadUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Global>^DHCEQEquip</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAutoCollectFlag">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ClassFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EQ_ClassFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBenefitAnalyFlag">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BenefitAnalyFlag"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EQ_BenefitAnalyFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCommonageFlag">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
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
<Expression>{EQ_CommonageFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContractList">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ContractList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_ContractListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDisuseDate">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EQ_RowID</Field>
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
<Expression>{EQ_DisuseDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EQ_StoreLocDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGuarantee">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Guarantee"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{EQ_GuaranteePeriodNum}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHasDepreFlag">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HasDepreFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_HasDepreFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHold13">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hold13"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_Hold13}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInStockList">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStockList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{EQ_InStockListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_StoreLocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_InvalidFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocCatDR">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EQ_RowID</Field>
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
<Expression>{EQ_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EQ_EquiCatDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexManuFactory">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ManuFactory"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_ManuFactoryDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpenCheckList">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
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
<Expression>{EQ_OpenCheckListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_ParentDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Provider"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_ProviderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Service"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_ServiceDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStockStatus">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StockStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_StockStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreEquipType">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreEquipType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_StockStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EQ_StoreLocDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EQ_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreInStock">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreInStock"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EQ_StockStatus}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EQ_InvalidFlag}</Expression>
</Subscript>
<Subscript name="7">
<Expression>+{EQ_InStockListDR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLoc">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLocItem">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StoreLocItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EQ_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EQ_ItemDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLocStatCat">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreLocStatCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_StoreLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EQ_StatCatDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseLoc">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UseLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUseLocItem">
<Global>^DHCEQEquip</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EQ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LocItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EQ_UseLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EQ_ItemDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
