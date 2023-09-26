/// PA Adm2(2481)
Class User.PAAdm2 Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Adm2, StorageStrategy = SQLStorage ]
{

Relationship ChildPAAdm2DischargeSummary As PAAdm2DischargeSummary [ Cardinality = children, Inverse = DISParRef ];

Relationship ChildPAAdm2RefStatHistory As PAAdm2RefStatHistory [ Cardinality = children, Inverse = REFHISParRef ];

Relationship ChildPAAdm2MaternityComplic As PAAdm2MaternityComplic [ Cardinality = children, Inverse = MATCParRef ];

Relationship ChildPAAdm2QualStatHistory As PAAdm2QualStatHistory [ Cardinality = children, Inverse = QUALParRef ];

Relationship ChildPAAdm2GroupNumber As PAAdm2GroupNumber [ Cardinality = children, Inverse = GRPParRef ];

Relationship ChildPAAdm2FreqAttendActions As PAAdm2FreqAttendActions [ Cardinality = children, Inverse = FRAParRef ];

/// Des Ref RefStatusReason
Property PAADM2RefStatusReasonDR As PACReferralStatusReason [ SqlColumnNumber = 2, SqlFieldName = PAADM2_RefStatusReason_DR ];

/// IndigLiasionVisit
Property PAADM2IndigLiasionVisit As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 3, SqlFieldName = PAADM2_IndigLiasionVisit ];

/// ClergyVisit
Property PAADM2ClergyVisit As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 4, SqlFieldName = PAADM2_ClergyVisit ];

/// HospitalInsurance
Property PAADM2HospitalInsurance As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 5, SqlFieldName = PAADM2_HospitalInsurance ];

/// Des Ref AdmissionPoint
Property PAADM2AdmissionPointDR As PACAdmissionPoint [ SqlColumnNumber = 6, SqlFieldName = PAADM2_AdmissionPoint_DR ];

/// OT Registration
Property PAADM2OTReg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PAADM2_OTReg ];

/// Des Ref CodingUpdateHospital
Property PAADM2CodingUpdateHospital As CTHospital [ SqlColumnNumber = 8, SqlFieldName = PAADM2_CodingUpdateHospital ];

/// Des Ref FinancialDischUser
Property PAADM2FinancialDischUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = PAADM2_FinancialDischUser_DR ];

/// Des Ref FinalDischUser
Property PAADM2FinalDischUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = PAADM2_FinalDischUser_DR ];

/// Des Ref PAADM
Property PAADM2PAADMDR As PAAdm [ SqlColumnNumber = 11, SqlComputeCode = { s {PAADM2_PAADM_DR}={PAADM2_RowId}
}, SqlComputed, SqlFieldName = PAADM2_PAADM_DR, Transient ];

/// VerifiedCoding
Property PAADM2VerifiedCoding As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PAADM2_VerifiedCoding ];

/// Injury
Property PAADM2Injury As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PAADM2_Injury ];

/// Des Ref NamedMidwife
Property PAADM2NamedMidwifeDR As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = PAADM2_NamedMidwife_DR ];

/// Des Ref AdmLabourStatus
Property PAADM2AdmLabourStatusDR As PACAdmLabourStatus [ SqlColumnNumber = 15, SqlFieldName = PAADM2_AdmLabourStatus_DR ];

/// DischWeight
Property PAADM2DischWeight As %Float [ SqlColumnNumber = 16, SqlFieldName = PAADM2_DischWeight ];

/// Disch Head Circumfer
Property PAADM2DischHeadCircumfer As %Float [ SqlColumnNumber = 17, SqlFieldName = PAADM2_DischHeadCircumfer ];

/// Des REf DischFeeding
Property PAADM2DischFeedingDR As PACFeedOnDischarge [ SqlColumnNumber = 18, SqlFieldName = PAADM2_DischFeeding_DR ];

/// DischSumNotRequired
Property PAADM2DischSumNotRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = PAADM2_DischSumNotRequired ];

/// Des Ref PANOK
Property PAADM2PANOKDR As PANok [ SqlColumnNumber = 20, SqlFieldName = PAADM2_PANOK_DR ];

/// CriteriaTypeC
Property PAADM2CriteriaTypeC As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = PAADM2_CriteriaTypeC ];

/// OnHold
Property PAADM2OnHold As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = PAADM2_OnHold ];

/// OnHoldReason
Property PAADM2OnHoldReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PAADM2_OnHoldReason ];

/// EstimateDateInjury
Property PAADM2EstimateDateInjury As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = PAADM2_EstimateDateInjury ];

/// EDIOverride
Property PAADM2EDIOverride As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = PAADM2_EDIOverride ];

/// Des Ref CTLOC
Property PAADM2AdmPointLocDR As CTLoc [ SqlColumnNumber = 26, SqlFieldName = PAADM2_AdmPointLoc_DR ];

/// Des Ref BillingLang
Property PAADM2BillingLangDR As PACPreferredLanguage [ SqlColumnNumber = 27, SqlFieldName = PAADM2_BillingLang_DR ];

