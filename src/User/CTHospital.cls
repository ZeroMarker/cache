/// CT Hospital(1412)
Class User.CTHospital Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_Hospital, StorageStrategy = SQLStorage ]
{

Relationship ChildCTHospitalTrusts As CTHospitalTrusts [ Cardinality = children, Inverse = TRUSTParRef ];

Relationship ChildCTHospitalReciprocalHosp As CTHospitalReciprocalHosp [ Cardinality = children, Inverse = RECParRef ];

Relationship ChildCTHospitalPlan As CTHospitalPlan [ Cardinality = children, Inverse = PLANParRef ];

Relationship ChildCTHospitalDRGFundGroup As CTHospitalDRGFundGroup [ Cardinality = children, Inverse = DFGParRef ];

/// 2022-06-23新增医院logo表
Relationship ChildCTHospitalLogo As CTHospitalLogo [ Cardinality = children, Inverse = LOGOParRef ];

/// Code
Property HOSPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = HOSP_Code ];

/// Description
Property HOSPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = HOSP_Desc ];

/// Billing Address
Property HOSPBillAddress As list Of %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HOSP_BillAddress, SqlListType = SUBNODE ];

/// Des Ref Counter Type
Property HOSPBillNoDR As PACCounterType [ SqlColumnNumber = 5, SqlFieldName = HOSP_BillNo_DR ];

/// Des Ref Counter TypeCredit Note No
Property HOSPCreditNoteNoDR As PACCounterType [ SqlColumnNumber = 6, SqlFieldName = HOSP_CreditNoteNo_DR ];

/// Use Same Counter for Bill/Refund
Property HOSPUseSameCounter As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = HOSP_UseSameCounter ];

/// Des Ref Trust
Property HOSPTrustDR As PACTrust [ SqlColumnNumber = 8, SqlFieldName = HOSP_Trust_DR ];

/// 定点医疗机构代码(医保编码）
Property HOSPNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = HOSP_NationalCode ];

/// Warn if Same Service within X Days
Property HOSPWarnSameServiceWnXDays As %Float [ SqlColumnNumber = 10, SqlFieldName = HOSP_WarnSameServiceWnXDays ];

/// DateFrom
Property HOSPDateFrom As %Date [ SqlColumnNumber = 11, SqlFieldName = HOSP_DateFrom ];

/// Date To
Property HOSPDateTo As %Date [ SqlColumnNumber = 12, SqlFieldName = HOSP_DateTo ];

/// Phone
Property HOSPPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = HOSP_Phone ];

/// Fax
Property HOSPFax As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = HOSP_Fax ];

/// Email
Property HOSPEmail As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = HOSP_Email ];

/// Medical Director
Property HOSPMedicalDirector As CTCareProv [ SqlColumnNumber = 16, SqlFieldName = HOSP_MedicalDirector ];

/// Zip des ref
Property HOSPZipDR As CTZip [ SqlColumnNumber = 17, SqlFieldName = HOSP_ZipDR ];

/// State
Property HOSPState As CTState [ SqlColumnNumber = 18, SqlFieldName = HOSP_State ];

/// Address
Property HOSPAddress As %String(COLLATION = "Exact", MAXLEN = 230, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = HOSP_Address ];

/// City
Property HOSPCity As CTCity [ SqlColumnNumber = 20, SqlFieldName = HOSP_City ];

/// Mandatory Ref Hospital
Property HOSPMandatoryRefHospital As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = HOSP_MandatoryRefHospital ];

/// Logo
Property HOSPLogo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = HOSP_Logo ];

/// Des Ref HospDRGCateg
Property HOSPHospDRGCategDR As CTHospitalDRGCategory [ SqlColumnNumber = 23, SqlFieldName = HOSP_HospDRGCateg_DR ];

/// Show Appointment Waiting Time Violation
Property HOSPSHowAppWTimeViolation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = HOSP_SHowAppWTimeViolation ];

/// Des Ref Province
Property HOSPProvinceDR As CTProvince [ SqlColumnNumber = 25, SqlFieldName = HOSP_Province_DR ];

/// Email1
Property HOSPEmail1 As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = HOSP_Email1 ];

/// Island
Property HOSPIsland As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = HOSP_Island ];

/// Apply VC Fees
Property HOSPApplyVCFees As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = HOSP_ApplyVCFees ];

/// BankAccount
Property HOSPBankAccount As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = HOSP_BankAccount ];

/// Des Ref Tariff
Property HOSPTariffDR As ARCTariff [ SqlColumnNumber = 30, SqlFieldName = HOSP_Tariff_DR ];

/// Des Ref MHACT
Property HOSPMHACTDR As CTMentalHealthACT [ SqlColumnNumber = 31, SqlFieldName = HOSP_MHACT_DR ];

/// FaxServerEmail
Property HOSPFaxServerEmail As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = HOSP_FaxServerEmail ];

