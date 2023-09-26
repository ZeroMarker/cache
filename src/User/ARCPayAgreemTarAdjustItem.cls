/// ARC Pay Agr Tar Adjust Item(1848)
Class User.ARCPayAgreemTarAdjustItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemTarAdjustItem, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = ITM_ARCIM_DR ];

/// Adjustment
Property ITMAdjustment As %Float [ SqlColumnNumber = 6, SqlFieldName = ITM_Adjustment ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$$next^at1848()}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Date From
Property ITMDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = ITM_DateFrom ];

/// Date To
Property ITMDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = ITM_DateTo ];

/// ARC_PayAgreemTarAdjBillSub Parent Reference
Relationship ITMParRef As ARCPayAgreemTarAdjBillSub [ Cardinality = parent, Inverse = ChildARCPayAgreemTarAdjustItem, Required, SqlFieldName = ITM_ParRef ];

/// Type
Property ITMType As %String(DISPLAYLIST = ",Insurance,Patient", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",I,P") [ SqlColumnNumber = 7, SqlFieldName = ITM_Type ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjustItem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjustItem","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjustItem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjustItem","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemTarAdjustItem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjustItem","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemTarAdjustItem).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjustItem","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemTarAdjustItem).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemTarAdjustItem","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_Adjustment">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemTariff.TAR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ARC_PayAgreemTarAdjust.ADJ_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>ARC_PayAgreemTarAdjBillSub.BS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="5">
<Expression>{L10}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TAR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemTariff.TAR_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ADJ"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARC_PayAgreemTarAdjust.ADJ_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"BS"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ARC_PayAgreemTarAdjBillSub.BS_Childsub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ITM_Childsub}</Expression>
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
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemTariff.TAR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L10}</Expression>
<Field>ARC_PayAgreemTarAdjust.ADJ_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
<Field>ARC_PayAgreemTarAdjBillSub.BS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="5">
<Expression>{L12}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TAR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemTariff.TAR_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ADJ"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_DateFrom}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{ARC_PayAgreemTarAdjust.ADJ_Childsub}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{ARC_PayAgreemTarAdjBillSub.BS_Childsub}</Expression>
</Subscript>
<Subscript name="12">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemTarAdjustItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
