/// CT Location               (CTLOC,7)
/// 科室（业务单元）
Class User.CTLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_Loc, StorageStrategy = SQLStorage ]
{

Relationship ChildCTLocRpt As CTLocRpt [ Cardinality = children, Inverse = LOCRPCTLOCParRef ];

Relationship ChildINCSterileItems As INCSterileItems [ Cardinality = children, Inverse = STERParRef ];

Relationship ChildCTLocMRType As CTLocMRType [ Cardinality = children, Inverse = MRTYPEParRef ];

Relationship ChildCTLocSimilarDepartment As CTLocSimilarDepartment [ Cardinality = children, Inverse = DEPParRef ];

Relationship ChildCTLocResultDeliveryTime As CTLocResultDeliveryTime [ Cardinality = children, Inverse = RDTParRef ];

Relationship ChildCTLocObservationGroup As CTLocObservationGroup [ Cardinality = children, Inverse = OBSParRef ];

Relationship ChildCTLocEpisSubType As CTLocEpisSubType [ Cardinality = children, Inverse = SUBTParRef ];

Relationship ChildCTLocCartTimes As CTLocCartTimes [ Cardinality = children, Inverse = CARTParRef ];

Relationship ChildCTLocMRRequirements As CTLocMRRequirements [ Cardinality = children, Inverse = MRParRef ];

Relationship ChildCTLocLinkLocation As CTLocLinkLocation [ Cardinality = children, Inverse = LINKParRef ];

Relationship ChildCTLocBorrowPref As CTLocBorrowPref [ Cardinality = children, Inverse = BORPRParRef ];

Relationship ChildCTLocCPType As CTLocCPType [ Cardinality = children, Inverse = CPTParRef ];

Relationship ChildCTLocTransport As CTLocTransport [ Cardinality = children, Inverse = TRANSPParRef ];

Relationship ChildCTLocInterpreter As CTLocInterpreter [ Cardinality = children, Inverse = INTERPParRef ];

Relationship ChildCTLocApprovedBeds As CTLocApprovedBeds [ Cardinality = children, Inverse = APBParRef ];

Relationship ChildCTLocStockFavourites As CTLocStockFavourites [ Cardinality = children, Inverse = STFParRef ];

Relationship ChildRBLocSchedule As RBLocSchedule [ Cardinality = children, Inverse = LSCTLOCParRef ];

Relationship ChildCTLocLinkWard As CTLocLinkWard [ Cardinality = children, Inverse = LINKWardParRef ];

/// 添加专项护理子表
Relationship ChildCTLocLinkSpNur As CTLocLinkSpNur [ Cardinality = children, Inverse = SpNurParRef ];

/// 科主任子表
Relationship ChildCTLocDepHeadUser As CTLocDepHeadUser [ Cardinality = children, Inverse = CTDHUParRef ];

/// 业务单元代码
Property CTLOCCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTLOC_Code ];

/// 业务单元名称
Property CTLOCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CTLOC_Desc ];

/// Des Ref to GLCCC (Cost Center)
Property CTLOCGLCCCDR As GLCCC [ SqlColumnNumber = 5, SqlFieldName = CTLOC_GLCCC_DR ];

/// Location Password
Property CTLOCPassword As %String(COLLATION = "AlphaUp", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CTLOC_Password ];

/// Ward Flag
Property CTLOCWardFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CTLOC_WardFlag ];

/// Address
Property CTLOCAddress As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CTLOC_Address, SqlListType = SUBNODE ];

/// 是否有效(Y/N)
Property CTLOCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = CTLOC_ActiveFlag ];

/// Des Ref to CTLOC
Property CTLOCCashierDR As CTLoc [ SqlColumnNumber = 17, SqlFieldName = CTLOC_Cashier_DR ];

/// Des Ref to CTLOC
Property CTLOCOTCDR As CTLoc [ SqlColumnNumber = 18, SqlFieldName = CTLOC_OTC_DR ];

/// Opening Time (Open)
Property CTLOCStartTime As %Time [ SqlColumnNumber = 19, SqlFieldName = CTLOC_StartTime ];

/// Operation End Time (close)
Property CTLOCEndTime As %Time [ SqlColumnNumber = 20, SqlFieldName = CTLOC_EndTime ];