/// WeeksSuspensionReview
Property HOSPWeeksSuspensionReview As %Float [ SqlColumnNumber = 33, SqlFieldName = HOSP_WeeksSuspensionReview ];

/// DaysForOPDOffer
Property HOSPDaysForOPDOffer As %Float [ SqlColumnNumber = 34, SqlFieldName = HOSP_DaysForOPDOffer ];

/// DaysForOPLetterResponse
Property HOSPDaysForOPLetterResponse As %Float [ SqlColumnNumber = 35, SqlFieldName = HOSP_DaysForOPLetterResponse ];

/// OffersBeforeIP OPWaitReset
Property HOSPOffersBeforeIPOPWaitReset As %Float [ SqlColumnNumber = 36, SqlFieldName = HOSP_OffersBeforeIP_OPWaitReset ];

/// NewWays
Property HOSPNewWays As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = HOSP_NewWays ];

/// DaysOfferOutcomeChange
Property HOSPDaysOfferOutcomeChange As %Float [ SqlColumnNumber = 38, SqlFieldName = HOSP_DaysOfferOutcomeChange ];

/// 简称1 2019-06-26add
Property HOSPShortDesc1 As %String [ SqlColumnNumber = 39, SqlFieldName = HOSP_ShortDesc1 ];

/// 简称2 2019-06-26add
Property HOSPShortDesc2 As %String [ SqlColumnNumber = 40, SqlFieldName = HOSP_ShortDesc2 ];

/// 默认医院 20200429
Property HOSPDefaultHospitalDR As CTHospital [ SqlColumnNumber = 41, SqlFieldName = HOSP_DefaultHospital_DR ];

/// 医疗机构 2020-12-10
Property HOSPClinDR As CTRefClin [ SqlColumnNumber = 42, SqlFieldName = HOSP_Clin_DR ];

/// 医保名称 ^43 2022-04-02
Property HOSPNationalDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = HOSP_NationalDesc ];

Index HOSPCodeUnqIdx1 On HOSPCode [ Unique ];

Index HOSPDescUnqIdx2 On HOSPDesc [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTHospital).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospital","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTHospital).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospital","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTHospital).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospital","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTHospital).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospital","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTHospital).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospital","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospital","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>27</ExtentSize>
<Property name="HOSPAddress">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPApplyVCFees">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPBankAccount">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPBillAddress">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPBillNoDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HOSPCity">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="HOSPCreditNoteNoDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPDateFrom">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="HOSPDateTo">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="HOSPDaysForOPDOffer">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPDaysForOPLetterResponse">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPDaysOfferOutcomeChange">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="HOSPEmail">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPEmail1">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPFax">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HOSPFaxServerEmail">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HOSPHospDRGCategDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPIsland">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPLogo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HOSPMHACTDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HOSPMandatoryRefHospital">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPMedicalDirector">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HOSPNationalCode">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="HOSPNewWays">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPOffersBeforeIPOPWaitReset">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPPhone">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPProvinceDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HOSPSHowAppWTimeViolation">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPState">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HOSPTariffDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPTrustDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPUseSameCounter">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPWarnSameServiceWnXDays">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HOSPWeeksSuspensionReview">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HOSPZipDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("HOSP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HOSP_Address">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="HOSP_ApplyVCFees">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="HOSP_BankAccount">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="HOSP_BillAddress">
<Node>"ADDR"</Node>
</Data>
<Data name="HOSP_BillNo_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HOSP_City">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="HOSP_Clin_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="HOSP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HOSP_CreditNoteNo_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HOSP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HOSP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HOSP_DaysForOPDOffer">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="HOSP_DaysForOPLetterResponse">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="HOSP_DaysOfferOutcomeChange">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="HOSP_DefaultHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="HOSP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HOSP_Email">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="HOSP_Email1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="HOSP_Fax">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="HOSP_FaxServerEmail">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="HOSP_HospDRGCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="HOSP_Island">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="HOSP_Logo">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="HOSP_MHACT_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="HOSP_MandatoryRefHospital">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="HOSP_MedicalDirector">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="HOSP_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HOSP_NationalDesc">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="HOSP_NewWays">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="HOSP_OffersBeforeIP_OPWaitReset">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="HOSP_Phone">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HOSP_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="HOSP_SHowAppWTimeViolation">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="HOSP_ShortDesc1">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="HOSP_ShortDesc2">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="HOSP_State">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HOSP_Tariff_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="HOSP_Trust_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HOSP_UseSameCounter">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HOSP_WarnSameServiceWnXDays">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HOSP_WeeksSuspensionReview">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="HOSP_ZipDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HOSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HOSP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HOSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HOSP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HOSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HOSP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HOSP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HOSP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HOSP_RowId</SqlRowIdName>
<StreamLocation>^User.CTHospitalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
