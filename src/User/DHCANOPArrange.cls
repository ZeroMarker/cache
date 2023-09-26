/// DHC_AN_OPArrange
Class User.DHCANOPArrange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPA_RowId, SqlTableName = DHC_AN_OPArrange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 80000;

Relationship ChildDHCANAnaestItem As User.DHCANAnaestItem [ Cardinality = children, Inverse = ANIParref ];

Relationship ChildDHCANAnalgesia As User.DHCANAnalgesia [ Cardinality = children, Inverse = PAAParref ];

Relationship ChildDHCANPostAnaVisit As User.DHCANPostAnaVisit [ Cardinality = children, Inverse = PAVParref ];

Relationship ChildDHCANOPCount As User.DHCANOPCount [ Cardinality = children, Inverse = ANOPCParref ];

Relationship ChildDHCANShift As User.DHCANShift [ Cardinality = children, Inverse = ANSParref ];

/// OPA_Adm_Dr
Property OPAAdmDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OPA_Adm_Dr ];

/// OPA_PatDept_Dr
Property OPAPatDeptDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OPA_PatDept_Dr ];

/// OPA_Anaest_Dr
Property OPAAnaestDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OPA_Anaest_Dr ];

/// OPA_OpRoom_Dr
Property OPAOpRoomDr As User.DHCANCOperRoom [ SqlColumnNumber = 5, SqlFieldName = OPA_OpRoom_Dr ];

/// OPA_Seq
Property OPASeq As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = OPA_Seq ];

/// OPA_StartDate
Property OPAStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = OPA_StartDate ];

/// OPA_EndDate
Property OPAEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = OPA_EndDate ];

/// OPA_StartTime
Property OPAStartTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = OPA_StartTime ];

/// OPA_EndTime
Property OPAEndTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = OPA_EndTime ];

/// OPA_PatStatus
Property OPAPatStatus As %Library.String(DISPLAYLIST = ",AnaLoc,InPatLoc,OperLoc", MAXLEN = 8, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",A,I,O") [ SqlColumnNumber = 11, SqlFieldName = OPA_PatStatus ];

/// OPA_AppCtcp_Dr
Property OPAAppCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = OPA_AppCtcp_Dr ];

/// OPA_AppDate
Property OPAAppDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = OPA_AppDate ];

/// OPA_AppTime
Property OPAAppTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = OPA_AppTime ];

/// OPA_AuditStatus
Property OPAAuditStatus As %Library.String(DISPLAYLIST = ",Apply,Receive", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",A,R") [ SqlColumnNumber = 15, SqlFieldName = OPA_AuditStatus ];

/// OPA_ArrangeUser_Dr
Property OPAArrangeUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OPA_ArrangeUser_Dr ];

/// OPA_ArrangeDate
Property OPAArrangeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = OPA_ArrangeDate ];

/// OPA_ArrangeTime
Property OPAArrangeTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = OPA_ArrangeTime ];

/// OPA_Memo
Property OPAMemo As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = OPA_Memo ];

/// OPA_Status
Property OPAStatus As %Library.String(DISPLAYLIST = ",Apply,Cancel,Decline,Receive,InRoom,Operate,LeaveRoom,Finish,NotApp,PACU,Surgery,Verify", MAXLEN = 9, SELECTIVITY = "10.0000%", TRUNCATE = 1, VALUELIST = ",A,C,D,R,I,O,L,F,N,P,S,V") [ SqlColumnNumber = 20, SqlFieldName = OPA_Status ];

/// OPA_OpLevel_Dr
Property OPAOpLevelDr As User.DHCANCOPLevel [ SqlColumnNumber = 21, SqlFieldName = OPA_OpLevel_Dr ];

/// OPA_CollectedStatus
Property OPACollectedStatus As %Library.String(DISPLAYLIST = ",New,Get,Modified,Cancel,Finish", MAXLEN = 8, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",N,G,M,C,F") [ SqlColumnNumber = 22, SqlFieldName = OPA_CollectedStatus ];

/// OPA_AnaEffect
Property OPAAnaEffect As %Library.String [ SqlColumnNumber = 23, SqlFieldName = OPA_AnaEffect ];

/// OPA_MiniInvasive
Property OPAMiniInvasive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = OPA_MiniInvasive ];

/// OPA_PatHeight
Property OPAPatHeight As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = OPA_PatHeight ];

/// OPA_PatWeight
Property OPAPatWeight As %Library.String [ SqlColumnNumber = 26, SqlFieldName = OPA_PatWeight ];

/// OPA_BloodType_Dr
Property OPABloodTypeDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = OPA_BloodType_Dr ];

/// OPA_RHBloodType
Property OPARHBloodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = OPA_RHBloodType ];

/// OPA_Isolated
Property OPAIsolated As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = OPA_Isolated ];

/// OPA_PreAnDrug
Property OPAPreAnDrug As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = OPA_PreAnDrug ];

/// OPA_Instrument_Dr
Property OPAInstrumentDr As User.DHCANCInstrument [ SqlColumnNumber = 31, SqlFieldName = OPA_Instrument_Dr ];

/// OPA_AddInstrument
Property OPAAddInstrument As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = OPA_AddInstrument ];

/// OPA_Ward_Dr
Property OPAWardDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = OPA_Ward_Dr ];

/// OPA_PrepareBlood
Property OPAPrepareBlood As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = OPA_PrepareBlood ];

/// OPA_UseSelfBlood
Property OPAUseSelfBlood As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = OPA_UseSelfBlood ];

/// OPA_ReturnReason_Dr
Property OPAReturnReasonDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = OPA_ReturnReason_Dr ];

/// OPA_ExCirculation
Property OPAExCirculation As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = OPA_ExCirculation ];

/// OPA_EstiOperDuration
Property OPAEstiOperDuration As %Library.String [ SqlColumnNumber = 38, SqlFieldName = OPA_EstiOperDuration ];

/// OPA_PreDiscussDate
Property OPAPreDiscussDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 39, SqlFieldName = OPA_PreDiscussDate ];

/// OPA_TransferMeans
Property OPATransferMeans As %Library.String(DISPLAYLIST = ",Walk,WheelChair,WheelStretcher", MAXLEN = 14, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",W,C,S") [ SqlColumnNumber = 40, SqlFieldName = OPA_TransferMeans ];

/// OPA_NeedScrubNurse
Property OPANeedScrubNurse As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = OPA_NeedScrubNurse ];

/// OPA_SeqNote
Property OPASeqNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = OPA_SeqNote ];

/// OPA_OpDocNote
Property OPAOpDocNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = OPA_OpDocNote ];

/// OPA_AnDocNote
Property OPAAnDocNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = OPA_AnDocNote ];

/// OPA_NeedAnaesthetist
Property OPANeedAnaesthetist As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = OPA_NeedAnaesthetist ];

/// OPA_Psychosis
Property OPAPsychosis As %Library.String(DISPLAYLIST = ",Sedation,Common,Nervous", MAXLEN = 8, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,C,N") [ SqlColumnNumber = 46, SqlFieldName = OPA_Psychosis ];

/// OPA_UnPlanedOperation
Property OPAUnPlanedOperation As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 47, SqlFieldName = OPA_UnPlanedOperation ];

/// OPA_PacuBed_Dr
Property OPAPacuBedDr As User.DHCANCOperRoom [ SqlColumnNumber = 48, SqlFieldName = OPA_PacuBed_Dr ];

/// OPA_AnaDoctorOrdered
Property OPAAnaDoctorOrdered As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = OPA_AnaDoctorOrdered ];

/// OPA_AnaNurseOrdered
Property OPAAnaNurseOrdered As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = OPA_AnaNurseOrdered ];

/// OPA_OpNurseOrdered
Property OPAOpNurseOrdered As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = OPA_OpNurseOrdered ];

/// OPA_ScrubNurseNote
Property OPAScrubNurseNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = OPA_ScrubNurseNote ];

/// OPA_CirculNurseNote
Property OPACirculNurseNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = OPA_CirculNurseNote ];

/// OPA_MedInfect
Property OPAMedInfect As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = OPA_MedInfect ];

/// OPA_AppLoc_Dr
Property OPAAppLocDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = OPA_AppLoc_Dr ];

/// OPA_Navigation
Property OPANavigation As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = OPA_Navigation ];

/// OPA_FreezingSlice
Property OPAFreezingSlice As %Library.String [ SqlColumnNumber = 57, SqlFieldName = OPA_FreezingSlice ];

/// OPA_PathologSection
Property OPAPathologSection As %Library.String [ SqlColumnNumber = 58, SqlFieldName = OPA_PathologSection ];

