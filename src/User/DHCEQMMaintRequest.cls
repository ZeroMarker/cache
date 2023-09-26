Class User.DHCEQMMaintRequest Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MR_RowID, SqlTableName = DHC_EQMMaintRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MR_AcceptDate
Property MRAcceptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = MR_AcceptDate ];

/// MR_AcceptTime
Property MRAcceptTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = MR_AcceptTime ];

/// MR_AcceptUserDR
Property MRAcceptUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MR_AcceptUserDR ];

/// MR_AddDate
Property MRAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 44, SqlFieldName = MR_AddDate ];

/// MR_AddTime
Property MRAddTime As %Library.Time [ SqlColumnNumber = 45, SqlFieldName = MR_AddTime ];

/// MR_AddUserDR
Property MRAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = MR_AddUserDR ];

/// MR_AssignDR
Property MRAssignDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MR_AssignDR ];

/// MR_AuditDate
Property MRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 53, SqlFieldName = MR_AuditDate ];

/// MR_AuditTime
Property MRAuditTime As %Library.Time [ SqlColumnNumber = 54, SqlFieldName = MR_AuditTime ];

/// MR_AuditUserDR
Property MRAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = MR_AuditUserDR ];

/// MR_CancelDate
Property MRCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 56, SqlFieldName = MR_CancelDate ];

/// MR_CancelTime
Property MRCancelTime As %Library.Time [ SqlColumnNumber = 57, SqlFieldName = MR_CancelTime ];

/// MR_CancelUser
Property MRCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = MR_CancelUser ];

/// MR_ContractDR
Property MRContractDR As User.DHCEQContract [ SqlColumnNumber = 31, SqlFieldName = MR_ContractDR ];

/// MR_DealMethodDR
Property MRDealMethodDR As User.DHCEQMCDealMethod [ SqlColumnNumber = 15, SqlFieldName = MR_DealMethodDR ];

/// MR_DealMethodRemark
Property MRDealMethodRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MR_DealMethodRemark ];

/// MR_EmergencyLevelDR 
Property MREmergencyLevelDR As User.DHCEQMCEmergencyLevel [ SqlColumnNumber = 62, SqlFieldName = MR_EmergencyLevelDR ];

/// MR_EndDate
Property MREndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = MR_EndDate ];

/// MR_EndTime
Property MREndTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = MR_EndTime ];

/// MR_EquipStatusDR
Property MREquipStatusDR As User.DHCEQEquipStatus [ SqlColumnNumber = 69, SqlFieldName = MR_EquipStatusDR ];

/// MR_EquipTypeDR
Property MREquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 4, SqlFieldName = MR_EquipTypeDR ];

/// MR_EstimateWorkHour
Property MREstimateWorkHour As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = MR_EstimateWorkHour ];

/// MR_ExObjDR
Property MRExObjDR As User.DHCEQMExObj [ SqlColumnNumber = 6, SqlFieldName = MR_ExObjDR ];

/// MR_FaultCaseDR
Property MRFaultCaseDR As User.DHCEQMCFaultCase [ SqlColumnNumber = 11, SqlFieldName = MR_FaultCaseDR ];

/// MR_FaultCaseRemark
Property MRFaultCaseRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MR_FaultCaseRemark ];

/// MR_FaultReasonDR
Property MRFaultReasonDR As User.DHCEQMCFaultReason [ SqlColumnNumber = 13, SqlFieldName = MR_FaultReasonDR ];

/// MR_FaultReasonRemark
Property MRFaultReasonRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MR_FaultReasonRemark ];

/// MR_FaultTypeDR
Property MRFaultTypeDR As User.DHCEQMCFaultType [ SqlColumnNumber = 24, SqlFieldName = MR_FaultTypeDR ];

/// MR_SourceType
Property MRSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = MR_SourceType ];

/// MR_AssignDate
Property MRAssignDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = MR_AssignDate ];

/// MR_PackageState
Property MRPackageState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = MR_PackageState ];

/// MR_SaveReason
Property MRSaveReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = MR_SaveReason ];

/// MR_GuaranteePeriod
Property MRGuaranteePeriod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = MR_GuaranteePeriod ];

/// MR_ExObjName
Property MRExObjName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 75, SqlFieldName = MR_ExObjName ];

/// MR_EQNo
Property MREQNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = MR_EQNo ];

/// MR_MaintType
Property MRMaintType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = MR_MaintType ];

/// MR_InputFlag
Property MRInputFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 78, SqlFieldName = MR_InputFlag ];

/// MR_CheckDate
Property MRCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 79, SqlFieldName = MR_CheckDate ];

