/// ARC Item Category       (ARCIC,126)
Class User.ARCItemCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = ARC_ItemCat, StorageStrategy = SQLStorage ]
{

Relationship ChildARCItemCatRecLoc As ARCItemCatRecLoc [ Cardinality = children, Inverse = RLParRef ];

Relationship ChildARCItemCatDelivTimeRes As ARCItemCatDelivTimeRes [ Cardinality = children, Inverse = DTRParRef ];

Relationship ChildARCItemCatQuestion As ARCItemCatQuestion [ Cardinality = children, Inverse = QUESParRef ];

Relationship ChildARCItemCatPregnBrFdAlert As ARCItemCatPregnBrFdAlert [ Cardinality = children, Inverse = PBAParRef ];

/// Item Category Code
Property ARCICCode As %String(COLLATION = "AlphaUp", MAXLEN = 70, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ARCIC_Code ];

/// Item Category Description
Property ARCICDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ARCIC_Desc ];

/// Execution Flag
Property ARCICExecFlag As %String(DISPLAYLIST = ",Required,Not Allowed", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",R,N") [ SqlColumnNumber = 4, SqlFieldName = ARCIC_ExecFlag ];

/// Dose Type
Property ARCICDoseType As %String(DISPLAYLIST = ",One  ,Daily,Unit ", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",O,D,U") [ SqlColumnNumber = 5, SqlFieldName = ARCIC_DoseType ];

/// Executable Frequency Dependant
Property ARCICExecFreq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = ARCIC_ExecFreq ];

/// Executable Dosage Dependant
Property ARCICExecDose As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = ARCIC_ExecDose ];

/// Order Type
Property ARCICOrderType As %String(DISPLAYLIST = ",Drug,Diet,IV,Consultation,Normal,Dental,LabTrak,RehabMedicine,Price,BloodBank,Diet Supplement,Hardware,Diet Enteral Feed,Day Book,DFT,Diet Thickened Fluid,Bulk Meal,Prosthetics,Material", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",R,D,I,C,N,T,L,X,P,B,S,H,E,A,F,DTF,BM,PROS,M") [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 8, SqlFieldName = ARCIC_OrderType ];

/// Des Ref to OrdCateg
Property ARCICOrdCatDR As OECOrderCategory [ SqlColumnNumber = 9, SqlFieldName = ARCIC_OrdCat_DR ];

/// Des Ref ExecCateg
Property ARCICExecCategDR As OECExecCateg [ SqlColumnNumber = 10, SqlFieldName = ARCIC_ExecCateg_DR ];

/// Template
Property ARCICTemplate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ARCIC_Template ];

/// Calculate Qty Flag
Property ARCICCalcQtyFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 12, SqlFieldName = ARCIC_CalcQtyFlag ];

/// Show in Nurses WorkBench
Property ARCICNurseWorkBench As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ARCIC_NurseWorkBench ];

/// Des Ref TextResultType
Property ARCICTextResultTypeDR As OECTextResultType [ SqlColumnNumber = 14, SqlFieldName = ARCIC_TextResultType_DR ];

/// Dicom Result
Property ARCICDicomResult As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = ARCIC_DicomResult ];

/// OverridePrice
Property ARCICOverridePrice As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = ARCIC_OverridePrice ];

/// Allow ToEnterOneResultOnly
Property ARCICAllowToEnterOneResultOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = ARCIC_AllowToEnterOneResultOnly ];

/// Use ODBC for Word
Property ARCICUseODBCforWord As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = ARCIC_UseODBCforWord ];

/// HL7 Result Type
Property ARCICHL7ResultType As %String(DISPLAYLIST = ",Atomic,Image,Atomic & Image", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",AT,IM,AI") [ SqlColumnNumber = 19, SqlFieldName = ARCIC_HL7ResultType ];

