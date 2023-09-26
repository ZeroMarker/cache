Class User.DHCEQCAccessory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = A_RowID, SqlTableName = DHC_EQCAccessory, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// A_ABCType
Property AABCType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = A_ABCType ];

/// A_AddDate
Property AAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 73, SqlFieldName = A_AddDate ];

/// A_AddTime
Property AAddTime As %Library.Time [ SqlColumnNumber = 74, SqlFieldName = A_AddTime ];

/// A_AddUserDR
Property AAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = A_AddUserDR ];

/// A_AllowOrderNoStock
Property AAllowOrderNoStock As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 59, SqlFieldName = A_AllowOrderNoStock ];

/// A_BarCode
Property ABarCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = A_BarCode ];

/// A_BaseUOMDR
Property ABaseUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = A_BaseUOMDR ];

/// A_BatchFlag
Property ABatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 89, SqlFieldName = A_BatchFlag ];

/// A_BillUOMDR
Property ABillUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = A_BillUOMDR ];

/// A_Brand
Property ABrand As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = A_Brand ];

/// A_BrandCertificate
Property ABrandCertificate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = A_BrandCertificate ];

/// A_CatDR
Property ACatDR As User.DHCEQCAccessoryCat [ SqlColumnNumber = 16, SqlFieldName = A_CatDR ];

/// A_CertificateNo
Property ACertificateNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = A_CertificateNo ];

/// A_Code
Property ACode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = A_Code ];

/// A_CommercialName
Property ACommercialName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = A_CommercialName ];

/// A_CountryDR
Property ACountryDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = A_CountryDR ];

/// A_CurBPrice
Property ACurBPrice As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = A_CurBPrice ];

/// A_CurProviderDR
Property ACurProviderDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 90, SqlFieldName = A_CurProviderDR ];

/// A_Desc
Property ADesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = A_Desc ];

/// A_EffDate
Property AEffDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 60, SqlFieldName = A_EffDate ];

/// A_EffDateTo
Property AEffDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 62, SqlFieldName = A_EffDateTo ];

/// A_EffTime
Property AEffTime As %Library.Time [ SqlColumnNumber = 61, SqlFieldName = A_EffTime ];

/// A_EffTimeTo
Property AEffTimeTo As %Library.Time [ SqlColumnNumber = 63, SqlFieldName = A_EffTimeTo ];

/// A_ExpSaleRate
Property AExpSaleRate As %Library.Float [ SqlColumnNumber = 46, SqlFieldName = A_ExpSaleRate ];

/// A_ExpiredDays
Property AExpiredDays As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = A_ExpiredDays ];

/// A_ExpiredFlag
Property AExpiredFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = A_ExpiredFlag ];

/// A_ExtendCode
Property AExtendCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = A_ExtendCode ];

/// A_FeeRulesDR
Property AFeeRulesDR As User.DHCEQCFeeRules [ SqlColumnNumber = 14, SqlFieldName = A_FeeRulesDR ];

/// A_FixPreDays
Property AFixPreDays As %Library.Float [ SqlColumnNumber = 45, SqlFieldName = A_FixPreDays ];

/// A_GeneralName
Property AGeneralName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = A_GeneralName ];

/// A_Hold1
Property AHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = A_Hold1 ];

/// A_Hold10
Property AHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 88, SqlFieldName = A_Hold10 ];

/// A_Hold2
Property AHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = A_Hold2 ];

/// A_Hold3
Property AHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = A_Hold3 ];

/// A_Hold4
Property AHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 82, SqlFieldName = A_Hold4 ];

/// A_Hold5
Property AHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 83, SqlFieldName = A_Hold5 ];

/// A_Hold6
Property AHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 84, SqlFieldName = A_Hold6 ];

/// A_Hold7
Property AHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 85, SqlFieldName = A_Hold7 ];

/// A_Hold8
Property AHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = A_Hold8 ];

/// A_Hold9
Property AHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 87, SqlFieldName = A_Hold9 ];

/// A_ImportNo
Property AImportNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = A_ImportNo ];

/// A_ImportRegisterNo
Property AImportRegisterNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = A_ImportRegisterNo ];

/// A_InvalidFlag
Property AInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 78, SqlFieldName = A_InvalidFlag ];

/// A_ManuFactoryDR
Property AManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 28, SqlFieldName = A_ManuFactoryDR ];

/// A_MaxBPrice
Property AMaxBPrice As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = A_MaxBPrice ];

/// A_MaxOrderQty
Property AMaxOrderQty As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = A_MaxOrderQty ];

/// A_MaxQty
Property AMaxQty As %Library.Float [ SqlColumnNumber = 50, SqlFieldName = A_MaxQty ];

/// A_MaxSPrice
Property AMaxSPrice As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = A_MaxSPrice ];

/// A_MinBPrice
Property AMinBPrice As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = A_MinBPrice ];

/// A_MinOrderQty
Property AMinOrderQty As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = A_MinOrderQty ];

/// A_MinQty
Property AMinQty As %Library.Float [ SqlColumnNumber = 49, SqlFieldName = A_MinQty ];

/// A_MinSPrice
Property AMinSPrice As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = A_MinSPrice ];

/// A_Model
Property AModel As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = A_Model ];

/// A_NeedTest
Property ANeedTest As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = A_NeedTest ];

/// A_OverStock
Property AOverStock As %Library.Float [ SqlColumnNumber = 40, SqlFieldName = A_OverStock ];