/// OPA_DocArriveTime
Property OPADocArriveTime As %Library.Time [ SqlColumnNumber = 59, SqlFieldName = OPA_DocArriveTime ];

/// OPA_OperDelayNote
Property OPAOperDelayNote As %Library.String [ SqlColumnNumber = 60, SqlFieldName = OPA_OperDelayNote ];

/// OPA_PAIllness
Property OPAPAIllness As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = OPA_PAIllness ];

/// OPA_PANervousSystem
Property OPAPANervousSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = OPA_PANervousSystem ];

/// OPA_PANervSystemOther
Property OPAPANervSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = OPA_PANervSystemOther ];

/// OPA_PARespSystem
Property OPAPARespSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = OPA_PARespSystem ];

/// OPA_PASmokeFreq
Property OPAPASmokeFreq As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = OPA_PASmokeFreq ];

/// OPA_PASmokeDuration
Property OPAPASmokeDuration As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = OPA_PASmokeDuration ];

/// OPA_PARespSystemOther
Property OPAPARespSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = OPA_PARespSystemOther ];

/// OPA_PACirculatorySystem
Property OPAPACirculatorySystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = OPA_PACirculatorySystem ];

/// OPA_PACardiacRhythm
Property OPAPACardiacRhythm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = OPA_PACardiacRhythm ];

/// OPA_PAHypertension
Property OPAPAHypertension As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = OPA_PAHypertension ];

/// OPA_PACirculSystemOther
Property OPAPACirculSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = OPA_PACirculSystemOther ];

/// OPA_PAEndocrineSystem
Property OPAPAEndocrineSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = OPA_PAEndocrineSystem ];

/// OPA_PAInsulin
Property OPAPAInsulin As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = OPA_PAInsulin ];

/// OPA_PAAldosterone
Property OPAPAAldosterone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = OPA_PAAldosterone ];

/// OPA_PAHypothyroid
Property OPAPAHypothyroid As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 75, SqlFieldName = OPA_PAHypothyroid ];

/// OPA_PAEndoSystemOther
Property OPAPAEndoSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = OPA_PAEndoSystemOther ];

/// OPA_PAMouth
Property OPAPAMouth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = OPA_PAMouth ];

/// OPA_PATongue
Property OPAPATongue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 78, SqlFieldName = OPA_PATongue ];

/// OPA_PAJaw
Property OPAPAJaw As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 79, SqlFieldName = OPA_PAJaw ];

/// OPA_PAMouthOther
Property OPAPAMouthOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 80, SqlFieldName = OPA_PAMouthOther ];

/// OPA_PAPharynx
Property OPAPAPharynx As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = OPA_PAPharynx ];

/// OPA_PATonsilHyper
Property OPAPATonsilHyper As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 82, SqlFieldName = OPA_PATonsilHyper ];

/// OPA_PAPharynxOther
Property OPAPAPharynxOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 83, SqlFieldName = OPA_PAPharynxOther ];

/// OPA_PANeck
Property OPAPANeck As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 84, SqlFieldName = OPA_PANeck ];

/// OPA_PANeckOther
Property OPAPANeckOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 85, SqlFieldName = OPA_PANeckOther ];

/// OPA_PASkin
Property OPAPASkin As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 86, SqlFieldName = OPA_PASkin ];

/// OPA_PASkinOther
Property OPAPASkinOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 87, SqlFieldName = OPA_PASkinOther ];

/// OPA_PANose
Property OPAPANose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 88, SqlFieldName = OPA_PANose ];

/// OPA_PANoseOther
Property OPAPANoseOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 89, SqlFieldName = OPA_PANoseOther ];

/// OPA_PAMuscularSystem
Property OPAPAMuscularSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 90, SqlFieldName = OPA_PAMuscularSystem ];

/// OPA_PAMuscularSystemOther
Property OPAPAMuscularSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = OPA_PAMuscularSystemOther ];

/// OPA_PADigestiveSystem
Property OPAPADigestiveSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 92, SqlFieldName = OPA_PADigestiveSystem ];

/// OPA_PALiver
Property OPAPALiver As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 93, SqlFieldName = OPA_PALiver ];

/// OPA_PASpleen
Property OPAPASpleen As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = OPA_PASpleen ];

/// OPA_PADigestSystemOther
Property OPAPADigestSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 95, SqlFieldName = OPA_PADigestSystemOther ];

/// OPA_PABoneSystem
Property OPAPABoneSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 96, SqlFieldName = OPA_PABoneSystem ];

/// OPA_PABoneSystemOther
Property OPAPABoneSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 97, SqlFieldName = OPA_PABoneSystemOther ];

/// OPA_PABloodSystem
Property OPAPABloodSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 98, SqlFieldName = OPA_PABloodSystem ];

/// OPA_PABloodSystemOther
Property OPAPABloodSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 99, SqlFieldName = OPA_PABloodSystemOther ];

/// OPA_PAGenitalSystem
Property OPAPAGenitalSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 100, SqlFieldName = OPA_PAGenitalSystem ];

/// OPA_PAGenitalSystemOther
Property OPAPAGenitalSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 101, SqlFieldName = OPA_PAGenitalSystemOther ];

/// OPA_PAUrinarySystem
Property OPAPAUrinarySystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 102, SqlFieldName = OPA_PAUrinarySystem ];

/// OPA_PAUrinarySystemOther
Property OPAPAUrinarySystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 103, SqlFieldName = OPA_PAUrinarySystemOther ];

/// OPA_PAOtherSystem
Property OPAPAOtherSystem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 104, SqlFieldName = OPA_PAOtherSystem ];

/// OPA_PAOtherSystemOther
Property OPAPAOtherSystemOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 105, SqlFieldName = OPA_PAOtherSystemOther ];

/// OPA_PAPreAnop
Property OPAPAPreAnop As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 106, SqlFieldName = OPA_PAPreAnop ];

/// OPA_PAPreAnopOther
Property OPAPAPreAnopOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 107, SqlFieldName = OPA_PAPreAnopOther ];

/// OPA_PAPreAllergy
Property OPAPAPreAllergy As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 108, SqlFieldName = OPA_PAPreAllergy ];

/// OPA_PAPreAllergyOther
Property OPAPAPreAllergyOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 109, SqlFieldName = OPA_PAPreAllergyOther ];

/// OPA_PACurDrug
Property OPAPACurDrug As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 110, SqlFieldName = OPA_PACurDrug ];

/// OPA_PACurDrugOther
Property OPAPACurDrugOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 111, SqlFieldName = OPA_PACurDrugOther ];

/// OPA_PAFamily
Property OPAPAFamily As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 112, SqlFieldName = OPA_PAFamily ];

/// OPA_PAFamilyOther
Property OPAPAFamilyOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 113, SqlFieldName = OPA_PAFamilyOther ];

/// OPA_PASocial
Property OPAPASocial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 114, SqlFieldName = OPA_PASocial ];

/// OPA_PASocialOther
Property OPAPASocialOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 115, SqlFieldName = OPA_PASocialOther ];

/// OPA_PACurCondition
Property OPAPACurCondition As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 116, SqlFieldName = OPA_PACurCondition ];

/// OPA_PACurConditionOther
Property OPAPACurConditionOther As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 117, SqlFieldName = OPA_PACurConditionOther ];

/// OPA_PAPhyExam
Property OPAPAPhyExam As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 118, SqlFieldName = OPA_PAPhyExam ];

/// OPA_PAHeartRate
Property OPAPAHeartRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 119, SqlFieldName = OPA_PAHeartRate ];

/// OPA_PATemp
Property OPAPATemp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 120, SqlFieldName = OPA_PATemp ];

/// OPA_PABPSystolic
Property OPAPABPSystolic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 121, SqlFieldName = OPA_PABPSystolic ];

/// OPA_PABPDiastolic
Property OPAPABPDiastolic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 122, SqlFieldName = OPA_PABPDiastolic ];

/// OPA_PARespRate
Property OPAPARespRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 123, SqlFieldName = OPA_PARespRate ];

/// OPA_PAConsciousness
Property OPAPAConsciousness As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 124, SqlFieldName = OPA_PAConsciousness ];

/// OPA_PAMouthOpen
Property OPAPAMouthOpen As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 125, SqlFieldName = OPA_PAMouthOpen ];

/// OPA_PAMallampatiClass
Property OPAPAMallampatiClass As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 126, SqlFieldName = OPA_PAMallampatiClass ];

/// OPA_PAThyromentalDistance
Property OPAPAThyromentalDistance As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 127, SqlFieldName = OPA_PAThyromentalDistance ];

