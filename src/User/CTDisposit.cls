/// CT Disposition           (CTDSP,40)
Class User.CTDisposit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Disposit, StorageStrategy = SQLStorage ]
{

Relationship ChildCTDispositDet As CTDispositDet [ Cardinality = children, Inverse = DETParRef ];

/// Disposition Code
Property CTDSPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTDSP_Code ];

/// Disposition Description
Property CTDSPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTDSP_Desc ];

/// Grouper Code
Property CTDSPGrouperCode As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CTDSP_GrouperCode ];

/// Date From
Property CTDSPDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = CTDSP_DateFrom ];

/// Date To
Property CTDSPDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CTDSP_DateTo ];

/// Default
Property CTDSPDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CTDSP_Default ];

/// Reason for Critical Care Transfer
Property CTDSPReasonForCritCareTransfer As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CTDSP_ReasonForCritCareTransfer ];

/// Transfer Source
Property CTDSPTransferSource As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CTDSP_TransferSource ];

/// Statistical Discharge
Property CTDSPStatDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = CTDSP_StatDischarge ];

/// Intention to ReAdmit
Property CTDSPIntentReAdmit As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CTDSP_IntentReAdmit ];

/// Care Availability
Property CTDSPCareAvailability As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CTDSP_CareAvailability ];

/// Care Type
Property CTDSPCareTyp As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CTDSP_CareTyp ];

/// Separation Referral
Property CTDSPSeparationReferral As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CTDSP_SeparationReferral ];

/// National Code
Property CTDSPNationalCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CTDSP_NationalCode ];

Index CTDSPCodeUnqIdx1 On CTDSPCode [ Unique ];

Index CTDSPDescUnqIdx2 On CTDSPDesc [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTDisposit).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDisposit","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTDisposit).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDisposit","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTDisposit).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDisposit","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTDisposit).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDisposit","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTDisposit).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDisposit","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("DSP",0))</SqlIdExpression>
<SQLMap name="DataMasterCTDSP">
<Data name="CTDSP_CareAvailability">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTDSP_CareTyp">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTDSP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTDSP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTDSP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTDSP_Default">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTDSP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTDSP_GrouperCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTDSP_IntentReAdmit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTDSP_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTDSP_ReasonForCritCareTransfer">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTDSP_SeparationReferral">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTDSP_StatDischarge">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTDSP_TransferSource">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTDSP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DSP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTDSP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTDSP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DSP"</Expression>
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
<Expression>$$ALPHAUP({CTDSP_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTDSP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTDSP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DSP"</Expression>
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
<Expression>$$ALPHAUP({CTDSP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTDSP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTDSP_RowID</SqlRowIdName>
<StreamLocation>^User.CTDispositS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
