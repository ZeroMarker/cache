/// Pay Agreem single fee Item(1737)
Class User.ARCPayAgreemSingleFeeItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemSingleFeeItem, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property SFARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = SF_ARCIM_DR ];

/// Childsub
Property SFChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),$c(1)),"SF",0))}, SqlColumnNumber = 2, SqlFieldName = SF_Childsub ];

/// ARC_PaymentAgreement Parent Reference
Relationship SFParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemSingleFeeItem, Required, SqlFieldName = SF_ParRef ];

Index RowIDBasedIDKeyIndex On SFChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemSingleFeeItem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemSingleFeeItem","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemSingleFeeItem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemSingleFeeItem","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemSingleFeeItem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemSingleFeeItem","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemSingleFeeItem).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemSingleFeeItem","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemSingleFeeItem).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemSingleFeeItem","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SF_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SF_Childsub}</Expression>
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
<Field>SF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SF_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SF_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SF_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemSingleFeeItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
