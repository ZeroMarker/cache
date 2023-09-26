/// Anaesthesia(1010)
Class User.ORAnaesthesia Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_Anaesthesia, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ANAChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildORAnaestAgent As ORAnaestAgent [ Cardinality = children, Inverse = ANAParRef ];

Relationship ChildORAnaestOperation As ORAnaestOperation [ Cardinality = children, Inverse = ANAOPParRef ];

Relationship ChildORAnaestMonitorDevice As ORAnaestMonitorDevice [ Cardinality = children, Inverse = MONParRef ];

Relationship ChildORAnaestComplications As ORAnaestComplications [ Cardinality = children, Inverse = COMPParRef ];

Relationship ChildORAnaestAdditionalStaff As ORAnaestAdditionalStaff [ Cardinality = children, Inverse = ANAASParRef ];

/// PA_Adm Parent Reference
Relationship ANAPAADMParRef As PAAdm [ Cardinality = parent, Inverse = ChildORAnaesthesia, Required, SqlFieldName = ANA_PAADM_ParRef ];

/// Childsub
Property ANAChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ANA",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ANA_Childsub ];

/// Date of Anaest.
Property ANADate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 3, SqlFieldName = ANA_Date ];

/// Anaest. Start Time
Property ANAAnaStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ANA_AnaStartTime ];

/// Anaest. Finish Time
Property ANAAnaFinishTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ANA_AnaFinishTime ];

/// Method of Anaest.
Property ANAMethod As %String [ SqlColumnNumber = 6, SqlFieldName = ANA_Method ];

/// Anaesthetist Des Ref to CTCP
Property ANAAnaesthetistDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = ANA_Anaesthetist_DR ];

/// Supervisor Des Ref to CTCP
Property ANASupervisorDR As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = ANA_Supervisor_DR ];

/// OR Anast. Nurse Des Ref to CTCP
Property ANAORAnaNurseDR As CTCareProv [ SqlColumnNumber = 9, SqlFieldName = ANA_ORAnaNurse_DR ];

/// PACU AnaestNurse Des Ref to CTCP
Property ANAPACUAnaNurseDR As CTCareProv [ SqlColumnNumber = 10, SqlFieldName = ANA_PACUAnaNurse_DR ];

/// PACU Anaest who allowed Discharge DR to CTCP
Property ANAPACUAnaDischargeDR As CTCareProv [ SqlColumnNumber = 11, SqlFieldName = ANA_PACUAnaDischarge_DR ];

/// Amount of Blood Loss
Property ANAAmtBloodLoss As %Float [ SqlColumnNumber = 12, SqlFieldName = ANA_AmtBloodLoss ];

/// Amount of Urine Output
Property ANAAmtUrineOutput As %Float [ SqlColumnNumber = 13, SqlFieldName = ANA_AmtUrineOutput ];

/// Amount of Fluid Infused
Property ANAAmtFluidInfused As %Float [ SqlColumnNumber = 14, SqlFieldName = ANA_AmtFluidInfused ];

/// Amount of Blood Tranfused
Property ANAAmtBloodTranfused As %Float [ SqlColumnNumber = 15, SqlFieldName = ANA_AmtBloodTranfused ];

/// Intubation Route Des Ref to ORCIR
Property ANAIntubRouteDR As ORCIntubRoute [ SqlColumnNumber = 16, SqlFieldName = ANA_IntubRoute_DR ];

/// Intubation Grade Des Ref to ORCIG
Property ANAIntubGradeDR As ORCIntubGrade [ SqlColumnNumber = 17, SqlFieldName = ANA_IntubGrade_DR ];

/// Transfer to Loc Des Ref to CTLOC
Property ANATransLocDR As CTLoc [ SqlColumnNumber = 18, SqlFieldName = ANA_TransLoc_DR ];

/// Extubation Time
Property ANAExtubTime As %Time [ SqlColumnNumber = 19, SqlFieldName = ANA_ExtubTime ];

/// Surgery Start Time
Property ANASurgStartTime As %Time [ SqlColumnNumber = 20, SqlFieldName = ANA_SurgStartTime ];

