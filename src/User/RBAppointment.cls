/// RB Appointment          (APPT,8058)
Class User.RBAppointment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_Appointment, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APPTChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildRBApptFollowOnSlots As RBApptFollowOnSlots [ Cardinality = children, Inverse = RBFOSParRef ];

Relationship ChildRBApptOutcome As RBApptOutcome [ Cardinality = children, Inverse = OUTCParRef ];

Relationship ChildRBApptLetter As RBApptLetter [ Cardinality = children, Inverse = LETParRef ];

Relationship ChildRBApptQMatic As RBApptQMatic [ Cardinality = children, Inverse = QMParRef ];

/// RBAS Par Ref
Relationship APPTASParRef As RBApptSchedule [ Cardinality = parent, Inverse = ChildRBAppointment, Required, SqlFieldName = APPT_AS_ParRef ];

/// Child Sub (New Key)
Property APPTChildSub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"APPT",0))}, Required, SqlColumnNumber = 2, SqlFieldName = APPT_ChildSub ];

/// Des Ref to RBC_ApptType
Property APPTATDR As RBCApptType [ SqlColumnNumber = 3, SqlFieldName = APPT_AT_DR ];

/// Des Ref to PAPMI
Property APPTPAPMIDR As PAPatMas [ SqlColumnNumber = 4, SqlFieldName = APPT_PAPMI_DR ];

/// Appointment Status
Property APPTStatus As %String(DISPLAYLIST = ",Inserted,Admitted,Transferred,Cancelled,Closed,Postponed,NotAttended,Hold(Postponed),Hold(Inserted),Could Not Wait,Arrived Not Seen,Departed", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,A,T,X,C,P,N,H,J,W,S,D") [ InitialExpression = "I", Required, SqlColumnNumber = 5, SqlFieldName = APPT_Status ];

/// Remarks
Property APPTRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = APPT_Remarks, SqlListType = SUBNODE ];

/// Queue Number
Property APPTQueueNo As %String(COLLATION = "AlphaUp", MAXLEN = 12, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = APPT_QueueNo ];

/// Des Ref to PAADM (only after admit RB)
Property APPTAdmDR As PAAdm [ SqlColumnNumber = 8, SqlFieldName = APPT_Adm_DR ];

/// Estimated Time of Arrival
Property APPTETA As %Time [ Required, SqlColumnNumber = 9, SqlFieldName = APPT_ETA ];

/// Des Ref to Transfer Appt
Property APPTAPPTDR As RBAppointment [ SqlColumnNumber = 10, SqlFieldName = APPT_APPT_DR ];

/// Transaction Date
Property APPTTransDate As %Date [ SqlColumnNumber = 11, SqlFieldName = APPT_TransDate ];

/// Transaction Time
Property APPTTransTime As %Time [ SqlColumnNumber = 12, SqlFieldName = APPT_TransTime ];

/// Not Used
Property APPTRBTR As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = APPT_RBTR ];

/// Transcation processed by
Property APPTTransUserDR As SSUser [ SqlColumnNumber = 14, SqlFieldName = APPT_TransUser_DR ];

/// Method Des Ref to RBCAptMeth
Property APPTMethodDR As RBCAppointMethod [ SqlColumnNumber = 15, SqlFieldName = APPT_Method_DR ];

/// Payed Flag
Property APPTPayedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = APPT_PayedFlag ];

/// Admission Type
Property APPTAdmType As %String(DISPLAYLIST = ",In Patient,Out Patient,Emergency,New Born,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,O,E,N,H") [ SqlColumnNumber = 17, SqlFieldName = APPT_AdmType ];

/// Des Ref RBC Service
Property APPTRBCServDR As RBCServices [ SqlColumnNumber = 18, SqlFieldName = APPT_RBCServ_DR ];

/// Des Ref Waiting List
Property APPTWaitListDR As PAWaitingList [ SqlColumnNumber = 19, SqlFieldName = APPT_WaitList_DR ];

/// Date Search
Property APPTDateSearch As %Date [ SqlColumnNumber = 20, SqlFieldName = APPT_DateSearch ];

/// Des Ref ReasonOverBook
Property APPTReasonOverBookDR As RBCReasonOverBook [ SqlColumnNumber = 21, SqlFieldName = APPT_ReasonOverBook_DR ];

/// Des Ref ReasonForTransfer
Property APPTReasonForTransferDR As RBCTransferApptReason [ SqlColumnNumber = 22, SqlFieldName = APPT_ReasonForTransfer_DR ];