/// Create Queue Flag (By Own Dept)
Property CTLOCOwnQueFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 21, SqlFieldName = CTLOC_OwnQueFlag ];

/// Create Queue Flag (By Other Dept)
Property CTLOCRecQueFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 22, SqlFieldName = CTLOC_RecQueFlag ];

/// Location Type
Property CTLOCType As %String(DISPLAYLIST = ",Ward,Execute,Drug Injection,Dispensing,Cashier,Other,Operating Theatre,Emergency,Day Surgery,Medical Records,OutPatient Consulting Room,Clinic,Admission Point", MAXLEN = 26, TRUNCATE = 1, VALUELIST = ",W,E,DI,D,C,O,OP,EM,DS,MR,OR,CL,ADM") [ SqlColumnNumber = 27, SqlFieldName = CTLOC_Type ];

/// Primary Dispensing Location DR
Property CTLOCDispLocDR As CTLoc [ SqlColumnNumber = 39, SqlFieldName = CTLOC_DispLoc_DR ];

/// Floor
Property CTLOCFloor As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = CTLOC_Floor ];

/// Des Ref to CT_NFMI
Property CTLOCNFMIDR As CTNFMICategDepart [ SqlColumnNumber = 41, SqlFieldName = CTLOC_NFMI_DR ];

/// CSR Flag
Property CTLOCLaundry As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 42, SqlFieldName = CTLOC_Laundry ];

/// Des Ref to Dep_DR
Property CTLOCDepDR As RBCDepartmentGroup [ SqlColumnNumber = 43, SqlFieldName = CTLOC_Dep_DR ];

/// Different Sex Patients in Room
Property CTLOCDifferentSexPatients As %String(DISPLAYLIST = ",Does Not Matter,Warning,Not Allowed", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",D,W,N") [ SqlColumnNumber = 44, SqlFieldName = CTLOC_DifferentSexPatients ];

/// Build Index by Order Date
Property CTLOCIndex As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = CTLOC_Index ];

/// Des Ref Hospital
Property CTLOCHospitalDR As CTHospital [ SqlColumnNumber = 46, SqlFieldName = CTLOC_Hospital_DR ];

/// Order Execute Confirmation
Property CTLOCExecuteConfirmation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = CTLOC_ExecuteConfirmation ];

/// 开始日期
Property CTLOCDateActiveFrom As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 48, SqlFieldName = CTLOC_DateActiveFrom ];

/// 结束日期
Property CTLOCDateActiveTo As %Date [ SqlColumnNumber = 49, SqlFieldName = CTLOC_DateActiveTo ];

/// Rehabilitative Flag
Property CTLOCRehabilitativeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = CTLOC_RehabilitativeFlag ];

/// Medical Record Active at this Location
Property CTLOCMedicalRecordActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = CTLOC_MedicalRecordActive ];

/// Des Ref DefaultMRType
Property CTLOCDefaultMRTypeDR As RTCMRecordType [ SqlColumnNumber = 55, SqlFieldName = CTLOC_DefaultMRType_DR ];

/// Result Delivery
Property CTLOCResultDelivery As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = CTLOC_ResultDelivery ];

/// Des Ref RespUnit
Property CTLOCRespUnitDR As CTResponsibleUnit [ SqlColumnNumber = 57, SqlFieldName = CTLOC_RespUnit_DR ];

/// Des Ref Patient Age Sex Mix
Property CTLOCPatientAgeSexMixDR As PACPatientAgeSexMix [ SqlColumnNumber = 58, SqlFieldName = CTLOC_PatientAgeSexMix_DR ];

/// Des Ref Intend Clinical Care Intensity
Property CTLOCIntendClinCareIntensityDR As PACIntendClinCareIntens [ SqlColumnNumber = 59, SqlFieldName = CTLOC_IntendClinCareIntensity_DR ];

/// Des Ref Broad Patient Group
Property CTLOCBroadPatientGroupDR As PACBroadPatientGroup [ SqlColumnNumber = 60, SqlFieldName = CTLOC_BroadPatientGroup_DR ];

/// Weekly Availability Indicator
Property CTLOCWeeklyAvailIndicator As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = CTLOC_WeeklyAvailIndicator ];

/// Open Overnight Indicator
Property CTLOCOpenOvernightIndicator As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = CTLOC_OpenOvernightIndicator ];