/// Surgery Finish Time
Property ANASurgFinishTime As %Time [ SqlColumnNumber = 21, SqlFieldName = ANA_SurgFinishTime ];

/// Anaesthesia No
Property ANANo As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = ANA_No ];

/// Surgery Duration
Property ANASurgeryDuration As %Time [ SqlColumnNumber = 23, SqlComputeCode = { i {ANA_SurgStartTime}="" s {ANA_Surgery_Duration}="" q
 i {ANA_SurgFinishTime}="" s {ANA_Surgery_Duration}="" q
 s {ANA_Surgery_Duration}=$s({ANA_SurgStartTime}>{ANA_SurgFinishTime}:24*3600,1:0)+{ANA_SurgFinishTime}-{ANA_SurgStartTime}
}, SqlComputed, SqlFieldName = ANA_Surgery_Duration, Transient ];

/// Duration of Anesthesia
Property ANAAnestDuration As %Float [ SqlColumnNumber = 24, SqlComputeCode = { i {ANA_FinishDate}="" s {ANA_Anest_Duration}="" q
i {ANA_Date}="" q
i {ANA_AnaFinishTime}="" q
i {ANA_AnaStartTime}="" q
  s {ANA_Anest_Duration}={ANA_FinishDate}-{ANA_Date}*24*3600+{ANA_AnaFinishTime}-{ANA_AnaStartTime}
}, SqlComputed, SqlFieldName = ANA_Anest_Duration, Transient ];

/// Total Output
Property ANATotalOutput As %Float [ SqlColumnNumber = 25, SqlComputeCode = { s {ANA_Total_Output}={ANA_AmtBloodLoss}+{ANA_AmtUrineOutput}
}, SqlComputed, SqlFieldName = ANA_Total_Output, Transient ];

/// Total Input
Property ANATotalInput As %Float [ SqlColumnNumber = 26, SqlComputeCode = { s {ANA_Total_Input}={ANA_AmtBloodTranfused}+{ANA_AmtFluidInfused}
}, SqlComputed, SqlFieldName = ANA_Total_Input, Transient ];

/// PACU Start Time
Property ANAPACUStartTime As %Time [ SqlColumnNumber = 27, SqlFieldName = ANA_PACU_StartTime ];

/// PACU Finish Time
Property ANAPACUFinishTime As %Time [ SqlColumnNumber = 28, SqlFieldName = ANA_PACU_FinishTime ];

/// Des Ref to Intub Size
Property ANAIntSizeDR As ORCIntubationSize [ SqlColumnNumber = 29, SqlFieldName = ANA_IntSize_DR ];

/// Is there a cuff in Intub Tube
Property ANACuffIntubTube As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = ANA_Cuff_IntubTube ];

/// Extubation Done
Property ANAExtubDone As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = ANA_ExtubDone ];

/// Des Ref to ORC ASA
Property ANAASADR As ORCASAClassPhActiv [ SqlColumnNumber = 32, SqlFieldName = ANA_ASA_DR ];

/// Time in PACU
Property ANAPACUTime As %Time [ SqlColumnNumber = 33, SqlComputeCode = { i {ANA_PACU_FinishTime}="" s {ANA_PACU_Time}="" q
 i {ANA_PACU_StartTime}="" s {ANA_PACU_Time}="" q
 s {ANA_PACU_Time}=$s({ANA_PACU_FinishTime}>{ANA_PACU_StartTime}:0,1:24*3600)+{ANA_PACU_FinishTime}-{ANA_PACU_StartTime}
}, SqlComputed, SqlFieldName = ANA_PACU_Time, Transient ];

/// Des Ref to ORANCOMP
Property ANACOMPDR As ORCAnaestComplications [ SqlColumnNumber = 34, SqlFieldName = ANA_COMP_DR ];

/// Notes
Property ANANotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = ANA_Notes, SqlListType = SUBNODE ];

/// Des Ref BldtType
Property ANABldtTypeDR As ORCBladeType [ SqlColumnNumber = 36, SqlFieldName = ANA_BldtType_DR ];

/// Ana. Finish Date
Property ANAFinishDate As %Date [ SqlColumnNumber = 38, SqlFieldName = ANA_FinishDate ];