/// Des REf ARCIM
Property APPTARCIMDR As ARCItmMast [ SqlColumnNumber = 23, SqlFieldName = APPT_ARCIM_DR ];

/// Des Ref OEORI
Property APPTOEORIDR As OEOrdItem [ SqlColumnNumber = 24, SqlFieldName = APPT_OEORI_DR ];

/// Executed Status
Property APPTExecutedStatus As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = APPT_ExecutedStatus ];

/// Service Duration
Property APPTDuration As %Float [ SqlColumnNumber = 26, SqlFieldName = APPT_Duration ];

/// Des Ref MainAppointment
Property APPTMainAppointmentDR As RBAppointment [ SqlColumnNumber = 27, SqlFieldName = APPT_MainAppointment_DR ];

/// Arrival Time
Property APPTArrivalTime As %Time [ SqlColumnNumber = 28, SqlFieldName = APPT_ArrivalTime ];

/// Seen Date
Property APPTSeenDate As %Date [ SqlColumnNumber = 29, SqlFieldName = APPT_SeenDate ];

/// Seen Time
Property APPTSeenTime As %Time [ SqlColumnNumber = 30, SqlFieldName = APPT_SeenTime ];

/// Des Ref Reason For Cancel
Property APPTReasonForCancelDR As RBCReasonForCancel [ SqlColumnNumber = 31, SqlFieldName = APPT_ReasonForCancel_DR ];

/// Des Ref Reason Not Show
Property APPTReasonNotShow As RBCReasonForNotShow [ SqlColumnNumber = 32, SqlFieldName = APPT_ReasonNotShow ];

/// Des Ref Outcome of Appointment
Property APPTOutcomeDR As RBCOutcomeOfAppoint [ SqlColumnNumber = 33, SqlFieldName = APPT_Outcome_DR ];

/// Not used field
Property APPTNotUsed As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = APPT_NotUsed ];

/// Des Ref RBOP
Property APPTRBOPDR As RBOperatingRoom [ SqlColumnNumber = 35, SqlFieldName = APPT_RBOP_DR ];

/// Appointment Letter
Property APPTAppointLetter As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = APPT_AppointLetter ];

/// Interpreter Required
Property APPTInterpreterRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = APPT_InterpreterRequired ];

/// Des Ref ReviewPeriod
Property APPTReviewPeriodDR As PACReferralPeriod [ SqlColumnNumber = 38, SqlFieldName = APPT_ReviewPeriod_DR ];

/// Des Ref Transport
Property APPTTransportDR As RBCAppointTransport [ SqlColumnNumber = 39, SqlFieldName = APPT_Transport_DR ];

/// Confirmation
Property APPTConfirmation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = APPT_Confirmation ];

/// Des Ref SourceOfAttend
Property APPTSourceOfAttendDR As PACSourceOfAttendance [ SqlColumnNumber = 41, SqlFieldName = APPT_SourceOfAttend_DR ];

/// Des Ref HRG
Property APPTHRGDR As PACHRGCodes [ SqlColumnNumber = 42, SqlFieldName = APPT_HRG_DR ];

/// Des Ref BookingSystem
Property APPTBookingSystemDR As PACApptBookingSystem [ SqlColumnNumber = 43, SqlFieldName = APPT_BookingSystem_DR ];

/// Verified
Property APPTVerified As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = APPT_Verified ];

/// Last Update Date
Property APPTLastUpdateDate As %Date [ SqlColumnNumber = 45, SqlFieldName = APPT_LastUpdateDate ];

/// Nursing Notes Flag
Property APPTNursingNotesFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = APPT_NursingNotesFlag ];

/// Urgent
Property APPTUrgent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = APPT_Urgent ];

/// First Appoint Flag
Property APPTFirstAppointFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = APPT_FirstAppointFlag ];

/// EndDate
Property APPTEndDate As %Date [ SqlColumnNumber = 49, SqlFieldName = APPT_EndDate ];

/// EndTime
Property APPTEndTime As %Time [ SqlColumnNumber = 50, SqlFieldName = APPT_EndTime ];

/// CareProvider
Property APPTCareProvider As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = APPT_CareProvider ];

/// Date Computed
Property APPTDateComp As %Date [ SqlColumnNumber = 52, SqlComputeCode = { s {APPT_DateComp}=$p($g(^RBAS(+{APPT_AS_ParRef},+$p({APPT_AS_ParRef},"||",2))),"^")
}, SqlComputed, SqlFieldName = APPT_DateComp, Transient ];

