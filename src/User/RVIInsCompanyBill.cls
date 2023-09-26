/// RVI InsuranceCompanyBill(1275)
Class User.RVIInsCompanyBill Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVI_InsCompanyBill, StorageStrategy = SQLStorage ]
{

Relationship ChildRVIInsCoBillCharges As RVIInsCoBillCharges [ Cardinality = children, Inverse = ITMParRef ];

Relationship ChildRVIInsCoBillDiagnosis As RVIInsCoBillDiagnosis [ Cardinality = children, Inverse = DIAParRef ];

Relationship ChildRVIInsCoBillLocation As RVIInsCoBillLocation [ Cardinality = children, Inverse = LOCParRef ];

Relationship ChildRVIInsCoBillMergeDetails As RVIInsCoBillMergeDetails [ Cardinality = children, Inverse = MDParRef ];

Relationship ChildRVIInsCoBillTreatmentDays As RVIInsCoBillTreatmentDays [ Cardinality = children, Inverse = TDAYParRef ];

/// Batch No
Property INSBBatchNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = INSB_BatchNo ];

/// Bill Flag
Property INSBBillFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlComputeCode = { s {INSB_BillFlag}=$$CO15^at1275({INSB_Ins_DR},{INSB_BillPrinted})
}, SqlComputed, SqlFieldName = INSB_BillFlag, Transient ];

/// Bill No
Property INSBBillNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = INSB_BillNo ];

/// Bill Printed(Y/N)
Property INSBBillPrinted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = INSB_BillPrinted ];

/// Claim Month
Property INSBClaimMonth As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = INSB_ClaimMonth ];

/// Days In Hospital
Property INSBDaysInHospital As %Float [ SqlColumnNumber = 36, SqlFieldName = INSB_DaysInHospital ];

/// Discharge Medication Days
Property INSBDischargeMedicationDays As %Float [ SqlColumnNumber = 30, SqlFieldName = INSB_DischargeMedicationDays ];

/// Discharge Type
Property INSBDischargeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = INSB_DischargeType ];

/// Discharged Flag
Property INSBDischargedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = INSB_DischargedFlag ];

/// Des Ref CTCP
Property INSBDoctorDR As CTCareProv [ SqlColumnNumber = 20, SqlFieldName = INSB_Doctor_DR ];

/// Duration Calculated
Property INSBDurationCalc As %Float [ SqlColumnNumber = 32, SqlFieldName = INSB_Duration_Calc ];

/// Duration Entered
Property INSBDurationEntered As %Float [ SqlColumnNumber = 33, SqlFieldName = INSB_Duration_Entered ];

/// First Adm Date
Property INSBFirstAdmDate As %Date [ SqlColumnNumber = 24, SqlFieldName = INSB_FirstAdmDate ];

/// Des Ref to InsAssoc
Property INSBInsAssocDR As ARCInsurAssociation [ SqlColumnNumber = 22, SqlFieldName = INSB_InsAssoc_DR ];

/// Des Ref to InsType
Property INSBInsDR As ARCInsuranceType [ SqlColumnNumber = 2, SqlFieldName = INSB_Ins_DR ];

/// Des Ref InsSubType
Property INSBInsSubTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 21, SqlFieldName = INSB_InsSubType_DR ];

/// Insure Status
Property INSBInsureStatus As %String(DISPLAYLIST = ",Accepted,Rejected,Cut,Pending", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",A,R,C,P") [ SqlColumnNumber = 19, SqlFieldName = INSB_InsureStatus ];

/// Des Ref NFMI Dep
Property INSBNFMIDepDR As CTNFMICategDepart [ SqlColumnNumber = 23, SqlFieldName = INSB_NFMI_Dep_DR ];

/// No More Orders Add
Property INSBNoMoreOrdersAdd As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = INSB_NoMoreOrdersAdd ];

/// No Orders Flag
Property INSBNoOrdersFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = INSB_NoOrdersFlag ];

/// Operation_Performed
Property INSBOperationPerformed As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = INSB_Operation_Performed ];

/// Des Ref PAPMI
Property INSBPAPMIDR As PAPatMas [ SqlColumnNumber = 6, SqlFieldName = INSB_PAPMI_DR ];

/// Patient Type
Property INSBPatientType As %String(DISPLAYLIST = ",OutPatient,InPatient", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",O,I") [ SqlColumnNumber = 4, SqlFieldName = INSB_PatientType ];

/// Reason for Injury
Property INSBReasonInjury As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = INSB_Reason_Injury ];