/// Des Ref Signif Facility
Property CTLOCSignifFacilityDR As CTSignificantFacility [ SqlColumnNumber = 63, SqlFieldName = CTLOC_SignifFacility_DR ];

/// Not Used
Property CTLOCNotUsed As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 64, SqlFieldName = CTLOC_NotUsed ];

/// Des Ref ExtGroup
Property CTLOCExtGroupDR As CTLocExtGroup [ SqlColumnNumber = 65, SqlFieldName = CTLOC_ExtGroup_DR ];

/// External Information System
Property CTLOCExternalInfoSystem As %String(DISPLAYLIST = ",Kestral,AusLab,Apex,Merlin Rx,Pyxis Rx,Cardiobase,ClinPath,Triple G,Quest Diagnostics,HBCIS Imaging,EBM,Mitra PACS,GE PACS,AGFA PACS,LabTrak,Sonic Apollo", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",KES,AUS,APX,MER,PYS,CARD,CLN,TRPG,QST,HBCIS,EBM,MIT,GE,AGFA,LT,SONA") [ SqlColumnNumber = 66, SqlFieldName = CTLOC_ExternalInfoSystem ];

/// Telephone
Property CTLOCTelephone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 67, SqlFieldName = CTLOC_Telephone ];

/// Telephone Extension
Property CTLOCTelephoneExt As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 68, SqlFieldName = CTLOC_TelephoneExt ];

/// HL7 Orders Link
Property CTLOCHL7OrdersLink As SSHL7 [ SqlColumnNumber = 69, SqlFieldName = CTLOC_HL7OrdersLink ];

/// Contact Name
Property CTLOCContactName As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 70, SqlFieldName = CTLOC_ContactName ];

/// Floorplans Query
Property CTLOCFloorplanQuery As %String(DISPLAYLIST = ",Emergency,Emergency - RIE,Emergency B & R", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",E,R,B") [ SqlColumnNumber = 71, SqlFieldName = CTLOC_FloorplanQuery ];

/// Visiting Hours From
Property CTLOCVisitHrFrom As %Time [ SqlColumnNumber = 72, SqlFieldName = CTLOC_VisitHrFrom ];

/// Visiting Hours To
Property CTLOCVisitHrTo As %Time [ SqlColumnNumber = 73, SqlFieldName = CTLOC_VisitHrTo ];

/// Rest Period From
Property CTLOCRestPeriodFrom As %Time [ SqlColumnNumber = 74, SqlFieldName = CTLOC_RestPeriodFrom ];

/// Rest Period To
Property CTLOCRestPeriodTo As %Time [ SqlColumnNumber = 75, SqlFieldName = CTLOC_RestPeriodTo ];

/// Age From
Property CTLOCAgeFrom As %Float(MAXVAL = 150, MINVAL = 0) [ SqlColumnNumber = 76, SqlFieldName = CTLOC_AgeFrom ];

/// Age To
Property CTLOCAgeTo As %Float(MAXVAL = 200, MINVAL = 0) [ SqlColumnNumber = 77, SqlFieldName = CTLOC_AgeTo ];

/// National Code
Property CTLOCNationCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 78, SqlFieldName = CTLOC_NationCode ];

/// Send OrdersToRecLoc
Property CTLOCOrdersToRecLoc As %String(DISPLAYLIST = ",On patient payment,On order entry", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",P,O") [ SqlColumnNumber = 79, SqlFieldName = CTLOC_OrdersToRecLoc ];

/// Send HL7 Message On
Property CTLOCSendHL7MessageOn As %String(DISPLAYLIST = ",Order Entry,Specimen Collection,Patient Arrive,Appointment & Pt Arrive,Appointments Created,Non Radiology Appointment,Specimen Receive", MAXLEN = 25, TRUNCATE = 1, VALUELIST = ",OE,SC,PA,APPT,APC,NRA,SR") [ SqlColumnNumber = 80, SqlFieldName = CTLOC_SendHL7MessageOn ];

/// Department Head UserDR
Property CTLOCDepartmentHeadUserDR As SSUser [ SqlColumnNumber = 81, SqlFieldName = CTLOC_DepartmentHeadUserDR ];

