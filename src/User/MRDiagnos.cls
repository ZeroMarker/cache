/// MR Diagnosis            (MRDIA,330)
Class User.MRDiagnos Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Diagnos, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MRDIAChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRDiagType As MRDiagType [ Cardinality = children, Inverse = TYPParRef ];

Relationship ChildMRDiagnosisAllocation As MRDiagnosisAllocation [ Cardinality = children, Inverse = ALLOCParRef ];

Relationship ChildMRDiagnosLymphInvasion As MRDiagnosLymphInvasion [ Cardinality = children, Inverse = DLIParRef ];

Relationship ChildMRDiagnosDistalMetasta As MRDiagnosDistalMetasta [ Cardinality = children, Inverse = METParRef ];

Relationship ChildDHCMRDiagnosMainDiag As DHCMRDiagnosMainDiag [ Cardinality = children, Inverse = DMDParRef ];

/// MR_AdmLink Parent Reference
Relationship MRDIAMRADMParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRDiagnos, Required, SqlFieldName = MRDIA_MRADM_ParRef ];

/// MRDIA_Childsub
Property MRDIAChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"DIA",0))}, Required, SqlColumnNumber = 2, SqlFieldName = MRDIA_Childsub ];

/// Des Ref to MRCID
Property MRDIAICDCodeDR As MRCICDDx [ SqlColumnNumber = 4, SqlFieldName = MRDIA_ICDCode_DR ];

/// Date Detected
Property MRDIADateDetect As %Date [ SqlColumnNumber = 5, SqlFieldName = MRDIA_DateDetect ];

/// Des Ref to MRCIS
Property MRDIAICDStatusDR As MRCICDStat [ SqlColumnNumber = 6, SqlFieldName = MRDIA_ICDStatus_DR ];

/// Work Related
Property MRDIAWorkRelated As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MRDIA_WorkRelated ];

/// Des Ref to CTPCP
Property MRDIADocCodeDR As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = MRDIA_DocCode_DR ];

/// Des Ref to MRCSI
Property MRDIAICDSupDR As MRCSuppICD [ SqlColumnNumber = 9, SqlFieldName = MRDIA_ICDSup_DR ];

/// Description
Property MRDIADesc As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MRDIA_Desc, SqlListType = SUBNODE ];

/// Date
Property MRDIADate As %Date [ SqlColumnNumber = 14, SqlFieldName = MRDIA_Date ];

/// Time
Property MRDIATime As %Time [ SqlColumnNumber = 15, SqlFieldName = MRDIA_Time ];

/// Des Ref to MRC_DiagStat
Property MRDIADiagStatDR As MRCDiagnosStatus [ SqlColumnNumber = 16, SqlFieldName = MRDIA_DiagStat_DR ];

/// Des Ref SignSym
Property MRDIASignSymDR As MRCDiagnosSignSymptom [ SqlColumnNumber = 17, SqlFieldName = MRDIA_SignSym_DR ];

/// DRG Order
Property MRDIADRGOrder As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = MRDIA_DRGOrder ];

/// Des Ref User
Property MRDIAUpdateUserDR As SSUser [ SqlColumnNumber = 19, SqlFieldName = MRDIA_UpdateUser_DR ];

/// Des Ref DiagnosisGroup1
Property MRDIADiagnosisGroup1DR As MRCDiagnosisGroup1 [ SqlColumnNumber = 20, SqlFieldName = MRDIA_DiagnosisGroup1_DR ];

/// Des Ref DiagnosisGroup2
Property MRDIADiagnosisGroup2DR As MRCDiagnosisGroup2 [ SqlColumnNumber = 21, SqlFieldName = MRDIA_DiagnosisGroup2_DR ];

/// Des Ref StageClas
Property MRDIAStageClasDR As PACStageClassification [ SqlColumnNumber = 22, SqlFieldName = MRDIA_StageClas_DR ];

/// Des Ref Tumour
Property MRDIATumourDR As PACTumour [ SqlColumnNumber = 23, SqlFieldName = MRDIA_Tumour_DR ];

/// Des Ref LymphNode
Property MRDIALymphNodeDR As PACLymphNode [ SqlColumnNumber = 24, SqlFieldName = MRDIA_LymphNode_DR ];

/// Des REf DistalMet
Property MRDIADistalMetDR As PACDistalMetastasis [ SqlColumnNumber = 25, SqlFieldName = MRDIA_DistalMet_DR ];

/// Des Ref VenInvasion
Property MRDIAVenInvasionDR As PACVenousInvasion [ SqlColumnNumber = 26, SqlFieldName = MRDIA_VenInvasion_DR ];