/// OPA_PATeeth
Property OPAPATeeth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 128, SqlFieldName = OPA_PATeeth ];

/// OPA_PATeethDetail
Property OPAPATeethDetail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 129, SqlFieldName = OPA_PATeethDetail ];

/// OPA_PAHeadNeck
Property OPAPAHeadNeck As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 130, SqlFieldName = OPA_PAHeadNeck ];

/// OPA_PANeckForwardFlexAngle
Property OPAPANeckForwardFlexAngle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 131, SqlFieldName = OPA_PANeckForwardFlexAngle ];

/// OPA_PANeckBackFlexAngle
Property OPAPANeckBackFlexAngle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 132, SqlFieldName = OPA_PANeckBackFlexAngle ];

/// OPA_PARespiration
Property OPAPARespiration As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 133, SqlFieldName = OPA_PARespiration ];

/// OPA_PACardiovascular
Property OPAPACardiovascular As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 134, SqlFieldName = OPA_PACardiovascular ];

/// OPA_PALung
Property OPAPALung As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 135, SqlFieldName = OPA_PALung ];

/// OPA_PANerve
Property OPAPANerve As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 136, SqlFieldName = OPA_PANerve ];

/// OPA_PAUpperLimb
Property OPAPAUpperLimb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 137, SqlFieldName = OPA_PAUpperLimb ];

/// OPA_PALowerLimb
Property OPAPALowerLimb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 138, SqlFieldName = OPA_PALowerLimb ];

/// OPA_PAAllen
Property OPAPAAllen As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 139, SqlFieldName = OPA_PAAllen ];

/// OPA_PAPeripheralVein
Property OPAPAPeripheralVein As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 140, SqlFieldName = OPA_PAPeripheralVein ];

/// OPA_PASpine
Property OPAPASpine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 141, SqlFieldName = OPA_PASpine ];

/// OPA_PAOrganOther
Property OPAPAOrganOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 142, SqlFieldName = OPA_PAOrganOther ];

/// OPA_PAPhyExamOther
Property OPAPAPhyExamOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 143, SqlFieldName = OPA_PAPhyExamOther ];

/// OPA_PARespTractClass
Property OPAPARespTractClass As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 144, SqlFieldName = OPA_PARespTractClass ];

/// OPA_PADyspneaClass
Property OPAPADyspneaClass As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 145, SqlFieldName = OPA_PADyspneaClass ];

/// OPA_PAIntubatDiffcult
Property OPAPAIntubatDiffcult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 146, SqlFieldName = OPA_PAIntubatDiffcult ];

/// OPA_PANYHA
Property OPAPANYHA As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 147, SqlFieldName = OPA_PANYHA ];

/// OPA_PAAnaClass
Property OPAPAAnaClass As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 148, SqlFieldName = OPA_PAAnaClass ];

/// OPA_PAAnaestType
Property OPAPAAnaestType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 149, SqlFieldName = OPA_PAAnaestType ];

/// OPA_PAMonitorItem
Property OPAPAMonitorItem As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 150, SqlFieldName = OPA_PAMonitorItem ];

/// OPA_PAAnaSpecificApply
Property OPAPAAnaSpecificApply As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 151, SqlFieldName = OPA_PAAnaSpecificApply ];

/// OPA_PAPlan
Property OPAPAPlan As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 152, SqlFieldName = OPA_PAPlan ];

/// OPA_PADiffcultPrevent
Property OPAPADiffcultPrevent As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 153, SqlFieldName = OPA_PADiffcultPrevent ];

/// OPA_PAExam
Property OPAPAExam As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 154, SqlFieldName = OPA_PAExam ];

/// OPA_PAEKG
Property OPAPAEKG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 155, SqlFieldName = OPA_PAEKG ];

/// OPA_PACardiacCatheter
Property OPAPACardiacCatheter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 156, SqlFieldName = OPA_PACardiacCatheter ];

/// OPA_PAEchocardiogram
Property OPAPAEchocardiogram As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 157, SqlFieldName = OPA_PAEchocardiogram ];

/// OPA_PAXRay
Property OPAPAXRay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 158, SqlFieldName = OPA_PAXRay ];

/// OPA_PACT
Property OPAPACT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 159, SqlFieldName = OPA_PACT ];

/// OPA_PAUltrsonic
Property OPAPAUltrsonic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 160, SqlFieldName = OPA_PAUltrsonic ];

/// OPA_PAVascularUltrasonic
Property OPAPAVascularUltrasonic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 161, SqlFieldName = OPA_PAVascularUltrasonic ];

/// OPA_PAAngiography
Property OPAPAAngiography As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 162, SqlFieldName = OPA_PAAngiography ];

/// OPA_PAPulmonaryFuncTest
Property OPAPAPulmonaryFuncTest As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 163, SqlFieldName = OPA_PAPulmonaryFuncTest ];

/// OPA_PAExamOther
Property OPAPAExamOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 164, SqlFieldName = OPA_PAExamOther ];

/// OPA_PATest
Property OPAPATest As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 165, SqlFieldName = OPA_PATest ];

/// OPA_PATestOther
Property OPAPATestOther As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 166, SqlFieldName = OPA_PATestOther ];

/// OPA_PATestWBC
Property OPAPATestWBC As %Library.Float [ SqlColumnNumber = 167, SqlFieldName = OPA_PATestWBC ];

/// OPA_PATestRBC
Property OPAPATestRBC As %Library.Float [ SqlColumnNumber = 168, SqlFieldName = OPA_PATestRBC ];

/// OPA_PATestHB
Property OPAPATestHB As %Library.Float [ SqlColumnNumber = 169, SqlFieldName = OPA_PATestHB ];

/// OPA_PATestHCT
Property OPAPATestHCT As %Library.Float [ SqlColumnNumber = 170, SqlFieldName = OPA_PATestHCT ];

/// OPA_PATestPLT
Property OPAPATestPLT As %Library.Float [ SqlColumnNumber = 171, SqlFieldName = OPA_PATestPLT ];

/// OPA_PATestALT
Property OPAPATestALT As %Library.Float [ SqlColumnNumber = 172, SqlFieldName = OPA_PATestALT ];

/// OPA_PATestAST
Property OPAPATestAST As %Library.Float [ SqlColumnNumber = 173, SqlFieldName = OPA_PATestAST ];

/// OPA_PATestTP
Property OPAPATestTP As %Library.Float [ SqlColumnNumber = 174, SqlFieldName = OPA_PATestTP ];

/// OPA_PATestALB
Property OPAPATestALB As %Library.Float [ SqlColumnNumber = 175, SqlFieldName = OPA_PATestALB ];

/// OPA_PATestTBIL
Property OPAPATestTBIL As %Library.Float [ SqlColumnNumber = 176, SqlFieldName = OPA_PATestTBIL ];

/// OPA_PATestALP
Property OPAPATestALP As %Library.Float [ SqlColumnNumber = 177, SqlFieldName = OPA_PATestALP ];

/// OPA_PATestGLU
Property OPAPATestGLU As %Library.Float [ SqlColumnNumber = 178, SqlFieldName = OPA_PATestGLU ];

/// OPA_PATestCREA
Property OPAPATestCREA As %Library.Float [ SqlColumnNumber = 179, SqlFieldName = OPA_PATestCREA ];

/// OPA_PATestBUN
Property OPAPATestBUN As %Library.Float [ SqlColumnNumber = 180, SqlFieldName = OPA_PATestBUN ];

/// OPA_PATestUA
Property OPAPATestUA As %Library.Float [ SqlColumnNumber = 181, SqlFieldName = OPA_PATestUA ];

/// OPA_PATestCHOL
Property OPAPATestCHOL As %Library.Float [ SqlColumnNumber = 182, SqlFieldName = OPA_PATestCHOL ];

/// OPA_PATestTG
Property OPAPATestTG As %Library.Float [ SqlColumnNumber = 183, SqlFieldName = OPA_PATestTG ];

/// OPA_PATestHDLC
Property OPAPATestHDLC As %Library.Float [ SqlColumnNumber = 184, SqlFieldName = OPA_PATestHDLC ];

/// OPA_PATestLDLC
Property OPAPATestLDLC As %Library.Float [ SqlColumnNumber = 185, SqlFieldName = OPA_PATestLDLC ];

/// OPA_PATestLDH
Property OPAPATestLDH As %Library.Float [ SqlColumnNumber = 186, SqlFieldName = OPA_PATestLDH ];

/// OPA_PATestCKMB
Property OPAPATestCKMB As %Library.Float [ SqlColumnNumber = 187, SqlFieldName = OPA_PATestCKMB ];