/// Pager Number
Property CTLOCPagerNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 82, SqlFieldName = CTLOC_PagerNo ];

/// Email
Property CTLOCEmail As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 83, SqlFieldName = CTLOC_Email ];

/// Fax
Property CTLOCFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 84, SqlFieldName = CTLOC_Fax ];

/// Days to AutoGenerate schedule overnight
Property CTLOCDaysAutoGenerate As %Float [ SqlColumnNumber = 85, SqlFieldName = CTLOC_DaysAutoGenerate ];

/// MR Request Move Valid
Property CTLOCMRRequestMoveValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 86, SqlFieldName = CTLOC_MRRequestMoveValid ];

/// SNAP Flag
Property CTLOCSNAPFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 87, SqlFieldName = CTLOC_SNAPFlag ];

/// Multiple Date Ranges of Visit Hrs
Property CTLOCMultDateRangesVisitHrs As %String(COLLATION = "Exact", MAXLEN = 230, TRUNCATE = 1) [ SqlColumnNumber = 88, SqlFieldName = CTLOC_MultDateRangesVisitHrs ];

/// Mental Health Unit
Property CTLOCMentalHealthUnit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 89, SqlFieldName = CTLOC_MentalHealthUnit ];

/// Prefered Outlier Ward
Property CTLOCPreferedOutlierWard As PACWard [ SqlColumnNumber = 90, SqlFieldName = CTLOC_PreferedOutlierWard ];

/// Ward Single Sex
Property CTLOCWardSingleSex As CTSex [ SqlColumnNumber = 91, SqlFieldName = CTLOC_WardSingleSex ];

/// Print Labels for Urgent MR Request
Property CTLOCPrintLabelsUrgMRRequest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 92, SqlFieldName = CTLOC_PrintLabelsUrgMRRequest ];

/// Enable Discharge All Hyperlink
Property CTLOCEnableDischargeAllHyperlin As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 93, SqlFieldName = CTLOC_EnableDischargeAllHyperlink ];

/// InPatient Unit
Property CTLOCInPatientUnit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 94, SqlFieldName = CTLOC_InPatientUnit ];

/// OutPatient Unit
Property CTLOCOutPatientUnit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 95, SqlFieldName = CTLOC_OutPatientUnit ];

/// TimeSinceLastAppt
Property CTLOCTimeSinceLastAppt As %Float [ SqlColumnNumber = 96, SqlFieldName = CTLOC_TimeSinceLastAppt ];

/// Period
Property CTLOCPeriod As %String(DISPLAYLIST = ",Day,Month,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 97, SqlFieldName = CTLOC_Period ];

/// Disch Sum NotRequired
Property CTLOCDischSumNotRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 98, SqlFieldName = CTLOC_DischSumNotRequired ];

/// NatCode DateFrom
Property CTLOCNatCodeDateFrom As %Date [ SqlColumnNumber = 99, SqlFieldName = CTLOC_NatCodeDateFrom ];

/// NatCodeDateTo
Property CTLOCNatCodeDateTo As %Date [ SqlColumnNumber = 100, SqlFieldName = CTLOC_NatCodeDateTo ];

/// Signif Facil Date From
Property CTLOCSignFacilDateFrom As %Date [ SqlColumnNumber = 101, SqlFieldName = CTLOC_SignFacilDateFrom ];

/// Signif Facil DateTo
Property CTLOCSignifFacilDateTo As %Date [ SqlColumnNumber = 102, SqlFieldName = CTLOC_SignifFacilDateTo ];

/// Discharge Lounge
Property CTLOCDischargeLounge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 103, SqlFieldName = CTLOC_DischargeLounge ];

/// External Viewer Link
Property CTLOCExternalViewerLink As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 104, SqlFieldName = CTLOC_ExternalViewerLink ];

/// DaysToKeepRecord
Property CTLOCDaysToKeepRecord As %Float [ SqlColumnNumber = 105, SqlFieldName = CTLOC_DaysToKeepRecord ];

/// NATA Headings
Property CTLOCNATAHeadings As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 106, SqlFieldName = CTLOC_NATAHeadings, SqlListType = SUBNODE ];

/// WeeksSuspensionReview
Property CTLOCWeeksSuspensionReview As %Float [ SqlColumnNumber = 107, SqlFieldName = CTLOC_WeeksSuspensionReview ];