/// Des Ref LymphInvas
Property MRDIALymphInvasDR As PACLymphInvasion [ SqlColumnNumber = 27, SqlFieldName = MRDIA_LymphInvas_DR ];

/// Des Ref MalGrade
Property MRDIAMalGradeDR As PACMalignancyGrade [ SqlColumnNumber = 28, SqlFieldName = MRDIA_MalGrade_DR ];

/// Des Ref ResTum_DR
Property MRDIAResTumDR As PACResidualTumour [ SqlColumnNumber = 29, SqlFieldName = MRDIA_ResTum_DR ];

/// Des Ref Stages_DR
Property MRDIAStagesDR As PACStage [ SqlColumnNumber = 30, SqlFieldName = MRDIA_Stages_DR ];

/// TumourSize
Property MRDIATumourSize As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = MRDIA_TumourSize ];

/// TumourNotes
Property MRDIATumourNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = MRDIA_TumourNotes, SqlListType = SUBNODE ];

/// Des Ref MRDIA
Property MRDIAMRDIADR As MRDiagnos [ SqlColumnNumber = 33, SqlFieldName = MRDIA_MRDIA_DR ];

/// Dagger Aster
Property MRDIADaggerAster As %String(DISPLAYLIST = ",Dagger,Aster", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,A") [ SqlColumnNumber = 34, SqlFieldName = MRDIA_DaggerAster ];

/// First Inset
Property MRDIAFirstInset As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = MRDIA_FirstInset ];

/// Prefix
Property MRDIAPrefix As %String(DISPLAYLIST = ",Primary,Complications,Associated,Morphology,E-code", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",P,C,A,M,E") [ SqlColumnNumber = 36, SqlFieldName = MRDIA_Prefix ];

/// Des Ref MappedICD
Property MRDIAMappedICDDR As MRCICDDx [ SqlColumnNumber = 37, SqlFieldName = MRDIA_MappedICD_DR ];

/// Des Ref ContractFlag
Property MRDIAContractFlagDR As MRCContractFlag [ SqlColumnNumber = 38, SqlFieldName = MRDIA_ContractFlag_DR ];

/// Des Ref Hospital
Property MRDIAUpdateHospitalDR As CTHospital [ SqlColumnNumber = 39, SqlFieldName = MRDIA_UpdateHospital_DR ];

/// UpdateDate
Property MRDIAUpdateDate As %Date [ SqlColumnNumber = 40, SqlFieldName = MRDIA_UpdateDate ];

/// UpdateTime
Property MRDIAUpdateTime As %Time [ SqlColumnNumber = 41, SqlFieldName = MRDIA_UpdateTime ];

/// TumourUpdateDate
Property MRDIATumourUpdateDate As %Date [ SqlColumnNumber = 42, SqlFieldName = MRDIA_TumourUpdateDate ];

/// TumourUpdateTime
Property MRDIATumourUpdateTime As %Time [ SqlColumnNumber = 43, SqlFieldName = MRDIA_TumourUpdateTime ];

/// Des Ref TumourUpdateUser
Property MRDIATumourUpdateUserDR As SSUser [ SqlColumnNumber = 44, SqlFieldName = MRDIA_TumourUpdateUser_DR ];

/// Des Ref TumourUpdateHospitalDR
Property MRDIATumourUpdateHospitalDR As CTHospital [ SqlColumnNumber = 45, SqlFieldName = MRDIA_TumourUpdateHospitalDR ];

/// Des Ref UserCreated
Property MRDIAUserCreatedDR As SSUser [ SqlColumnNumber = 46, SqlFieldName = MRDIA_UserCreated_DR ];

/// Des Ref DeletionReason
Property MRDIADeletionReasonDR As PACReasonForChangePatData [ SqlColumnNumber = 47, SqlFieldName = MRDIA_DeletionReason_DR ];

/// Des Ref PrimaryTumourSite
Property MRDIAPrimaryTumourSiteDR As OECBodySite [ SqlColumnNumber = 48, SqlFieldName = MRDIA_PrimaryTumourSite_DR ];

/// Questionnaire
Property MRDIAQuestionnaire As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = MRDIA_Questionnaire ];

/// AliasDiagText
Property MRDIAAliasDiagText As %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = MRDIA_AliasDiagText ];

/// AccidentDate
Property MRDIAAccidentDate As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = MRDIA_AccidentDate ];

/// DSReportFlag
Property MRDIADSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = MRDIA_DSReportFlag ];

