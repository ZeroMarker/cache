Class User.DHCEQOpenCheckList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OCL_RowID, SqlTableName = DHC_EQOpenCheckList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OCL_ABCType
Property OCLABCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OCL_ABCType ];

/// OCL_AccountNo
Property OCLAccountNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = OCL_AccountNo ];

/// OCL_AccountShape
Property OCLAccountShape As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = OCL_AccountShape ];

/// OCL_AppendFeeAmount
Property OCLAppendFeeAmount As %Library.Float [ SqlColumnNumber = 54, SqlFieldName = OCL_AppendFeeAmount ];

/// OCL_AutoCollectFlag
Property OCLAutoCollectFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = OCL_AutoCollectFlag ];

/// OCL_BatchNo
Property OCLBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = OCL_BatchNo ];

/// OCL_BenefitAnalyFlag
Property OCLBenefitAnalyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = OCL_BenefitAnalyFlag ];

/// OCL_BuyTypeDR
Property OCLBuyTypeDR As User.DHCEQCBuyType [ SqlColumnNumber = 14, SqlFieldName = OCL_BuyTypeDR ];

/// OCL_CheckDate
Property OCLCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 47, SqlFieldName = OCL_CheckDate ];

/// OCL_Code
Property OCLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OCL_Code ];

/// OCL_CommonageFlag
Property OCLCommonageFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = OCL_CommonageFlag ];

/// OCL_ContractListDR
Property OCLContractListDR As User.DHCEQContractList [ SqlColumnNumber = 38, SqlFieldName = OCL_ContractListDR ];

/// OCL_ContractNo
Property OCLContractNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = OCL_ContractNo ];

/// OCL_CountryDR
Property OCLCountryDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OCL_CountryDR ];

/// OCL_CurrencyDR
Property OCLCurrencyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = OCL_CurrencyDR ];

/// OCL_CurrencyFee
Property OCLCurrencyFee As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = OCL_CurrencyFee ];

/// OCL_DepreMethodDR
Property OCLDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 21, SqlFieldName = OCL_DepreMethodDR ];

/// OCL_DesignWorkLoadNum
Property OCLDesignWorkLoadNum As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = OCL_DesignWorkLoadNum ];

/// OCL_DirectionsUse
Property OCLDirectionsUse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = OCL_DirectionsUse ];

/// OCL_EquiCatDR
Property OCLEquiCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 7, SqlFieldName = OCL_EquiCatDR ];

/// OCL_EquipTechLevelDR
Property OCLEquipTechLevelDR As User.DHCEQCTechLevel [ SqlColumnNumber = 15, SqlFieldName = OCL_EquipTechLevelDR ];

/// OCL_EquipTypeDR
Property OCLEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 4, SqlFieldName = OCL_EquipTypeDR ];

/// OCL_GuaranteeEndDate
Property OCLGuaranteeEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 45, SqlFieldName = OCL_GuaranteeEndDate ];

/// OCL_GuaranteeFlag
Property OCLGuaranteeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = OCL_GuaranteeFlag ];

/// OCL_GuaranteePeriodNum
Property OCLGuaranteePeriodNum As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = OCL_GuaranteePeriodNum ];

/// OCL_GuaranteeStartDate
Property OCLGuaranteeStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = OCL_GuaranteeStartDate ];

/// OCL_Hold1 发票号
Property OCLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = OCL_Hold1 ];

/// OCL_Hold10
Property OCLHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = OCL_Hold10 ];

/// OCL_Hold11 产地
Property OCLHold11 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 84, SqlFieldName = OCL_Hold11 ];

/// OCL_Hold12 功率
Property OCLHold12 As %Library.Float [ SqlColumnNumber = 85, SqlFieldName = OCL_Hold12 ];

/// OCL_Hold13 保管人
Property OCLHold13 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = OCL_Hold13 ];

/// OCL_Hold14 招标编号
Property OCLHold14 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 87, SqlFieldName = OCL_Hold14 ];

/// OCL_IsInstall 是否安装
Property OCLIsInstall As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 88, SqlFieldName = OCL_IsInstall ];

/// OCL_ConfigLicense 配置许可证号
Property OCLConfigLicense As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 89, SqlFieldName = OCL_ConfigLicense ];