/// OPA_PATestLAC
Property OPAPATestLAC As %Library.Float [ SqlColumnNumber = 188, SqlFieldName = OPA_PATestLAC ];

/// OPA_PATestK
Property OPAPATestK As %Library.Float [ SqlColumnNumber = 189, SqlFieldName = OPA_PATestK ];

/// OPA_PATestNa
Property OPAPATestNa As %Library.Float [ SqlColumnNumber = 190, SqlFieldName = OPA_PATestNa ];

/// OPA_PATestCa
Property OPAPATestCa As %Library.Float [ SqlColumnNumber = 191, SqlFieldName = OPA_PATestCa ];

/// OPA_PATestCl
Property OPAPATestCl As %Library.Float [ SqlColumnNumber = 192, SqlFieldName = OPA_PATestCl ];

/// OPA_PATestHBsAg
Property OPAPATestHBsAg As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 193, SqlFieldName = OPA_PATestHBsAg ];

/// OPA_PATestHBsAb
Property OPAPATestHBsAb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 194, SqlFieldName = OPA_PATestHBsAb ];

/// OPA_PATestHBeAg
Property OPAPATestHBeAg As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 195, SqlFieldName = OPA_PATestHBeAg ];

/// OPA_PATestHBeAb
Property OPAPATestHBeAb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 196, SqlFieldName = OPA_PATestHBeAb ];

/// OPA_PATestHBcAb
Property OPAPATestHBcAb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 197, SqlFieldName = OPA_PATestHBcAb ];

/// OPA_PATestHCVAb
Property OPAPATestHCVAb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 198, SqlFieldName = OPA_PATestHCVAb ];

/// OPA_PATestHivAb
Property OPAPATestHivAb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 199, SqlFieldName = OPA_PATestHivAb ];

/// OPA_PATestTPAb
Property OPAPATestTPAb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 200, SqlFieldName = OPA_PATestTPAb ];

/// OPA_PATestPT
Property OPAPATestPT As %Library.Float [ SqlColumnNumber = 201, SqlFieldName = OPA_PATestPT ];

/// OPA_PATestPTA
Property OPAPATestPTA As %Library.Float [ SqlColumnNumber = 202, SqlFieldName = OPA_PATestPTA ];

/// OPA_PATestPTR
Property OPAPATestPTR As %Library.Float [ SqlColumnNumber = 203, SqlFieldName = OPA_PATestPTR ];

/// OPA_PATestINR
Property OPAPATestINR As %Library.Float [ SqlColumnNumber = 204, SqlFieldName = OPA_PATestINR ];

/// OPA_PATestAPTT
Property OPAPATestAPTT As %Library.Float [ SqlColumnNumber = 205, SqlFieldName = OPA_PATestAPTT ];

/// OPA_PATestFIB
Property OPAPATestFIB As %Library.Float [ SqlColumnNumber = 206, SqlFieldName = OPA_PATestFIB ];

/// OPA_PATestDDimer
Property OPAPATestDDimer As %Library.Float [ SqlColumnNumber = 207, SqlFieldName = OPA_PATestDDimer ];

/// OPA_PATestFDP
Property OPAPATestFDP As %Library.Float [ SqlColumnNumber = 208, SqlFieldName = OPA_PATestFDP ];

/// OPA_PATestUrineGLU
Property OPAPATestUrineGLU As %Library.Float [ SqlColumnNumber = 209, SqlFieldName = OPA_PATestUrineGLU ];

/// OPA_PATestUrineKET
Property OPAPATestUrineKET As %Library.Float [ SqlColumnNumber = 210, SqlFieldName = OPA_PATestUrineKET ];

/// OPA_PATestUrineNPRO
Property OPAPATestUrineNPRO As %Library.Float [ SqlColumnNumber = 211, SqlFieldName = OPA_PATestUrineNPRO ];

/// OPA_PATestUrinePH
Property OPAPATestUrinePH As %Library.Float [ SqlColumnNumber = 212, SqlFieldName = OPA_PATestUrinePH ];

/// OPA_PATestUrineERY
Property OPAPATestUrineERY As %Library.Float [ SqlColumnNumber = 213, SqlFieldName = OPA_PATestUrineERY ];

/// OPA_PATestPH
Property OPAPATestPH As %Library.Float [ SqlColumnNumber = 214, SqlFieldName = OPA_PATestPH ];

/// OPA_PATestPCO2
Property OPAPATestPCO2 As %Library.Float [ SqlColumnNumber = 215, SqlFieldName = OPA_PATestPCO2 ];

/// OPA_PATestPO2
Property OPAPATestPO2 As %Library.Float [ SqlColumnNumber = 216, SqlFieldName = OPA_PATestPO2 ];

/// OPA_PATestHCO3
Property OPAPATestHCO3 As %Library.Float [ SqlColumnNumber = 217, SqlFieldName = OPA_PATestHCO3 ];

/// OPA_PATestBE
Property OPAPATestBE As %Library.Float [ SqlColumnNumber = 218, SqlFieldName = OPA_PATestBE ];

/// OPA_PATestSO2
Property OPAPATestSO2 As %Library.Float [ SqlColumnNumber = 219, SqlFieldName = OPA_PATestSO2 ];

/// OPA_AnalgesiaPlan
Property OPAAnalgesiaPlan As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 220, SqlFieldName = OPA_AnalgesiaPlan ];

/// OPA_PreAnaVisit
Property OPAPreAnaVisit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 221, SqlFieldName = OPA_PreAnaVisit ];

/// OPA_PreAnaVisitOther
Property OPAPreAnaVisitOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 222, SqlFieldName = OPA_PreAnaVisitOther ];

/// OPA_PostAnaSum
Property OPAPostAnaSum As %Library.String(COLLATION = "Exact", MAXLEN = 3000, TRUNCATE = 0) [ SqlColumnNumber = 223, SqlFieldName = OPA_PostAnaSum ];

/// OPA_PostAnaSumOther
Property OPAPostAnaSumOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 224, SqlFieldName = OPA_PostAnaSumOther ];

/// OPA_PostAnaVisit
Property OPAPostAnaVisit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 225, SqlFieldName = OPA_PostAnaVisit ];

/// OPA_PostAnaVisitOther
Property OPAPostAnaVisitOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 226, SqlFieldName = OPA_PostAnaVisitOther ];

/// OPA_ExtubationDone
Property OPAExtubationDone As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 227, SqlFieldName = OPA_ExtubationDone ];

/// OPA_ExtubIndicate
Property OPAExtubIndicate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 228, SqlFieldName = OPA_ExtubIndicate ];

/// OPA_Analgesia
Property OPAAnalgesia As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 229, SqlFieldName = OPA_Analgesia ];

/// OPA_AnalgesiaOther
Property OPAAnalgesiaOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 230, SqlFieldName = OPA_AnalgesiaOther ];

/// OPA_AnalgesiaEstimate
Property OPAAnalgesiaEstimate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 231, SqlFieldName = OPA_AnalgesiaEstimate ];

/// OPA_PACUInAdmission
Property OPAPACUInAdmission As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 232, SqlFieldName = OPA_PACUInAdmission ];

/// OPA_PACUScoreDetail
Property OPAPACUScoreDetail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 233, SqlFieldName = OPA_PACUScoreDetail ];

/// OPA_PACUScoreVal
Property OPAPACUScoreVal As %Library.Float [ SqlColumnNumber = 234, SqlFieldName = OPA_PACUScoreVal ];

/// OPA_PACUVasScoreDetail
Property OPAPACUVasScoreDetail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 235, SqlFieldName = OPA_PACUVasScoreDetail ];

/// OPA_PACUVasScoreVal
Property OPAPACUVasScoreVal As %Library.Float [ SqlColumnNumber = 236, SqlFieldName = OPA_PACUVasScoreVal ];

/// OPA_PACUInDate
Property OPAPACUInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 237, SqlFieldName = OPA_PACUInDate ];

/// OPA_PACUInTime
Property OPAPACUInTime As %Library.Time [ SqlColumnNumber = 238, SqlFieldName = OPA_PACUInTime ];

/// OPA_PACUOutDate
Property OPAPACUOutDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 239, SqlFieldName = OPA_PACUOutDate ];

/// OPA_PACUOutTime
Property OPAPACUOutTime As %Library.Time [ SqlColumnNumber = 240, SqlFieldName = OPA_PACUOutTime ];

/// OPA_PACUDuration
Property OPAPACUDuration As %Library.Float [ SqlColumnNumber = 241, SqlFieldName = OPA_PACUDuration ];