/// Des Ref RiskEvaluation
Property MRDIARiskEvaluationDR As MRCRiskEvalParam [ SqlColumnNumber = 53, SqlFieldName = MRDIA_RiskEvaluation_DR ];

/// DateDiagnosisIdentified
Property MRDIADateDiagnosisIdentif As %Date [ SqlColumnNumber = 54, SqlFieldName = MRDIA_DateDiagnosisIdentif ];

/// Des Ref Consult
Property MRDIAConsultDR As PAPersonConsultSetCons [ SqlColumnNumber = 55, SqlFieldName = MRDIA_Consult_DR ];

/// Des Ref BodySite
Property MRDIABodySiteDR As OECBodySite [ SqlColumnNumber = 56, SqlFieldName = MRDIA_BodySite_DR ];

/// Des Ref Laterality
Property MRDIALateralityDR As PACLaterality [ SqlColumnNumber = 57, SqlFieldName = MRDIA_Laterality_DR ];

/// Des Ref Severity
Property MRDIASeverityDR As MRCSeverity [ SqlColumnNumber = 58, SqlFieldName = MRDIA_Severity_DR ];

/// DurationNum
Property MRDIADurationNum As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = MRDIA_DurationNum ];

/// DurationUnit
Property MRDIADurationUnit As %String(DISPLAYLIST = ",Days,Weeks,Months,Years,Hours,Minutes", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",D,W,M,Y,H,Min") [ SqlColumnNumber = 60, SqlFieldName = MRDIA_DurationUnit ];

/// Active
Property MRDIAActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = MRDIA_Active ];

/// OnsetDate
Property MRDIAOnsetDate As %Date [ SqlColumnNumber = 62, SqlFieldName = MRDIA_OnsetDate ];

/// OnsetTime
Property MRDIAOnsetTime As %Time [ SqlColumnNumber = 63, SqlFieldName = MRDIA_OnsetTime ];

/// EndDate
Property MRDIAEndDate As %Date [ SqlColumnNumber = 64, SqlFieldName = MRDIA_EndDate ];

/// EndTime
Property MRDIAEndTime As %Time [ SqlColumnNumber = 65, SqlFieldName = MRDIA_EndTime ];

/// TimeDiagnosisIdentif
Property MRDIATimeDiagnosisIdentif As %Time [ SqlColumnNumber = 66, SqlFieldName = MRDIA_TimeDiagnosisIdentif ];

/// Approximate
Property MRDIAApproximate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 67, SqlFieldName = MRDIA_Approximate ];

/// Main Diagnos Flag
Property MRDIAMainDiagFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 68, SqlFieldName = MRDIA_MainDiagFlag ];

/// Main Body Part
Property MRDIABodyPart As %String(MAXLEN = 3, TRUNCATE = 1) [ SqlColumnNumber = 69, SqlFieldName = MRDIA_BodyPart ];

/// 诊断前缀,用于在ICD诊断不能有效表达医生诊断时,此问题可以在显示时显示在诊断ICD描述之前,诊断描述字段MRDIADesc可以做为后缀显示
Property MRDIAPrefixDesc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 70, SqlFieldName = MRDIA_PrefixDesc ];

Property MRDIAAddDate As %Date [ SqlColumnNumber = 71, SqlFieldName = MRDIA_AddDate ];

Property MRDIAAddTime As %Time [ SqlColumnNumber = 72, SqlFieldName = MRDIA_AddTime ];

/// 长效诊断标识
/// LongDiagnosFlagRowId
Property MRDIALongDiagnosFlag As %String(DISPLAYLIST = ",Loc,Hosp", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",L,H") [ SqlColumnNumber = 73, SqlFieldName = MRDIA_LongDiagnosFlag ];

/// 更新诊断科室
Property MRDIAUpdateLocDr As CTLoc [ SqlColumnNumber = 74, SqlFieldName = MRDIA_UpdateLoc_Dr ];

/// 下诊断科室
Property MRDIAAddLocDr As CTLoc [ SqlColumnNumber = 75, SqlFieldName = MRDIA_AddLoc_Dr ];

///  诊断前缀
Property MRDIADiagnosPrefix As %String [ SqlColumnNumber = 76, SqlFieldName = MRDIA_DiagnosPrefix ];

/// 诊断级别
Property MRDIALevel As %String [ SqlColumnNumber = 77, SqlFieldName = MRDIA_Level ];

/// 诊断顺序号
Property MRDIASequence As %String [ SqlColumnNumber = 78, SqlFieldName = MRDIA_Sequence ];