/// OCL_NewOldPercent 新旧程度
Property OCLNewOldPercent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 90, SqlFieldName = OCL_NewOldPercent ];

/// OCL_Voltage 电压
Property OCLVoltage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = OCL_Voltage ];

/// OCLElectriccurrent 电流
Property OCLElectriccurrent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 92, SqlFieldName = OCL_Electriccurrent ];

/// OCL_UseYearsNum 厂家建议年限
Property OCLUseYearsNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 93, SqlFieldName = OCL_UseYearsNum ];

/// OCL_Note 注意事项
Property OCLNote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = OCL_Note ];

/// OCL_MaintNote 保养要点
Property OCLMaintNote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 95, SqlFieldName = OCL_MaintNote ];

/// OCL_Hold16 是否2012年后获得的设备购置项目
Property OCLHold16 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 96, SqlFieldName = OCL_Hold16 ];

/// OCL_Hold17 下达设备购置项目文件文号及名称
Property OCLHold17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 97, SqlFieldName = OCL_Hold17 ];

/// OCL_Hold18 获得设备购置项目年份(YYYY)
Property OCLHold18 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 98, SqlFieldName = OCL_Hold18 ];

/// OCL_Hold19 设备购置项目投入资金数(万元)
Property OCLHold19 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 99, SqlFieldName = OCL_Hold19 ];

/// OCL_Hold20 业务用途
Property OCLHold20 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 100, SqlFieldName = OCL_Hold20 ];

/// OCL_Hold2
Property OCLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = OCL_Hold2 ];

/// OCL_Hold3
Property OCLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = OCL_Hold3 ];

/// OCL_Hold4
Property OCLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = OCL_Hold4 ];

/// OCL_Hold5
Property OCLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = OCL_Hold5 ];

/// OCL_Hold9
Property OCLHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = OCL_Hold9 ];

/// OCL_InstallDate
Property OCLInstallDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 49, SqlFieldName = OCL_InstallDate ];

/// OCL_InstallLocDR
Property OCLInstallLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = OCL_InstallLocDR ];

/// OCL_ItemDR
Property OCLItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 10, SqlFieldName = OCL_ItemDR ];

/// OCL_LeaveFactoryDate
Property OCLLeaveFactoryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 50, SqlFieldName = OCL_LeaveFactoryDate ];

/// OCL_LimitYearsNum
Property OCLLimitYearsNum As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = OCL_LimitYearsNum ];

/// OCL_LocationDR
Property OCLLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 27, SqlFieldName = OCL_LocationDR ];

/// OCL_MakeDate
Property OCLMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = OCL_MakeDate ];

/// OCL_ManageLevelDR
Property OCLManageLevelDR As User.DHCEQCManageLevel [ SqlColumnNumber = 13, SqlFieldName = OCL_ManageLevelDR ];

/// OCL_ManageLocDR
Property OCLManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = OCL_ManageLocDR ];

/// OCL_ManuFactoryDR
Property OCLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 16, SqlFieldName = OCL_ManuFactoryDR ];

/// OCL_MeasureDate
Property OCLMeasureDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 80, SqlFieldName = OCL_MeasureDate ];

/// OCL_MeasureFlag
Property OCLMeasureFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = OCL_MeasureFlag ];

/// OCL_MeasureNos
Property OCLMeasureNos As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = OCL_MeasureNos ];

/// OCL_MedicalFlag
Property OCLMedicalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = OCL_MedicalFlag ];

/// OCL_MemoryCode
Property OCLMemoryCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = OCL_MemoryCode ];

/// OCL_ModelDR
Property OCLModelDR As User.DHCEQCModel [ SqlColumnNumber = 6, SqlFieldName = OCL_ModelDR ];

/// OCL_Name
Property OCLName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OCL_Name ];

/// OCL_NetRemainFee
Property OCLNetRemainFee As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = OCL_NetRemainFee ];

/// OCL_OpenCheckDate
Property OCLOpenCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 46, SqlFieldName = OCL_OpenCheckDate ];

/// OCL_OpenCheckRequestDR
Property OCLOpenCheckRequestDR As User.DHCEQOpenCheckRequest [ SqlColumnNumber = 2, SqlFieldName = OCL_OpenCheckRequestDR ];

/// OCL_OriginalFee
Property OCLOriginalFee As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = OCL_OriginalFee ];