/// PACU StartDate
Property ANAPACUStartDate As %Date [ SqlColumnNumber = 39, SqlFieldName = ANA_PACU_StartDate ];

/// PACU FinishDate
Property ANAPACUFinishDate As %Date [ SqlColumnNumber = 40, SqlFieldName = ANA_PACU_FinishDate ];

/// Source Type
Property ANASourceType As %String(DISPLAYLIST = ",Booked,Not Booked,Emergency", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",B,N,E") [ SqlColumnNumber = 41, SqlFieldName = ANA_SourceType ];

/// Status
Property ANAStatus As %String(DISPLAYLIST = ",Done,Suspended,Anulled", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",D,S,A") [ SqlColumnNumber = 42, SqlFieldName = ANA_Status ];

/// DEs Ref Reason for Suspend
Property ANAReasonSuspendDR As ORCReasonForSuspend [ SqlColumnNumber = 43, SqlFieldName = ANA_Reason_Suspend_DR ];

/// Area In Date
Property ANAAreaInDate As %Date [ SqlColumnNumber = 44, SqlFieldName = ANA_AreaInDate ];

/// Area In Time
Property ANAAreaInTime As %Time [ SqlColumnNumber = 45, SqlFieldName = ANA_AreaInTime ];

/// Area Out Date
Property ANAAreaOutDate As %Date [ SqlColumnNumber = 46, SqlFieldName = ANA_AreaOutDate ];

/// Area Out Time
Property ANAAreaOutTime As %Time [ SqlColumnNumber = 47, SqlFieldName = ANA_AreaOutTime ];

/// Theatre In Date
Property ANATheatreInDate As %Date [ SqlColumnNumber = 48, SqlFieldName = ANA_TheatreInDate ];

/// Theatre In Time
Property ANATheatreInTime As %Time [ SqlColumnNumber = 49, SqlFieldName = ANA_TheatreInTime ];

/// Theatre Out Date
Property ANATheatreOutDate As %Date [ SqlColumnNumber = 50, SqlFieldName = ANA_TheatreOutDate ];

/// Theatre Out Time
Property ANATheatreOutTime As %Time [ SqlColumnNumber = 51, SqlFieldName = ANA_TheatreOutTime ];

/// Crystalloids
Property ANACrystalloids As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = ANA_Crystalloids ];

/// Colloids
Property ANAColloids As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = ANA_Colloids ];

/// Red Cells
Property ANARedCells As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = ANA_RedCells ];

/// RedCellsCode
Property ANARedCellsCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 55, SqlFieldName = ANA_RedCellsCode ];

/// Plasma
Property ANAPlasma As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = ANA_Plasma ];

/// PlasmaCode
Property ANAPlasmaCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 57, SqlFieldName = ANA_PlasmaCode ];

/// Platelets
Property ANAPlatelets As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 58, SqlFieldName = ANA_Platelets ];

/// PlateletsCode
Property ANAPlateletsCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = ANA_PlateletsCode ];

/// Des Ref Consultant
Property ANAConsultantDR As CTCareProv [ SqlColumnNumber = 60, SqlFieldName = ANA_Consultant_DR ];

/// Last Update Date
Property ANAUpdateDate As %Date [ SqlColumnNumber = 61, SqlFieldName = ANA_UpdateDate ];

/// Last Update Time
Property ANAUpdateTime As %Time [ SqlColumnNumber = 62, SqlFieldName = ANA_UpdateTime ];

/// Last Update User
Property ANAUpdateUserDR As SSUser [ SqlColumnNumber = 63, SqlFieldName = ANA_UpdateUser_DR ];

/// Last Update Hospital
Property ANAUpdateHospitalDR As CTHospital [ SqlColumnNumber = 64, SqlFieldName = ANA_UpdateHospital_DR ];

/// DR RBOperatingRoom
Property ANARBOperatingRoomDR As RBOperatingRoom [ SqlColumnNumber = 65, SqlFieldName = ANA_RBOperatingRoom_DR ];

/// PACU_ReadyLeaveDate
Property ANAPACUReadyLeaveDate As %Date [ SqlColumnNumber = 66, SqlFieldName = ANA_PACU_ReadyLeaveDate ];