/// Time Computed
Property APPTTimeComp As %Time [ SqlColumnNumber = 53, SqlComputeCode = { s {APPT_TimeComp}=$p($g(^RBAS(+{APPT_AS_ParRef},+$p({APPT_AS_ParRef},"||",2))),"^",4)
}, SqlComputed, SqlFieldName = APPT_TimeComp, Transient ];

/// Des Ref CareProvType
Property APPTCareProvTypeDR As CTCarPrvTp [ SqlColumnNumber = 54, SqlFieldName = APPT_CareProvType_DR ];

/// RSVP
Property APPTRSVP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = APPT_RSVP ];

/// PatientNotAttending
Property APPTPatientNotAttending As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = APPT_PatientNotAttending ];

/// ViewableByEpCareProv
Property APPTViewableByEpCareProv As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = APPT_ViewableByEpCareProv ];

/// Des Ref RBEvent
Property APPTRBEventDR As RBEvent [ SqlColumnNumber = 58, SqlFieldName = APPT_RBEvent_DR ];

/// Interpreter Confirmed
Property APPTInterpreterConfirmed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 59, SqlFieldName = APPT_InterpreterConfirmed ];

/// Reason For Cancellation
Property APPTReasonForCancellation As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 60, SqlFieldName = APPT_ReasonForCancellation ];

/// Des Ref CTPCP
Property APPTSeenDoctorDR As CTCareProv [ SqlColumnNumber = 61, SqlFieldName = APPT_SeenDoctor_DR ];

/// Doctor Letter Notes
Property APPTDoctorLetterNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 62, SqlFieldName = APPT_DoctorLetterNotes, SqlListType = SUBNODE ];

/// Patient Letter Notes
Property APPTPatientLetterNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 63, SqlFieldName = APPT_PatientLetterNotes, SqlListType = SUBNODE ];

/// Des Ref Interpreter
Property APPTInterpreterDR As PACInterpreter [ SqlColumnNumber = 64, SqlFieldName = APPT_Interpreter_DR ];

/// Departure Time
Property APPTDepartureTime As %Time [ SqlColumnNumber = 65, SqlFieldName = APPT_DepartureTime ];

/// Transport Required
Property APPTTransportRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 66, SqlFieldName = APPT_TransportRequired ];

/// Des Ref ServiceSet
Property APPTServiceSetDR As RBCServiceSet [ SqlColumnNumber = 67, SqlFieldName = APPT_ServiceSet_DR ];

/// Des Ref LastUpdateHospital
Property APPTLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 68, SqlFieldName = APPT_LastUpdateHospital_DR ];

/// Confirmed Date
Property APPTConfirmedDate As %Date [ SqlColumnNumber = 69, SqlFieldName = APPT_ConfirmedDate ];

/// Des Ref LastStatusChangeUser
Property APPTLastStatusChangeUserDR As SSUser [ SqlColumnNumber = 70, SqlFieldName = APPT_LastStatusChangeUser_DR ];

/// Des Ref LastStatusChangeHospital
Property APPTLastStatusChangeHospitalDR As CTHospital [ SqlColumnNumber = 71, SqlFieldName = APPT_LastStatusChangeHospital_DR ];

/// LastStatusChangeDate
Property APPTLastStatusChangeDate As %Date [ SqlColumnNumber = 72, SqlFieldName = APPT_LastStatusChangeDate ];

/// LastStatusChangeTime
Property APPTLastStatusChangeTime As %Time [ SqlColumnNumber = 73, SqlFieldName = APPT_LastStatusChangeTime ];

/// CancelledOnDischarge
Property APPTCancelledOnDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 74, SqlFieldName = APPT_CancelledOnDischarge ];

/// Des Ref Language
Property APPTLanguageDR As PACPreferredLanguage [ SqlColumnNumber = 75, SqlFieldName = APPT_Language_DR ];

/// SystemSession
Property APPTSystemSession As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 76, SqlFieldName = APPT_SystemSession ];

/// Activity
Property APPTActivity As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = APPT_Activity ];

/// View
Property APPTView As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 78, SqlFieldName = APPT_View ];

/// Des Ref MainGroupAppt
Property APPTMainGroupApptDR As RBAppointment [ SqlColumnNumber = 79, SqlFieldName = APPT_MainGroupAppt_DR ];

/// MoveMedRec
Property APPTMoveMedRec As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 80, SqlFieldName = APPT_MoveMedRec ];