/// Name
Property PAADM2Name As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = PAADM2_Name ];

/// Name2
Property PAADM2Name2 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = PAADM2_Name2 ];

/// Name3
Property PAADM2Name3 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PAADM2_Name3 ];

/// Name4
Property PAADM2Name4 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = PAADM2_Name4 ];

/// Des Ref ReferredToHospital
Property PAADM2ReferredToHospitalDR As CTHospital [ SqlColumnNumber = 32, SqlFieldName = PAADM2_ReferredToHospital_DR ];

/// PalliativeCarePatDays
Property PAADM2PalliativeCarePatDays As %Float [ SqlColumnNumber = 33, SqlFieldName = PAADM2_PalliativeCarePatDays ];

/// Expected AdmTime
Property PAADM2ExpAdmTime As %Time [ SqlColumnNumber = 34, SqlFieldName = PAADM2_ExpAdmTime ];

/// TriageSympSum
Property PAADM2TriageSympSum As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = PAADM2_TriageSympSum ];

/// WalkIn
Property PAADM2WalkIn As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = PAADM2_WalkIn ];

/// Functional Assessment Date on Admisson
Property PAADM2FuncAssessDateAdm As %Date [ SqlColumnNumber = 37, SqlFieldName = PAADM2_FuncAssessDateAdm ];

/// Functional Assessment Date on Discharge
Property PAADM2FuncAssessDateDisch As %Date [ SqlColumnNumber = 38, SqlFieldName = PAADM2_FuncAssessDateDisch ];

/// Pract F Care Provider Des Ref
Property PAADM2PractFCareProvDR As CTCareProv [ SqlColumnNumber = 39, SqlFieldName = PAADM2_PractFCareProv_DR ];

/// Pract F Seen Date
Property PAADM2PractFSeenDate As %Date [ SqlColumnNumber = 40, SqlFieldName = PAADM2_PractFSeenDate ];

/// Pract F Seen Time
Property PAADM2PractFSeenTime As %Time [ SqlColumnNumber = 41, SqlFieldName = PAADM2_PractFSeenTime ];

/// OperationDate
Property PAADM2OperationDate As %Date [ SqlColumnNumber = 42, SqlFieldName = PAADM2_OperationDate ];

/// OperationTime
Property PAADM2OperationTime As %Time [ SqlColumnNumber = 43, SqlFieldName = PAADM2_OperationTime ];

/// Des Ref BillAdm
Property PAADM2BillAdmDR As PAAdm [ SqlColumnNumber = 44, SqlFieldName = PAADM2_BillAdm_DR ];

/// SystemSession
Property PAADM2SystemSession As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = PAADM2_SystemSession ];

/// Des Ref PAPersonPatMas
Property PAADM2PAPersonPatMasDR As PAPersonPatMas [ SqlColumnNumber = 46, SqlFieldName = PAADM2_PAPersonPatMas_DR ];

/// Des Ref Service
Property PAADM2ServiceDR As RBCServices [ SqlColumnNumber = 47, SqlFieldName = PAADM2_Service_DR ];

/// Des Ref APPTLoc
Property PAADM2APPTLocDR As CTLoc [ SqlColumnNumber = 48, SqlFieldName = PAADM2_APPTLoc_DR ];

/// MultiAppt
Property PAADM2MultiAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = PAADM2_MultiAppt ];

/// Des Ref FreqAttendConcernLev
Property PAADM2FreqAttendConcernLevDR As PACFreqAttendConcernLev [ SqlColumnNumber = 50, SqlFieldName = PAADM2_FreqAttendConcernLev_DR ];

/// FreqAttendComments
Property PAADM2FreqAttendComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = PAADM2_FreqAttendComments, SqlListType = subnode ];

/// Des Ref FreqAttendUpdateUser
Property PAADM2FreqAttendUpdateUserDR As SSUser [ SqlColumnNumber = 52, SqlFieldName = PAADM2_FreqAttendUpdateUser_DR ];

/// FreqAttendUpdateDate
Property PAADM2FreqAttendUpdateDate As %Date [ SqlColumnNumber = 53, SqlFieldName = PAADM2_FreqAttendUpdateDate ];

/// FreqAttendUpdateTime
Property PAADM2FreqAttendUpdateTime As %Time [ SqlColumnNumber = 54, SqlFieldName = PAADM2_FreqAttendUpdateTime ];

/// Des Ref DeftTreatInit
Property PAADM2DeftTreatInitDR As PACDefTreatmentInitiator [ SqlColumnNumber = 55, SqlFieldName = PAADM2_DeftTreatInit_DR ];

/// ViewablebyEpLoc
Property PAADM2ViewablebyEpLoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = PAADM2_ViewablebyEpLoc ];