/// OPA_PACUDischCtcp_DR
Property OPAPACUDischCtcpDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 242, SqlFieldName = OPA_PACUDischCtcp_DR ];

/// OPA_PACUNurse_Dr
Property OPAPACUNurseDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 243, SqlFieldName = OPA_PACUNurse_Dr ];

/// OPA_PACUConsciousness
Property OPAPACUConsciousness As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 244, SqlFieldName = OPA_PACUConsciousness ];

/// OPA_PACURespiration
Property OPAPACURespiration As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 245, SqlFieldName = OPA_PACURespiration ];

/// OPA_PACUExtremityMove
Property OPAPACUExtremityMove As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 246, SqlFieldName = OPA_PACUExtremityMove ];

/// OPA_PACUHemodynamics
Property OPAPACUHemodynamics As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 247, SqlFieldName = OPA_PACUHemodynamics ];

/// OPA_PACUOxygenSaturation
Property OPAPACUOxygenSaturation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 248, SqlFieldName = OPA_PACUOxygenSaturation ];

/// OPA_PACURenal
Property OPAPACURenal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 249, SqlFieldName = OPA_PACURenal ];

/// OPA_PACUNerve
Property OPAPACUNerve As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 250, SqlFieldName = OPA_PACUNerve ];

/// OPA_PACUNausea
Property OPAPACUNausea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 251, SqlFieldName = OPA_PACUNausea ];

/// OPA_PACUVomiting
Property OPAPACUVomiting As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 252, SqlFieldName = OPA_PACUVomiting ];

/// OPA_PACUTemperature
Property OPAPACUTemperature As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 253, SqlFieldName = OPA_PACUTemperature ];

/// OPA_PACUNote
Property OPAPACUNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 254, SqlFieldName = OPA_PACUNote ];

/// OPA_PACUOther
Property OPAPACUOther As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 255, SqlFieldName = OPA_PACUOther ];

/// OPA_PAInfect
Property OPAPAInfect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 256, SqlFieldName = OPA_PAInfect ];

/// OPA_PAInfectDispose
Property OPAPAInfectDispose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 257, SqlFieldName = OPA_PAInfectDispose ];

/// OPA_SelfIntroduce
Property OPASelfIntroduce As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 258, SqlFieldName = OPA_SelfIntroduce ];

/// OPA_PreOperPatTeaching
Property OPAPreOperPatTeaching As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 259, SqlFieldName = OPA_PreOperPatTeaching ];

/// OPA_PsychologicRelease
Property OPAPsychologicRelease As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 260, SqlFieldName = OPA_PsychologicRelease ];

/// OPA_PreAnaDrug
Property OPAPreAnaDrug As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 261, SqlFieldName = OPA_PreAnaDrug ];

/// OPA_AnSheetPrintAudit
Property OPAAnSheetPrintAudit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 262, SqlFieldName = OPA_AnSheetPrintAudit ];

/// OPA_AnSheetEditAudit
Property OPAAnSheetEditAudit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 263, SqlFieldName = OPA_AnSheetEditAudit ];

/// OPA_OperSiteSkin
Property OPAOperSiteSkin As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 264, SqlFieldName = OPA_OperSiteSkin ];

/// OPA_PreAnaVisitCtcp_Dr
Property OPAPreAnaVisitCtcpDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 265, SqlFieldName = OPA_PreAnaVisitCtcp_Dr ];

/// OPA_PreAnaVisitDate
Property OPAPreAnaVisitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 266, SqlFieldName = OPA_PreAnaVisitDate ];

/// OPA_PreAnaVisitTime
Property OPAPreAnaVisitTime As %Library.Time [ SqlColumnNumber = 267, SqlFieldName = OPA_PreAnaVisitTime ];

/// OPA_OpNurseOrderedDate
Property OPAOpNurseOrderedDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 268, SqlFieldName = OPA_OpNurseOrderedDate ];

/// OPA_OpNurseOrderedTime
Property OPAOpNurseOrderedTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 269, SqlFieldName = OPA_OpNurseOrderedTime ];

/// OPA_TotalIn
Property OPATotalIn As %Library.Float [ SqlColumnNumber = 270, SqlFieldName = OPA_TotalIn ];

/// OPA_InfusedElectrolyte
Property OPAInfusedElectrolyte As %Library.Float [ SqlColumnNumber = 271, SqlFieldName = OPA_InfusedElectrolyte ];

/// OPA_InfusedNutrition
Property OPAInfusedNutrition As %Library.Float [ SqlColumnNumber = 272, SqlFieldName = OPA_InfusedNutrition ];

/// OPA_InfusedSyntheticColloids
Property OPAInfusedSyntheticColloids As %Library.Float [ SqlColumnNumber = 273, SqlFieldName = OPA_InfusedSyntheticColloids ];

/// OPA_InfusedTherapy
Property OPAInfusedTherapy As %Library.Float [ SqlColumnNumber = 274, SqlFieldName = OPA_InfusedTherapy ];

/// OPA_InfusedBlood
Property OPAInfusedBlood As %Library.Float [ SqlColumnNumber = 275, SqlFieldName = OPA_InfusedBlood ];

/// OPA_AllogeneicBlood
Property OPAAllogeneicBlood As %Library.Float [ SqlColumnNumber = 276, SqlFieldName = OPA_AllogeneicBlood ];

/// OPA_AutologousBlood
Property OPAAutologousBlood As %Library.Float [ SqlColumnNumber = 277, SqlFieldName = OPA_AutologousBlood ];

/// OPA_SalvagedBlood
Property OPASalvagedBlood As %Library.Float [ SqlColumnNumber = 278, SqlFieldName = OPA_SalvagedBlood ];

/// OPA_RedCells
Property OPARedCells As %Library.Float [ SqlColumnNumber = 279, SqlFieldName = OPA_RedCells ];

/// OPA_Plasma
Property OPAPlasma As %Library.Float [ SqlColumnNumber = 280, SqlFieldName = OPA_Plasma ];

/// OPA_Platelets
Property OPAPlatelets As %Library.Float [ SqlColumnNumber = 281, SqlFieldName = OPA_Platelets ];

/// OPA_CoagulationFactor
Property OPACoagulationFactor As %Library.Float [ SqlColumnNumber = 282, SqlFieldName = OPA_CoagulationFactor ];

/// OPA_TotalOut
Property OPATotalOut As %Library.Float [ SqlColumnNumber = 283, SqlFieldName = OPA_TotalOut ];

/// OPA_Urine
Property OPAUrine As %Library.Float [ SqlColumnNumber = 284, SqlFieldName = OPA_Urine ];

/// OPA_LossBlood
Property OPALossBlood As %Library.Float [ SqlColumnNumber = 285, SqlFieldName = OPA_LossBlood ];

/// OPA_Drainage
Property OPADrainage As %Library.Float [ SqlColumnNumber = 286, SqlFieldName = OPA_Drainage ];

/// OPA_InAreaTemperature
Property OPAInAreaTemperature As %Library.Float [ SqlColumnNumber = 287, SqlFieldName = OPA_InAreaTemperature ];

/// OPA_InAreaBPSystolic
Property OPAInAreaBPSystolic As %Library.String [ SqlColumnNumber = 288, SqlFieldName = OPA_InAreaBPSystolic ];

/// OPA_InAreaBPDiastolic
Property OPAInAreaBPDiastolic As %Library.Float [ SqlColumnNumber = 289, SqlFieldName = OPA_InAreaBPDiastolic ];

/// OPA_InAreaHeartRate
Property OPAInAreaHeartRate As %Library.Float [ SqlColumnNumber = 290, SqlFieldName = OPA_InAreaHeartRate ];

/// OPA_InAreaRespRate
Property OPAInAreaRespRate As %Library.Float [ SqlColumnNumber = 291, SqlFieldName = OPA_InAreaRespRate ];

/// OPA_SurgeonLoc_Dr
Property OPASurgeonLocDr As %Library.String [ SqlColumnNumber = 292, SqlFieldName = OPA_SurgeonLoc_Dr ];

/// OPA_UpdateDate
Property OPAUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 293, SqlFieldName = OPA_UpdateDate ];

/// OPA_UpdateTime
Property OPAUpdateTime As %Library.Time [ SqlColumnNumber = 294, SqlFieldName = OPA_UpdateTime ];

/// OPA_CareFlush
Property OPACareFlush As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 295, SqlFieldName = OPA_CareFlush ];

/// OPA_CareFlushOther
Property OPACareFlushOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 296, SqlFieldName = OPA_CareFlushOther ];

