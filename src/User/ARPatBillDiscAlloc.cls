/// AR Pat Bill Disc Allocation(1851)
Class User.ARPatBillDiscAlloc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillDiscAlloc, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property DSALARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = DSAL_ARCIM_DR ];

/// Discount Amount
Property DSALAmt As %Float [ SqlColumnNumber = 7, SqlFieldName = DSAL_Amt ];

/// Bill Amt
Property DSALBillAmt As %Float [ SqlColumnNumber = 9, SqlFieldName = DSAL_BillAmt ];

/// Des Ref BillGrp
Property DSALBillGrpDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = DSAL_BillGrp_DR ];

/// Des Ref BillItem
Property DSALBillItemDR As ARPatBillGroupCharges [ SqlColumnNumber = 8, SqlFieldName = DSAL_BillItem_DR ];

/// Des Ref BillSub
Property DSALBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = DSAL_BillSub_DR ];

/// Childsub
Property DSALChildsub As %Float [ InitialExpression = {$i(^ARPBL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DSAL",0))}, SqlColumnNumber = 2, SqlFieldName = DSAL_Childsub ];

/// AR_PatientBill Parent Reference
Relationship DSALParRef As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillDiscAlloc, Required, SqlFieldName = DSAL_ParRef ];

/// Discount Percentage
Property DSALPerc As %Float [ SqlColumnNumber = 6, SqlFieldName = DSAL_Perc ];

Index RowIDBasedIDKeyIndex On DSALChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillDiscAlloc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscAlloc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillDiscAlloc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscAlloc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillDiscAlloc).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscAlloc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillDiscAlloc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscAlloc","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillDiscAlloc).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscAlloc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DSAL_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSAL_Amt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSAL_BillAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSAL_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSAL_BillItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSAL_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSAL_Perc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DSAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DSAL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSAL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DSAL_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillDiscAllocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