/// Des Ref PatType
Property PAADM2PatTypeDR As PACPatientType [ SqlColumnNumber = 57, SqlFieldName = PAADM2_PatType_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAAdm2).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAAdm2).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAAdm2).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAAdm2).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAAdm2).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAADM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PAADM2_APPTLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>46</Piece>
</Data>
<Data name="PAADM2_AdmLabourStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>13</Piece>
</Data>
<Data name="PAADM2_AdmPointLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>24</Piece>
</Data>
<Data name="PAADM2_AdmissionPoint_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>4</Piece>
</Data>
<Data name="PAADM2_BillAdm_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>42</Piece>
</Data>
<Data name="PAADM2_BillingLang_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>25</Piece>
</Data>
<Data name="PAADM2_ClergyVisit">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>3</Piece>
</Data>
<Data name="PAADM2_CodingUpdateHospital">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>7</Piece>
</Data>
<Data name="PAADM2_CriteriaTypeC">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>19</Piece>
</Data>
<Data name="PAADM2_DeftTreatInit_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>52</Piece>
</Data>
<Data name="PAADM2_DischFeeding_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>16</Piece>
</Data>
<Data name="PAADM2_DischHeadCircumfer">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>15</Piece>
</Data>
<Data name="PAADM2_DischSumNotRequired">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>17</Piece>
</Data>
<Data name="PAADM2_DischWeight">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>14</Piece>
</Data>
<Data name="PAADM2_EDIOverride">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>23</Piece>
</Data>
<Data name="PAADM2_EstimateDateInjury">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>22</Piece>
</Data>
<Data name="PAADM2_ExpAdmTime">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>32</Piece>
</Data>
<Data name="PAADM2_FinalDischUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>8</Piece>
</Data>
<Data name="PAADM2_FinancialDischUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>9</Piece>
</Data>
<Data name="PAADM2_FreqAttendComments">
<Node>"ADM2","FRCMT"</Node>
</Data>
<Data name="PAADM2_FreqAttendConcernLev_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>48</Piece>
</Data>
<Data name="PAADM2_FreqAttendUpdateDate">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>50</Piece>
</Data>
<Data name="PAADM2_FreqAttendUpdateTime">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>51</Piece>
</Data>
<Data name="PAADM2_FreqAttendUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>49</Piece>
</Data>
<Data name="PAADM2_FuncAssessDateAdm">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>35</Piece>
</Data>
<Data name="PAADM2_FuncAssessDateDisch">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>36</Piece>
</Data>
<Data name="PAADM2_HospitalInsurance">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>5</Piece>
</Data>
<Data name="PAADM2_IndigLiasionVisit">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>2</Piece>
</Data>
<Data name="PAADM2_Injury">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>11</Piece>
</Data>
<Data name="PAADM2_MultiAppt">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>47</Piece>
</Data>
<Data name="PAADM2_Name">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>26</Piece>
</Data>
<Data name="PAADM2_Name2">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>27</Piece>
</Data>
<Data name="PAADM2_Name3">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>28</Piece>
</Data>
<Data name="PAADM2_Name4">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>29</Piece>
</Data>
<Data name="PAADM2_NamedMidwife_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>12</Piece>
</Data>
<Data name="PAADM2_OTReg">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>6</Piece>
</Data>
<Data name="PAADM2_OnHold">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>21</Piece>
</Data>
<Data name="PAADM2_OnHoldReason">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>20</Piece>
</Data>
<Data name="PAADM2_OperationDate">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>40</Piece>
</Data>
<Data name="PAADM2_OperationTime">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>41</Piece>
</Data>
<Data name="PAADM2_PANOK_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>18</Piece>
</Data>
<Data name="PAADM2_PAPersonPatMas_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>44</Piece>
</Data>
<Data name="PAADM2_PalliativeCarePatDays">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>31</Piece>
</Data>
<Data name="PAADM2_PatType_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>54</Piece>
</Data>
<Data name="PAADM2_PractFCareProv_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>37</Piece>
</Data>
<Data name="PAADM2_PractFSeenDate">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>38</Piece>
</Data>
<Data name="PAADM2_PractFSeenTime">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>39</Piece>
</Data>
<Data name="PAADM2_RefStatusReason_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>1</Piece>
</Data>
<Data name="PAADM2_ReferredToHospital_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>30</Piece>
</Data>
<Data name="PAADM2_Service_DR">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>45</Piece>
</Data>
<Data name="PAADM2_SystemSession">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>43</Piece>
</Data>
<Data name="PAADM2_TriageSympSum">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>33</Piece>
</Data>
<Data name="PAADM2_VerifiedCoding">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>10</Piece>
</Data>
<Data name="PAADM2_ViewablebyEpLoc">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>53</Piece>
</Data>
<Data name="PAADM2_WalkIn">
<Delimiter>"^"</Delimiter>
<Node>"ADM2"</Node>
<Piece>34</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAADM2_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAADM2_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillAdm">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAADM2_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BillAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAADM2_BillAdm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAADM2_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSystemSess">
<Global>^PAADMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PAADM2_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SystemSess"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAADM2_SystemSession}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAADM2_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAADM2_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdm2S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