/// OCL_PackNum
Property OCLPackNum As %Library.Float [ SqlColumnNumber = 52, SqlFieldName = OCL_PackNum ];

/// OCL_PackTypeDR
Property OCLPackTypeDR As User.DHCEQCPackType [ SqlColumnNumber = 51, SqlFieldName = OCL_PackTypeDR ];

/// OCL_ProjectNo
Property OCLProjectNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = OCL_ProjectNo ];

/// OCL_PurchaseTypeDR
Property OCLPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 24, SqlFieldName = OCL_PurchaseTypeDR ];

/// OCL_PurposeTypeDR
Property OCLPurposeTypeDR As User.DHCEQCPurposeType [ SqlColumnNumber = 25, SqlFieldName = OCL_PurposeTypeDR ];

/// OCL_Quantity
Property OCLQuantity As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = OCL_Quantity ];

/// OCL_RaditionFlag
Property OCLRaditionFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = OCL_RaditionFlag ];

/// OCL_Remark
Property OCLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = OCL_Remark ];

/// OCL_SalesManager
Property OCLSalesManager As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 82, SqlFieldName = OCL_SalesManager ];

/// OCL_SalesManagerTel
Property OCLSalesManagerTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 83, SqlFieldName = OCL_SalesManagerTel ];

/// OCL_ServiceDR
Property OCLServiceDR As User.DHCEQCVendor [ SqlColumnNumber = 26, SqlFieldName = OCL_ServiceDR ];

/// OCL_ServiceHandler
Property OCLServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = OCL_ServiceHandler ];

/// OCL_ServiceTel
Property OCLServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = OCL_ServiceTel ];

/// OCL_SourceID
Property OCLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = OCL_SourceID ];

/// OCL_SourceType
Property OCLSourceType As %Library.String(DISPLAYLIST = ",无,合同,采购单,计划单,申请单", MAXLEN = 3, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 64, SqlFieldName = OCL_SourceType ];

/// OCL_SpecialFlag
Property OCLSpecialFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 75, SqlFieldName = OCL_SpecialFlag ];

/// OCL_StatCatDR
Property OCLStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 29, SqlFieldName = OCL_StatCatDR ];

/// OCL_StoreLocDR
Property OCLStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = OCL_StoreLocDR ];

/// OCL_TCMFlag
Property OCLTCMFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = OCL_TCMFlag ];

/// OCL_TestFlag
Property OCLTestFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = OCL_TestFlag ];

/// OCL_TransAssetDate
Property OCLTransAssetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 53, SqlFieldName = OCL_TransAssetDate ];

/// OCL_UnitDR
Property OCLUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OCL_UnitDR ];

/// OCL_UrgencyFlag
Property OCLUrgencyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = OCL_UrgencyFlag ];

/// OCL_UseLocDR
Property OCLUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = OCL_UseLocDR ];

/// OCL_UserDR 使用人
Property OCLUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = OCL_UserDR ];

/// OCL_ValueType
Property OCLValueType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = OCL_ValueType ];

/// OCL_WorkLoadPerMonth
Property OCLWorkLoadPerMonth As %Library.Float [ SqlColumnNumber = 66, SqlFieldName = OCL_WorkLoadPerMonth ];

/// OCL_WorkLoadUnitDR
Property OCLWorkLoadUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = OCL_WorkLoadUnitDR ];

/// OCL_AuthorizeDeptDR 配置批准单位
Property OCLAuthorizeDeptDR As User.DHCEQCAuthorizeDept [ SqlColumnNumber = 101, SqlFieldName = OCL_AuthorizeDeptDR ];

/// OCL_UseSubjectDR 使用主体
Property OCLUseSubjectDR As User.DHCEQCUseSubject [ SqlColumnNumber = 102, SqlFieldName = OCL_UseSubjectDR ];

/// OCL_BuyModeDR 采购组织形式
Property OCLBuyModeDR As User.DHCEQCBuyMode [ SqlColumnNumber = 103, SqlFieldName = OCL_BuyModeDR ];

/// OCL_AccountDate
Property OCLAccountDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 104, SqlFieldName = OCL_AccountDate ];

/// OCL_ManageUserDR 管理人
Property OCLManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 105, SqlFieldName = OCL_ManageUserDR ];