/// PACU_ReadyLeaveTime
Property ANAPACUReadyLeaveTime As %Time [ SqlColumnNumber = 67, SqlFieldName = ANA_PACU_ReadyLeaveTime ];

/// Des Ref RecovSPPP
Property ANARecovSPPPDR As PACStatePPP [ SqlColumnNumber = 68, SqlFieldName = ANA_RecovSPPP_DR ];

/// Des Ref RecovOper
Property ANARecovOperDR As ORCOperation [ SqlColumnNumber = 69, SqlFieldName = ANA_RecovOper_DR ];

/// DSReportFlag
Property ANADSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 70, SqlFieldName = ANA_DSReportFlag ];

/// Des Ref PrevMethod
Property ANAPrevMethodDR As ORCAnaestMethod [ SqlColumnNumber = 71, SqlFieldName = ANA_PrevMethod_DR ];

/// Des Ref PrevAnaest
Property ANAPrevAnaestDR As %String [ SqlColumnNumber = 72, SqlFieldName = ANA_PrevAnaest_DR ];

/// Des Ref PrevRecOp
Property ANAPrevRecOpDR As ORCOperation [ SqlColumnNumber = 73, SqlFieldName = ANA_PrevRecOp_DR ];

/// Des Ref PrevRecSPPP
Property ANAPrevRecSPPPDR As PACStatePPP [ SqlColumnNumber = 74, SqlFieldName = ANA_PrevRecSPPP_DR ];

/// Des Ref OutcomeOfSurgery
Property ANAOutcomeOfSurgeryDR As ORCOutcomeOfSurgery [ SqlColumnNumber = 75, SqlFieldName = ANA_OutcomeOfSurgery_DR ];

