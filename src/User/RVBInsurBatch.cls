/// RVB Insur Batch(1370)
Class User.RVBInsurBatch Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVB_InsurBatch, StorageStrategy = SQLStorage ]
{

/// Insur Batch No
Property BATBatchNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = BAT_BatchNo ];

/// Chk Tot Count Cut
Property BATChkTotCountCut As %Float [ SqlColumnNumber = 33, SqlFieldName = BAT_ChkTotCountCut ];

/// Chk Tot Count Pending
Property BATChkTotCountPending As %Float [ SqlColumnNumber = 37, SqlFieldName = BAT_ChkTotCountPending ];

/// Chk Tot Count Rejected
Property BATChkTotCountRejected As %Float [ SqlColumnNumber = 35, SqlFieldName = BAT_ChkTotCountRejected ];

/// Chk Tot Cut
Property BATChkTotCut As %Float [ SqlColumnNumber = 32, SqlFieldName = BAT_ChkTotCut ];

/// Chk Tot Pending
Property BATChkTotPending As %Float [ SqlColumnNumber = 36, SqlFieldName = BAT_ChkTotPending ];

/// Chk Tot Rejected
Property BATChkTotRejected As %Float [ SqlColumnNumber = 34, SqlFieldName = BAT_ChkTotRejected ];

/// Claim Month
Property BATClaimMonth As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = BAT_ClaimMonth ];

/// No of Claims
Property BATClaimsCount As %Float [ SqlColumnNumber = 15, SqlFieldName = BAT_ClaimsCount ];

/// Ins Report Arrive Date
Property BATInsReportArriveDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BAT_InsReportArriveDate ];

/// Ins Report Date
Property BATInsReportDate As %Date [ SqlColumnNumber = 7, SqlFieldName = BAT_InsReportDate ];

/// Insur Report No
Property BATInsReportNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = BAT_InsReportNo ];

/// InsSubType (Text)
Property BATInsSubType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = BAT_InsSubType ];

/// Des Ref InsurAss
Property BATInsurAssDR As ARCInsurAssociation [ SqlColumnNumber = 13, SqlFieldName = BAT_InsurAss_DR ];

/// Des Ref InsurType
Property BATInsurTypeDR As ARCInsuranceType [ SqlColumnNumber = 12, SqlFieldName = BAT_InsurType_DR ];

/// Des Ref NFMICateg
Property BATNFMICategDR As CTNFMICategory [ SqlColumnNumber = 11, SqlFieldName = BAT_NFMI_Categ_DR ];

/// Internal batch Number
Property BATNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BAT_Number ];

/// Des Ref Parent Batch
Property BATParBatchDR As RVBInsurBatch [ SqlColumnNumber = 4, SqlFieldName = BAT_ParBatch_DR ];

/// Patient Type
Property BATPatientType As %String(DISPLAYLIST = ",InPatient,OutPatient", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 14, SqlFieldName = BAT_PatientType ];

/// Print Date
Property BATPrintDate As %Date [ SqlColumnNumber = 9, SqlFieldName = BAT_PrintDate ];

/// Rpt Count Pending
Property BATRptCountPending As %Float [ SqlColumnNumber = 27, SqlFieldName = BAT_RptCountPending ];

/// Rpt Tot Accepted
Property BATRptTotAccepted As %Float [ SqlColumnNumber = 21, SqlFieldName = BAT_RptTotAccepted ];

/// Rpt Tot Count Accepted
Property BATRptTotCountAccepted As %Float [ SqlColumnNumber = 22, SqlFieldName = BAT_RptTotCountAccepted ];

/// Rpt Tot Count Cut
Property BATRptTotCountCut As %Float [ SqlColumnNumber = 24, SqlFieldName = BAT_RptTotCountCut ];

/// Rpt Tot Count Rejected
Property BATRptTotCountRejected As %Float [ SqlColumnNumber = 25, SqlFieldName = BAT_RptTotCountRejected ];

/// Rpt Tot Cut
Property BATRptTotCut As %Float [ SqlColumnNumber = 23, SqlFieldName = BAT_RptTotCut ];

/// Rpt Tot Pending
Property BATRptTotPending As %Float [ SqlColumnNumber = 26, SqlFieldName = BAT_RptTotPending ];

/// Rpt Tot Rejected
Property BATRptTotRejected As %Float [ SqlColumnNumber = 30, SqlFieldName = BAT_RptTotRejected ];

/// Status
Property BATStatus As %String(DISPLAYLIST = ",Running,Printed,Outcome,Closed,New", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",R,P,O,C,N") [ SqlColumnNumber = 29, SqlFieldName = BAT_Status ];

/// Total HandicapAss
Property BATTotHandicapAss As %Float [ SqlColumnNumber = 20, SqlFieldName = BAT_TotHandicapAss ];

/// Total InsCo
Property BATTotInsCo As %Float [ SqlColumnNumber = 16, SqlFieldName = BAT_TotInsCo ];

/// Total Local Gov
Property BATTotLocalGov As %Float [ SqlColumnNumber = 19, SqlFieldName = BAT_TotLocalGov ];

/// Tot Paid
Property BATTotPaid As %Float [ SqlColumnNumber = 28, SqlFieldName = BAT_TotPaid ];

/// Total Patient
Property BATTotPatient As %Float [ SqlColumnNumber = 18, SqlFieldName = BAT_TotPatient ];

/// Total Treatment
Property BATTotTreatment As %Float [ SqlColumnNumber = 17, SqlFieldName = BAT_TotTreatment ];

/// Type
Property BATType As %String(DISPLAYLIST = ",First,Reject,Cut", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",F,R,C") [ SqlColumnNumber = 3, SqlFieldName = BAT_Type ];

Relationship ChildRVBInsurBatchClaim As RVBInsurBatchClaim [ Cardinality = children, Inverse = CLMParRef ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVBInsurBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatch","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVBInsurBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatch","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVBInsurBatch).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatch","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVBInsurBatch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatch","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVBInsurBatch).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatch","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RVB("BAT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BAT_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BAT_ChkTotCountCut">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="BAT_ChkTotCountPending">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="BAT_ChkTotCountRejected">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="BAT_ChkTotCut">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BAT_ChkTotPending">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="BAT_ChkTotRejected">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="BAT_ClaimMonth">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BAT_ClaimsCount">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BAT_InsReportArriveDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BAT_InsReportDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BAT_InsReportNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BAT_InsSubType">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BAT_InsurAss_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BAT_InsurType_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BAT_NFMI_Categ_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BAT_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BAT_ParBatch_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BAT_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BAT_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BAT_RptCountPending">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BAT_RptTotAccepted">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BAT_RptTotCountAccepted">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BAT_RptTotCountCut">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BAT_RptTotCountRejected">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BAT_RptTotCut">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BAT_RptTotPending">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BAT_RptTotRejected">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BAT_Status">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BAT_TotHandicapAss">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BAT_TotInsCo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BAT_TotLocalGov">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BAT_TotPaid">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BAT_TotPatient">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BAT_TotTreatment">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BAT_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RVB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClaimMonth">
<Global>^RVB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ClaimMonth"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_ClaimMonth}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParentBatch">
<Global>^RVB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BAT_ParBatch_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BAT_RowId</SqlRowIdName>
<StreamLocation>^User.RVBInsurBatchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
