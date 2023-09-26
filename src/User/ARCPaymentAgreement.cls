/// ARC Payment Agreement(1415)
Class User.ARCPaymentAgreement Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PaymentAgreement, StorageStrategy = SQLStorage ]
{

Relationship ChildARCPayAgreemLocation As ARCPayAgreemLocation [ Cardinality = children, Inverse = LOCParRef ];

Relationship ChildARCPayAgreemTariff As ARCPayAgreemTariff [ Cardinality = children, Inverse = TARParRef ];

Relationship ChildARCPayAgreemDetails As ARCPayAgreemDetails [ Cardinality = children, Inverse = DETParRef ];

Relationship ChildARCPayAgreemBedCharges As ARCPayAgreemBedCharges [ Cardinality = children, Inverse = BEDParRef ];

Relationship ChildARCPayAgreemICD As ARCPayAgreemICD [ Cardinality = children, Inverse = ICDParRef ];

Relationship ChildARCPayAgreemOverrideBillGr As ARCPayAgreemOverrideBillGrp [ Cardinality = children, Inverse = BGParRef ];

Relationship ChildARCPayAgreemSingleFeeItem As ARCPayAgreemSingleFeeItem [ Cardinality = children, Inverse = SFParRef ];

Relationship ChildARCPayAgreemTheatreBand As ARCPayAgreemTheatreBand [ Cardinality = children, Inverse = TBParRef ];

Relationship ChildARCPayAgreemDRG As ARCPayAgreemDRG [ Cardinality = children, Inverse = DRGParRef ];

Relationship ChildARCPayAgreemBGLimits As ARCPayAgreemBGLimits [ Cardinality = children, Inverse = LIMParRef ];

Relationship ChildARCPayAgreemPatients As ARCPayAgreemPatients [ Cardinality = children, Inverse = PATParRef ];

Relationship ChildARCPayAgreemBGCombLimits As ARCPayAgreemBGCombLimits [ Cardinality = children, Inverse = COMParRef ];

Relationship ChildARCPayAgreemBedDiscount As ARCPayAgreemBedDiscount [ Cardinality = children, Inverse = BDParRef ];

Relationship ChildARCPayAgreemDiscount As ARCPayAgreemDiscount [ Cardinality = children, Inverse = DISCParRef ];

Relationship ChildARCPayAgreemPayMode As ARCPayAgreemPayMode [ Cardinality = children, Inverse = PMParRef ];

Relationship ChildARCPayAgreemPackage As ARCPayAgreemPackage [ Cardinality = children, Inverse = PKParRef ];

Relationship ChildARCPayAgreemReferral As ARCPayAgreemReferral [ Cardinality = children, Inverse = REFParRef ];

/// Des Ref InsType
Property PAYInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 2, SqlFieldName = PAY_InsType_DR ];

/// Date From
Property PAYDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = PAY_DateFrom ];

/// Date To
Property PAYDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = PAY_DateTo ];

/// Patient Share
Property PAYPayorShare As %Float(MAXVAL = 100, MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = PAY_PayorShare ];

/// Fixed Amt
Property PAYFixedAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = PAY_FixedAmt ];

/// Des Ref AuxInsType
Property PAYAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 7, SqlFieldName = PAY_AuxInsType_DR ];

/// Pays From
Property PAYPaysFrom As %Float [ SqlColumnNumber = 8, SqlFieldName = PAY_PaysFrom ];

/// Fixed Patient Share
Property PAYFixedPatientShare As %Float [ SqlColumnNumber = 9, SqlFieldName = PAY_FixedPatientShare ];

/// Bill By Order Group
Property PAYBillByOrderGroup As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PAY_BillByOrderGroup ];

/// Patient Pays
Property PAYPatientPays As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PAY_PatientPays ];

/// Des Ref ARCIM1
Property PAYARCIM1DR As ARCItmMast [ SqlColumnNumber = 12, SqlFieldName = PAY_ARCIM1_DR ];

/// Des Ref ARCIM2
Property PAYARCIM2DR As ARCItmMast [ SqlColumnNumber = 13, SqlFieldName = PAY_ARCIM2_DR ];

/// YesNo1
Property PAYYesNo1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PAY_YesNo1 ];

/// YesNo2
Property PAYYesNo2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = PAY_YesNo2 ];

/// YesNo3
Property PAYYesNo3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = PAY_YesNo3 ];