/// DaysForOPDOffer
Property CTLOCDaysForOPDOffer As %Float [ SqlColumnNumber = 108, SqlFieldName = CTLOC_DaysForOPDOffer ];

/// DaysForOPLetterResponse
Property CTLOCDaysForOPLetterResponse As %Float [ SqlColumnNumber = 109, SqlFieldName = CTLOC_DaysForOPLetterResponse ];

/// OffersBeforeIP OPWaitReset
Property CTLOCOffersBeforeIPOPWaitReset As %Float [ SqlColumnNumber = 110, SqlFieldName = CTLOC_OffersBeforeIP_OPWaitReset ];

/// DaysOfferOutcomeChange
Property CTLOCDaysOfferOutcomeChange As %Float [ SqlColumnNumber = 111, SqlFieldName = CTLOC_DaysOfferOutcomeChange ];

/// RadOrdAccessNoPrefix
Property CTLOCRadOrdAccessNoPrefix As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 112, SqlFieldName = CTLOC_RadOrdAccessNoPrefix ];

/// 新增字段 作为接收科室时能接收的就诊类型 ClinicType(门诊O,急诊E,住院I,体检H)
Property CTLOCClinicType As %String(MAXLEN = "") [ SqlColumnNumber = 113, SqlFieldName = CTLOC_ClinicType ];

/// 新增字段 允许无收治限制  
Property CTLOCAllowNoCureLimit As %String(MAXLEN = "") [ SqlColumnNumber = 114, SqlFieldName = CTLOC_AllowNoCureLimit ];

/// Stay in hospital 是否住院总签床
Property CTLOCBeInHospital As %String [ SqlColumnNumber = 115, SqlFieldName = CTLOC_BeInHospital ];

/// 指向科室多层分类	//update2020-1-2 钟荣枫
Property CTLOCCategoryDR As User.BDPCTLOCCategory [ SqlColumnNumber = 116, SqlFieldName = CTLOC_CategoryDR ];

/// 部门代码-外键20220923add
Property CTLOCDeptCode As CT.BDP.CT.HOSDepartment [ SqlColumnNumber = 117, SqlFieldName = CTLOC_DeptCode ];

/// 业务域代码-外键
Property CTLOCDomainCode As CT.BDP.CT.HOSBusiDomain [ SqlColumnNumber = 118, SqlFieldName = CTLOC_DomainCode ];

/// 物理位置
Property CTLOCLocation As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 119, SqlFieldName = CTLOC_Location ];

/// 系统创建日期
Property CTLOCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 120, SqlFieldName = CTLOC_CreateDate ];

/// 系统创建时间
Property CTLOCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 121, SqlFieldName = CTLOC_CreateTime ];

/// 系统创建人
Property CTLOCCreateUser As User.SSUser [ SqlColumnNumber = 122, SqlFieldName = CTLOC_CreateUser ];

/// 系统排序号
Property CTLOCSeqNo As %Float [ SqlColumnNumber = 123, SqlFieldName = CTLOC_SeqNo ];

/// 系统最后更新日期
Property CTLOCLastUpdateDate As %Date [ SqlColumnNumber = 124, SqlFieldName = CTLOC_LastUpdateDate ];

/// 系统最后更新时间
Property CTLOCLastUpdateTime As %Time [ SqlColumnNumber = 125, SqlFieldName = CTLOC_LastUpdateTime ];

/// 系统最新更新人
Property CTLOCLastUpdateUser As User.SSUser [ SqlColumnNumber = 126, SqlFieldName = CTLOC_LastUpdateUser ];

/// 拼音码
Property CTLOCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 127, SqlFieldName = CTLOC_PYCode ];

/// 五笔码
Property CTLOCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 128, SqlFieldName = CTLOC_WBCode ];

