/// DHC_ICU_Arrange
Class User.DHCICUArrange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUA_RowId, SqlTableName = DHC_ICU_Arrange, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCICUPrintRecord As User.DHCICUPrintRecord [ Cardinality = children, Inverse = ICUPRParref ];

Relationship ChildDHCICUANItem As User.DHCICUANItem [ Cardinality = children, Inverse = ICUANIParref ];

Relationship ChildDHCICUShift As User.DHCICUShift [ Cardinality = children, Inverse = ICUSParref ];

Relationship ChildDHCICUCollectData As User.DHCICUCollectData [ Cardinality = children, Inverse = ICUCDParref ];

Parameter EXTENTSIZE = 250;

/// ICUA_Adm_Dr
Property ICUAAdmDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ICUA_Adm_Dr ];

/// ICUA_PatDept_Dr
Property ICUAPatDeptDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ICUA_PatDept_Dr ];

/// ICUA_Anaest_Dr
Property ICUAAnaestDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ICUA_Anaest_Dr ];

/// ICUA_Bed_Dr
Property ICUABedDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ICUA_Bed_Dr ];

/// ICUA_Type
Property ICUAType As %Library.String(DISPLAYLIST = ",Intensive,Mixed,Normal", MAXLEN = 9, SELECTIVITY = "25.0000%", VALUELIST = ",I,M,N") [ SqlColumnNumber = 6, SqlFieldName = ICUA_Type ];

/// ICUA_StartDate
Property ICUAStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ICUA_StartDate ];

/// ICUA_EndDate
Property ICUAEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = ICUA_EndDate ];

/// ICUA_StartTime
Property ICUAStartTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = ICUA_StartTime ];

/// ICUA_EndTime
Property ICUAEndTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = ICUA_EndTime ];

/// ICUA_PatStatus
Property ICUAPatStatus As %Library.String(DISPLAYLIST = ",Normal,Abnormal", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,A") [ SqlColumnNumber = 11, SqlFieldName = ICUA_PatStatus ];

/// ICUA_CreateUser_Dr
Property ICUACreateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ICUA_CreateUser_Dr ];

/// ICUA_CreateDate
Property ICUACreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = ICUA_CreateDate ];

/// ICUA_CreateTime
Property ICUACreateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = ICUA_CreateTime ];

/// ICUA_UpdateUser_Dr
Property ICUAUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ICUA_UpdateUser_Dr ];

/// ICUA_UpdateDate
Property ICUAUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = ICUA_UpdateDate ];

/// ICUA_UpdateTime
Property ICUAUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = ICUA_UpdateTime ];

/// ICUA_Note
Property ICUANote As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ICUA_Note ];

/// ICUA_Status
Property ICUAStatus As %Library.String(DISPLAYLIST = ",Apply,Decline,Receive,Monitor,Terminate,Finish", MAXLEN = 9, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",A,D,R,M,T,F") [ SqlColumnNumber = 19, SqlFieldName = ICUA_Status ];

/// ICUA_Level_Dr
Property ICUALevelDr As User.DHCICUCLevel [ SqlColumnNumber = 20, SqlFieldName = ICUA_Level_Dr ];

/// ICUA_RelatedDiag_Dr
Property ICUARelatedDiagDr As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ICUA_RelatedDiag_Dr ];

/// ICUA_Isolated
Property ICUAIsolated As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = ICUA_Isolated ];

Property ICUANormalStartDate As %Date [ SqlColumnNumber = 23, SqlFieldName = ICUA_NormalStartDate ];

Property ICUANormalStartTime As %Time [ SqlColumnNumber = 24, SqlFieldName = ICUA_NormalStartTime ];

Property ICUAPatHeight As %Float [ SqlColumnNumber = 25, SqlFieldName = ICUA_PatHeight ];

Property ICUAPatWeight As %Float [ SqlColumnNumber = 26, SqlFieldName = ICUA_PatWeight ];

Property ICUAAcuteRenalFailure As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = ICUA_AcuteRenalFailure ];

Property ICUAChronicHealthPoint As %String [ SqlColumnNumber = 28, SqlFieldName = ICUA_ChronicHealthPoint ];

Property ICUAResidentCtcpDr As %String [ SqlColumnNumber = 29, SqlFieldName = ICUA_ResidentCtcp_Dr ];

