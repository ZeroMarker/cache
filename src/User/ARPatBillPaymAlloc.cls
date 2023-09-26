/// AR Pat Bill Paym Alloc(1866)
Class User.ARPatBillPaymAlloc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillPaymAlloc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PAYMChildsub [ IdKey, PrimaryKey, Unique ];

/// AR_PatientBill Parent Reference
Relationship PAYMParREf As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillPaymAlloc, Required, SqlFieldName = PAYM_ParREf ];

/// Childsub
Property PAYMChildsub As %Float [ InitialExpression = {$i(^ARPBL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PAYM",0))}, SqlColumnNumber = 2, SqlFieldName = PAYM_Childsub ];

/// Des Ref BillGrp
Property PAYMBillGrpDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = PAYM_BillGrp_DR ];

/// Des Ref BillSub
Property PAYMBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = PAYM_BillSub_DR ];

/// Des Ref ARCIM
Property PAYMARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = PAYM_ARCIM_DR ];

/// Amount
Property PAYMAmount As %Float [ SqlColumnNumber = 6, SqlFieldName = PAYM_Amount ];

/// Des Ref BillItem
Property PAYMBillItemDR As ARPatBillGroupCharges [ SqlColumnNumber = 7, SqlFieldName = PAYM_BillItem_DR ];

/// Des Ref ARRCA
Property PAYMARRCADR As ARRcptAlloc [ SqlColumnNumber = 8, SqlFieldName = PAYM_ARRCA_DR ];

/// Bill Amount
Property PAYMBillAmount As %Float [ SqlColumnNumber = 9, SqlFieldName = PAYM_BillAmount ];

/// Paid So Far
Property PAYMPaidSoFar As %Float [ SqlColumnNumber = 10, SqlFieldName = PAYM_PaidSoFar ];

/// Des Ref BillWriteOff
Property PAYMBillWriteOffDR As ARPatBillWriteOff [ SqlColumnNumber = 11, SqlFieldName = PAYM_BillWriteOff_DR ];

/// WOAmount
Property PAYMWOAmount As %Float [ SqlColumnNumber = 12, SqlFieldName = PAYM_WOAmount ];

/// WO Amount So Far
Property PAYMWOAmountSoFar As %Float [ SqlColumnNumber = 13, SqlFieldName = PAYM_WOAmountSoFar ];

/// Claim Amount
Property PAYMClaimAmount As %Float [ SqlColumnNumber = 14, SqlFieldName = PAYM_ClaimAmount ];

/// Not Claim Amount
Property PAYMNotClaimAmount As %Float [ SqlColumnNumber = 15, SqlFieldName = PAYM_NotClaimAmount ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillPaymAlloc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillPaymAlloc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillPaymAlloc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillPaymAlloc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillPaymAlloc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillPaymAlloc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillPaymAlloc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillPaymAlloc","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillPaymAlloc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillPaymAlloc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PAYM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAYM_ARRCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAYM_Amount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAYM_BillAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAYM_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAYM_BillItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAYM_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAYM_BillWriteOff_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAYM_ClaimAmount">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAYM_NotClaimAmount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PAYM_PaidSoFar">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAYM_WOAmount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAYM_WOAmountSoFar">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAYM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAYM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAYM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PAYM_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillPaymAllocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
