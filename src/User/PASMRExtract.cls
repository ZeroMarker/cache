/// PA SMR Extract(2004)
Class User.PASMRExtract Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_SMRExtract, StorageStrategy = SQLStorage ]
{

Relationship ChildPASMRExtractErrors As PASMRExtractErrors [ Cardinality = children, Inverse = ERRParRef ];

/// Hospital Patient Identifier
Property SMREHospitalPatientIdent As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SMRE_HospitalPatientIdent ];

/// Surname
Property SMRESurname As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SMRE_Surname ];

/// First Forename
Property SMREFirstForename As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SMRE_FirstForename ];

/// Second Forename
Property SMRESecondForename As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SMRE_SecondForename ];

/// Previous Surname
Property SMREPreviousSurname As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SMRE_PreviousSurname ];

/// Date Of Birth
Property SMREDateOfBirth As %Date [ SqlColumnNumber = 7, SqlFieldName = SMRE_DateOfBirth ];

/// Des Ref Sex
Property SMRESexDR As CTSex [ SqlColumnNumber = 8, SqlFieldName = SMRE_Sex_DR ];

/// Des Ref Marital
Property SMREMaritalDR As CTMarital [ SqlColumnNumber = 9, SqlFieldName = SMRE_Marital_DR ];

/// Community Health Index
Property SMRECommunityHealthIndex As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = SMRE_CommunityHealthIndex ];

/// NHS Number
Property SMRENHSNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = SMRE_NHSNumber ];

/// Patient Address
Property SMREPatientAddress As %String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = SMRE_PatientAddress ];

/// Des Ref EthnicGroup
Property SMREEthnicGroupDR As PACIndigStatus [ SqlColumnNumber = 13, SqlFieldName = SMRE_EthnicGroup_DR ];

/// Des Ref GP Code
Property SMREGPCodeDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = SMRE_GPCode_DR ];

/// Record Type
Property SMRERecordType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = SMRE_RecordType ];

/// Contr Id Provider Code
Property SMREContrIdProviderCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = SMRE_ContrIdProviderCode ];

/// ContractIdentifierPurchaser
Property SMREContractIdentifierPurchaser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = SMRE_ContractIdentifierPurchaser ];

/// Contract Identifier Cont No
Property SMREContractIdentifierContNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = SMRE_ContractIdentifierContNo ];

/// OSV Status
Property SMREOSVStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = SMRE_OSVStatus ];

/// Details of OS interview
Property SMREDetailsofOSinterview As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = SMRE_DetailsofOSinterview ];

/// Referrercode
Property SMREReferrercode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = SMRE_Referrercode ];

/// Spell Care Package id
Property SMRESpellCarePackageid As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = SMRE_SpellCarePackageid ];

/// Location/Hospital
Property SMRELocationHospitalDR As CTHospital [ SqlColumnNumber = 23, SqlFieldName = SMRE_LocationHospital_DR ];

/// Speciality
Property SMRESpeciality As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = SMRE_Speciality ];

/// Des Ref Significant Facility
Property SMRESignificantFacilityDR As CTSignificantFacility [ SqlColumnNumber = 25, SqlFieldName = SMRE_SignificantFacility_DR ];

/// Des Ref ResponsibleHCP
Property SMREResponsibleHCPDR As CTCareProv [ SqlColumnNumber = 26, SqlFieldName = SMRE_ResponsibleHCP_DR ];

/// Patient Category
Property SMREPatientCategory As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = SMRE_PatientCategory ];

/// Referral Reason1
Property SMREReferralReason1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = SMRE_ReferralReason1 ];

/// Referral Reason2
Property SMREReferralReason2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = SMRE_ReferralReason2 ];

/// Clinic Date
Property SMREClinicDate As %Date [ SqlColumnNumber = 30, SqlFieldName = SMRE_ClinicDate ];

/// Clinic Time
Property SMREClinicTime As %Time [ SqlColumnNumber = 31, SqlFieldName = SMRE_ClinicTime ];

/// Clinic Code
Property SMREClinicCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = SMRE_ClinicCode ];