/// OCL_PurchaseDate 购入日期
Property OCLPurchaseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 106, SqlFieldName = OCL_PurchaseDate ];

/// OCL_Hold21 商检证
Property OCLHold21 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 107, SqlFieldName = OCL_Hold21 ];

/// OCL_Hold22 报关单
Property OCLHold22 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 108, SqlFieldName = OCL_Hold22 ];

/// OCL_ManageCat 管理类别
Property OCLManageCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 109, SqlFieldName = OCL_ManageCat ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOpenCheckList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OCL_ABCType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OCL_AccountDate">
<Delimiter>"^"</Delimiter>
<Piece>103</Piece>
</Data>
<Data name="OCL_AccountNo">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="OCL_AccountShape">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="OCL_AppendFeeAmount">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="OCL_AuthorizeDeptDR">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="OCL_AutoCollectFlag">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="OCL_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="OCL_BenefitAnalyFlag">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="OCL_BuyModeDR">
<Delimiter>"^"</Delimiter>
<Piece>102</Piece>
</Data>
<Data name="OCL_BuyTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OCL_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="OCL_Code">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OCL_CommonageFlag">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="OCL_ConfigLicense">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="OCL_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OCL_ContractNo">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OCL_CountryDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OCL_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OCL_CurrencyFee">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OCL_DepreMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OCL_DesignWorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OCL_DirectionsUse">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="OCL_Electriccurrent">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="OCL_EquiCatDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OCL_EquipTechLevelDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OCL_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OCL_GuaranteeEndDate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="OCL_GuaranteeFlag">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OCL_GuaranteePeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OCL_GuaranteeStartDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="OCL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="OCL_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="OCL_Hold11">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="OCL_Hold12">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="OCL_Hold13">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="OCL_Hold14">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="OCL_Hold16">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="OCL_Hold17">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="OCL_Hold18">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="OCL_Hold19">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="OCL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="OCL_Hold20">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="OCL_Hold21">
<Delimiter>"^"</Delimiter>
<Piece>106</Piece>
</Data>
<Data name="OCL_Hold22">
<Delimiter>"^"</Delimiter>
<Piece>107</Piece>
</Data>
<Data name="OCL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="OCL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="OCL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="OCL_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="OCL_InstallDate">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="OCL_InstallLocDR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="OCL_IsInstall">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="OCL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OCL_LeaveFactoryDate">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="OCL_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OCL_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OCL_MaintNote">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="OCL_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OCL_ManageCat">
<Delimiter>"^"</Delimiter>
<Piece>108</Piece>
</Data>
<Data name="OCL_ManageLevelDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OCL_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OCL_ManageUserDR">
<Delimiter>"^"</Delimiter>
<Piece>104</Piece>
</Data>
<Data name="OCL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OCL_MeasureDate">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="OCL_MeasureFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="OCL_MeasureNos">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="OCL_MedicalFlag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OCL_MemoryCode">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OCL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OCL_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OCL_NetRemainFee">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OCL_NewOldPercent">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="OCL_Note">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="OCL_OpenCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="OCL_OpenCheckRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OCL_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OCL_PackNum">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="OCL_PackTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="OCL_ProjectNo">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="OCL_PurchaseDate">
<Delimiter>"^"</Delimiter>
<Piece>105</Piece>
</Data>
<Data name="OCL_PurchaseTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OCL_PurposeTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OCL_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OCL_RaditionFlag">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="OCL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OCL_SalesManager">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="OCL_SalesManagerTel">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="OCL_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OCL_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="OCL_ServiceTel">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="OCL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="OCL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="OCL_SpecialFlag">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="OCL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OCL_StoreLocDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OCL_TCMFlag">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="OCL_TestFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OCL_TransAssetDate">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="OCL_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OCL_UrgencyFlag">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="OCL_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OCL_UseSubjectDR">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Data name="OCL_UseYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="OCL_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="OCL_ValueType">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="OCL_Voltage">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="OCL_WorkLoadPerMonth">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="OCL_WorkLoadUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^DHCEQOpenCheckList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OCL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OCL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOpenCheckRequest">
<Global>^DHCEQOpenCheckList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OpenCheckRequest"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCL_OpenCheckRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQOpenCheckList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OCL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OCL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OCL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OCL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOpenCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
