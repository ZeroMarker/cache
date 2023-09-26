/// RVB InsurBatch Claim(1371)
Class User.RVBInsurBatchClaim Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVB_InsurBatchClaim, StorageStrategy = SQLStorage ]
{

/// Des Ref BillingFlag
Property CLMBillingFlagDR As RVCClaimFlag [ SqlColumnNumber = 5, SqlFieldName = CLM_BillingFlag_DR ];

/// Childsub
Property CLMChildsub As %Float [ InitialExpression = {$i(^RVB("BAT",$p(%d(0),$c(1)),"CLM",0))}, SqlColumnNumber = 2, SqlFieldName = CLM_Childsub ];

/// Claim No
Property CLMClaimNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLM_ClaimNo ];

/// OverPaid Flag
Property CLMOverPaidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CLM_OverPaidFlag ];

/// OverPaid NotifID
Property CLMOverPaidNotifID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CLM_OverPaidNotifID ];

/// RVB_InsurBatch Parent Reference
Relationship CLMParRef As RVBInsurBatch [ Cardinality = parent, Inverse = ChildRVBInsurBatchClaim, Required, SqlFieldName = CLM_ParRef ];

/// Des Ref RVIInsCoBill
Property CLMRVIInsCoBillDR As RVIInsCompanyBill [ SqlColumnNumber = 4, SqlFieldName = CLM_RVIInsCoBill_DR ];

/// Read Only
Property CLMReadOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CLM_ReadOnly ];

/// Des REf ReasonForReject_DR
Property CLMReasonForRejectDR As RVCRejectionCodeNFMI [ SqlColumnNumber = 11, SqlFieldName = CLM_ReasonForReject_DR ];

/// Reclaim Flag
Property CLMReclaimFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = CLM_ReclaimFlag ];

/// Status
Property CLMStatus As %String(DISPLAYLIST = ",Accepted,Cut,Rejected,Pending", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",A,C,R,P") [ SqlColumnNumber = 10, SqlFieldName = CLM_Status ];

Index RowIDBasedIDKeyIndex On CLMChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVBInsurBatchClaim).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatchClaim","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVBInsurBatchClaim).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatchClaim","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVBInsurBatchClaim).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatchClaim","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVBInsurBatchClaim).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatchClaim","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVBInsurBatchClaim).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVBInsurBatchClaim","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CLM_BillingFlag_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CLM_ClaimNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CLM_OverPaidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CLM_OverPaidNotifID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CLM_RVIInsCoBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CLM_ReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CLM_ReasonForReject_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CLM_ReclaimFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CLM_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^RVB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RVB_InsurBatch.BAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CLM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RVB_InsurBatch.BAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CLM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CLM_RowId</SqlRowIdName>
<StreamLocation>^User.RVBInsurBatchClaimS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