/// GP referral letter number
Property SMREGPreferralletternumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = SMRE_GPreferralletternumber ];

/// Waiting Time Guarantee Exception
Property SMREWaitingTimeGuaranteeExc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = SMRE_WaitingTimeGuaranteeExc ];

/// Referral Received Date
Property SMREReferralReceivedDate As %Date [ SqlColumnNumber = 35, SqlFieldName = SMRE_ReferralReceivedDate ];

/// Referral Type
Property SMREReferralType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = SMRE_ReferralType ];

/// Des Ref ReferralSource
Property SMREReferralSourceDR As PACSourceOfAttendance [ SqlColumnNumber = 37, SqlFieldName = SMRE_ReferralSource_DR ];

/// Attendance Status
Property SMREAttendanceStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = SMRE_AttendanceStatus ];

/// Attendance Follow up
Property SMREAttendanceFollowup As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = SMRE_AttendanceFollow_up ];

/// Prime_diagnosis condition
Property SMREPrimediagnosisconditi As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = SMRE_Prime_diagnosis_conditi ];

/// Main Procedure
Property SMREMainProcedure As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = SMRE_MainProcedure ];

/// Attendance Class
Property SMREAttendanceClass As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = SMRE_AttendanceClass ];

/// Statistics Indicator
Property SMREStatisticsIndicator As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = SMRE_StatisticsIndicator ];

/// Appointment Time
Property SMREAppointmentTime As %Time [ SqlColumnNumber = 44, SqlFieldName = SMRE_AppointmentTime ];

/// Time Patient seen
Property SMRETimePatientseen As %Time [ SqlColumnNumber = 45, SqlFieldName = SMRE_TimePatientseen ];

/// Time of Arrival
Property SMRETimeofArrival As %Time [ SqlColumnNumber = 46, SqlFieldName = SMRE_TimeofArrival ];

/// Time of Departure
Property SMRETimeofDeparture As %Time [ SqlColumnNumber = 47, SqlFieldName = SMRE_TimeofDeparture ];

/// Management of patient
Property SMREManagementofpatient As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = SMRE_Managementofpatient ];

/// Des Ref WLGuarantExcCode
Property SMREWLGuarantExcCodeDR As PACWLGuarantExcCode [ SqlColumnNumber = 49, SqlFieldName = SMRE_WLGuarantExcCode_DR ];

/// Waiting List Date
Property SMREWaitingListDate As %Date [ SqlColumnNumber = 50, SqlFieldName = SMRE_WaitingListDate ];

/// Admission Date
Property SMREAdmissionDate As %Date [ SqlColumnNumber = 51, SqlFieldName = SMRE_AdmissionDate ];

/// AdmissionType
Property SMREAdmissionType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = SMRE_AdmissionType ];

/// Des Ref AdmissionReason
Property SMREAdmissionReasonDR As PACAdmReason [ SqlColumnNumber = 53, SqlFieldName = SMRE_AdmissionReason_DR ];

/// Des Ref Source of Admission
Property SMRESourceofAdmissionDR As PACAdmSource [ SqlColumnNumber = 54, SqlFieldName = SMRE_SourceofAdmission_DR ];

/// Des Ref Admission Transferred(ref clinic)
Property SMREAdmissionTransferred As CTRefClin [ SqlColumnNumber = 55, SqlFieldName = SMRE_AdmissionTransferred ];

/// Waiting List Type
Property SMREWaitingListType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = SMRE_WaitingListType ];

/// Main Diagnosis
Property SPREMainDiagnosis As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 57, SqlFieldName = SPRE_MainDiagnosis ];

/// Other Diagnosis
Property SMREOtherDiagnosis As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 58, SqlFieldName = SMRE_OtherDiagnosis ];

/// Prime procedure
Property SMREPrimeprocedure As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = SMRE_Primeprocedure ];

/// Date of Procedure
Property SMREDateofProcedure As %Date [ SqlColumnNumber = 60, SqlFieldName = SMRE_DateofProcedure ];

/// Des Ref ClinicianResponsible
Property SMREClinicianResponsibleDR As CTCareProv [ SqlColumnNumber = 61, SqlFieldName = SMRE_ClinicianResponsible_DR ];