/// OPA_CarePlugger
Property OPACarePlugger As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 297, SqlFieldName = OPA_CarePlugger ];

/// OPA_CarePluggerSite
Property OPACarePluggerSite As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 298, SqlFieldName = OPA_CarePluggerSite ];

/// OPA_CareOperVitalSign
Property OPACareOperVitalSign As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 299, SqlFieldName = OPA_CareOperVitalSign ];

/// OPA_CareOperRecord
Property OPACareOperRecord As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 300, SqlFieldName = OPA_CareOperRecord ];

/// OPA_CareOperRecordSpecial
Property OPACareOperRecordSpecial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 301, SqlFieldName = OPA_CareOperRecordSpecial ];

/// OPA_CareOperRecordDispose
Property OPACareOperRecordDispose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 302, SqlFieldName = OPA_CareOperRecordDispose ];

/// OPA_CareOperRecordOther
Property OPACareOperRecordOther As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 303, SqlFieldName = OPA_CareOperRecordOther ];

/// OPA_CountPreOperScrub_Dr
Property OPACountPreOperScrubDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 304, SqlFieldName = OPA_CountPreOperScrub_Dr ];

/// OPA_CountPreOperCircul_Dr
Property OPACountPreOperCirculDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 305, SqlFieldName = OPA_CountPreOperCircul_Dr ];

/// OPA_CountPreOperDate
Property OPACountPreOperDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 306, SqlFieldName = OPA_CountPreOperDate ];

/// OPA_CountPreOperTime
Property OPACountPreOperTime As %Library.Time [ SqlColumnNumber = 307, SqlFieldName = OPA_CountPreOperTime ];

/// OPA_CountAddScrub_Dr
Property OPACountAddScrubDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 308, SqlFieldName = OPA_CountAddScrub_Dr ];

/// OPA_CountAddCircul_Dr
Property OPACountAddCirculDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 309, SqlFieldName = OPA_CountAddCircul_Dr ];

/// OPA_CountAddDate
Property OPACountAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 310, SqlFieldName = OPA_CountAddDate ];

/// OPA_CountAddTime
Property OPACountAddTime As %Library.Time [ SqlColumnNumber = 311, SqlFieldName = OPA_CountAddTime ];

/// OPA_CountUnSewScrub_Dr
Property OPACountUnSewScrubDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 312, SqlFieldName = OPA_CountUnSewScrub_Dr ];

/// OPA_CountUnSewCircul_Dr
Property OPACountUnSewCirculDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 313, SqlFieldName = OPA_CountUnSewCircul_Dr ];

/// OPA_CountUnSewDate
Property OPACountUnSewDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 314, SqlFieldName = OPA_CountUnSewDate ];

/// OPA_CountUnSewTime
Property OPACountUnSewTime As %Library.Time [ SqlColumnNumber = 315, SqlFieldName = OPA_CountUnSewTime ];

/// OPA_CountSewedScrub_Dr
Property OPACountSewedScrubDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 316, SqlFieldName = OPA_CountSewedScrub_Dr ];

/// OPA_CountSewedCircul_Dr
Property OPACountSewedCirculDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 317, SqlFieldName = OPA_CountSewedCircul_Dr ];

/// OPA_CountSewedDate
Property OPACountSewedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 318, SqlFieldName = OPA_CountSewedDate ];

/// OPA_CountSewedTime
Property OPACountSewedTime As %Library.Time [ SqlColumnNumber = 319, SqlFieldName = OPA_CountSewedTime ];

/// OPA_CountCorrect
Property OPACountCorrect As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 320, SqlFieldName = OPA_CountCorrect ];

/// OPA_CountNote
Property OPACountNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 321, SqlFieldName = OPA_CountNote ];

/// OPA_CountAuditCTCP_Dr
Property OPACountAuditCTCPDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 322, SqlFieldName = OPA_CountAuditCTCP_Dr ];

/// OPA_CountAuditDate
Property OPACountAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 323, SqlFieldName = OPA_CountAuditDate ];

/// OPA_CountAuditTime
Property OPACountAuditTime As %Library.Time [ SqlColumnNumber = 324, SqlFieldName = OPA_CountAuditTime ];

