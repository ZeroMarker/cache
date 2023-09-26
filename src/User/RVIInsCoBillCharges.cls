/// RVI Ins Co Bill Charges(1276)
Class User.RVIInsCoBillCharges Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVI_InsCoBillCharges, StorageStrategy = SQLStorage ]
{

Relationship ChildRVIInsCoBillChargesSurch As RVIInsCoBillChargesSurch [ Cardinality = children, Inverse = SURParRef ];

/// Des REf to ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ITM_ARCIM_DR ];

/// Des Ref ARCOS
Property ITMARCOSDR As ARCOrdSets [ SqlColumnNumber = 34, SqlFieldName = ITM_ARCOS_DR ];

/// Anaest Duration
Property ITMAnaestDuration As %Float [ SqlColumnNumber = 39, SqlFieldName = ITM_AnaestDuration ];

/// Des Ref BillSubGr
Property ITMBillSubDR As ARCBillSub [ SqlColumnNumber = 33, SqlFieldName = ITM_BillSub_DR ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^RVI($p(%d(0),$c(1)),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Cut Days
Property ITMCutDays As %Float [ SqlColumnNumber = 29, SqlFieldName = ITM_CutDays ];

/// Cut Qty
Property ITMCutQty As %Float [ SqlColumnNumber = 28, SqlFieldName = ITM_CutQty ];

/// Daily Qty
Property ITMDailyQty As %Float [ SqlColumnNumber = 6, SqlFieldName = ITM_DailyQty ];

/// Order Date
Property ITMDate As %Date [ SqlColumnNumber = 18, SqlFieldName = ITM_Date ];

/// Day-Night
Property ITMDayNight As %String(DISPLAYLIST = ",Day,Night", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",D,N") [ SqlColumnNumber = 23, SqlFieldName = ITM_DayNight ];

/// Des Ref Doctor
Property ITMDoctorDR As CTCareProv [ SqlColumnNumber = 25, SqlFieldName = ITM_Doctor_DR ];

/// Handicapped Association Share
Property ITMHandiShare As %Float [ SqlColumnNumber = 13, SqlFieldName = ITM_HandiShare ];

/// Ins Assoc Analisys Code
Property ITMInsAssocAnalisysCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = ITM_InsAssocAnalisysCode ];

/// Insurance Company Share
Property ITMInsCompanyShare As %Float [ SqlColumnNumber = 11, SqlFieldName = ITM_InsCompanyShare ];

/// Insurance Cover Status
Property ITMInsCoverStatusDR As ARCInsurCoverStatus [ SqlColumnNumber = 21, SqlFieldName = ITM_InsCoverStatus_DR ];

/// Insure Status
Property ITMInsureStatus As %String(DISPLAYLIST = ",Printed,Cut,Finished", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",P,C,F") [ SqlColumnNumber = 26, SqlFieldName = ITM_InsureStatus ];

/// Line Total
Property ITMLineTotal As %Float [ SqlColumnNumber = 9, SqlFieldName = ITM_LineTotal ];

/// Local Govt Share
Property ITMLocalGovtShare As %Float [ SqlColumnNumber = 12, SqlFieldName = ITM_LocalGovtShare ];

/// Material Total
Property ITMMaterialTotal As %Float [ SqlColumnNumber = 15, SqlFieldName = ITM_MaterialTotal ];

/// Des Ref to NFMI Department
Property ITMNFMIDepartDR As CTNFMICategDepart [ SqlColumnNumber = 20, SqlFieldName = ITM_NFMIDepart_DR ];

/// No of Times
Property ITMNoTimes As %Float [ SqlColumnNumber = 7, SqlFieldName = ITM_NoTimes ];

/// Occurrence Flag
Property ITMOccurrenceFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = ITM_OccurrenceFlag ];

/// Ointment Treat Days
Property ITMOintmentTreatDays As %Float [ SqlColumnNumber = 35, SqlFieldName = ITM_OintmentTreatDays ];

/// Des REf OrdItem
Property ITMOrdItemDR As OEOrdItem [ SqlColumnNumber = 37, SqlFieldName = ITM_OrdItem_DR ];

/// Order Time
Property ITMOrderTime As %Time [ SqlColumnNumber = 17, SqlFieldName = ITM_OrderTime ];

/// Des Ref PAADM
Property ITMPAADMDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = ITM_PAADM_DR ];

/// RVI_InsCompanyBill Parent Reference
Relationship ITMParRef As RVIInsCompanyBill [ Cardinality = parent, Inverse = ChildRVIInsCoBillCharges, Required, SqlFieldName = ITM_ParRef ];

/// Patient Insurance Flag
Property ITMPatInsFlag As %String(DISPLAYLIST = ",Patient,Insurance", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",P,I") [ SqlColumnNumber = 8, SqlFieldName = ITM_PatInsFlag ];

/// Patient Share
Property ITMPatientShare As %Float [ SqlColumnNumber = 10, SqlFieldName = ITM_PatientShare ];

/// Des Ref to RVCReasonForChange
Property ITMReasonForChangeDR As RVCReasonAddOrder [ SqlColumnNumber = 24, SqlFieldName = ITM_ReasonForChange_DR ];

/// Des Ref ReasonForCut
Property ITMReasonForCutDR As RVCReasonCutNFMI [ SqlColumnNumber = 31, SqlFieldName = ITM_ReasonForCut_DR ];

/// Reclaim Amt
Property ITMReclaimAmt As %Float [ SqlColumnNumber = 30, SqlFieldName = ITM_ReclaimAmt ];

/// Review Modified
Property ITMReviewModified As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = ITM_ReviewModified ];

/// Service/Material
Property ITMServiceMaterial As %String(DISPLAYLIST = ",Service,Material", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",S,M") [ SqlColumnNumber = 19, SqlFieldName = ITM_ServiceMaterial ];

/// Service Total
Property ITMServiceTotal As %Float [ SqlColumnNumber = 16, SqlFieldName = ITM_ServiceTotal ];

/// Specialist Surcharge
Property ITMSpecialistSurcharge As %Float [ SqlColumnNumber = 14, SqlFieldName = ITM_SpecialistSurcharge ];

/// Unit Price
Property ITMUnitPrice As %Float [ SqlColumnNumber = 5, SqlFieldName = ITM_UnitPrice ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillCharges","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillCharges","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillCharges","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVIInsCoBillCharges).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillCharges","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVIInsCoBillCharges).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillCharges","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ITM_AnaestDuration">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ITM_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ITM_CutDays">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ITM_CutQty">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ITM_DailyQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_Date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ITM_DayNight">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ITM_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ITM_HandiShare">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ITM_InsAssocAnalisysCode">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ITM_InsCompanyShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ITM_InsCoverStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ITM_InsureStatus">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ITM_LineTotal">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ITM_LocalGovtShare">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ITM_MaterialTotal">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ITM_NFMIDepart_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ITM_NoTimes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITM_OccurrenceFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ITM_OintmentTreatDays">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ITM_OrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ITM_OrderTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ITM_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_PatInsFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ITM_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ITM_ReasonForChange_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ITM_ReasonForCut_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ITM_ReclaimAmt">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ITM_ReviewModified">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ITM_ServiceMaterial">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ITM_ServiceTotal">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ITM_SpecialistSurcharge">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ITM_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RVI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RVI_InsCompanyBill.INSB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RVI_InsCompanyBill.INSB_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^RVI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RVI_InsCompanyBill.INSB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RVI_InsCompanyBill.INSB_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.RVIInsCoBillChargesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