/// A_PakageType
Property APakageType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = A_PakageType ];

/// A_PickingRule
Property APickingRule As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = A_PickingRule ];

/// A_PlaceOfProduction
Property APlaceOfProduction As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = A_PlaceOfProduction ];

/// A_ProductionLicence
Property AProductionLicence As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = A_ProductionLicence ];

/// A_PurchaseFlag
Property APurchaseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = A_PurchaseFlag ];

/// A_RegisterNo
Property ARegisterNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = A_RegisterNo ];

/// A_Remark
Property ARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = A_Remark ];

/// A_RequireNote
Property ARequireNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = A_RequireNote ];

/// A_ReturnInspectRequirement
Property AReturnInspectRequirement As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = A_ReturnInspectRequirement ];

/// A_ReturnableFlag
Property AReturnableFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 68, SqlFieldName = A_ReturnableFlag ];

/// A_SafeQty
Property ASafeQty As %Library.Float [ SqlColumnNumber = 48, SqlFieldName = A_SafeQty ];

/// A_SaleFlag
Property ASaleFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = A_SaleFlag ];

/// A_SelfMakeFlag
Property ASelfMakeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = A_SelfMakeFlag ];

/// A_SerialFlag
Property ASerialFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = A_SerialFlag ];

/// A_ServMaterial
Property AServMaterial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = A_ServMaterial ];

/// A_ShortDesc
Property AShortDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = A_ShortDesc ];

/// A_ShowMessage
Property AShowMessage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = A_ShowMessage ];

/// A_SolitudeFlag
Property ASolitudeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = A_SolitudeFlag ];

/// A_StdSPrice
Property AStdSPrice As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = A_StdSPrice ];

/// A_StockEnabledFlag
Property AStockEnabledFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = A_StockEnabledFlag ];

/// A_TypeDR
Property ATypeDR As User.DHCEQCAccessoryType [ SqlColumnNumber = 15, SqlFieldName = A_TypeDR ];

/// A_UpdateDate
Property AUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 76, SqlFieldName = A_UpdateDate ];

/// A_UpdateTime
Property AUpdateTime As %Library.Time [ SqlColumnNumber = 77, SqlFieldName = A_UpdateTime ];

/// A_UpdateUserDR
Property AUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 75, SqlFieldName = A_UpdateUserDR ];

/// A_Version
Property AVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = A_Version ];

/// A_VirtualFlag
Property AVirtualFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = A_VirtualFlag ];

/// A_VisibleInOrderList
Property AVisibleInOrderList As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 64, SqlFieldName = A_VisibleInOrderList ];

/// A_Volume
Property AVolume As %Library.Float [ SqlColumnNumber = 52, SqlFieldName = A_Volume ];

/// A_VolumeUOMDR
Property AVolumeUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = A_VolumeUOMDR ];

/// A_WarningDays
Property AWarningDays As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = A_WarningDays ];

/// A_WastageRate
Property AWastageRate As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = A_WastageRate ];

/// A_Weight
Property AWeight As %Library.Float [ SqlColumnNumber = 54, SqlFieldName = A_Weight ];

/// A_WeightUOMDR
Property AWeightUOMDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = A_WeightUOMDR ];

/// A_WorthQty
Property AWorthQty As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = A_WorthQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCAccessory",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="A_ABCType">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="A_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="A_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="A_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="A_AllowOrderNoStock">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="A_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="A_BaseUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="A_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="A_BillUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="A_Brand">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="A_BrandCertificate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="A_CatDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="A_CertificateNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="A_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="A_CommercialName">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="A_CountryDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="A_CurBPrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="A_CurProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="A_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="A_EffDate">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="A_EffDateTo">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="A_EffTime">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="A_EffTimeTo">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="A_ExpSaleRate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="A_ExpiredDays">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="A_ExpiredFlag">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="A_ExtendCode">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="A_FeeRulesDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="A_FixPreDays">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="A_GeneralName">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="A_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="A_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="A_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="A_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="A_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="A_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="A_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="A_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="A_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="A_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="A_ImportNo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="A_ImportRegisterNo">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="A_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="A_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="A_MaxBPrice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="A_MaxOrderQty">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="A_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="A_MaxSPrice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="A_MinBPrice">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="A_MinOrderQty">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="A_MinQty">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="A_MinSPrice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="A_Model">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="A_NeedTest">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="A_OverStock">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="A_PakageType">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="A_PickingRule">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="A_PlaceOfProduction">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="A_ProductionLicence">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="A_PurchaseFlag">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="A_RegisterNo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="A_Remark">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="A_RequireNote">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="A_ReturnInspectRequirement">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="A_ReturnableFlag">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="A_SafeQty">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="A_SaleFlag">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="A_SelfMakeFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="A_SerialFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="A_ServMaterial">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="A_ShortDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="A_ShowMessage">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="A_SolitudeFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="A_StdSPrice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="A_StockEnabledFlag">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="A_TypeDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="A_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="A_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="A_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="A_Version">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="A_VirtualFlag">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="A_VisibleInOrderList">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="A_Volume">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="A_VolumeUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="A_WarningDays">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="A_WastageRate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="A_Weight">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="A_WeightUOMDR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="A_WorthQty">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCAccessory"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{A_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCAccessory"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{A_TypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{A_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{A_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCAccessory"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{A_TypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{A_Desc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{A_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServMaterial">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>A_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCAccessory"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ServMaterial"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{A_TypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{A_ServMaterial}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{A_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCAccessoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