/// Billing Type
Property ARCICBillingType As %String(DISPLAYLIST = ",Collection,Executable,SpecimenReception,NotRequired", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",C,E,SR,I") [ SqlColumnNumber = 20, SqlFieldName = ARCIC_BillingType ];

/// Des Ref Questionnaire
Property ARCICQuestionnaireDR As SSUserDefWindow [ SqlColumnNumber = 21, SqlFieldName = ARCIC_Questionnaire_DR ];

/// Only Show Verified Results
Property ARCICOnlyShowVerRes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = ARCIC_OnlyShowVerRes ];

/// Laboratory Codes
Property ARCICLaboratoryCodes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = ARCIC_LaboratoryCodes ];

/// Recieve Specimens
Property ARCICRecieveSpecimens As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = ARCIC_RecieveSpecimens ];

/// Counter type DR
Property ARCICCounterTypeDr As PACCounterType [ SqlColumnNumber = 25, SqlFieldName = ARCIC_CounterTypeDr ];

/// Restricted Order
Property ARCICRestrictedOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = ARCIC_RestrictedOrder ];

/// SecSignForAdm
Property ARCICSecSignForAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = ARCIC_SecSignForAdm ];

/// WarningNonVerResult
Property ARCICWarningNonVerResult As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = ARCIC_WarningNonVerResult ];

/// Des Ref UserDefWindow
Property ARCICUserDefWindowDR As SSUserDefWindow [ SqlColumnNumber = 29, SqlFieldName = ARCIC_UserDefWindow_DR ];

/// PrescrExpDays
Property ARCICPrescrExpDays As %Float [ SqlColumnNumber = 30, SqlFieldName = ARCIC_PrescrExpDays ];

/// PrescrRepeatDays
Property ARCICPrescrRepeatDays As %Float [ SqlColumnNumber = 31, SqlFieldName = ARCIC_PrescrRepeatDays ];

/// IV Expiry
Property ARCICIVExpiry As %Float [ SqlColumnNumber = 32, SqlFieldName = ARCIC_IVExpiry ];

/// PhoneOrderReviewTime
Property ARCICPhoneOrderReviewTime As %Float [ SqlColumnNumber = 33, SqlFieldName = ARCIC_PhoneOrderReviewTime ];

Index ARCICCodeUnqIdx1 On ARCICCode;

Index ARCICDescUnqIdx2 On ARCICDesc;

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemCat).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemCat).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemCat).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCat","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemCat).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCat","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCat","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemCat).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCat","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("IC",0))</SqlIdExpression>
<SQLMap name="DataMasterARCIC">
<Data name="ARCIC_AllowToEnterOneResultOnly">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ARCIC_BillingType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ARCIC_CalcQtyFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARCIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIC_CounterTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ARCIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARCIC_DicomResult">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ARCIC_DoseType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARCIC_ExecCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARCIC_ExecDose">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARCIC_ExecFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARCIC_ExecFreq">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARCIC_HL7ResultType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ARCIC_IVExpiry">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ARCIC_LaboratoryCodes">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ARCIC_NurseWorkBench">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARCIC_OnlyShowVerRes">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ARCIC_OrdCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARCIC_OrderType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARCIC_OverridePrice">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ARCIC_PhoneOrderReviewTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ARCIC_PrescrExpDays">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ARCIC_PrescrRepeatDays">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ARCIC_Questionnaire_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ARCIC_RecieveSpecimens">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ARCIC_RestrictedOrder">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ARCIC_SecSignForAdm">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ARCIC_Template">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARCIC_TextResultType_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARCIC_UseODBCforWord">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ARCIC_UserDefWindow_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ARCIC_WarningNonVerResult">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARCIC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ARCIC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCICCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARCIC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCIC_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCICDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARCIC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCIC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExecType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARCIC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ExecType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIC_ExecCateg_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARCIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdCat">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARCIC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIC_OrdCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARCIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrderType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARCIC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIC_OrderType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARCIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARCIC_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