Property ICUAAttendingCtcpDr As %String [ SqlColumnNumber = 30, SqlFieldName = ICUA_AttendingCtcp_Dr ];

Property ICUASurgeryType As %String(DISPLAYLIST = ",None,Emergency,Booked", MAXLEN = 9, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,E,B") [ SqlColumnNumber = 31, SqlFieldName = ICUA_SurgeryType ];

Property ICUAInfectedSite As %String(MAXLEN = 100) [ SqlColumnNumber = 32, SqlFieldName = ICUA_InfectedSite ];

Property ICUAShockType As %String [ SqlColumnNumber = 33, SqlFieldName = ICUA_ShockType ];

Property ICUAEyeOpeningCLCSODr As User.DHCCLCScoreOption [ SqlColumnNumber = 34, SqlFieldName = ICUA_EyeOpeningCLCSO_Dr ];

Property ICUAVerbalResponseCLCSODr As User.DHCCLCScoreOption [ SqlColumnNumber = 35, SqlFieldName = ICUA_VerbalResponseCLCSO_Dr ];

Property ICUAMotorResponseCLCSODr As User.DHCCLCScoreOption [ SqlColumnNumber = 36, SqlFieldName = ICUA_MotorResponseCLCSO_Dr ];

Property ICUAGlasgowPoint As %Float [ SqlColumnNumber = 37, SqlFieldName = ICUA_GlasgowPoint ];

Property ICUAAPSPoint As %Float [ SqlColumnNumber = 38, SqlFieldName = ICUA_APSPoint ];

Property ICUAAgePoint As %Float [ SqlColumnNumber = 39, SqlFieldName = ICUA_AgePoint ];

Property ICUACHPPoint As %Float [ SqlColumnNumber = 40, SqlFieldName = ICUA_CHPPoint ];

Property ICUAApacheIIPoint As %Float [ SqlColumnNumber = 41, SqlFieldName = ICUA_ApacheIIPoint ];

Property ICUADiagnosticCatCLCSODr As User.DHCCLCScoreOption [ SqlColumnNumber = 42, SqlFieldName = ICUA_DiagnosticCatCLCSO_Dr ];

Property ICUADeathProbability As %Float [ SqlColumnNumber = 43, SqlFieldName = ICUA_DeathProbability ];

Property ICUALeaveCondition As %String(DISPLAYLIST = ",Transfer,MBD,AAD,Death,OutTreat", VALUELIST = ",T,M,A,D,O") [ SqlColumnNumber = 44, SqlFieldName = ICUA_LeaveCondition ];

Property ICUALeaveDate As %Date [ SqlColumnNumber = 45, SqlFieldName = ICUA_LeaveDate ];

Property ICUALeaveTime As %Time [ SqlColumnNumber = 46, SqlFieldName = ICUA_LeaveTime ];

Property ICUAFee As %Float [ SqlColumnNumber = 47, SqlFieldName = ICUA_Fee ];

Property ICUAMechanVentilationHour As %Float [ SqlColumnNumber = 48, SqlFieldName = ICUA_MechanVentilationHour ];

Property ICUANoninvasVentilationHour As %Float [ SqlColumnNumber = 49, SqlFieldName = ICUA_NoninvasVentilationHour ];

Property ICUAPiccoHour As %Float [ SqlColumnNumber = 50, SqlFieldName = ICUA_PiccoHour ];

Property ICUAPacHour As %Float [ SqlColumnNumber = 51, SqlFieldName = ICUA_PacHour ];

Property ICUAEcmoHour As %Float [ SqlColumnNumber = 52, SqlFieldName = ICUA_EcmoHour ];

Property ICUACrrtHour As %Float [ SqlColumnNumber = 53, SqlFieldName = ICUA_CrrtHour ];

Property ICUAIabpHour As %Float [ SqlColumnNumber = 54, SqlFieldName = ICUA_IabpHour ];

Property ICUACvpCount As %Float [ SqlColumnNumber = 55, SqlFieldName = ICUA_CvpCount ];

Property ICUACvpDateTime As %String(MAXLEN = 500) [ SqlColumnNumber = 56, SqlFieldName = ICUA_CvpDateTime ];

Property ICUACvpCatheterModel As %String [ SqlColumnNumber = 57, SqlFieldName = ICUA_CvpCatheterModel ];

Property ICUACvpCatheterDay As %Float [ SqlColumnNumber = 58, SqlFieldName = ICUA_CvpCatheterDay ];

Property ICUAUrinaryCatheterDay As %Float [ SqlColumnNumber = 59, SqlFieldName = ICUA_UrinaryCatheterDay ];

Property ICUAIsPdt As %Boolean [ SqlColumnNumber = 60, SqlFieldName = ICUA_IsPdt ];

Property ICUAChargeNurseDr As %String [ SqlColumnNumber = 61, SqlFieldName = ICUA_ChargeNurse_Dr ];

Property ICUASupervisorNurseDr As %String [ SqlColumnNumber = 62, SqlFieldName = ICUA_SupervisorNurse_Dr ];

Property ICUAICUPMDr As User.DHCICUPatMaster [ SqlColumnNumber = 63, SqlFieldName = ICUA_ICUPM_Dr ];

Property ICUAAdmCode As %String [ SqlColumnNumber = 64, SqlFieldName = ICUA_AdmCode ];

Property ICUAHostpitalCode As %String [ SqlColumnNumber = 65, SqlFieldName = ICUA_HostpitalCode ];

Property ICUAResidence As %String(DISPLAYLIST = ",Home,WorkPlace,NursingHome,Hospital,HealthInstitution,TemporaryHome,NonHealth", VALUELIST = ",M,W,U,H,I,T,N") [ SqlColumnNumber = 66, SqlFieldName = ICUA_Residence ];

Property ICUAIsEstimatedHeight As %Boolean [ SqlColumnNumber = 67, SqlFieldName = ICUA_IsEstimatedHeight ];

Property ICUAIsEstimatedWeight As %Boolean [ SqlColumnNumber = 68, SqlFieldName = ICUA_IsEstimatedWeight ];

Property ICUAPregnant As %String(DISPLAYLIST = ",Currently,Recently,UnKnown", VALUELIST = ",C,R,U") [ SqlColumnNumber = 69, SqlFieldName = ICUA_Pregnant ];

Property ICUAGestation As %String [ SqlColumnNumber = 70, SqlFieldName = ICUA_Gestation ];

Property ICUADeliveryDate As %Date [ SqlColumnNumber = 71, SqlFieldName = ICUA_DeliveryDate ];

Property ICUAAdmDate As %Date [ SqlColumnNumber = 72, SqlFieldName = ICUA_AdmDate ];

Property ICUAPreDayCPR As %String(DISPLAYLIST = ",Hospital,Community,NoCPR", VALUELIST = ",H,C,N") [ SqlColumnNumber = 73, SqlFieldName = ICUA_PreDayCPR ];

Property ICUASourceHospital As %String(DISPLAYLIST = ",None,Same,Other", VALUELIST = ",N,S,O") [ SqlColumnNumber = 74, SqlFieldName = ICUA_SourceHospital ];

Property ICUASourceLocationType As %String(DISPLAYLIST = ",ICU,Emergency,Operation,PACU,Normal,ImagingDepartment,Radiology,OutPatient,Other", VALUELIST = ",I,E,O,P,N,D,R,U,T") [ SqlColumnNumber = 75, SqlFieldName = ICUA_SourceLocationType ];

Property ICUAPreHospitalAdmDate As %Date [ SqlColumnNumber = 76, SqlFieldName = ICUA_PreHospitalAdmDate ];

Property ICUAArriveAssistance As %String(DISPLAYLIST = ",Without,Minor,Major,Total", VALUELIST = ",W,M,J,T") [ SqlColumnNumber = 77, SqlFieldName = ICUA_ArriveAssistance ];

Property ICUAVasoactiveDrugHour As %Float [ SqlColumnNumber = 78, SqlFieldName = ICUA_VasoactiveDrugHour ];

Property ICUAHavePronePositionDay As %Float [ SqlColumnNumber = 79, SqlFieldName = ICUA_HavePronePositionDay ];

Property ICUAIsBrainstemDeath As %Boolean [ SqlColumnNumber = 80, SqlFieldName = ICUA_IsBrainstemDeath ];

Property ICUAIsOrganDonation As %Boolean [ SqlColumnNumber = 81, SqlFieldName = ICUA_IsOrganDonation ];

Property ICUALimitedTreatment As %String(DISPLAYLIST = ",WithHold,Withdraw,NoLimited", VALUELIST = ",W,D,N") [ SqlColumnNumber = 82, SqlFieldName = ICUA_LimitedTreatment ];

Property ICUANEHour As %Float [ SqlColumnNumber = 83, SqlFieldName = ICUA_NEHour ];

Property ICUAEpiHour As %Float [ SqlColumnNumber = 84, SqlFieldName = ICUA_EpiHour ];

Property ICUADAHour As %Float [ SqlColumnNumber = 85, SqlFieldName = ICUA_DAHour ];

Property ICUADobuHour As %Float [ SqlColumnNumber = 86, SqlFieldName = ICUA_DobuHour ];

Property ICUASourceType As %String(DISPLAYLIST = ",EmMedicineDept,EmOperation,SelectiveOperation,NonEmMedicineDept,NonEmHospital", MAXLEN = 18, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",ED,EO,SO,ND,H") [ SqlColumnNumber = 87, SqlFieldName = ICUA_SourceType ];

Property ICUAPatWardDR As %String [ SqlColumnNumber = 88, SqlFieldName = ICUA_PatWard_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUArrange(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUA_APSPoint">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ICUA_AcuteRenalFailure">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ICUA_AdmCode">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="ICUA_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="ICUA_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUA_AgePoint">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ICUA_Anaest_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUA_ApacheIIPoint">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ICUA_ArriveAssistance">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="ICUA_AttendingCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ICUA_Bed_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUA_CHPPoint">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ICUA_ChargeNurse_Dr">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="ICUA_ChronicHealthPoint">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ICUA_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUA_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ICUA_CreateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUA_CrrtHour">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="ICUA_CvpCatheterDay">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="ICUA_CvpCatheterModel">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="ICUA_CvpCount">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="ICUA_CvpDateTime">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="ICUA_DAHour">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="ICUA_DeathProbability">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ICUA_DeliveryDate">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="ICUA_DiagnosticCatCLCSO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ICUA_DobuHour">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="ICUA_EcmoHour">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ICUA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUA_EpiHour">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="ICUA_EyeOpeningCLCSO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ICUA_Fee">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ICUA_Gestation">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="ICUA_GlasgowPoint">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ICUA_HavePronePositionDay">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="ICUA_HostpitalCode">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="ICUA_ICUPM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="ICUA_IabpHour">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="ICUA_InfectedSite">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ICUA_IsBrainstemDeath">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="ICUA_IsEstimatedHeight">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="ICUA_IsEstimatedWeight">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="ICUA_IsOrganDonation">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="ICUA_IsPdt">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="ICUA_Isolated">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ICUA_LeaveCondition">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ICUA_LeaveDate">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ICUA_LeaveTime">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ICUA_Level_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ICUA_LimitedTreatment">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="ICUA_MechanVentilationHour">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ICUA_MotorResponseCLCSO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ICUA_NEHour">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="ICUA_NoninvasVentilationHour">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ICUA_NormalStartDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ICUA_NormalStartTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ICUA_Note">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ICUA_PacHour">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ICUA_PatDept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUA_PatHeight">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ICUA_PatStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUA_PatWard_DR">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="ICUA_PatWeight">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ICUA_PiccoHour">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ICUA_PreDayCPR">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="ICUA_PreHospitalAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="ICUA_Pregnant">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="ICUA_RelatedDiag_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ICUA_Residence">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="ICUA_ResidentCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ICUA_ShockType">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ICUA_SourceHospital">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="ICUA_SourceLocationType">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="ICUA_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="ICUA_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUA_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUA_Status">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ICUA_SupervisorNurse_Dr">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="ICUA_SurgeryType">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ICUA_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ICUA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ICUA_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ICUA_UrinaryCatheterDay">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="ICUA_VasoactiveDrugHour">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="ICUA_VerbalResponseCLCSO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICUA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ICUA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBedStatus">
<Global>^DHCICUArrange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICUA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BedStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUA_Bed_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUA_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLeaveDate">
<Global>^DHCICUArrange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUA_LeaveDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAAdm">
<Global>^DHCICUArrange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUA_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCICUArrange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICUA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUA_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IUCA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUArrangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