/// Other procedures
Property SMREOtherprocedures As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 62, SqlFieldName = SMRE_Otherprocedures ];

/// Date of Procedures
Property SMREDateofProcedures As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 63, SqlFieldName = SMRE_DateofProcedures ];

/// Des Ref ClinicianResponsibleOther
Property SMREClinicianResponsibleOtherDR As CTCareProv [ SqlColumnNumber = 64, SqlFieldName = SMRE_ClinicianResponsibleOther_DR ];

/// Ready for Discharge date
Property SMREReadyforDischargedate As %Date [ SqlColumnNumber = 65, SqlFieldName = SMRE_ReadyforDischargedate ];

/// Reason for delay in discharge
Property SMREReasonfordelayindisc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 66, SqlFieldName = SMRE_Reasonfordelayindisc ];

/// Discharge Date
Property SMREDischargeDate As %Date [ SqlColumnNumber = 67, SqlFieldName = SMRE_DischargeDate ];

/// Des Ref Discharge Type
Property SMREDischargeTypeDR As PACDischCondit [ SqlColumnNumber = 68, SqlFieldName = SMRE_DischargeType_DR ];

/// Des Ref DischargeDestination
Property SMREDischargeDestinationDR As PACDischargeDestination [ SqlColumnNumber = 69, SqlFieldName = SMRE_DischargeDestination_DR ];

/// Des Ref RefClinc
Property SMRERefClincDR As CTRefClin [ SqlColumnNumber = 70, SqlFieldName = SMRE_RefClinc_DR ];

/// Day_case_suit_indicator
Property SMREDaycasesuitindicator As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 71, SqlFieldName = SMRE_Day_case_suit_indicator ];

/// Expected LOS
Property SMREExpectedLOS As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 72, SqlFieldName = SMRE_ExpectedLOS ];

/// Own_minister_indicator
Property SMREOwnministerindicator As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 73, SqlFieldName = SMRE_Own_minister_indicator ];

/// Hospital Chaplain Visit Required
Property SMREHospitalChaplainVisitRequir As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 74, SqlFieldName = SMRE_HospitalChaplainVisitRequired ];

/// Borrowed Bed indicator
Property SMREBorrowedBedindicator As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 75, SqlFieldName = SMRE_BorrowedBedindicator ];

/// Bed lent_from_speciality
Property SMREBedlentfromspeciality As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 76, SqlFieldName = SMRE_Bedlent_from_speciality ];

/// Des Ref Bed Transfer Reason
Property SMREBedTransferReasonDR As PACBedTransferReason [ SqlColumnNumber = 77, SqlFieldName = SMRE_BedTransferReason_DR ];

/// ExtractNumber
Property SMREExtractNumber As %Float [ SqlColumnNumber = 78, SqlFieldName = SMRE_ExtractNumber ];

/// Des Ref PASMR
Property SMREPASMRDR As PASMR [ SqlColumnNumber = 79, SqlFieldName = SMRE_PASMR_DR ];

/// Des Ref SMR Batch
Property SMREBatchDR As PASMRBatch [ SqlColumnNumber = 80, SqlFieldName = SMRE_Batch_DR ];

/// Invalid Indicator
Property SMREInvalidIndicator As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 81, SqlFieldName = SMRE_InvalidIndicator ];

/// Des Ref ExtractBuild
Property SMREExtractBuildDR As PASMRExtractBuild [ SqlColumnNumber = 82, SqlFieldName = SMRE_ExtractBuild_DR ];

/// SourceOfAdmission
Property SMRESourceOfAdmission As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 83, SqlFieldName = SMRE_SourceOfAdmission ];

/// DischargeType
Property SMREDischargeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 84, SqlFieldName = SMRE_DischargeType ];

/// DischargeDestination
Property SMREDischargeDestination As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 85, SqlFieldName = SMRE_DischargeDestination ];