/// PostOperInstructions
Property ANAPostOperInstructions As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 76, SqlFieldName = ANA_PostOperInstructions, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnaesthesia).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaesthesia","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnaesthesia).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaesthesia","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnaesthesia).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaesthesia","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnaesthesia).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaesthesia","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaesthesia","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnaesthesia).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaesthesia","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>533</ExtentSize>
<Property name="ANAASADR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ANAAmtBloodLoss">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANAAmtBloodTranfused">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAAmtFluidInfused">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANAAmtUrineOutput">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANAAnaFinishTime">
<Selectivity>1.7857%</Selectivity>
</Property>
<Property name="ANAAnaStartTime">
<Selectivity>2.0000%</Selectivity>
</Property>
<Property name="ANAAnaesthetistDR">
<Selectivity>3.5714%</Selectivity>
</Property>
<Property name="ANAAnestDuration">
<Selectivity>0.9091%</Selectivity>
</Property>
<Property name="ANAAreaInDate">
<Selectivity>1.1364%</Selectivity>
</Property>
<Property name="ANAAreaInTime">
<Selectivity>3.3333%</Selectivity>
</Property>
<Property name="ANAAreaOutDate">
<Selectivity>0.9174%</Selectivity>
</Property>
<Property name="ANAAreaOutTime">
<Selectivity>2.7027%</Selectivity>
</Property>
<Property name="ANABldtTypeDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="ANACOMPDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAChildsub">
<Selectivity>1.7857%</Selectivity>
</Property>
<Property name="ANAColloids">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANAConsultantDR">
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="ANACrystalloids">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANACuffIntubTube">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANADSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANADate">
<Selectivity>0.5682%</Selectivity>
</Property>
<Property name="ANAExtubDone">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAExtubTime">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAFinishDate">
<Selectivity>0.8475%</Selectivity>
</Property>
<Property name="ANAIntSizeDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANAIntubGradeDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANAIntubRouteDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ANAMethod">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="ANANo">
<Selectivity>0.2179%</Selectivity>
</Property>
<Property name="ANANotes">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ANAORAnaNurseDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAOutcomeOfSurgeryDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANAPAADMParRef">
<Selectivity>0.3390%</Selectivity>
</Property>
<Property name="ANAPACUAnaDischargeDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANAPACUAnaNurseDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAPACUFinishDate">
<Selectivity>0.9174%</Selectivity>
</Property>
<Property name="ANAPACUFinishTime">
<Selectivity>1.5873%</Selectivity>
</Property>
<Property name="ANAPACUReadyLeaveDate">
<Selectivity>2.7778%</Selectivity>
</Property>
<Property name="ANAPACUReadyLeaveTime">
<Selectivity>1.8182%</Selectivity>
</Property>
<Property name="ANAPACUStartDate">
<Selectivity>0.9009%</Selectivity>
</Property>
<Property name="ANAPACUStartTime">
<Selectivity>1.2195%</Selectivity>
</Property>
<Property name="ANAPACUTime">
<Selectivity>3.5714%</Selectivity>
</Property>
<Property name="ANAPlasma">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAPlasmaCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAPlatelets">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAPlateletsCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAPostOperInstructions">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAPrevAnaestDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANAPrevMethodDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANAPrevRecOpDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAPrevRecSPPPDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ANARBOperatingRoomDR">
<Selectivity>0.4329%</Selectivity>
</Property>
<Property name="ANAReasonSuspendDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANARecovOperDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANARecovSPPPDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANARedCells">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANARedCellsCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANASourceType">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANAStatus">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANASupervisorDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANASurgFinishTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANASurgStartTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANASurgeryDuration">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANATheatreInDate">
<Selectivity>0.8000%</Selectivity>
</Property>
<Property name="ANATheatreInTime">
<Selectivity>1.3699%</Selectivity>
</Property>
<Property name="ANATheatreOutDate">
<Selectivity>0.8264%</Selectivity>
</Property>
<Property name="ANATheatreOutTime">
<Selectivity>1.1905%</Selectivity>
</Property>
<Property name="ANATotalInput">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANATotalOutput">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANATransLocDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="ANAUpdateDate">
<Selectivity>0.6944%</Selectivity>
</Property>
<Property name="ANAUpdateHospitalDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ANAUpdateTime">
<Selectivity>0.2681%</Selectivity>
</Property>
<Property name="ANAUpdateUserDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ANA_ASA_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ANA_AmtBloodLoss">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANA_AmtBloodTranfused">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ANA_AmtFluidInfused">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ANA_AmtUrineOutput">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANA_AnaFinishTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ANA_AnaStartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANA_Anaesthetist_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANA_AreaInDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ANA_AreaInTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ANA_AreaOutDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ANA_AreaOutTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ANA_BldtType_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ANA_COMP_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ANA_Colloids">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ANA_Consultant_DR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ANA_Crystalloids">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ANA_Cuff_IntubTube">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ANA_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="ANA_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANA_ExtubDone">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ANA_ExtubTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ANA_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ANA_IntSize_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ANA_IntubGrade_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ANA_IntubRoute_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ANA_Method">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANA_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANA_Notes">
<Node>"TXT"</Node>
</Data>
<Data name="ANA_ORAnaNurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANA_OutcomeOfSurgery_DR">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="ANA_PACUAnaDischarge_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANA_PACUAnaNurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANA_PACU_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ANA_PACU_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ANA_PACU_ReadyLeaveDate">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="ANA_PACU_ReadyLeaveTime">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="ANA_PACU_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ANA_PACU_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ANA_Plasma">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ANA_PlasmaCode">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ANA_Platelets">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ANA_PlateletsCode">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ANA_PostOperInstructions">
<Node>"POSTOP"</Node>
</Data>
<Data name="ANA_PrevAnaest_DR">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="ANA_PrevMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="ANA_PrevRecOp_DR">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="ANA_PrevRecSPPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="ANA_RBOperatingRoom_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="ANA_Reason_Suspend_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ANA_RecovOper_DR">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="ANA_RecovSPPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="ANA_RedCells">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ANA_RedCellsCode">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ANA_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ANA_Status">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ANA_Supervisor_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANA_SurgFinishTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ANA_SurgStartTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ANA_TheatreInDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ANA_TheatreInTime">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ANA_TheatreOutDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ANA_TheatreOutTime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ANA_TransLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ANA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="ANA_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="ANA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="ANA_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Global>^OR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ANA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^OR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ANA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ana-No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANA_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRBOP">
<Global>^OR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ANA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RBOP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANA_RBOperatingRoom_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ANA_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnaesthesiaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