/// Des Ref ConsultCateg
Property APPTConsultCategDR As OECConsultCateg [ SqlColumnNumber = 81, SqlFieldName = APPT_ConsultCateg_DR ];

/// USRN number
Property APPTUSRN As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 82, SqlFieldName = APPT_USRN ];

/// UBRN number
Property APPTUBRN As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 83, SqlFieldName = APPT_UBRN ];

/// Des Ref ASSI
Property APPTASSIDR As PACAusSouthSeaIslander [ SqlColumnNumber = 84, SqlFieldName = APPT_ASSI_DR ];

/// ArrivalTimeCP1
Property APPTArrivalTimeCP1 As %Time [ SqlColumnNumber = 85, SqlFieldName = APPT_ArrivalTimeCP1 ];

/// ArrivalTimeCP2
Property APPTArrivalTimeCP2 As %Time [ SqlColumnNumber = 86, SqlFieldName = APPT_ArrivalTimeCP2 ];

/// DepartureTimeCP1
Property APPTDepartureTimeCP1 As %Time [ SqlColumnNumber = 87, SqlFieldName = APPT_DepartureTimeCP1 ];

/// DepartureTimeCP2
Property APPTDepartureTimeCP2 As %Time [ SqlColumnNumber = 88, SqlFieldName = APPT_DepartureTimeCP2 ];

/// Des Ref RequestedCP
Property APPTRequestedCPDR As CTCareProv [ SqlColumnNumber = 89, SqlFieldName = APPT_RequestedCP_DR ];

/// PatientStatus
Property APPTPatientStatus As %String(DISPLAYLIST = ",Next,With Care Provider,Departed Care Provider", MAXLEN = 22, TRUNCATE = 1, VALUELIST = ",N,WCP,DCP") [ SqlColumnNumber = 90, SqlFieldName = APPT_PatientStatus ];

/// Des Ref OPDRoom
Property APPTOPDRoomDR As PACOPDRooms [ SqlColumnNumber = 91, SqlFieldName = APPT_OPDRoom_DR ];

/// Des Ref CareProvider2
Property APPTCareProvider2DR As CTCareProv [ SqlColumnNumber = 92, SqlFieldName = APPT_CareProvider2_DR ];

/// Des Ref RequestCareProvider2
Property APPTRequestCareProvider2DR As CTCareProv [ SqlColumnNumber = 93, SqlFieldName = APPT_RequestCareProvider2_DR ];

/// Des Ref User
Property APPTBookedByDR As SSUser [ SqlColumnNumber = 94, SqlFieldName = APPT_BookedBy_DR ];

/// BookedDate
Property APPTBookedDate As %Date [ SqlColumnNumber = 95, SqlFieldName = APPT_BookedDate ];

/// BookedTime
Property APPTBookedTime As %Time [ SqlColumnNumber = 96, SqlFieldName = APPT_BookedTime ];

/// Des Ref PersonScheduleItem
Property APPTPersonScheduleItemDR As PAPersonScheduleItem [ SqlColumnNumber = 97, SqlFieldName = APPT_PersonScheduleItem_DR ];

/// Des Ref RBAttendance
Property APPTRBAttendanceDR As RBAttendance [ SqlColumnNumber = 98, SqlFieldName = APPT_RBAttendance_DR ];