/// MR_AccessoryOriginalDR
Property MRAccessoryOriginalDR As User.DHCEQAffix [ SqlColumnNumber = 80, SqlFieldName = MR_AccessoryOriginalDR ];

/// MR_YearWorkLoad
Property MRYearWorkLoad As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = MR_YearWorkLoad ];

/// MR_YearIncome
Property MRYearIncome As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 82, SqlFieldName = MR_YearIncome ];

/// MR_Assessment
Property MRAssessment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 83, SqlFieldName = MR_Assessment ];

/// MR_AccountDate
Property MRAccountDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 84, SqlFieldName = MR_AccountDate ];

/// MR_Hold15
Property MRHold15 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 85, SqlFieldName = MR_Hold15 ];

/// MR_Hold16
Property MRHold16 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = MR_Hold16 ];

/// MR_Hold17
Property MRHold17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 87, SqlFieldName = MR_Hold17 ];

/// MR_RetrieveFlag
Property MRRetrieveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 88, SqlFieldName = MR_RetrieveFlag ];

/// MR_ReplaceFlag
Property MRReplaceFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 89, SqlFieldName = MR_ReplaceFlag ];

/// MR_DisuesdFlag
Property MRDisuesdFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 90, SqlFieldName = MR_DisuesdFlag ];

/// MR_InsurFlag
Property MRInsurFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 67, SqlFieldName = MR_InsurFlag ];

/// MR_InvalidFlag
Property MRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = MR_InvalidFlag ];

/// MR_MaintFee
Property MRMaintFee As %Library.Float [ SqlColumnNumber = 59, SqlFieldName = MR_MaintFee ];

/// MR_MaintGroupDR
Property MRMaintGroupDR As User.DHCEQMCMaintGroup [ SqlColumnNumber = 71, SqlFieldName = MR_MaintGroupDR ];

/// MR_MaintLocDR
Property MRMaintLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = MR_MaintLocDR ];

/// MR_MaintModeDR
Property MRMaintModeDR As User.DHCEQMCMaintMode [ SqlColumnNumber = 29, SqlFieldName = MR_MaintModeDR ];

/// MR_MaintProcessDR
Property MRMaintProcessDR As User.DHCEQMCMaintProcess [ SqlColumnNumber = 70, SqlFieldName = MR_MaintProcessDR ];

/// MR_MaintRemark
Property MRMaintRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = MR_MaintRemark ];

/// MR_MaintRequestDR
Property MRMaintRequestDR As User.DHCEQMMaintRequest [ SqlColumnNumber = 37, SqlFieldName = MR_MaintRequestDR ];

/// MR_MaintResultsDR 
Property MRMaintResultsDR As User.DHCEQMCMaintResults [ SqlColumnNumber = 68, SqlFieldName = MR_MaintResultsDR ];

/// MR_ManageLocDR
Property MRManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = MR_ManageLocDR ];

/// MR_ManageTypeDR
Property MRManageTypeDR As User.DHCEQMCManageType [ SqlColumnNumber = 3, SqlFieldName = MR_ManageTypeDR ];

/// MR_ObjLocDR
Property MRObjLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MR_ObjLocDR ];

/// MR_ObjTypeDR
Property MRObjTypeDR As User.DHCEQMCObjType [ SqlColumnNumber = 5, SqlFieldName = MR_ObjTypeDR ];

/// MR_OtherFee
Property MROtherFee As %Library.Float [ SqlColumnNumber = 60, SqlFieldName = MR_OtherFee ];

/// MR_Place
/// add by WY 2020-8-30 MR_Place 改为MRLocationDR
Property MRLocationDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = MR_LocationDR ];

/// MR_Remark
Property MRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = MR_Remark ];

/// MR_RequestDate
Property MRRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = MR_RequestDate ];

/// MR_RequestLocDR
Property MRRequestLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MR_RequestLocDR ];

/// MR_RequestNo
Property MRRequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MR_RequestNo ];

/// MR_RequestTel
Property MRRequestTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MR_RequestTel ];

/// MR_RequestTime
Property MRRequestTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = MR_RequestTime ];

/// MR_RequestUserDR
Property MRRequestUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MR_RequestUserDR ];

/// MR_ReturnFlag
Property MRReturnFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = MR_ReturnFlag ];

/// MR_SaveCostFee
Property MRSaveCostFee As %Library.Float [ SqlColumnNumber = 72, SqlFieldName = MR_SaveCostFee ];

/// MR_ServiceDR
Property MRServiceDR As User.DHCEQCVendor [ SqlColumnNumber = 32, SqlFieldName = MR_ServiceDR ];