/// 备注
Property CTLOCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 129, SqlFieldName = CTLOC_Mark ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLoc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLoc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLoc","OnBeforeDelete")
 d VALDEL^at7
 d PREDEL^at7
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLoc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLoc","OnBeforeUpdate")
 d VALUPD^at7
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLoc","OnBeforeInsert")
 d VALINS^at7
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLoc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLoc","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CTLOC(0))</SqlIdExpression>
<SQLMap name="DataMasterCTLOC">
<Data name="CTLOC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTLOC_Address">
<Node>"ADDR"</Node>
</Data>
<Data name="CTLOC_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="CTLOC_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="CTLOC_AllowNoCureLimit">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="CTLOC_BeInHospital">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="CTLOC_BroadPatientGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="CTLOC_Cashier_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTLOC_CategoryDR">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="CTLOC_ClinicType">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="CTLOC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTLOC_ContactName">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="CTLOC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="CTLOC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="CTLOC_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="CTLOC_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CTLOC_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CTLOC_DaysAutoGenerate">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="CTLOC_DaysForOPDOffer">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="CTLOC_DaysForOPLetterResponse">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="CTLOC_DaysOfferOutcomeChange">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="CTLOC_DaysToKeepRecord">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="CTLOC_DefaultMRType_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CTLOC_Dep_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CTLOC_DepartmentHeadUserDR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="CTLOC_DeptCode">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="CTLOC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTLOC_DifferentSexPatients">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CTLOC_DischSumNotRequired">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="CTLOC_DischargeLounge">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="CTLOC_DispLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTLOC_DomainCode">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="CTLOC_Email">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="CTLOC_EnableDischargeAllHyperlink">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="CTLOC_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTLOC_ExecuteConfirmation">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CTLOC_ExtGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="CTLOC_ExternalInfoSystem">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="CTLOC_ExternalViewerLink">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="CTLOC_Fax">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="CTLOC_Floor">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTLOC_FloorplanQuery">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="CTLOC_GLCCC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTLOC_HL7OrdersLink">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="CTLOC_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CTLOC_InPatientUnit">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="CTLOC_Index">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CTLOC_IntendClinCareIntensity_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CTLOC_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="CTLOC_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="CTLOC_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="CTLOC_Laundry">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CTLOC_Location">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="CTLOC_MRRequestMoveValid">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="CTLOC_Mark">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Data name="CTLOC_MedicalRecordActive">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CTLOC_MentalHealthUnit">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="CTLOC_MultDateRangesVisitHrs">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="CTLOC_NATAHeadings">
<Node>"NATA"</Node>
</Data>
<Data name="CTLOC_NFMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CTLOC_NatCodeDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="CTLOC_NatCodeDateTo">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="CTLOC_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="CTLOC_NotUsed">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="CTLOC_OTC_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTLOC_OffersBeforeIP_OPWaitReset">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="CTLOC_OpenOvernightIndicator">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="CTLOC_OrdersToRecLoc">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="CTLOC_OutPatientUnit">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="CTLOC_OwnQueFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTLOC_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="CTLOC_PagerNo">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="CTLOC_Password">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTLOC_PatientAgeSexMix_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CTLOC_Period">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="CTLOC_PreferedOutlierWard">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="CTLOC_PrintLabelsUrgMRRequest">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="CTLOC_RadOrdAccessNoPrefix">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="CTLOC_RecQueFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTLOC_RehabilitativeFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CTLOC_RespUnit_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CTLOC_RestPeriodFrom">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="CTLOC_RestPeriodTo">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="CTLOC_ResultDelivery">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CTLOC_SNAPFlag">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="CTLOC_SendHL7MessageOn">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="CTLOC_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="CTLOC_SignFacilDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="CTLOC_SignifFacilDateTo">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="CTLOC_SignifFacility_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="CTLOC_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTLOC_Telephone">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="CTLOC_TelephoneExt">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="CTLOC_TimeSinceLastAppt">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="CTLOC_Type">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTLOC_VisitHrFrom">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="CTLOC_VisitHrTo">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="CTLOC_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="CTLOC_WardFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTLOC_WardSingleSex">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="CTLOC_WeeklyAvailIndicator">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="CTLOC_WeeksSuspensionReview">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CTLOC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOCCode">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTLOC_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTLOCDesc">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTLOC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCategory">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Category"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTLOC_CategoryDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepGrp">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DepGrp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTLOC_Dep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeptCode">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTLOC_DeptCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDomainCode">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowI</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DomainCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTLOC_DomainCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTLOC_Hospital_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrefward">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrefWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTLOC_PreferedOutlierWard}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CTLOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTLOC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTLOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTLOC_RowID</SqlRowIdName>
<StreamLocation>^User.CTLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