Storage SQLStorage
{
<ExtentSize>80000</ExtentSize>
<SqlIdExpression>$i(^DHCANOPArrange(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OPA_AddInstrument">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OPA_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPA_AllogeneicBlood">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>7</Piece>
</Data>
<Data name="OPA_AnDocNote">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="OPA_AnSheetEditAudit">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="OPA_AnSheetPrintAudit">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="OPA_AnaDoctorOrdered">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="OPA_AnaEffect">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OPA_AnaNurseOrdered">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="OPA_Anaest_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPA_Analgesia">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="OPA_AnalgesiaEstimate">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="OPA_AnalgesiaOther">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="OPA_AnalgesiaPlan">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>105</Piece>
</Data>
<Data name="OPA_AppCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPA_AppDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPA_AppLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="OPA_AppTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPA_ArrangeDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPA_ArrangeTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPA_ArrangeUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPA_AuditStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPA_AutologousBlood">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>8</Piece>
</Data>
<Data name="OPA_BloodType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OPA_CareFlush">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>31</Piece>
</Data>
<Data name="OPA_CareFlushOther">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>32</Piece>
</Data>
<Data name="OPA_CareOperRecord">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>36</Piece>
</Data>
<Data name="OPA_CareOperRecordDispose">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>38</Piece>
</Data>
<Data name="OPA_CareOperRecordOther">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>39</Piece>
</Data>
<Data name="OPA_CareOperRecordSpecial">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>37</Piece>
</Data>
<Data name="OPA_CareOperVitalSign">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>35</Piece>
</Data>
<Data name="OPA_CarePlugger">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>33</Piece>
</Data>
<Data name="OPA_CarePluggerSite">
<Delimiter>"^"</Delimiter>
<Node>"Care"</Node>
<Piece>34</Piece>
</Data>
<Data name="OPA_CirculNurseNote">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="OPA_CoagulationFactor">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>13</Piece>
</Data>
<Data name="OPA_CollectedStatus">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OPA_CountAddCircul_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>6</Piece>
</Data>
<Data name="OPA_CountAddDate">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>7</Piece>
</Data>
<Data name="OPA_CountAddScrub_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>5</Piece>
</Data>
<Data name="OPA_CountAddTime">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>8</Piece>
</Data>
<Data name="OPA_CountAuditCTCP_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>19</Piece>
</Data>
<Data name="OPA_CountAuditDate">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>20</Piece>
</Data>
<Data name="OPA_CountAuditTime">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>21</Piece>
</Data>
<Data name="OPA_CountCorrect">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>17</Piece>
</Data>
<Data name="OPA_CountNote">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>18</Piece>
</Data>
<Data name="OPA_CountPreOperCircul_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>2</Piece>
</Data>
<Data name="OPA_CountPreOperDate">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>3</Piece>
</Data>
<Data name="OPA_CountPreOperScrub_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>1</Piece>
</Data>
<Data name="OPA_CountPreOperTime">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>4</Piece>
</Data>
<Data name="OPA_CountSewedCircul_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>14</Piece>
</Data>
<Data name="OPA_CountSewedDate">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>15</Piece>
</Data>
<Data name="OPA_CountSewedScrub_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>13</Piece>
</Data>
<Data name="OPA_CountSewedTime">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>16</Piece>
</Data>
<Data name="OPA_CountUnSewCircul_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>10</Piece>
</Data>
<Data name="OPA_CountUnSewDate">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>11</Piece>
</Data>
<Data name="OPA_CountUnSewScrub_Dr">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>9</Piece>
</Data>
<Data name="OPA_CountUnSewTime">
<Delimiter>"^"</Delimiter>
<Node>"Count"</Node>
<Piece>12</Piece>
</Data>
<Data name="OPA_DocArriveTime">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="OPA_Drainage">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>17</Piece>
</Data>
<Data name="OPA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OPA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OPA_EstiOperDuration">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OPA_ExCirculation">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OPA_ExtubIndicate">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="OPA_ExtubationDone">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="OPA_FreezingSlice">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="OPA_InAreaBPDiastolic">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="OPA_InAreaBPSystolic">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="OPA_InAreaHeartRate">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="OPA_InAreaRespRate">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="OPA_InAreaTemperature">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="OPA_InfusedBlood">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>6</Piece>
</Data>
<Data name="OPA_InfusedElectrolyte">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>2</Piece>
</Data>
<Data name="OPA_InfusedNutrition">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>3</Piece>
</Data>
<Data name="OPA_InfusedSyntheticColloids">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>4</Piece>
</Data>
<Data name="OPA_InfusedTherapy">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>5</Piece>
</Data>
<Data name="OPA_Instrument_Dr">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OPA_Isolated">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OPA_LossBlood">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>16</Piece>
</Data>
<Data name="OPA_MedInfect">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="OPA_Memo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OPA_MiniInvasive">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OPA_Navigation">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="OPA_NeedAnaesthetist">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="OPA_NeedScrubNurse">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OPA_OpDocNote">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OPA_OpLevel_Dr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OPA_OpNurseOrdered">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="OPA_OpNurseOrderedDate">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="OPA_OpNurseOrderedTime">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="OPA_OpRoom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OPA_OperDelayNote">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="OPA_OperSiteSkin">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="OPA_PAAldosterone">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>14</Piece>
</Data>
<Data name="OPA_PAAllen">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>79</Piece>
</Data>
<Data name="OPA_PAAnaClass">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>88</Piece>
</Data>
<Data name="OPA_PAAnaSpecificApply">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>91</Piece>
</Data>
<Data name="OPA_PAAnaestType">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>89</Piece>
</Data>
<Data name="OPA_PAAngiography">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>102</Piece>
</Data>
<Data name="OPA_PABPDiastolic">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>62</Piece>
</Data>
<Data name="OPA_PABPSystolic">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>61</Piece>
</Data>
<Data name="OPA_PABloodSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>38</Piece>
</Data>
<Data name="OPA_PABloodSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>39</Piece>
</Data>
<Data name="OPA_PABoneSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>36</Piece>
</Data>
<Data name="OPA_PABoneSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>37</Piece>
</Data>
<Data name="OPA_PACT">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>99</Piece>
</Data>
<Data name="OPA_PACUConsciousness">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>13</Piece>
</Data>
<Data name="OPA_PACUDischCtcp_DR">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>11</Piece>
</Data>
<Data name="OPA_PACUDuration">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>10</Piece>
</Data>
<Data name="OPA_PACUExtremityMove">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>15</Piece>
</Data>
<Data name="OPA_PACUHemodynamics">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>16</Piece>
</Data>
<Data name="OPA_PACUInAdmission">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>1</Piece>
</Data>
<Data name="OPA_PACUInDate">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>6</Piece>
</Data>
<Data name="OPA_PACUInTime">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>7</Piece>
</Data>
<Data name="OPA_PACUNausea">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>20</Piece>
</Data>
<Data name="OPA_PACUNerve">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>19</Piece>
</Data>
<Data name="OPA_PACUNote">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>23</Piece>
</Data>
<Data name="OPA_PACUNurse_Dr">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>12</Piece>
</Data>
<Data name="OPA_PACUOther">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>24</Piece>
</Data>
<Data name="OPA_PACUOutDate">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>8</Piece>
</Data>
<Data name="OPA_PACUOutTime">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>9</Piece>
</Data>
<Data name="OPA_PACUOxygenSaturation">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>17</Piece>
</Data>
<Data name="OPA_PACURenal">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>18</Piece>
</Data>
<Data name="OPA_PACURespiration">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>14</Piece>
</Data>
<Data name="OPA_PACUScoreDetail">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>2</Piece>
</Data>
<Data name="OPA_PACUScoreVal">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>3</Piece>
</Data>
<Data name="OPA_PACUTemperature">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>22</Piece>
</Data>
<Data name="OPA_PACUVasScoreDetail">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>4</Piece>
</Data>
<Data name="OPA_PACUVasScoreVal">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>5</Piece>
</Data>
<Data name="OPA_PACUVomiting">
<Delimiter>"^"</Delimiter>
<Node>"PACU"</Node>
<Piece>21</Piece>
</Data>
<Data name="OPA_PACardiacCatheter">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>96</Piece>
</Data>
<Data name="OPA_PACardiacRhythm">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>9</Piece>
</Data>
<Data name="OPA_PACardiovascular">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>74</Piece>
</Data>
<Data name="OPA_PACirculSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>11</Piece>
</Data>
<Data name="OPA_PACirculatorySystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>8</Piece>
</Data>
<Data name="OPA_PAConsciousness">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>64</Piece>
</Data>
<Data name="OPA_PACurCondition">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>56</Piece>
</Data>
<Data name="OPA_PACurConditionOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>57</Piece>
</Data>
<Data name="OPA_PACurDrug">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>50</Piece>
</Data>
<Data name="OPA_PACurDrugOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>51</Piece>
</Data>
<Data name="OPA_PADiffcultPrevent">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>93</Piece>
</Data>
<Data name="OPA_PADigestSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>35</Piece>
</Data>
<Data name="OPA_PADigestiveSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>32</Piece>
</Data>
<Data name="OPA_PADyspneaClass">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>85</Piece>
</Data>
<Data name="OPA_PAEKG">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>95</Piece>
</Data>
<Data name="OPA_PAEchocardiogram">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>97</Piece>
</Data>
<Data name="OPA_PAEndoSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>16</Piece>
</Data>
<Data name="OPA_PAEndocrineSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>12</Piece>
</Data>
<Data name="OPA_PAExam">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>94</Piece>
</Data>
<Data name="OPA_PAExamOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>104</Piece>
</Data>
<Data name="OPA_PAFamily">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>52</Piece>
</Data>
<Data name="OPA_PAFamilyOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>53</Piece>
</Data>
<Data name="OPA_PAGenitalSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>40</Piece>
</Data>
<Data name="OPA_PAGenitalSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>41</Piece>
</Data>
<Data name="OPA_PAHeadNeck">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>70</Piece>
</Data>
<Data name="OPA_PAHeartRate">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>59</Piece>
</Data>
<Data name="OPA_PAHypertension">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>10</Piece>
</Data>
<Data name="OPA_PAHypothyroid">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>15</Piece>
</Data>
<Data name="OPA_PAIllness">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>1</Piece>
</Data>
<Data name="OPA_PAInfect">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>108</Piece>
</Data>
<Data name="OPA_PAInfectDispose">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>109</Piece>
</Data>
<Data name="OPA_PAInsulin">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>13</Piece>
</Data>
<Data name="OPA_PAIntubatDiffcult">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>86</Piece>
</Data>
<Data name="OPA_PAJaw">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>19</Piece>
</Data>
<Data name="OPA_PALiver">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>33</Piece>
</Data>
<Data name="OPA_PALowerLimb">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>78</Piece>
</Data>
<Data name="OPA_PALung">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>75</Piece>
</Data>
<Data name="OPA_PAMallampatiClass">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>66</Piece>
</Data>
<Data name="OPA_PAMonitorItem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>90</Piece>
</Data>
<Data name="OPA_PAMouth">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>17</Piece>
</Data>
<Data name="OPA_PAMouthOpen">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>65</Piece>
</Data>
<Data name="OPA_PAMouthOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>20</Piece>
</Data>
<Data name="OPA_PAMuscularSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>30</Piece>
</Data>
<Data name="OPA_PAMuscularSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>31</Piece>
</Data>
<Data name="OPA_PANYHA">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>87</Piece>
</Data>
<Data name="OPA_PANeck">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>24</Piece>
</Data>
<Data name="OPA_PANeckBackFlexAngle">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>72</Piece>
</Data>
<Data name="OPA_PANeckForwardFlexAngle">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>71</Piece>
</Data>
<Data name="OPA_PANeckOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>25</Piece>
</Data>
<Data name="OPA_PANervSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>3</Piece>
</Data>
<Data name="OPA_PANerve">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>76</Piece>
</Data>
<Data name="OPA_PANervousSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>2</Piece>
</Data>
<Data name="OPA_PANose">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>28</Piece>
</Data>
<Data name="OPA_PANoseOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>29</Piece>
</Data>
<Data name="OPA_PAOrganOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>82</Piece>
</Data>
<Data name="OPA_PAOtherSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>44</Piece>
</Data>
<Data name="OPA_PAOtherSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>45</Piece>
</Data>
<Data name="OPA_PAPeripheralVein">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>80</Piece>
</Data>
<Data name="OPA_PAPharynx">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>21</Piece>
</Data>
<Data name="OPA_PAPharynxOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>23</Piece>
</Data>
<Data name="OPA_PAPhyExam">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>58</Piece>
</Data>
<Data name="OPA_PAPhyExamOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>83</Piece>
</Data>
<Data name="OPA_PAPlan">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>92</Piece>
</Data>
<Data name="OPA_PAPreAllergy">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>48</Piece>
</Data>
<Data name="OPA_PAPreAllergyOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>49</Piece>
</Data>
<Data name="OPA_PAPreAnop">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>46</Piece>
</Data>
<Data name="OPA_PAPreAnopOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>47</Piece>
</Data>
<Data name="OPA_PAPulmonaryFuncTest">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>103</Piece>
</Data>
<Data name="OPA_PARespRate">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>63</Piece>
</Data>
<Data name="OPA_PARespSystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>4</Piece>
</Data>
<Data name="OPA_PARespSystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>7</Piece>
</Data>
<Data name="OPA_PARespTractClass">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>84</Piece>
</Data>
<Data name="OPA_PARespiration">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>73</Piece>
</Data>
<Data name="OPA_PASkin">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>26</Piece>
</Data>
<Data name="OPA_PASkinOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>27</Piece>
</Data>
<Data name="OPA_PASmokeDuration">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>6</Piece>
</Data>
<Data name="OPA_PASmokeFreq">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>5</Piece>
</Data>
<Data name="OPA_PASocial">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>54</Piece>
</Data>
<Data name="OPA_PASocialOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>55</Piece>
</Data>
<Data name="OPA_PASpine">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>81</Piece>
</Data>
<Data name="OPA_PASpleen">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>34</Piece>
</Data>
<Data name="OPA_PATeeth">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>68</Piece>
</Data>
<Data name="OPA_PATeethDetail">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>69</Piece>
</Data>
<Data name="OPA_PATemp">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>60</Piece>
</Data>
<Data name="OPA_PATest">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>1</Piece>
</Data>
<Data name="OPA_PATestALB">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>11</Piece>
</Data>
<Data name="OPA_PATestALP">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>13</Piece>
</Data>
<Data name="OPA_PATestALT">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>8</Piece>
</Data>
<Data name="OPA_PATestAPTT">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>41</Piece>
</Data>
<Data name="OPA_PATestAST">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>9</Piece>
</Data>
<Data name="OPA_PATestBE">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>54</Piece>
</Data>
<Data name="OPA_PATestBUN">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>16</Piece>
</Data>
<Data name="OPA_PATestCHOL">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>18</Piece>
</Data>
<Data name="OPA_PATestCKMB">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>23</Piece>
</Data>
<Data name="OPA_PATestCREA">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>15</Piece>
</Data>
<Data name="OPA_PATestCa">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>27</Piece>
</Data>
<Data name="OPA_PATestCl">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>28</Piece>
</Data>
<Data name="OPA_PATestDDimer">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>43</Piece>
</Data>
<Data name="OPA_PATestFDP">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>44</Piece>
</Data>
<Data name="OPA_PATestFIB">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>42</Piece>
</Data>
<Data name="OPA_PATestGLU">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>14</Piece>
</Data>
<Data name="OPA_PATestHB">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>5</Piece>
</Data>
<Data name="OPA_PATestHBcAb">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>33</Piece>
</Data>
<Data name="OPA_PATestHBeAb">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>32</Piece>
</Data>
<Data name="OPA_PATestHBeAg">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>31</Piece>
</Data>
<Data name="OPA_PATestHBsAb">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>30</Piece>
</Data>
<Data name="OPA_PATestHBsAg">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>29</Piece>
</Data>
<Data name="OPA_PATestHCO3">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>53</Piece>
</Data>
<Data name="OPA_PATestHCT">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>6</Piece>
</Data>
<Data name="OPA_PATestHCVAb">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>34</Piece>
</Data>
<Data name="OPA_PATestHDLC">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>20</Piece>
</Data>
<Data name="OPA_PATestHivAb">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>35</Piece>
</Data>
<Data name="OPA_PATestINR">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>40</Piece>
</Data>
<Data name="OPA_PATestK">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>25</Piece>
</Data>
<Data name="OPA_PATestLAC">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>24</Piece>
</Data>
<Data name="OPA_PATestLDH">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>22</Piece>
</Data>
<Data name="OPA_PATestLDLC">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>21</Piece>
</Data>
<Data name="OPA_PATestNa">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>26</Piece>
</Data>
<Data name="OPA_PATestOther">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>2</Piece>
</Data>
<Data name="OPA_PATestPCO2">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>51</Piece>
</Data>
<Data name="OPA_PATestPH">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>50</Piece>
</Data>
<Data name="OPA_PATestPLT">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>7</Piece>
</Data>
<Data name="OPA_PATestPO2">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>52</Piece>
</Data>
<Data name="OPA_PATestPT">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>37</Piece>
</Data>
<Data name="OPA_PATestPTA">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>38</Piece>
</Data>
<Data name="OPA_PATestPTR">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>39</Piece>
</Data>
<Data name="OPA_PATestRBC">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>4</Piece>
</Data>
<Data name="OPA_PATestSO2">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>55</Piece>
</Data>
<Data name="OPA_PATestTBIL">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>12</Piece>
</Data>
<Data name="OPA_PATestTG">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>19</Piece>
</Data>
<Data name="OPA_PATestTP">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>10</Piece>
</Data>
<Data name="OPA_PATestTPAb">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>36</Piece>
</Data>
<Data name="OPA_PATestUA">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>17</Piece>
</Data>
<Data name="OPA_PATestUrineERY">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>49</Piece>
</Data>
<Data name="OPA_PATestUrineGLU">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>45</Piece>
</Data>
<Data name="OPA_PATestUrineKET">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>46</Piece>
</Data>
<Data name="OPA_PATestUrineNPRO">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>47</Piece>
</Data>
<Data name="OPA_PATestUrinePH">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>48</Piece>
</Data>
<Data name="OPA_PATestWBC">
<Delimiter>"^"</Delimiter>
<Node>"PALab"</Node>
<Piece>3</Piece>
</Data>
<Data name="OPA_PAThyromentalDistance">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>67</Piece>
</Data>
<Data name="OPA_PATongue">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>18</Piece>
</Data>
<Data name="OPA_PATonsilHyper">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>22</Piece>
</Data>
<Data name="OPA_PAUltrsonic">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>100</Piece>
</Data>
<Data name="OPA_PAUpperLimb">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>77</Piece>
</Data>
<Data name="OPA_PAUrinarySystem">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>42</Piece>
</Data>
<Data name="OPA_PAUrinarySystemOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>43</Piece>
</Data>
<Data name="OPA_PAVascularUltrasonic">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>101</Piece>
</Data>
<Data name="OPA_PAXRay">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>98</Piece>
</Data>
<Data name="OPA_PacuBed_Dr">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="OPA_PatDept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OPA_PatHeight">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OPA_PatStatus">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OPA_PatWeight">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OPA_PathologSection">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="OPA_Plasma">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>11</Piece>
</Data>
<Data name="OPA_Platelets">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>12</Piece>
</Data>
<Data name="OPA_PostAnaSum">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="OPA_PostAnaSumOther">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="OPA_PostAnaVisit">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="OPA_PostAnaVisitOther">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="OPA_PreAnDrug">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OPA_PreAnaDrug">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="OPA_PreAnaVisit">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>106</Piece>
</Data>
<Data name="OPA_PreAnaVisitCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="OPA_PreAnaVisitDate">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="OPA_PreAnaVisitOther">
<Delimiter>"^"</Delimiter>
<Node>"PA"</Node>
<Piece>107</Piece>
</Data>
<Data name="OPA_PreAnaVisitTime">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="OPA_PreDiscussDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OPA_PreOperPatTeaching">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="OPA_PrepareBlood">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OPA_PsychologicRelease">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="OPA_Psychosis">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="OPA_RHBloodType">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OPA_RedCells">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>10</Piece>
</Data>
<Data name="OPA_ReturnReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OPA_SalvagedBlood">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>9</Piece>
</Data>
<Data name="OPA_ScrubNurseNote">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="OPA_SelfIntroduce">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="OPA_Seq">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OPA_SeqNote">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="OPA_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OPA_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OPA_Status">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OPA_SurgeonLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="OPA_TotalIn">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>1</Piece>
</Data>
<Data name="OPA_TotalOut">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>14</Piece>
</Data>
<Data name="OPA_TransferMeans">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="OPA_UnPlanedOperation">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="OPA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="OPA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="OPA_Urine">
<Delimiter>"^"</Delimiter>
<Node>"Sum"</Node>
<Piece>15</Piece>
</Data>
<Data name="OPA_UseSelfBlood">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OPA_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Global>^DHCANOPArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OPA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppDate">
<Global>^DHCANOPArrange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPA_AppDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaAdm">
<Global>^DHCANOPArrange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPA_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRoomStatus">
<Global>^DHCANOPArrange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RoomStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPA_OpRoom_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPA_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCANOPArrange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPA_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCANOPArrange</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OPA_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANOPArrangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
