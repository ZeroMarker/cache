Class User.DHCEQEquipTemp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EQ_RowID, SqlTableName = DHC_EQEquipTemp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EQ_Name
Property EQName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EQ_Name ];

/// EQ_ABCType
Property EQABCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EQ_ABCType ];

/// EQ_ModelDR
Property EQModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = EQ_ModelDR ];

/// EQ_EquiCatDR
Property EQEquiCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 5, SqlFieldName = EQ_EquiCatDR ];

/// EQ_UnitDR
Property EQUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EQ_UnitDR ];

/// EQ_Code
Property EQCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EQ_Code ];

/// EQ_Desc
Property EQDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EQ_Desc ];

/// EQ_InstallLocDR
Property EQInstallLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EQ_InstallLocDR ];

/// EQ_InstallDate
Property EQInstallDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = EQ_InstallDate ];

/// EQ_LeaveFactoryNo
Property EQLeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EQ_LeaveFactoryNo ];

/// EQ_LeaveFactoryDate
Property EQLeaveFactoryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = EQ_LeaveFactoryDate ];

/// EQ_OpenCheckDate
Property EQOpenCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = EQ_OpenCheckDate ];

/// EQ_CheckDate
Property EQCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = EQ_CheckDate ];

/// EQ_MakeDate
Property EQMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = EQ_MakeDate ];

/// EQ_ComputerFlag
Property EQComputerFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = EQ_ComputerFlag ];

/// EQ_CountryDR
Property EQCountryDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EQ_CountryDR ];

/// EQ_ManageLocDR
Property EQManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = EQ_ManageLocDR ];

/// EQ_ManageLevelDR
Property EQManageLevelDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = EQ_ManageLevelDR ];

/// EQ_UseLocDR
Property EQUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = EQ_UseLocDR ];

/// EQ_OriginDR
Property EQOriginDR As User.DHCEQCOrigin [ SqlColumnNumber = 21, SqlFieldName = EQ_OriginDR ];

/// EQ_FromDeptDR
Property EQFromDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 22, SqlFieldName = EQ_FromDeptDR ];

/// EQ_ToDeptDR
Property EQToDeptDR As User.DHCEQCFromToDept [ SqlColumnNumber = 23, SqlFieldName = EQ_ToDeptDR ];

/// EQ_BuyTypeDR
Property EQBuyTypeDR As User.DHCEQCBuyType [ SqlColumnNumber = 24, SqlFieldName = EQ_BuyTypeDR ];

/// EQ_EquipTechLevelDR
Property EQEquipTechLevelDR As User.DHCEQCTechLevel [ SqlColumnNumber = 25, SqlFieldName = EQ_EquipTechLevelDR ];

/// EQ_ProviderDR
Property EQProviderDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = EQ_ProviderDR ];

/// EQ_ManuFactoryDR
Property EQManuFactoryDR As User.DHCEQCManufacturer [ SqlColumnNumber = 27, SqlFieldName = EQ_ManuFactoryDR ];

/// EQ_OriginalFee
Property EQOriginalFee As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = EQ_OriginalFee ];

/// EQ_NetFee
Property EQNetFee As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = EQ_NetFee ];

/// EQ_NetRemainFee
Property EQNetRemainFee As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = EQ_NetRemainFee ];

/// EQ_GroupDR
Property EQGroupDR As User.DHCEQGroup [ SqlColumnNumber = 31, SqlFieldName = EQ_GroupDR ];

/// EQ_LimitYearsNum
Property EQLimitYearsNum As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = EQ_LimitYearsNum ];

/// EQ_ContractListDR
Property EQContractListDR As User.DHCEQContractList [ SqlColumnNumber = 33, SqlFieldName = EQ_ContractListDR ];

/// EQ_DepreMethodDR
Property EQDepreMethodDR As User.DHCEQCDepreMethod [ SqlColumnNumber = 34, SqlFieldName = EQ_DepreMethodDR ];

/// EQ_Remark
Property EQRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = EQ_Remark ];

/// EQ_DepreTotalFee
Property EQDepreTotalFee As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = EQ_DepreTotalFee ];

/// EQ_DesignWorkLoadNum
Property EQDesignWorkLoadNum As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = EQ_DesignWorkLoadNum ];

/// EQ_WorkLoadUnitDR
Property EQWorkLoadUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = EQ_WorkLoadUnitDR ];

/// EQ_Status
Property EQStatus As %Library.String(DISPLAYLIST = ",新增,启用,封存,报废,其他", MAXLEN = 2, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 39, SqlFieldName = EQ_Status ];

/// EQ_ManageUserDR
Property EQManageUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = EQ_ManageUserDR ];

/// EQ_MaintUserDR
Property EQMaintUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = EQ_MaintUserDR ];

/// EQ_ProviderHandler
Property EQProviderHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = EQ_ProviderHandler ];

/// EQ_ProviderTel
Property EQProviderTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = EQ_ProviderTel ];

/// EQ_AppendFeeTotalFee
Property EQAppendFeeTotalFee As %Library.Float [ SqlColumnNumber = 44, SqlFieldName = EQ_AppendFeeTotalFee ];

/// EQ_StartDate
Property EQStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 45, SqlFieldName = EQ_StartDate ];

/// EQ_TransAssetDate
Property EQTransAssetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 46, SqlFieldName = EQ_TransAssetDate ];

/// EQ_GuaranteeFlag
Property EQGuaranteeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = EQ_GuaranteeFlag ];

/// EQ_InputFlag
Property EQInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = EQ_InputFlag ];

/// EQ_TestFlag
Property EQTestFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = EQ_TestFlag ];

/// EQ_MedicalFlag
Property EQMedicalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = EQ_MedicalFlag ];