/// YesNo4
Property PAYYesNo4 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = PAY_YesNo4 ];

/// YesNo5
Property PAYYesNo5 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = PAY_YesNo5 ];

/// YesNo6
Property PAYYesNo6 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = PAY_YesNo6 ];

/// YesNo7
Property PAYYesNo7 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = PAY_YesNo7 ];

/// Text1
Property PAYText1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = PAY_Text1 ];

/// Text2
Property PAYText2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = PAY_Text2 ];

/// Text3
Property PAYText3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PAY_Text3 ];

/// Text4
Property PAYText4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = PAY_Text4 ];

/// Text5
Property PAYText5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = PAY_Text5 ];

/// Number1
Property PAYNumber1 As %Float [ SqlColumnNumber = 26, SqlFieldName = PAY_Number1 ];

/// Number2
Property PAYNumber2 As %Float [ SqlColumnNumber = 27, SqlFieldName = PAY_Number2 ];

/// Number3
Property PAYNumber3 As %Float [ SqlColumnNumber = 28, SqlFieldName = PAY_Number3 ];

/// Number4
Property PAYNumber4 As %Float [ SqlColumnNumber = 29, SqlFieldName = PAY_Number4 ];

/// Number5
Property PAYNumber5 As %Float [ SqlColumnNumber = 30, SqlFieldName = PAY_Number5 ];

/// Time1
Property PAYTime1 As %Time [ SqlColumnNumber = 31, SqlFieldName = PAY_Time1 ];

/// Time2
Property PAYTime2 As %Time [ SqlColumnNumber = 32, SqlFieldName = PAY_Time2 ];

/// MultText1
Property PAYMultText1 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = PAY_MultText1, SqlListType = SUBNODE ];

/// MultText2
Property PAYMultText2 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = PAY_MultText2, SqlListType = SUBNODE ];

/// AgreemCode
Property PAYAgreemCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = PAY_AgreemCode ];

/// AccountCode
Property PAYAccountCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = PAY_AccountCode ];

/// InvoiceType
Property PAYInvoiceType As %String(DISPLAYLIST = ",Delayed,Batch,Immediate", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",D,B,I") [ SqlColumnNumber = 37, SqlFieldName = PAY_InvoiceType ];

/// Des Ref Contract
Property PAYContractDR As BLCContractDetails [ SqlColumnNumber = 38, SqlFieldName = PAY_Contract_DR ];

/// Des Ref Currency
Property PAYCurrencyDR As CTCurrency [ SqlColumnNumber = 39, SqlFieldName = PAY_Currency_DR ];

/// Des Ref ContractDRG
Property PAYContractDRGDR As BLCContractDetails [ SqlColumnNumber = 40, SqlFieldName = PAY_ContractDRG_DR ];

/// RestrictOverride
Property PAYRestrictOverride As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = PAY_RestrictOverride ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPaymentAgreement).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPaymentAgreement","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPaymentAgreement).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPaymentAgreement","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPaymentAgreement).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPaymentAgreement","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPaymentAgreement).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPaymentAgreement","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPaymentAgreement","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPaymentAgreement).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPaymentAgreement","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("PAY",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PAY_ARCIM1_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PAY_ARCIM2_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAY_AccountCode">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PAY_AgreemCode">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PAY_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAY_BillByOrderGroup">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAY_ContractDRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PAY_Contract_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PAY_Currency_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PAY_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAY_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAY_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAY_FixedPatientShare">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAY_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAY_InvoiceType">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PAY_MultText1">
<Node>"TEXT1"</Node>
</Data>
<Data name="PAY_MultText2">
<Node>"TEXT2"</Node>
</Data>
<Data name="PAY_Number1">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PAY_Number2">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PAY_Number3">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PAY_Number4">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PAY_Number5">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PAY_PatientPays">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAY_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAY_PaysFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAY_RestrictOverride">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PAY_Text1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PAY_Text2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PAY_Text3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PAY_Text4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PAY_Text5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PAY_Time1">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PAY_Time2">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PAY_YesNo1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PAY_YesNo2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PAY_YesNo3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PAY_YesNo4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PAY_YesNo5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PAY_YesNo6">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PAY_YesNo7">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAY_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAY_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuxInsType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PAY_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AuxInsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAY_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAY_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAY_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PAY_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAY_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAY_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAY_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAY_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPaymentAgreementS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
