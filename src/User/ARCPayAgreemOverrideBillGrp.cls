/// Paym. Agreem override bill grp(1736
Class User.ARCPayAgreemOverrideBillGrp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemOverrideBillGrp, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property BGARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = BG_ARCIM_DR ];

/// Des Ref BillGroup
Property BGBillGroupDR As ARCBillGrp [ SqlColumnNumber = 4, SqlFieldName = BG_BillGroup_DR ];

/// Childsub
Property BGChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),$c(1)),"BG",0))}, SqlColumnNumber = 2, SqlFieldName = BG_Childsub ];

/// ARC_PaymentAgreement Parent Reference
Relationship BGParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemOverrideBillGr, Required, SqlFieldName = BG_ParRef ];

Index RowIDBasedIDKeyIndex On BGChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemOverrideBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemOverrideBillGrp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemOverrideBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemOverrideBillGrp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemOverrideBillGrp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemOverrideBillGrp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemOverrideBillGrp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemOverrideBillGrp","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemOverrideBillGrp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemOverrideBillGrp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BG_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BG_BillGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>BG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BG_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BG_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemOverrideBillGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