/// Reclaim Amt
Property INSBReclaimAmt As %Float [ SqlColumnNumber = 25, SqlFieldName = INSB_ReclaimAmt ];

/// Registration No
Property INSBRegistrationNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlComputeCode = { s {INSB_RegistrationNo}=$$CO26^at1275({INSB_PAPMI_DR})
}, SqlComputed, SqlFieldName = INSB_RegistrationNo, Transient ];

/// Review Date
Property INSBReviewDate As %Date [ SqlColumnNumber = 42, SqlFieldName = INSB_ReviewDate ];

/// Review Status
Property INSBReviewStatus As %String(DISPLAYLIST = ",Editable,Fixed,Hold,Printed,Disputed,Closed", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",E,F,H,P,D,C") [ SqlColumnNumber = 18, SqlFieldName = INSB_ReviewStatus ];

/// Des Ref to ReviewType
Property INSBReviewTypeDR As RVCReviewType [ SqlColumnNumber = 5, SqlFieldName = INSB_ReviewType_DR ];

/// Special Code
Property INSBSpecialCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = INSB_SpecialCode ];

/// Split Date
Property INSBSplitDate As %Date [ SqlColumnNumber = 41, SqlFieldName = INSB_SplitDate ];

/// Ins Report Cut
Property INSBTotCut As %Float [ SqlColumnNumber = 16, SqlFieldName = INSB_TotCut ];

/// Total for Handicap Assoc
Property INSBTotHandicapAss As %Float [ SqlColumnNumber = 13, SqlFieldName = INSB_TotHandicapAss ];

/// Total for InsCo Serv
Property INSBTotInsCo As %Float [ SqlColumnNumber = 10, SqlFieldName = INSB_TotInsCo ];

/// Total for Ins Co Mat
Property INSBTotInsCoMat As %Float [ SqlColumnNumber = 14, SqlFieldName = INSB_TotInsCoMat ];

/// Amt Total Paid
Property INSBTotInsPaid As %Float [ SqlColumnNumber = 17, SqlFieldName = INSB_TotInsPaid ];

/// Total for Local Gov
Property INSBTotLocalGov As %Float [ SqlColumnNumber = 12, SqlFieldName = INSB_TotLocalGov ];

/// Tot Over Paid
Property INSBTotOverPaid As %Float [ SqlColumnNumber = 29, SqlFieldName = INSB_TotOverPaid ];

/// Total for Patient
Property INSBTotPatient As %Float [ SqlColumnNumber = 11, SqlFieldName = INSB_TotPatient ];

/// Tot Pending
Property INSBTotPending As %Float [ SqlColumnNumber = 28, SqlFieldName = INSB_TotPending ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVIInsCompanyBill).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCompanyBill","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVIInsCompanyBill).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCompanyBill","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVIInsCompanyBill).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCompanyBill","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVIInsCompanyBill).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCompanyBill","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVIInsCompanyBill).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCompanyBill","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RVI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INSB_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INSB_BillNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSB_BillPrinted">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSB_ClaimMonth">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSB_DaysInHospital">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INSB_DischargeMedicationDays">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INSB_DischargeType">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INSB_DischargedFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INSB_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INSB_Duration_Calc">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INSB_Duration_Entered">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INSB_FirstAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INSB_InsAssoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INSB_InsSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INSB_Ins_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSB_InsureStatus">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INSB_NFMI_Dep_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INSB_NoMoreOrdersAdd">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INSB_NoOrdersFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INSB_Operation_Performed">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INSB_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSB_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSB_Reason_Injury">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INSB_ReclaimAmt">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INSB_ReviewDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INSB_ReviewStatus">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INSB_ReviewType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSB_SpecialCode">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INSB_SplitDate">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INSB_TotCut">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INSB_TotHandicapAss">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSB_TotInsCo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSB_TotInsCoMat">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSB_TotInsPaid">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INSB_TotLocalGov">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSB_TotOverPaid">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INSB_TotPatient">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSB_TotPending">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^RVI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INSB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INSB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClaimMonth">
<Global>^RVI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INSB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ClaimMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSB_ClaimMonth}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSB_Ins_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSB_PatientType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INSB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Condition>{INSB_BillFlag}="N"</Condition>
<Global>^RVI</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>INSB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSB_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSB_ClaimMonth}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSB_Ins_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSB_PatientType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReviewType">
<Global>^RVI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>INSB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReviewType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSB_ReviewType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSB_PatientType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSB_ClaimMonth}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSB_RegistrationNo}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INSB_RowId</SqlRowIdName>
<StreamLocation>^User.RVIInsCompanyBillS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