/// MR_SeverityLevelDR
Property MRSeverityLevelDR As User.DHCEQMCSeverityLevel [ SqlColumnNumber = 63, SqlFieldName = MR_SeverityLevelDR ];

/// MR_StartDate
Property MRStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MR_StartDate ];

/// MR_StartTime
Property MRStartTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MR_StartTime ];

/// MR_Status
Property MRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废,异常结束", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 42, SqlFieldName = MR_Status ];

/// MR_SubmitDate
Property MRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 50, SqlFieldName = MR_SubmitDate ];

/// MR_SubmitTime
Property MRSubmitTime As %Library.Time [ SqlColumnNumber = 51, SqlFieldName = MR_SubmitTime ];

/// MR_SubmitUserDR
Property MRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = MR_SubmitUserDR ];

/// MR_TotalFee
Property MRTotalFee As %Library.Float [ SqlColumnNumber = 61, SqlFieldName = MR_TotalFee ];

/// MR_UpdateDate
Property MRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 47, SqlFieldName = MR_UpdateDate ];

/// MR_UpdateTime
Property MRUpdateTime As %Library.Time [ SqlColumnNumber = 48, SqlFieldName = MR_UpdateTime ];

/// MR_UpdateUserDR
Property MRUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = MR_UpdateUserDR ];

/// MR_UserOpinion
Property MRUserOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = MR_UserOpinion ];

/// MR_UserSignDR
Property MRUserSignDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = MR_UserSignDR ];

/// MR_WorkHour
Property MRWorkHour As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = MR_WorkHour ];

/// MR_Hold21
Property MRHold21 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = MR_Hold21 ];

/// MR_Hold22
Property MRHold22 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 92, SqlFieldName = MR_Hold22 ];

/// MR_Hold23
Property MRHold23 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 93, SqlFieldName = MR_Hold23 ];

/// MR_Hold24
Property MRHold24 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = MR_Hold24 ];

/// MR_Hold25
Property MRHold25 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 95, SqlFieldName = MR_Hold25 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMMaintRequest("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MR_AcceptDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MR_AcceptTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MR_AcceptUserDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MR_AccessoryOriginalDR">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="MR_AccountDate">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="MR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="MR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="MR_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MR_Assessment">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="MR_AssignDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MR_AssignDate">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="MR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="MR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="MR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="MR_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="MR_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="MR_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="MR_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="MR_ContractDR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MR_DealMethodDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MR_DealMethodRemark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MR_DisuesdFlag">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="MR_EQNo">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="MR_EmergencyLevelDR">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="MR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MR_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MR_EquipStatusDR">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="MR_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MR_EstimateWorkHour">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MR_ExObjDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MR_ExObjName">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="MR_FaultCaseDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MR_FaultCaseRemark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MR_FaultReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MR_FaultReasonRemark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MR_FaultTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MR_GuaranteePeriod">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="MR_Hold15">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="MR_Hold16">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="MR_Hold17">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="MR_Hold21">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="MR_Hold22">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="MR_Hold23">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="MR_Hold24">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="MR_Hold25">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="MR_InputFlag">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="MR_InsurFlag">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="MR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="MR_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MR_MaintFee">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="MR_MaintGroupDR">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="MR_MaintLocDR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MR_MaintModeDR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MR_MaintProcessDR">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="MR_MaintRemark">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MR_MaintRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MR_MaintResultsDR">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="MR_MaintType">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="MR_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MR_ManageTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MR_ObjLocDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MR_ObjTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MR_OtherFee">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="MR_PackageState">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="MR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MR_ReplaceFlag">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="MR_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MR_RequestLocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MR_RequestNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MR_RequestTel">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MR_RequestTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MR_RequestUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MR_RetrieveFlag">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="MR_ReturnFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MR_SaveCostFee">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="MR_SaveReason">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="MR_ServiceDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MR_SeverityLevelDR">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="MR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="MR_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MR_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MR_Status">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="MR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="MR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="MR_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="MR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="MR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="MR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="MR_UserOpinion">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MR_UserSignDR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MR_WorkHour">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MR_YearIncome">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="MR_YearWorkLoad">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Global>^DHCEQMMaintRequest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexObjLoc">
<Global>^DHCEQMMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ObjLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MR_ObjLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MR_AddDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestNo">
<Global>^DHCEQMMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RequestNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>" "_{MR_RequestNO}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^DHCEQMMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Service"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MR_ServiceDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MR_AddDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQMMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_ExObjDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQMMaintRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MR_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMMaintRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