/// 下诊断方式
Property MRDIAAddDiagnoseWay As %String(DISPLAYLIST = ",OP,Doc,Nur", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",O,D,N") [ SqlColumnNumber = 79, SqlFieldName = MRDIA_AddDiagnoseWay ];

/// 医保结算诊断主诊断标识
Property MRDIAInsuMainDiagFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 80, SqlFieldName = MRDIA_InsuMainDiagFlag ];

/// 中医治法指向
Property MRDIATCMTreatDR As MRCTCMTreatment [ SqlColumnNumber = 81, SqlFieldName = MRDIA_TCMTreat_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRDiagnos).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnos","OnAfterInsert")
 d Table^HL7Outbound("MRDiagnos",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRDiagnos).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnos","OnAfterUpdate")
 d Table^HL7Outbound("MRDiagnos",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRDiagnos).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnos","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRDiagnos).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnos","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnos","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRDiagnos).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRDiagnos","OnAfterDelete")
 d Table^HL7Outbound("MRDiagnos",%old(1),"Delete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexCons">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRDIA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DIAGCons"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRDIA_Consult_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRDIA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRDIA_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRDIA_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRDIA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRDIA">
<Condition>1</Condition>
<Global>^MR</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>MRDIA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRDIA_MRDIA_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRDIA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRDIA_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRDIA_UpdateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRDIA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MRDIADataMasterMap">
<Data name="MRDIA_AccidentDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MRDIA_Active">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MRDIA_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="MRDIA_AddDiagnoseWay">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>27</Piece>
</Data>
<Data name="MRDIA_AddLoc_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>25</Piece>
</Data>
<Data name="MRDIA_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="MRDIA_AliasDiagText">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MRDIA_Approximate">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="MRDIA_BodyPart">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="MRDIA_BodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MRDIA_Consult_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MRDIA_ContractFlag_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MRDIA_DRGOrder">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRDIA_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MRDIA_DaggerAster">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="MRDIA_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRDIA_DateDetect">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRDIA_DateDiagnosisIdentif">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MRDIA_DeletionReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MRDIA_Desc">
<Node>"DES"</Node>
</Data>
<Data name="MRDIA_DiagStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRDIA_DiagnosPrefix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>26</Piece>
</Data>
<Data name="MRDIA_DiagnosisGroup1_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MRDIA_DiagnosisGroup2_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MRDIA_DistalMet_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="MRDIA_DocCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRDIA_DurationNum">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MRDIA_DurationUnit">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MRDIA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MRDIA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MRDIA_FirstInset">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="MRDIA_ICDCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRDIA_ICDStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRDIA_ICDSup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRDIA_InsuMainDiagFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>28</Piece>
</Data>
<Data name="MRDIA_Laterality_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MRDIA_Level">
<Delimiter>"^"</Delimiter>
<Node>"EPR"</Node>
<Piece>1</Piece>
</Data>
<Data name="MRDIA_LongDiagnosFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Data name="MRDIA_LymphInvas_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="MRDIA_LymphNode_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="MRDIA_MRDIA_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MRDIA_MainDiagFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="MRDIA_MalGrade_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="MRDIA_MappedICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MRDIA_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MRDIA_OnsetTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MRDIA_Prefix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="MRDIA_PrefixDesc">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="MRDIA_PrimaryTumourSite_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="MRDIA_Questionnaire">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MRDIA_ResTum_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="MRDIA_RiskEvaluation_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MRDIA_Sequence">
<Delimiter>"^"</Delimiter>
<Node>"EPR"</Node>
<Piece>2</Piece>
</Data>
<Data name="MRDIA_Severity_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MRDIA_SignSym_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRDIA_StageClas_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="MRDIA_Stages_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="MRDIA_TCMTreat_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>29</Piece>
</Data>
<Data name="MRDIA_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRDIA_TimeDiagnosisIdentif">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="MRDIA_TumourNotes">
<Node>"TN"</Node>
</Data>
<Data name="MRDIA_TumourSize">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="MRDIA_TumourUpdateDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="MRDIA_TumourUpdateHospitalDR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="MRDIA_TumourUpdateTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="MRDIA_TumourUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="MRDIA_Tumour_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="MRDIA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MRDIA_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MRDIA_UpdateLoc_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="MRDIA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MRDIA_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MRDIA_UserCreated_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="MRDIA_VenInvasion_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="MRDIA_WorkRelated">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRDIA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DIA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRDIA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRDIA_RowId</SqlRowIdName>
<StreamLocation>^User.MRDiagnosS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
