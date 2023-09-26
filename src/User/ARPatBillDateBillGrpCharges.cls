/// Korea ARPatBillDateBillGrpCharg1440
Class User.ARPatBillDateBillGrpCharges Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillDateBillGrpCharges, StorageStrategy = SQLStorage ]
{

/// Des Ref ARPBLItem
Property ITMARPBLItemDR As ARPatBillGroupCharges [ SqlColumnNumber = 3, SqlFieldName = ITM_ARPBLItem_DR ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^ARPBL($p(%d(0),"||"),"DATE",$p(%d(0),"||",2),"BGRP",$p(%d(0),"||",3),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// AR_PatientBillDateBillGrp Parent Reference
Relationship ITMParRef As ARPatBillDateBillGrp [ Cardinality = parent, Inverse = ChildARPatBillDateBillGrpCharge, Required, SqlFieldName = ITM_ParRef ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillDateBillGrpCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrpCharges","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillDateBillGrpCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrpCharges","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillDateBillGrpCharges).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrpCharges","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillDateBillGrpCharges).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrpCharges","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillDateBillGrpCharges).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDateBillGrpCharges","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITM_ARPBLItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AR_PatBillDate.DATE_Date</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>AR_PatBillDateBillGrp.BGRP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_PatBillDate.DATE_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"BGRP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_PatBillDateBillGrp.BGRP_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillDateBillGrpChargS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
