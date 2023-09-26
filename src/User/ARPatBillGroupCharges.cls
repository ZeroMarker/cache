/// AR PatBillGroup Charges(1285)
Class User.ARPatBillGroupCharges Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillGroupCharges, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARPatBillGroupChargeSurch As ARPatBillGroupChargeSurch [ Cardinality = children, Inverse = SURParRef ];

/// AR_PatBillGroup Parent Reference
Relationship ITMParRef As ARPatBillGroup [ Cardinality = parent, Inverse = ChildARPatBillGroupCharges, Required, SqlFieldName = ITM_ParRef ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^ARPBL($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"BGRP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Des Ref to PAADM
Property ITMPAADMDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = ITM_PAADM_DR ];

/// Des Ref to ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ITM_ARCIM_DR ];

/// Unit Price
Property ITMUnitPrice As %Float [ SqlColumnNumber = 5, SqlFieldName = ITM_UnitPrice ];

/// Daily Qty
Property ITMDailyQty As %Float [ SqlColumnNumber = 6, SqlFieldName = ITM_DailyQty ];

/// No of Times
Property ITMNoTimes As %Float [ SqlColumnNumber = 7, SqlFieldName = ITM_NoTimes ];

/// Patient Insurance Flag
Property ITMPatInsFlag As %String(DISPLAYLIST = ",Patient,Insurance", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",P,I") [ SqlColumnNumber = 8, SqlFieldName = ITM_PatInsFlag ];

/// Line Total
Property ITMLineTotal As %Float [ SqlColumnNumber = 9, SqlFieldName = ITM_LineTotal ];

/// Patient Share
Property ITMPatientShare As %Float [ SqlColumnNumber = 10, SqlFieldName = ITM_PatientShare ];

/// Insurance Company Share
Property ITMInsCompanyShare As %Float [ SqlColumnNumber = 11, SqlFieldName = ITM_InsCompanyShare ];

/// Local Govt Share
Property ITMLocalGovtShare As %Float [ SqlColumnNumber = 12, SqlFieldName = ITM_LocalGovtShare ];

/// Handicapped Association Share
Property ITMHandiShare As %Float [ SqlColumnNumber = 13, SqlFieldName = ITM_HandiShare ];

/// Specialist Surcharge
Property ITMSpecialistSurcharge As %Float [ SqlColumnNumber = 14, SqlFieldName = ITM_SpecialistSurcharge ];

/// Material Total
Property ITMMaterialTotal As %Float [ SqlColumnNumber = 15, SqlFieldName = ITM_MaterialTotal ];

/// Service Total
Property ITMServiceTotal As %Float [ SqlColumnNumber = 16, SqlFieldName = ITM_ServiceTotal ];

/// Order Time
Property ITMOrderTime As %Time [ SqlColumnNumber = 17, SqlFieldName = ITM_OrderTime ];

/// Order Date
Property ITMDate As %Date [ SqlColumnNumber = 18, SqlFieldName = ITM_Date ];

/// Service/Material
Property ITMServiceMaterial As %String(DISPLAYLIST = ",Service,Material", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",S,M") [ SqlColumnNumber = 19, SqlFieldName = ITM_ServiceMaterial ];

/// Des Ref to CTLOC
Property ITMDepartDR As CTLoc [ SqlColumnNumber = 20, SqlFieldName = ITM_Depart_DR ];

/// Des Ref to InsCoverStatus
Property ITMInsCoverStatusDR As ARCInsurCoverStatus [ SqlColumnNumber = 21, SqlFieldName = ITM_InsCoverStatus_DR ];

/// Prescription No
Property ITMPrescNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = ITM_PrescNo ];

/// Service charge applied to this item
Property ITMServiceCharge As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = ITM_ServiceCharge ];

/// Des Ref OEORI
Property ITMOEORIDR As OEOrdItem [ SqlColumnNumber = 24, SqlFieldName = ITM_OEORI_DR ];

/// Des Ref ARCOS
Property ITMARCOSDR As ARCOrdSets [ SqlColumnNumber = 25, SqlFieldName = ITM_ARCOS_DR ];

/// Account
Property ITMAccount As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = ITM_Account ];

/// ANAEST_Duration
Property ITMANAESTDuration As %Float [ SqlColumnNumber = 27, SqlFieldName = ITM_ANAEST_Duration ];

/// Des REf BiilGrp_DR
Property ITMRVIBiilGrpDR As ARCBillSub [ SqlColumnNumber = 28, SqlFieldName = ITM_RVI_BiilGrp_DR ];

/// Amt Payor Paid
Property ITMAmtPayorPaid As %Float [ SqlColumnNumber = 29, SqlFieldName = ITM_AmtPayorPaid ];

/// UnSettled
Property ITMUnSettled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = ITM_UnSettled ];

/// Des Ref AuxInsType
Property ITMAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 31, SqlFieldName = ITM_AuxInsType_DR ];

/// Des Ref OrdCateg
Property ITMOrdCategDR As OECOrderCategory [ SqlColumnNumber = 32, SqlFieldName = ITM_OrdCateg_DR ];

/// Des Ref OrdSubCat
Property ITMOrdSubCatDR As ARCItemCat [ SqlColumnNumber = 33, SqlFieldName = ITM_OrdSubCat_DR ];

/// Des Ref OrdCategGroup
Property ITMOrdCategGroupDR As OECOrderCategoryGroup [ SqlColumnNumber = 34, SqlFieldName = ITM_OrdCategGroup_DR ];

/// Des Ref InsuranceType
Property ITMInsuranceTypeDR As ARCInsuranceType [ SqlColumnNumber = 35, SqlFieldName = ITM_InsuranceType_DR ];

/// Des Ref BillGroup
Property ITMBillGroupDR As ARCBillGrp [ SqlColumnNumber = 36, SqlFieldName = ITM_BillGroup_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroupCharges).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroupCharges","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroupCharges).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroupCharges","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillGroupCharges).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroupCharges","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillGroupCharges).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroupCharges","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillGroupCharges).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillGroupCharges","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITM_ANAEST_Duration">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ITM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ITM_Account">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ITM_AmtPayorPaid">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ITM_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ITM_BillGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ITM_DailyQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_Date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ITM_Depart_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ITM_HandiShare">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ITM_InsCompanyShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ITM_InsCoverStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ITM_InsuranceType_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
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
<Data name="ITM_NoTimes">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITM_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ITM_OrdCategGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ITM_OrdCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ITM_OrdSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
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
<Data name="ITM_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ITM_RVI_BiilGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ITM_ServiceCharge">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
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
<Data name="ITM_UnSettled">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ITM_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM2">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArcim1">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillGrp1">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_BillGroup_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillGrp2">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_BillGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCatGrp1">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CatGrp"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_OrdCategGroup_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCatGrp2">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CatGrp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_OrdCategGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeARCIM">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeBillGrp">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeBillGrp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_BillGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeCatGrp">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeCatGrp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_OrdCategGroup_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeOrdCat">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeOrdCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_OrdCateg_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeSubCat">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeSubCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_OrdSubCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdCat1">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_OrdCateg_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdCat2">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_OrdCateg_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubCat1">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SubCat"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITM_OrdSubCat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubCat2">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AR_PatBillGroup.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SubCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITM_OrdSubCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatBillGroup.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillGroupChargesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