/// EQ_GuaranteeStartDate
Property EQGuaranteeStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 51, SqlFieldName = EQ_GuaranteeStartDate ];

/// EQ_GuaranteeEndDate
Property EQGuaranteeEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 52, SqlFieldName = EQ_GuaranteeEndDate ];

/// EQ_AddUserDR
Property EQAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = EQ_AddUserDR ];

/// EQ_AddDate
Property EQAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 54, SqlFieldName = EQ_AddDate ];

/// EQ_AddTime
Property EQAddTime As %Library.Time [ SqlColumnNumber = 55, SqlFieldName = EQ_AddTime ];

/// EQ_UpdateUserDR
Property EQUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = EQ_UpdateUserDR ];

/// EQ_UpdateDate
Property EQUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 57, SqlFieldName = EQ_UpdateDate ];

/// EQ_UpdateTime
Property EQUpdateTime As %Library.Time [ SqlColumnNumber = 58, SqlFieldName = EQ_UpdateTime ];

/// EQ_CurrencyDR
Property EQCurrencyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = EQ_CurrencyDR ];

/// EQ_InvalidFlag
Property EQInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = EQ_InvalidFlag ];

/// EQ_StockStatus
Property EQStockStatus As %Library.String(DISPLAYLIST = ",新增,入库,转移出库,出库", MAXLEN = 4, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 61, SqlFieldName = EQ_StockStatus ];

/// EQ_MemoryCode
Property EQMemoryCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = EQ_MemoryCode ];

/// EQ_UrgencyFlag
Property EQUrgencyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = EQ_UrgencyFlag ];

/// EQ_EquipTypeDR
Property EQEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 64, SqlFieldName = EQ_EquipTypeDR ];

/// EQ_PurchaseTypeDR
Property EQPurchaseTypeDR As User.DHCEQCPurchaseType [ SqlColumnNumber = 65, SqlFieldName = EQ_PurchaseTypeDR ];

/// EQ_PurposeTypeDR
Property EQPurposeTypeDR As User.DHCEQCPurposeType [ SqlColumnNumber = 66, SqlFieldName = EQ_PurposeTypeDR ];

/// EQ_KeeperDR
Property EQKeeperDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = EQ_KeeperDR ];

/// EQ_StoreLocDR
Property EQStoreLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = EQ_StoreLocDR ];

/// EQ_StartDepreMonth
Property EQStartDepreMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = EQ_StartDepreMonth ];

/// EQ_ServiceDR
Property EQServiceDR As User.DHCEQCService [ SqlColumnNumber = 70, SqlFieldName = EQ_ServiceDR ];

/// EQ_InStockListDR
Property EQInStockListDR As User.DHCEQInStockList [ SqlColumnNumber = 71, SqlFieldName = EQ_InStockListDR ];

/// EQ_No
Property EQNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = EQ_No ];

/// EQ_ServiceHandler
Property EQServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = EQ_ServiceHandler ];

/// EQ_ServiceTel
Property EQServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = EQ_ServiceTel ];

/// EQ_HasDepreFlag
Property EQHasDepreFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 75, SqlFieldName = EQ_HasDepreFlag ];

/// EQ_StatCatDR
Property EQStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 76, SqlFieldName = EQ_StatCatDR ];

/// EQ_Hold1
Property EQHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = EQ_Hold1 ];

/// EQ_Hold2
Property EQHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = EQ_Hold2 ];

/// EQ_Hold3
Property EQHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = EQ_Hold3 ];

/// EQ_Hold4
Property EQHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = EQ_Hold4 ];

/// EQ_Hold5
Property EQHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = EQ_Hold5 ];

Index EQNoUnqIdx1 On EQNo [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipTemp("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EQ_ABCType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
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
<Data name="EQ_AppendFeeTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="EQ_BuyTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="EQ_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EQ_Code">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EQ_ComputerFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EQ_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
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
<Data name="EQ_DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="EQ_Desc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EQ_DesignWorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
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
<Piece>76</Piece>
</Data>
<Data name="EQ_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="EQ_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="EQ_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="EQ_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
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
<Data name="EQ_MaintUserDR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="EQ_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
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
<Data name="EQ_No">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="EQ_OpenCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EQ_OriginDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EQ_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
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
<Data name="EQ_Remark">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="EQ_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="EQ_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="EQ_ServiceTel">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
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
<Data name="EQ_WorkLoadUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Global>^DHCEQEquipTemp</Global>
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
<SQLMap name="IndexCode">
<Global>^DHCEQEquipTemp</Global>
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
<SQLMap name="IndexContractList">
<Global>^DHCEQEquipTemp</Global>
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
<SQLMap name="IndexHasDepreFlag">
<Global>^DHCEQEquipTemp</Global>
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
<SQLMap name="IndexInStockList">
<Global>^DHCEQEquipTemp</Global>
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
<Expression>"InStockList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_InStockListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexManuFactory">
<Global>^DHCEQEquipTemp</Global>
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
<Global>^DHCEQEquipTemp</Global>
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
<SQLMap name="IndexProvider">
<Global>^DHCEQEquipTemp</Global>
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
<Global>^DHCEQEquipTemp</Global>
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
<Global>^DHCEQEquipTemp</Global>
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
<Global>^DHCEQEquipTemp</Global>
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
<Global>^DHCEQEquipTemp</Global>
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
<Expression>{EQ_InStockListDR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{EQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreLoc">
<Global>^DHCEQEquipTemp</Global>
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
<SQLMap name="IndexUseLoc">
<Global>^DHCEQEquipTemp</Global>
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
<StreamLocation>^User.DHCEQEquipTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