/// Des Ref AuthoriseUser
Property APPTAuthoriseUserDR As SSUser [ SqlColumnNumber = 99, SqlFieldName = APPT_AuthoriseUser_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBAppointment).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAppointment","OnAfterInsert")
 d Table^HL7Outbound("RBAppointment",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBAppointment).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAppointment","OnAfterUpdate")
 d Table^HL7Outbound("RBAppointment",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBAppointment).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAppointment","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBAppointment).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAppointment","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAppointment","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBAppointment).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAppointment","OnAfterDelete")
 d Table^HL7Outbound("RBAppointment",%old(1),"Delete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMasterAPPT">
<Data name="APPT_APPT_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APPT_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="APPT_ASSI_DR">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="APPT_AT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APPT_Activity">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="APPT_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="APPT_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APPT_AppointLetter">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="APPT_ArrivalTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="APPT_ArrivalTimeCP1">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="APPT_ArrivalTimeCP2">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="APPT_AuthoriseUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="APPT_BookedBy_DR">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="APPT_BookedDate">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="APPT_BookedTime">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="APPT_BookingSystem_DR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="APPT_CancelledOnDischarge">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="APPT_CareProvType_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="APPT_CareProvider">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="APPT_CareProvider2_DR">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="APPT_Confirmation">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="APPT_ConfirmedDate">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="APPT_ConsultCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="APPT_DateSearch">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="APPT_DepartureTime">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="APPT_DepartureTimeCP1">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="APPT_DepartureTimeCP2">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="APPT_DoctorLetterNotes">
<Node>"DL"</Node>
</Data>
<Data name="APPT_Duration">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="APPT_ETA">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APPT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="APPT_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="APPT_ExecutedStatus">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="APPT_FirstAppointFlag">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="APPT_HRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="APPT_InterpreterConfirmed">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="APPT_InterpreterRequired">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="APPT_Interpreter_DR">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="APPT_Language_DR">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="APPT_LastStatusChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="APPT_LastStatusChangeHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="APPT_LastStatusChangeTime">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="APPT_LastStatusChangeUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="APPT_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="APPT_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="APPT_MainAppointment_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="APPT_MainGroupAppt_DR">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="APPT_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="APPT_MoveMedRec">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="APPT_NotUsed">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="APPT_NursingNotesFlag">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="APPT_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="APPT_OPDRoom_DR">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="APPT_Outcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="APPT_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APPT_PatientLetterNotes">
<Node>"PL"</Node>
</Data>
<Data name="APPT_PatientNotAttending">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="APPT_PatientStatus">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="APPT_PayedFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="APPT_PersonScheduleItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="APPT_QueueNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APPT_RBAttendance_DR">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="APPT_RBCServ_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="APPT_RBEvent_DR">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="APPT_RBOP_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="APPT_RBTR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APPT_RSVP">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="APPT_ReasonForCancel_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="APPT_ReasonForCancellation">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="APPT_ReasonForTransfer_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="APPT_ReasonNotShow">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="APPT_ReasonOverBook_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="APPT_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="APPT_RequestCareProvider2_DR">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="APPT_RequestedCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="APPT_ReviewPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="APPT_SeenDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="APPT_SeenDoctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="APPT_SeenTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="APPT_ServiceSet_DR">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="APPT_SourceOfAttend_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="APPT_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APPT_SystemSession">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="APPT_TransDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APPT_TransTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APPT_TransUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APPT_TransportRequired">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="APPT_Transport_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="APPT_UBRN">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="APPT_USRN">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="APPT_Urgent">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="APPT_Verified">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="APPT_View">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="APPT_ViewableByEpCareProv">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="APPT_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{APPT_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_Adm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"APPT_Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_DateComp}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_TimeComp}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLastStatusChange">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusChangeDateT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_LastStatusChangeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_LastStatusChangeTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMainApptDR">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MainAppt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_MainAppointment_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMainGroupAppt">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MainGroupAppt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_MainGroupAppt_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotVerified">
<Condition>{APPT_Verified}'["Y"</Condition>
<ConditionFields>APPT_Verified</ConditionFields>
<Global>^RBAS</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NVerif"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_DateComp}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_TimeComp}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNursingNotes">
<Condition>{APPT_NursingNotesFlag}'["Y"</Condition>
<ConditionFields>APPT_NursingNotesFlag</ConditionFields>
<Global>^RBAS</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NNotes"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADMDR">
<Condition>" P A "[(" "_$p({APPT_Status},$c(1))_" ")</Condition>
<ConditionalWithHostVars>1</ConditionalWithHostVars>
<Global>^RBAS</Global>
<PopulationPct>90</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAADM_DR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{APPT_Adm_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPERDR">
<Global>^PAPERDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{APPT_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RB_Appt"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{APPT_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPersonSched">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PersonSched"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_PersonScheduleItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRBEvent">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RBEvent"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_RBEvent_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRBOP">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RBOP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_RBOP_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Condition>{APPT_Status}'["A"</Condition>
<Global>^RBAS</Global>
<PopulationPct>5</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"APPT_Status"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{APPT_Status}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSystemSess">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SystemSess"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_SystemSession}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransDate">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TransDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_TransDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APPT_TransTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransUserDateComp">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TransUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_TransUser_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APPT_DateComp}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UpdDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_LastUpdateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWaitingList">
<Global>^RBAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WaitList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APPT_WaitList_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexqueueNumber">
<Condition>1</Condition>
<Global>^RBAS</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>APPT_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"QN"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APPT_QueueNo}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{APPT_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APPT_RowId</SqlRowIdName>
<StreamLocation>^User.RBAppointmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