/// Des Ref WaitList
Property SMREWaitListDR As PAWaitingList [ SqlColumnNumber = 86, SqlFieldName = SMRE_WaitList_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PASMRExtract).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtract","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PASMRExtract).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtract","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PASMRExtract).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtract","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PASMRExtract).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtract","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtract","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PASMRExtract).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtract","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PASMRE(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SMRE_AdmissionDate">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="SMRE_AdmissionReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="SMRE_AdmissionTransferred">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="SMRE_AdmissionType">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="SMRE_AppointmentTime">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SMRE_AttendanceClass">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="SMRE_AttendanceFollow_up">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="SMRE_AttendanceStatus">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="SMRE_Batch_DR">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="SMRE_BedTransferReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="SMRE_Bedlent_from_speciality">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="SMRE_BorrowedBedindicator">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="SMRE_ClinicCode">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SMRE_ClinicDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SMRE_ClinicTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SMRE_ClinicianResponsibleOther_DR">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="SMRE_ClinicianResponsible_DR">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="SMRE_CommunityHealthIndex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMRE_ContrIdProviderCode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMRE_ContractIdentifierContNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMRE_ContractIdentifierPurchaser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMRE_DateOfBirth">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMRE_DateofProcedure">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="SMRE_DateofProcedures">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="SMRE_Day_case_suit_indicator">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="SMRE_DetailsofOSinterview">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMRE_DischargeDate">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="SMRE_DischargeDestination">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="SMRE_DischargeDestination_DR">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="SMRE_DischargeType">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="SMRE_DischargeType_DR">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="SMRE_EthnicGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMRE_ExpectedLOS">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="SMRE_ExtractBuild_DR">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="SMRE_ExtractNumber">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="SMRE_FirstForename">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMRE_GPCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMRE_GPreferralletternumber">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SMRE_HospitalChaplainVisitRequired">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="SMRE_HospitalPatientIdent">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMRE_InvalidIndicator">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="SMRE_LocationHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SMRE_MainProcedure">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="SMRE_Managementofpatient">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="SMRE_Marital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMRE_NHSNumber">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMRE_OSVStatus">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMRE_OtherDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="SMRE_Otherprocedures">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="SMRE_Own_minister_indicator">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="SMRE_PASMR_DR">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="SMRE_PatientAddress">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMRE_PatientCategory">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SMRE_PreviousSurname">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMRE_Prime_diagnosis_conditi">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="SMRE_Primeprocedure">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="SMRE_ReadyforDischargedate">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="SMRE_Reasonfordelayindisc">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="SMRE_RecordType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMRE_RefClinc_DR">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="SMRE_ReferralReason1">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SMRE_ReferralReason2">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SMRE_ReferralReceivedDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="SMRE_ReferralSource_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="SMRE_ReferralType">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="SMRE_Referrercode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SMRE_ResponsibleHCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SMRE_SecondForename">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMRE_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMRE_SignificantFacility_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SMRE_SourceOfAdmission">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="SMRE_SourceofAdmission_DR">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="SMRE_Speciality">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SMRE_SpellCarePackageid">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SMRE_StatisticsIndicator">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SMRE_Surname">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMRE_TimePatientseen">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="SMRE_TimeofArrival">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="SMRE_TimeofDeparture">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="SMRE_WLGuarantExcCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="SMRE_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="SMRE_WaitingListDate">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="SMRE_WaitingListType">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="SMRE_WaitingTimeGuaranteeExc">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SPRE_MainDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Global>^PASMRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SMRE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBatch">
<Global>^PASMREi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Batch"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMRE_Batch_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtractBuild">
<Global>^PASMREi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ExtrBuild"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMRE_ExtractBuild_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvalid">
<Condition>{SMRE_InvalidIndicator}["Y"</Condition>
<ConditionFields>SMRE_ExtractBuild_DR,SMRE_InvalidIndicator</ConditionFields>
<Global>^PASMREi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Invalid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMRE_ExtractBuild_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^PASMREi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Number"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMRE_ExtractNumber}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSMR">
<Global>^PASMREi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SMRE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SMR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SMRE_PASMR_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SMRE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SMRE_RowId</SqlRowIdName>
<StreamLocation>^User.PASMRExtractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
